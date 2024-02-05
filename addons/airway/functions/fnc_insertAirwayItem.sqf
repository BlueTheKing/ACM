#include "..\script_component.hpp"
/*
 * Author: Blue
 * Attempt to insert airway item
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Airway type <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "OPA"] call AMS_airway_fnc_insertAirwayItem;
 *
 * Public: No
 */

params ["_medic", "_patient", "_type"];

private _item = "Guedel Tube";

if (_type == "SGA") then {
    _item = "iGel";
};

if ((_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0]) + (_patient getVariable [QGVAR(AirwayObstructionBlood_State), 0]) > 0) exitWith {
    [format ["Failed to insert %1<br/>Airway obstructed", _item], 1.5, _medic] call ACEFUNC(common,displayTextStructured);
};

[format ["%1 inserted", _item], 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", "%1 has inserted %2", [[_medic, false, true] call ACEFUNC(common,getName)], _item] call ACEFUNC(medical_treatment,addToLog);

_patient setVariable [QGVAR(AirwayItem), _type, true];
[_patient] call FUNC(updateAirwayState);