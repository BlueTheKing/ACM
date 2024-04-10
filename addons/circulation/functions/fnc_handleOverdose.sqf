#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle medication overdose
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Medication Classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "Morphine"] call AMS_circulation_fnc_handleOverdose;
 *
 * Public: No
 */

params ["_patient", "_classname"];

[QACEGVAR(medical,FatalVitals), (_this select 0)] call CBA_fnc_localEvent;