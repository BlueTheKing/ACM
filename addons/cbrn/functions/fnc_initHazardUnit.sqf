#include "..\script_component.hpp"
/*
 * Author: Blue
 * Initialize hazard effects for unit. (LOCAL)
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Hazard Type <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "Chemical_CS"] call ACM_CBRN_fnc_initHazardUnit;
 *
 * Public: No
 */

params ["_unit", "_hazardType"];

private _PFHVarString = format ["ACM_CBRN_%1_PFH", toLower _hazardType];

if (_unit getVariable [(format [_PFHVarString, toLower _hazardType]), -1] != -1) exitWith {};

private _buildupVarString = format ["ACM_CBRN_%1_Buildup", toLower _hazardType];

systemchat format ["%1 - %2",_unit,_hazardType];

private _fnc_inArea = {
    params ["_unit"];

    private _zoneList = missionNamespace getVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), createHashMap];
    private _index = (keys _zoneList) findIf {_unit inArea ((_zoneList getOrDefault [_x, []]) select 0)};

    if (_index > -1) exitWith {true};
    false
};

(_hazardType splitString "_") params ["_hazardCategory", "_hazardEntry"];

private _hazardClass = configFile >> "ACM_CBRN_Hazards" >> _hazardCategory >> _hazardEntry;

private _inhalationRate = getNumber (_hazardClass >> "inhalation_rate");
private _absorptionRate = getNumber (_hazardClass >> "absorption_rate");
private _eliminationRate = getNumber (_hazardClass >> "elimination_rate");
private _thresholdList = getArray (_hazardClass >> "thresholds");
private _thresholdRateList = getArray (_hazardClass >> "threshold_rate");
GET_FUNCTION(_thresholdFunction,_hazardClass >> "thresholdFunction");

private _canAbsorbThroughEyes = [true, ((getNumber (_hazardClass >> "absorbant_eyes")) > 0)] select (isNumber (_hazardClass >> "absorbant_eyes"));
private _canInhale = _inhalationRate > 0;
private _canAbsorb = _absorptionRate > 0;

private _configArgs = [_inhalationRate, _absorptionRate, _eliminationRate, _thresholdFunction, _canInhale, _canAbsorb, _canAbsorbThroughEyes];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_unit", "_PFHVarString", "_buildupVarString", "_hazardType", "_configArgs", "_fnc_inArea"];
    _configArgs params ["_inhalationRate", "_absorptionRate", "_eliminationRate", "_thresholdFunction", "_canInhale", "_canAbsorb", "_canAbsorbThroughEyes"];

    private _buildup = _unit getVariable [_buildupVarString, 0];
    private _inArea = _unit call _fnc_inArea;

    if (!_inArea && _buildup <= 0 || !(alive _unit)) exitWith {
        _unit setVariable [_PFHVarString, -1, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _blocked = false;
    private _filtered = false || !_canInhale;
    private _protectedEyes = false || !_canAbsorbThroughEyes;
    private _protectedBody = false;
    private _exposed = false;
    private _filterLevel = 0;

    if (_inArea) then {
        private _suitIndex = (uniform _unit) findIf {
            _x in GVAR(PPE_List) get "suit";
        };

        if (_suitIndex > -1) then {
            _protectedBody = true;
        };

        if (!_blocked || _protectedBody) then {
            private _respiratorIndex = [goggles _unit, headgear _unit] findIf {
                _x in GVAR(PPE_List) get "respirator";
            };

            if (_respiratorIndex > -1) then {
                _protectedEyes = true;
                _filtered = true;
                _filterLevel = 3;
                _blocked = _protectedBody;
            };
        };
        
        if (_blocked) exitWith {};
        _exposed = true;

        private _gogglesIndex = (goggles _unit) findIf {
            _x in GVAR(PPE_List) get "goggles";
        };

        if (_gogglesIndex > -1) then {
            _protectedEyes = true;
        } else {
            if (_filtered) exitWith {};
            private _maskIndex = (goggles _unit) findIf {
                _x in GVAR(PPE_List) get "mask";
                _filterLevel = 2;
            };

            if (_maskIndex > -1) then {
                _inhalationRate = _inhalationRate * 0.5;
            } else {
                private _makeshiftMaskIndex = (goggles _unit) findIf {
                    _x in GVAR(PPE_List) get "mask_makeshift";
                };

                if (_makeshiftMaskIndex > -1) then {
                    _inhalationRate = _inhalationRate * 0.9;
                    _filterLevel = 1;
                };
            };
        };
    };

    if (_exposed && (_inhalationRate max _absorptionRate) > 0) then {
        _buildup = _buildup + (_inhalationRate max _absorptionRate);
        if (_buildup > 100) then {
            _buildup = 100;
        };
    } else {
        _buildup = _buildup + _eliminationRate;
        if (_buildup < 0) then {
            _buildup = 0;
        };
    };

    _unit setVariable [_buildupVarString, _buildup, true];

    if (_buildup > 0) then {
        [_unit, _buildup, _exposed, [_filtered, _protectedBody, _protectedEyes, _filterLevel]] call _thresholdFunction;
    };
    
    systemchat format ["%1 - %2",_unit,_buildup];

}, 1, [_unit, _PFHVarString, _buildupVarString, _hazardType, _configArgs, _fnc_inArea]] call CBA_fnc_addPerFrameHandler;

_unit setVariable [(format [_PFHVarString, toLower _hazardType]), _PFH, true];