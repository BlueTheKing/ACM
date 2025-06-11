#include "..\script_component.hpp"
/*
 * Author: Blue
 * Inflict internal bleeding depending on wounds recieved.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Wound Type <NUMBER>
 * 3: Wound Severity <NUMBER>
 * 4: Wound Bleed Rate <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "head", 60, 1, 1] call ACM_damage_fnc_inflictInternalBleeding;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", "_woundTypeID", "_woundSeverityID", "_bleedRate"];

if (_woundSeverityID < 1 || !(_woundTypeID in INTERNAL_WOUND_TYPES)) exitWith {};

private _chance = switch (_woundTypeID) do {
    case 70: { // Puncture
       ([0, 0.3, 0.7] select _woundSeverityID);
    };
    case 60: { // Velocity
       ([0, 0.45, 1] select _woundSeverityID);
    };
    case 10: { // Avulsion
       ([0, 0.2, 0.4] select _woundSeverityID);
    };
    case 30: { // Crush
        ([0, 0.2, 0.3] select _woundSeverityID);
    };
    default {
        ([0, 0.01, 0.1] select _woundSeverityID);
    };
};

_chance = _chance * GVAR(internalBleedingChanceMultiplier);

private _inflict = (_chance >= 1);

if !(_inflict) then {
    private _partDamage = GET_BODYPART_DAMAGE(_patient) select GET_BODYPART_INDEX(_bodyPart);
    _chance = _chance + ((linearConversion [2, 4, _partDamage, 0, 0.5]) min 0.8);
    _inflict = (random 1 < _chance);
};

if !(_inflict) exitWith {};

private _targetWoundID = _woundTypeID + _woundSeverityID;

private _wounds = GET_INTERNAL_WOUNDS(_patient);
private _woundsPart = _wounds getOrDefault [_bodyPart, [], true];
private _foundInjury = false;

private _index = _woundsPart findIf {
    _x params ["_woundID"];

    _woundID == _targetWoundID
};

if (_index != -1) then {
    _foundInjury = true;
};

private _bodyPartSeverity = [0.6,0.6,0.3,0.3,0.45,0.45] select (ALL_BODY_PARTS find _bodyPart);

if (_foundInjury) then {
    private _targetWound = _woundsPart select _index;
    _targetWound params ["_targetWoundID", "_targetWoundCount", "_targetWoundBleedRate"];

    private _newWoundCount = _targetWoundCount + 1;
    private _newBleedRate = (_targetWoundCount * _targetWoundBleedRate + (_bleedRate * _bodyPartSeverity)) / _newWoundCount;
    _woundsPart set [_index, [_targetWoundID, _newWoundCount, _newBleedRate]];
} else {
    // bodypart <- [WoundID, count, bleeding]
    _woundsPart pushBack [_targetWoundID, 1, (_bleedRate * _bodyPartSeverity)]; // TODO add setting
};

_patient setVariable [VAR_INTERNAL_WOUNDS, _wounds, true];