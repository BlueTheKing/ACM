#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle draining blood from pleural space
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Device type <NUMBER>
    * 0: Suction Bag
    * 1: ACCUVAC
    * 2: Hand Pump
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

private _item = [LELSTRING(airway,SuctionBag_Short), LELSTRING(airway,ACCUVAC), LELSTRING(breathing,HandPump)] select _type;

[_patient, "activity", LLSTRING(ThoracostomyDrain_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _item]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_drainLocal), [_medic, _patient, _type], _patient] call CBA_fnc_targetEvent;