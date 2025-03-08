#include "..\script_component.hpp"
/*
 * Author: Blue
 * Initialize hazard effects for unit. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
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

params ["_patient", "_hazardType"];

private _PFHVarString = format ["ACM_CBRN_%1_PFH", toLower _hazardType];

if (_patient getVariable [(format [_PFHVarString, toLower _hazardType]), -1] != -1) exitWith {};

private _buildupVarString = format ["ACM_CBRN_%1_Buildup", toLower _hazardType];

private _fnc_inArea = {
    params ["_patient"];

    private _zoneList = missionNamespace getVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), createHashMap];
    private _index = (keys _zoneList) findIf {_patient inArea ((_zoneList getOrDefault [_x, []]) select 0)};

    if (_index > -1) exitWith {true};
    false
};

(_hazardType splitString "_") params ["_hazardCategory", "_hazardEntry"];

private _hazardClass = configFile >> "ACM_CBRN_Hazards" >> _hazardCategory >> _hazardEntry;

private _inhalationRate = getNumber (_hazardClass >> "inhalation_rate");
private _absorptionRate = getNumber (_hazardClass >> "absorption_rate");
private _eliminationRate = getNumber (_hazardClass >> "elimination_rate");

(GVAR(HazardType_ThresholdList) get _hazardType) params ["_thresholdList", "_thresholdPositiveRateList", "_thresholdNegativeRateList"];

private _useThreshold = ((count _thresholdList) > 1) && (((count _thresholdPositiveRateList) > 1) || ((count _thresholdNegativeRateList) > 1));

GET_FUNCTION(_thresholdFunction,_hazardClass >> "thresholdFunction");

private _canAbsorbThroughEyes = [true, ((getNumber (_hazardClass >> "absorbant_eyes")) > 0)] select (isNumber (_hazardClass >> "absorbant_eyes"));
private _canInhale = _inhalationRate > 0;
private _canAbsorb = [(_absorptionRate > 0), ((getNumber (_hazardClass >> "absorbant_skin")) > 0)] select (isNumber (_hazardClass >> "absorbant_skin"));

private _configArgs = [_inhalationRate, _absorptionRate, _eliminationRate, _thresholdFunction, _useThreshold, _canInhale, _canAbsorb, _canAbsorbThroughEyes];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_PFHVarString", "_buildupVarString", "_hazardType", "_configArgs", "_fnc_inArea"];
    _configArgs params ["_inhalationRate", "_absorptionRate", "_eliminationRate", "_thresholdFunction", "_useThreshold", "_canInhale", "_canAbsorb", "_canAbsorbThroughEyes"];

    private _buildup = _patient getVariable [_buildupVarString, 0];
    private _inArea = _patient call _fnc_inArea;

    private _wasExposed = _patient getVariable [(format ["ACM_CBRN_%1_Exposed_State", toLower _hazardType]), false];
    private _wasExposedExternal = _patient getVariable [(format ["ACM_CBRN_%1_Exposed_External_State", toLower _hazardType]), false];

    _patient setVariable [(format ["ACM_CBRN_%1_Contaminated_State", toLower _hazardType]), _inArea];

    if (!_inArea && _buildup <= 0 || !(alive _patient)) exitWith {
        _patient setVariable [_PFHVarString, -1, true];

        _patient setVariable [(format ["ACM_CBRN_%1_Exposed_State", toLower _hazardType]), false];
        _patient setVariable [(format ["ACM_CBRN_%1_Exposed_External_State", toLower _hazardType]), false];
        [_patient, true] call FUNC(updateExposureEffects);

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_patient getVariable [QGVAR(IsImmune), false]) exitWith {};

    private _lastThreshold = _patient getVariable [(format ["ACM_CBRN_%1_Buildup_Threshold", toLower _hazardType]), -1];
    private _currentThreshold = 0;

    private _blocked = false;
    private _filtered = false || !_canInhale;
    private _protectedEyes = false || !_canAbsorbThroughEyes;
    private _protectedBody = false || !_canAbsorb;
    private _exposed = false;
    private _exposedExternal = false;
    private _filterLevel = 0;

    private _increaseModifier = 1;
    private _decreaseModifier = 1;

    private _filterDepletionRate = 1;

    if (_inArea) then {
        private _vehicle = vehicle _patient;
        private _isTurnedOut = isTurnedOut _patient;
        private _CBRNVehicle = _vehicle in (GVAR(Vehicle_List) get "cbrn");

        _blocked = _CBRNVehicle && !_isTurnedOut;

        if (_blocked) exitWith {};

        private _sealedVehicle = _vehicle in (GVAR(Vehicle_List) get "sealed");

        _blocked = _sealedVehicle && !_isTurnedOut && !(_vehicle getVariable [QGVAR(Vehicle_Contaminated_State), false]);

        if (_blocked) exitWith {};

        private _unitUniform = uniform _patient;
        private _unitGoggles = goggles _patient;
        private _unitHeadGear = headgear _patient;

        private _suitFound = _unitUniform in (GVAR(PPE_List) get "suit");

        if (_suitFound) then {
            _protectedBody = true;
        };

        private _gasMaskFound = ([_unitGoggles, _unitHeadGear] findIf {
            _x in (GVAR(PPE_List) get "gasmask");
        }) > -1;

        if (_gasMaskFound) then {
            _protectedEyes = true;
            _filterLevel = 3;

            private _filterCondition = GET_FILTER_CONDITION(_patient);
            _filtered = _filterCondition > 0;
            _blocked = _protectedBody && _filtered;

            if (_filtered) then {
                _patient setVariable [QGVAR(Filter_State), (_filterCondition - _filterDepletionRate) max 0];
            };
        };
        
        if (_blocked) exitWith {};
        _exposed = !_filtered;
        _exposedExternal = true;

        private _gogglesFound = _unitGoggles in (GVAR(PPE_List) get "goggles");

        if (_gogglesFound) then {
            _protectedEyes = true;
        } else {
            if (_filtered) exitWith {};
            private _maskFound = _unitGoggles in (GVAR(PPE_List) get "mask");

            if (_maskFound) then {
                _inhalationRate = _inhalationRate * 0.5;
                _filterLevel = 2;
            } else {
                private _makeshiftMaskFound = _unitGoggles in (GVAR(PPE_List) get "mask_makeshift");

                if (_makeshiftMaskFound) then {
                    _inhalationRate = _inhalationRate * 0.9;
                    _filterLevel = 1;
                };
            };
        };
    };

    if (_useThreshold) then {
        (GVAR(HazardType_ThresholdList) get _hazardType) params ["_thresholdList", "_thresholdPositiveRateList", "_thresholdNegativeRateList"];

        private _lastThresholdIndex = _thresholdList findIf {_x > _buildup};
        if (_lastThresholdIndex > -1) then {
            private _targetThresholdIndex = (_lastThresholdIndex - 1) max 0;
            _currentThreshold = _thresholdList select _targetThresholdIndex;

            _increaseModifier = _thresholdPositiveRateList select _targetThresholdIndex;
            _decreaseModifier = _thresholdNegativeRateList select _targetThresholdIndex;
        };
    };
    
    if (_exposed && !_filtered || _exposedExternal && !_protectedBody) then {
        _buildup = (_buildup + ((_inhalationRate max _absorptionRate) * _increaseModifier)) min 100;
    } else {
        _buildup = (_buildup + (_eliminationRate * _decreaseModifier)) max 0;
    };

    _patient setVariable [_buildupVarString, _buildup, true];

    if (_buildup > 0) then {
        [_patient, _buildup, _exposed, _exposedExternal, [_filtered, _protectedBody, _protectedEyes, _filterLevel]] call _thresholdFunction;
    };

    if (_exposed != _wasExposed) then {
        _patient setVariable [(format ["ACM_CBRN_%1_Exposed_State", toLower _hazardType]), _exposed];
    };

    if (_exposedExternal != _wasExposedExternal) then {
        _patient setVariable [(format ["ACM_CBRN_%1_Exposed_External_State", toLower _hazardType]), _exposedExternal];
    };

    if (_lastThreshold != _currentThreshold) then {
        _patient setVariable [(format ["ACM_CBRN_%1_Buildup_Threshold", toLower _hazardType]), _currentThreshold, true];
    };

    if ((_exposed || _exposedExternal) && !(_patient getVariable [(format ["ACM_CBRN_%1_WasExposed", toLower _hazardType]), false])) then {
        _patient setVariable [(format ["ACM_CBRN_%1_WasExposed", toLower _hazardType]), true, true];
    };

    [_patient] call FUNC(updateExposureEffects);
}, 1, [_patient, _PFHVarString, _buildupVarString, _hazardType, _configArgs, _fnc_inArea]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [(format [_PFHVarString, toLower _hazardType]), _PFH, true];

if (_patient getVariable [QGVAR(CoughPFH), -1] > -1) exitWith {};

private _coughPFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    if (!(alive _patient) || ((_patient getVariable [QGVAR(CoughPFH), -1]) == -1)) then {
        _patient setVariable [QGVAR(CoughPFH), -1, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _isExposed = _patient getVariable [QGVAR(Exposed_State), false];

    if (!_isExposed || IS_UNCONSCIOUS(_patient)) exitWith {};

    private _nextCough = _patient getVariable [QGVAR(ExposureEffects_NextCough), -1];

    if (_nextCough > CBA_missionTime) exitWith {};

    private _randomCough = 1 + round (random 3);
    private _randomInhale = 1 + round (random 1);

    private _coughTime = switch (_randomCough) do {
        case 1: {1.165}; // 1.163s
        case 2: {1.230}; // 1.226s
        case 3: {1.290}; // 1.285s
        case 4: {1.710}; // 1.708s
    };

    private _inhaleTime = switch (_randomInhale) do {
        case 1: {0.505}; // 0.504s
        case 2: {0.305}; // 0.304s
    };

    private _addTime = 0.2 + random 0.2;

    private _distance = 8;

    private _targets = allPlayers inAreaArray [ASLToAGL getPosASL _patient, _distance, _distance, 0, false, _distance];

    [QEGVAR(core,forceSay3D), [_patient, (format ["ACM_CBRN_Cough_%1", _randomCough]), _distance, (0.9 + (random 0.2))], _targets] call CBA_fnc_targetEvent;

    [{
        params ["_patient", "_randomInhale", "_distance"];

        private _targets = allPlayers inAreaArray [ASLToAGL getPosASL _patient, _distance, _distance, 0, false, _distance];

        [QEGVAR(core,forceSay3D), [_patient, (format ["ACM_CBRN_Inhale_%1", _randomInhale]), _distance, (0.9 + (random 0.2))], _targets] call CBA_fnc_targetEvent;
    }, [_patient, _randomInhale, _distance], (_coughTime + _addTime)] call CBA_fnc_waitAndExecute;

    _patient setVariable [QGVAR(ExposureEffects_NextCough), (CBA_missionTime + _coughTime + _inhaleTime + _addTime)];
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CoughPFH), _coughPFH, true];