#include "..\script_component.hpp"
/*
 * Author: Blue
 * Initialize hazard effects for unit.
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

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_unit", "_hazardType", "_inhalationRate", "_eliminationRate", "_fnc_inArea"];

    private _buildup = _unit getVariable [(format ["ACM_CBRN_%1_Buildup", toLower _hazardType]), 0];
    private _inArea = _unit call _fnc_inArea;
    private _blocked = false;
    private _filtered = false;
    private _protected = false;

    if (!_inArea && _buildup <= 0 || !(alive _unit)) exitWith {
        _unit setVariable [(format ["ACM_CBRN_%1_PFH", toLower _hazardType]), -1, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(_blocked) then {
        if (_inArea) then {
            _buildup = _buildup + _inhalationRate;
            if (_buildup > 100) then {
                _buildup = 100;
            };
        } else {
            _buildup = _buildup + _eliminationRate;
            if (_buildup < 0) then {
                _buildup = 0;
            };
        };

        _unit setVariable [(format ["ACM_CBRN_%1_Buildup", toLower _hazardType]), _buildup, 0];
    };
    
    systemchat format ["%1 - %2",_unit,_buildup];

}, 1, [_unit, _hazardType, _inhalationRate, _eliminationRate, _fnc_inArea]] call CBA_fnc_addPerFrameHandler;

_unit setVariable [(format ["ACM_CBRN_%1_PFH", toLower _hazardType]), _PFH, true];