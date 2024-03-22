#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Ammonium Carbonate effects
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_circulation_fnc_handleMed_AmmoniumCarbonateLocal;
 *
 * Public: No
 */

params ["_patient"];

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {};

if (true) then { // TODO success conditions
    //playSound3D [QPATHTO_R(sound\wakeup.ogg), _patient, false, getPosASL _patient, 1, 1, 3];
    [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
};