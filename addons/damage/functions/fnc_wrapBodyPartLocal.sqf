#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle wrapping wounds/bandages on body part
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Wrappable Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "head", 1] call ACM_damage_fnc_wrapBodyPartLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type"];

private _fnc_handleReopening = {
    params ["_patient", "_bodyPart", "_id", "_type"];

    private _delay = random [360, 600, 900];

    [{
        params ["_patient", "_bodyPart", "_id", "_type"];
        
        private _wrappedWounds = GET_WRAPPED_WOUNDS(_patient);
        private _wrappedWoundsOnPart = _wrappedWounds getOrDefault [_bodyPart, []];

        private _wrappedIndex = _wrappedWoundsOnPart findIf {(_x select 0) isEqualTo _id && {_x select 1 > 0}};

        if (_wrappedIndex < 0) exitWith {};

        (_wrappedWoundsOnPart select _wrappedIndex) params ["", "_wrappedAmountOf", "_wrappedBleeding", "_wrappedDamage"];
        private _wrappedWound = [_id, ((_wrappedAmountOf - 1) max 0), _wrappedBleeding, _wrappedDamage];

        _wrappedWoundsOnPart set [_wrappedIndex, _wrappedWound];
        _wrappedWounds set [_bodyPart, _wrappedWoundsOnPart];

        _patient setVariable [VAR_WRAPPED_WOUNDS, _wrappedWounds, true];

        [_patient, 2] call FUNC(refreshWounds);

        private _targetWoundsVar = [VAR_BANDAGED_WOUNDS, VAR_CLOTTED_WOUNDS] select _type;
        private _targetWounds = [GET_BANDAGED_WOUNDS(_patient), GET_CLOTTED_WOUNDS(_patient)] select _type;
        private _targetWoundsOnPart = _targetWounds getOrDefault [_bodyPart, []];

        private _index = _targetWoundsOnPart findIf {(_x select 0) isEqualTo _id};

        if (_index < 0) then {
            _targetWoundsOnPart pushBack [_id, 1, _wrappedBleeding, _wrappedDamage];
        } else {
            (_targetWoundsOnPart select _index) params ["", "_woundAmountOf", "_woundBleeding", "_woundDamage"];

            private _targetWound = [_id, (_woundAmountOf + 1), _woundBleeding, _woundDamage];
            _targetWoundsOnPart set [_index, _targetWound];
        };
        _targetWounds set [_bodyPart, _targetWoundsOnPart];

        _patient setVariable [_targetWoundsVar, _targetWounds, true];

        [_patient, _type] call EFUNC(damage,refreshWounds);

        [_patient] call ACEFUNC(medical_status,updateWoundBloodLoss);

        private _partIndex = ALL_BODY_PARTS find _bodyPart;

        switch (_partIndex) do {
            case 0: { [_patient, true, false, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
            case 1: { [_patient, false, true, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
            case 2;
            case 3: { [_patient, false, false, true, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
            default { [_patient, false, false, false, true] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
        };

        if ((ACEGVAR(medical,limping) == 1) && {_partIndex > 3}) then {
            [_patient] call ACEFUNC(medical_engine,updateDamageEffects);
        };

        private _plateletCount = GET_PLATELET_COUNT(_patient);

        if (random 1 < (linearConversion [2.5, 1, _plateletCount, 1, 0.1, true])) exitWith {};

        private _timeToReopen = linearConversion [2.5, 1, _plateletCount, 1200, 900, true];

        [{
            params ["_patient", "_bodyPart", "_id", "_type"];

            private _targetWoundsVar = [VAR_BANDAGED_WOUNDS, VAR_CLOTTED_WOUNDS] select _type;
            private _targetWounds = [GET_BANDAGED_WOUNDS(_patient), GET_CLOTTED_WOUNDS(_patient)] select _type;
            private _targetWoundsOnPart = _targetWounds getOrDefault [_bodyPart, []];

            private _targetIndex = _targetWoundsOnPart findIf {(_x select 0) isEqualTo _id && {_x select 1 > 0}};
            
            if (_targetIndex < 0) exitWith {};

            (_targetWoundsOnPart select _targetIndex) params ["", "_targetAmountOf", "_targetBleeding", "_targetDamage"];

            private _openWounds = GET_OPEN_WOUNDS(_patient);
            private _openWoundsOnPart = _openWounds getOrDefault [_bodyPart, []];

            if (_openWoundsOnPart isEqualTo []) then {
                _openWoundsOnPart pushBack [_id, 1, _targetBleeding, _targetDamage];
            } else {
                private _openWoundIndex = _openWoundsOnPart findIf {(_x select 0) isEqualTo _id};

                if (_openWoundIndex < 0) then {
                    _openWoundsOnPart pushBack [_id, 1, _targetBleeding, _targetDamage];
                } else {
                    (_openWoundsOnPart select _openWoundIndex) params ["", "_openAmountOf", "_openBleeding", "_openDamage"];
                    _openWoundsOnPart set [_openWoundIndex, [_id, (_openAmountOf + 1), _openBleeding, _openDamage]]
                };
            };

            _targetWoundsOnPart set [_targetIndex, [_id, (_targetAmountOf - 1), _targetBleeding, _targetDamage]];
            _targetWounds set [_bodyPart, _targetWoundsOnPart];
            _patient setVariable [_targetWoundsVar, _targetWounds, true];

            [_patient, _type] call EFUNC(damage,refreshWounds);

            _openWounds set [_bodyPart, _openWoundsOnPart];
            _patient setVariable [VAR_OPEN_WOUNDS, _openWounds, true];

            [_patient] call ACEFUNC(medical_status,updateWoundBloodLoss);

            private _partIndex = GET_BODYPART_INDEX(_bodyPart);

            switch (_partIndex) do {
                case 0: { [_patient, true, false, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                case 1: { [_patient, false, true, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                case 2;
                case 3: { [_patient, false, false, true, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                default { [_patient, false, false, false, true] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
            };

            // Check if limping is caused by this wound re-opening
            if ((ACEGVAR(medical,limping) > 0) && {_partIndex > 3}) then {
                [_patient] call ACEFUNC(medical_engine,updateDamageEffects);
            };
        }, [_patient, _bodyPart, _id, _type], _timeToReopen] call CBA_fnc_waitAndExecute;
    }, [_patient, _bodyPart, _id, _type], _delay] call CBA_fnc_waitAndExecute;
};

private _wrappableList = createHashMap;
private _woundsVar = VAR_BANDAGED_WOUNDS;

if (_type == 1) then {
    _wrappableList = GET_CLOTTED_WOUNDS(_patient);
    _woundsVar = VAR_CLOTTED_WOUNDS;
} else {
    _wrappableList = GET_BANDAGED_WOUNDS(_patient);
};

private _wrappableListOnPart = _wrappableList getOrDefault [_bodyPart, []];

if (_wrappableListOnPart isEqualTo []) exitWith {};
private _openWounds = GET_OPEN_WOUNDS(_patient) getOrDefault [_bodyPart, []];

if (_openWounds isNotEqualTo [] && {[_patient, _bodyPart] call FUNC(isBodyPartBleeding)}) exitWith {}; // Can't wrap while wounds are bleeding

private _wrappedWounds = GET_WRAPPED_WOUNDS(_patient);
private _wrappedWoundsOnPart = _wrappedWounds getOrDefault [_bodyPart, []];

// Handle incrementing or creating new entry for wrapped wounds
if (_wrappedWoundsOnPart isEqualTo []) then { 
    _wrappedWounds set [_bodyPart, _wrappableListOnPart];
} else {
    {
        _x params ["_id", "_amountOf"];

        private _index = _wrappedWoundsOnPart findIf {_x select 0 isEqualTo _id};

        if (_index != -1) then {
            private _current = _wrappedWoundsOnPart select _index;
            _wrappedWoundsOnPart set [_index, [_current select 0, (_current select 1) + _amountOf, _current select 2, _current select 3]];
        } else {
            _wrappedWoundsOnPart insert [-1, [_x]];
        };
    } forEach _wrappableListOnPart;

    _wrappedWounds set [_bodyPart, _wrappedWoundsOnPart];
};

private _plateletEffect = linearConversion [2.5, 1, GET_PLATELET_COUNT(_patient), 0.5, 1, true];

// Handle reopening
{
    _x params ["_id", "_amountOf"];

    for "_i" from 1 to _amountOf do {
        if (random 1 < (([0.5, 0.7] select _type) * _plateletEffect)) then {
            [_patient, _bodyPart, _id, _type] call _fnc_handleReopening;
        };
    };
} forEach _wrappableListOnPart;

_patient setVariable [VAR_WRAPPED_WOUNDS, _wrappedWounds, true];

_wrappableList deleteAt _bodyPart;

_patient setVariable [_woundsVar, _wrappableList, true];

// Check if we fixed limping by wrapping this wound (only for leg wounds)
if (ACEGVAR(medical,limping) > 0 && {_patient getVariable [QACEGVAR(medical,isLimping), false]} && {_bodyPart in ["leftleg", "rightleg"]}) then {
    [_patient] call ACEFUNC(medical_engine,updateDamageEffects);
};