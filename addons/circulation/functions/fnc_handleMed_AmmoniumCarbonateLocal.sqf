#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Ammonium Carbonate effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleMed_AmmoniumCarbonateLocal;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(KnockOut_State), false];

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {};

private _oxygenSaturationChance = linearConversion [80, 99, GET_OXYGEN(_patient), 40, 100, true] ;

if (random 100 < _oxygenSaturationChance) then {
    //playSound3D [QPATHTO_R(sound\wakeup.wav), _patient, false, getPosASL _patient, 15, 1, 12];
    [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
};