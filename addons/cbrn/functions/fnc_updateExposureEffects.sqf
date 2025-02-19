#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update exposure effects of patient. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_updateExposureEffects;
 *
 * Public: No
 */

params ["_patient"];

private _lastUpdate = _patient getVariable [QGVAR(ExposureEffects_LastUpdate), -1];
private _deltaT = (CBA_missionTime - _lastUpdate) min 10;

if (_deltaT < 1) exitWith {};

_patient setVariable [QGVAR(ExposureEffects_LastUpdate), CBA_missionTime];

private _lastSync = _patient getVariable [QGVAR(ExposureEffects_LastSync), -1];
private _syncValues = (CBA_missionTime - _lastSync) >= (10 + floor(random 10));

if (_syncValues) then {
    _patient setVariable [QGVAR(ExposureEffects_LastSync), CBA_missionTime];
};

private _isExposed = false;

{
    private _category = _x;
    
    {
        private _hazardType = format ["%1_%2", _category, _x];
        
        if (_patient getVariable [(format ["ACM_CBRN_%1_Exposed_State", toLower _hazardType]), false]) then {
            _isExposed =  true;
            break;
        };
    } forEach _y;
} forEach GVAR(HazardType_List);

private _breathingAbility = 1;
private _breathingAbilityIncrease = 1;

private _CSExposure = _patient getVariable [QGVAR_BUILDUP(Chemical_CS), 0];
private _chlorineExposure = _patient getVariable [QGVAR_BUILDUP(Chemical_Chlorine), 0];

if (_CSExposure > 50 || _chlorineExposure > 0.5) then {
    _breathingAbilityIncrease = _breathingAbilityIncrease / 4;
};

if (_CSExposure >= 100 || _chlorineExposure > 25) then {
    _breathingAbility = _breathingAbility / 2;
};

_patient setVariable [QGVAR(Exposed_State), _isExposed, _syncValues];

_patient setVariable [QGVAR(BreathingAbility_State), _breathingAbility, _syncValues];
_patient setVariable [QGVAR(BreathingAbility_Increase_State), _breathingAbilityIncrease, _syncValues];