#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Handles the unconscious state
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ace_medical_statemachine_fnc_handleStateCardiacArrest
 *
 * Public: No
 */

params ["_unit"];

// If the unit died the loop is finished
if (!alive _unit || {!local _unit}) exitWith {};

[_unit] call ACEFUNC(medical_vitals,handleUnitVitals);

private _timeDiff = CBA_missionTime - (_unit getVariable [QACEGVAR(medical_statemachine,cardiacArrestTimeLastUpdate), 0]);
if (_timeDiff >= 1) then {
    _timeDiff = _timeDiff min 10;
    _unit setVariable [QACEGVAR(medical_statemachine,cardiacArrestTimeLastUpdate), CBA_missionTime];
    private _receivingCPR = alive (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull]);
    TRACE_3("cardiac arrest life tick",_unit,_receivingCPR,_timeDiff);
};
