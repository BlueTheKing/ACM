#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle hazard effects on AI. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Hazard Type <STRING>
 * 2: Is Exposed? <BOOL>
 * 3: Is Exposed Externally? <BOOL>
 * 4: Active PPE <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [this, "chemical_cs", true, true, [false,false,false,0]] call ACM_CBRN_fnc_handleAIEffects;
 *
 * Public: No
 */

params ["_patient", "_hazardType", "_isExposed", "_isExposedExternal", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if (CBA_missionTime < (_patient getVariable [QGVAR(AIEffect_NextCheck), 0])) exitWith {};

_patient setVariable [QGVAR(AIEffect_NextCheck), (CBA_missionTime + 5)];

if (_isExposed || (_isExposedExternal && (_hazardType == "chemical_lewisite"))) then {
    [QACEGVAR(ai,allowFleeing), [_patient, 1], _patient] call CBA_fnc_targetEvent;
    
    _patient doMove (_patient getPos [(30 + random 30), (150 + random 30)]);
    _patient setSpeedMode "FULL";
};