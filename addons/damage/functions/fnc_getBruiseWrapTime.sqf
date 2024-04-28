#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time to wrap bruises in body part
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * Time to wrap bruises <NUMBER>
 *
 * Example:
 * [player, cursorTarget, "head" call ACM_damage_fnc_getBruiseWrapTime;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _woundsOnPart = GET_OPEN_WOUNDS(_patient) getOrDefault [_bodyPart, []];

private _woundsToTreat = 0;
private _treatmentTimeModifier = 0;

{
    _x params ["_id", "_amountOf"];

    if (_woundsToTreat >= 8) exitWith {break;};

    if (_id in [20,21,22] && {_amountOf > 0}) then {

        private _woundSeverity = 1;
        switch (_id) do {
            case 22: {_woundSeverity = 4};
            case 21: {_woundSeverity = 2};
            default {};
        };

        _woundsToTreat = _woundsToTreat + _amountOf * _woundSeverity;
    };
} forEach _woundsOnPart;

if (_medic isEqualTo _patient) then {
    _treatmentTimeModifier = _treatmentTimeModifier + BANDAGE_TIME_MOD_SELF;
};

if ([_medic] call ACEFUNC(medical_treatment,isMedic)) then {
    _treatmentTimeModifier = _treatmentTimeModifier + BANDAGE_TIME_MOD_MEDIC;
};

3 max ((_woundsToTreat min 12) + _treatmentTimeModifier);