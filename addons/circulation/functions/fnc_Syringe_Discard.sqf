#include "..\script_component.hpp"
/*
 * Author: Blue
 * Discard syringe medication
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Medication Classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 'Epinephrine'] call ACM_circulation_fnc_Syringe_Discard;
 *
 * Public: No
 */

params ["_medic", "_medication"];

_medic call ACEFUNC(common,goKneeling);

[3, [_medic, _medication], {
    params ["_args"];
    _args params ["_medic", "_medication"];

    _medic removeItem (format ["ACM_Syringe_IM_%1", _medication]);
    [_medic, "ACM_Syringe_IM"] call ACEFUNC(common,addToInventory);
}, {}, (format ["Discarding %1 from syringe...", _medication])] call ACEFUNC(common,progressBar);

