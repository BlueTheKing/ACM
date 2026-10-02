#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update medication list
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Medication List <ARRAY<STRING>>
 *
 * Example:
 * [] call ACM_circulation_fnc_Syringe_GetMedicationList;
 *
 * Public: No
 */

params [];

private _targetInventory = switch (GVAR(SyringeDraw_InventorySelection)) do {
    case 1: {[GVAR(SyringeDraw_Target)] call EFUNC(core,itemList)};
    case 2: {};
    default {[ACE_player] call EFUNC(core,itemList)};
};

private _medicationList = [];

{
    if (_x in ACM_MEDICATION_VIALS) then {
        _medicationList pushBack _x;
    };
} forEach _targetInventory;

_medicationList;