#include "..\script_component.hpp"
/*
 * Author: Blue
 * Prepare medication into syringe
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Medication Classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 'Epinephrine'] call ACM_circulation_fnc_Syringe_Prepare;
 *
 * Public: No
 */

params ["_medic", "_medication"];

_medic call ACEFUNC(common,goKneeling);

[3, [_medic, _medication], {
    params ["_args"];
    _args params ["_medic", "_medication"];

    _medic removeItem (format ["ACM_Vial_%1", _medication]);
    _medic removeItem "ACM_Syringe_IM";
    [_medic, (format ["ACM_Syringe_IM_%1", _medication])] call ACEFUNC(common,addToInventory);
}, {}, (format ["Drawing %1...", _medication])] call ACEFUNC(common,progressBar);