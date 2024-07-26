#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle draining blood from plueral space
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
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_drain;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_type", 1]];

private _item = [LLSTRING(SuctionBag_Short), LLSTRING(ACCUVAC)] select _type;

[_patient, "activity", LSTRING(ThoracostomyDrain_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _item]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_drainLocal), [_medic, _patient, _type], _patient] call CBA_fnc_targetEvent;