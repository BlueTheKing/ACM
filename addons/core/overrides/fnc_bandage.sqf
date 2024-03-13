#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Bandages open wounds on the given body part of the patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Treatment <STRING>
 * 4: Bandage effectiveness coefficient <NUMBER> (default: 1)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "Head", "FieldDressing"] call ace_medical_treatment_fnc_bandage // TODO REMOVE WHEN FIXED
 *
 * Public: No
 */

_this set [4, 1]; // set default Bandage effectiveness coefficient
[QACEGVAR(medical_treatment,bandaged), _this] call CBA_fnc_localEvent; // Raise event with reference so mods can modify this

params ["_medic", "_patient", "_bodyPart", "_classname", "_bandageEffectiveness"];

[_patient, "activity", ACELSTRING(medical_treatment,Activity_bandagedPatient), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QACEGVAR(medical_treatment,bandageLocal), [_patient, _bodyPart, _classname, _bandageEffectiveness], _patient] call CBA_fnc_targetEvent;
