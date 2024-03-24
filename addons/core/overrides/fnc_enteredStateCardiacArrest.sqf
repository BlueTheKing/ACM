#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Handles a unit entering cardiac arrest (calls for a status update).
 * Sets required variables for countdown timer until death.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ace_medical_statemachine_fnc_enteredStateCardiacArrest
 *
 * Public: No
 */

params ["_unit"];
if (isNull _unit || {!isNil {_unit getVariable QACEGVAR(medical,causeOfDeath)}}) exitWith {
    WARNING_1("enteredStateCardiacArrest: State transition on dead or null unit - %1",_unit);
};

_unit setVariable [QACEGVAR(medical_statemachine,cardiacArrestTimeLastUpdate), CBA_missionTime];

TRACE_3("enteredStateCardiacArrest",_unit,_time,CBA_missionTime);

// Update the unit status to reflect cardiac arrest
[_unit, true] call ACEFUNC(medical_status,setCardiacArrestState);

//[_unit] call EFUNC(circulation,handleReversibleCardiacArrest);