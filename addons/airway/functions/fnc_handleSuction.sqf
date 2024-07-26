#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle suction of airway
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Device type <NUMBER>
    * 0: Suction Bag
    * 1: ACCUVAC
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, 0] call ACM_airway_fnc_handleSuction;
 *
 * Public: No
 */

params ["_medic", "_patient", "_type"];

private _hint = format ["%1<br />%2", LLSTRING(Suction_Finished), LLSTRING(Suction_AirwayIsClear)];
private _device = ([LSTRING(SuctionBag_Short), LSTRING(ACCUVAC)] select _type);

if (((_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0]) + (_patient getVariable [QGVAR(AirwayObstructionBlood_State), 0])) > 0) then {
    [QGVAR(handleSuctionLocal), [_patient], _patient] call CBA_fnc_targetEvent;

    _hint = format ["%1<br />%2", LLSTRING(Suction_Finished), LLSTRING(Suction_AirwayHasBeenCleared)];
};

[_hint, 2, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", ACELSTRING(medical_treatment,Activity_usedItem), [[_medic, false, true] call ACEFUNC(common,getName), _device]] call ACEFUNC(medical_treatment,addToLog);