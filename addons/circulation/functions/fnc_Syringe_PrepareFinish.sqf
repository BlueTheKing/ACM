#include "..\script_component.hpp"
/*
 * Author: Blue
 * Finish preparing medication into syringe
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Medication Classname <STRING>
 * 2: Dose (mL) <NUMBER>
 * 3: Syringe Size <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 'Epinephrine', 1, 10] call ACM_circulation_fnc_Syringe_PrepareFinish;
 *
 * Public: No
 */

params ["_medic", "_medication", "_dose", ["_size", 10]];

switch (GVAR(SyringeDraw_InventorySelection)) do {
    case 1: {
        GVAR(SyringeDraw_Target) removeItem (format ["ACM_Vial_%1", _medication]);
    };
    case 2: {
        (objectParent _medic) addItemCargoGlobal [(format ["ACM_Vial_%1", _medication]), -1];
    };
    default {
        _medic removeItem (format ["ACM_Vial_%1", _medication]);
    };
};

_medic removeItem (format ["ACM_Syringe_%1", _size]);

[_medic, (format ["ACM_Syringe_%1_%2",_size, _medication]), "", (floor (_dose * 100))] call ACEFUNC(common,addToInventory);