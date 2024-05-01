#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Ammonia Inhalant effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleMed_AmmoniaInhalantLocal;
 *
 * Public: No
 */

params ["_patient"];

private _usesLeft = _patient getVariable [QGVAR(AmmoniaInhalant_EffectiveUses), 0];

if (_usesLeft < 1) exitWith {};

_usesLeft = _usesLeft - 1;

_patient setVariable [QGVAR(AmmoniaInhalant_EffectiveUses), _usesLeft, true];

_patient setVariable [QEGVAR(core,KnockOut_State), false];

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {};

private _oxygenSaturationChance = linearConversion [80, 99, GET_OXYGEN(_patient), 40, 100, true] ;

if (random 100 < _oxygenSaturationChance) then {
    if (IS_UNCONSCIOUS(_patient)) then {
        [QEGVAR(core,playWakeUpSound), _patient] call CBA_fnc_localEvent;
        [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
    };
};