#include "..\script_component.hpp"
/*
 * Author: Blue
 * Finish preparing medication into syringe
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Medication Classname <STRING>
 * 2: Dose (mL) <NUMBER>
 * 3: IV? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 'Epinephrine', 1, false] call ACM_circulation_fnc_Syringe_PrepareFinish;
 *
 * Public: No
 */

params ["_medic", "_medication", "_dose", ["_iv", false]];

_medic removeItem (format ["ACM_Vial_%1", _medication]);

if (_iv) then {
    _medic removeItem "ACM_Syringe_IV";
    [_medic, (format ["ACM_Syringe_IV_%1", _medication]), "", (floor (_dose * 100))] call ACEFUNC(common,addToInventory);
} else {
    _medic removeItem "ACM_Syringe_IM";
    [_medic, (format ["ACM_Syringe_IM_%1", _medication]), "", (floor (_dose * 100))] call ACEFUNC(common,addToInventory);
};