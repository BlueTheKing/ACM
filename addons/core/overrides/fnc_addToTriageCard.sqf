#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Adds an entry to the unit's triage card.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item Classname <STRING/ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "ACE_morphine"] call ace_medical_treatment_fnc_addToTriageCard
 *
 * Public: No
 */

params ["_unit", "_item"];

if (!local _unit) exitWith {
    [QACEGVAR(medical_treatment,addToTriageCard), _this, _unit] call CBA_fnc_targetEvent;
};

private _triageCard = _unit getVariable [QACEGVAR(medical,triageCard), []];
private _time = [] call EFUNC(core,getTimeString);

_triageCard pushBack [_item, _time];

_unit setVariable [QACEGVAR(medical,triageCard), _triageCard, true];

// todo: add amount of item to event args?
["ace_triageCardItemAdded", [_unit, _item]] call CBA_fnc_localEvent;
