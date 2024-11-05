#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Handles the bandage of a patient.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Impact <NUMBER>
 * 2: Body Part <STRING>
 * 3: Injury Index <NUMBER>
 * 4: Injury <ARRAY>
 * 5: Used Bandage type <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_target", "_impact", "_bodyPart", "_injuryIndex", "_injury", "_bandage"]; // ace_medical_treatment_fnc_handleBandageOpening
TRACE_6("handleBandageOpening",_target,_impact,_bodyPart,_injuryIndex,_injury,_bandage);

_injury params ["_classID"];

private _className = ACEGVAR(medical_damage,woundClassNamesComplex) select _classID;
private _reopeningChance = DEFAULT_BANDAGE_REOPENING_CHANCE;
private _reopeningMinDelay = DEFAULT_BANDAGE_REOPENING_MIN_DELAY;
private _reopeningMaxDelay = DEFAULT_BANDAGE_REOPENING_MAX_DELAY;

// Get the default values for the used bandage
private _config = configFile >> QUOTE(ACE_ADDON(medical_treatment)) >> "Bandaging";

if (isClass (_config >> _bandage)) then {
    _config = _config >> _bandage;
    _reopeningChance = getNumber (_config >> "reopeningChance");
    _reopeningMinDelay = getNumber (_config >> "reopeningMinDelay");
    _reopeningMaxDelay = getNumber (_config >> "reopeningMaxDelay") max _reopeningMinDelay;
} else {
    WARNING_2("No config for bandage [%1] config base [%2]",_bandage,_config);
};

if (isClass (_config >> _className)) then {
    private _woundTreatmentConfig = _config >> _className;

    if (isNumber (_woundTreatmentConfig >> "reopeningChance")) then {
        _reopeningChance = getNumber (_woundTreatmentConfig >> "reopeningChance");
    };

    if (isNumber (_woundTreatmentConfig >> "reopeningMinDelay")) then {
        _reopeningMinDelay = getNumber (_woundTreatmentConfig >> "reopeningMinDelay");
    };

    if (isNumber (_woundTreatmentConfig >> "reopeningMaxDelay")) then {
        _reopeningMaxDelay = getNumber (_woundTreatmentConfig >> "reopeningMaxDelay") max _reopeningMinDelay;
    };
} else {
    WARNING_2("No config for wound type [%1] config base [%2]",_className,_config);
};
TRACE_5("configs",_bandage,_className,_reopeningChance,_reopeningMinDelay,_reopeningMaxDelay);

private _bandagedWounds = GET_BANDAGED_WOUNDS(_target);
private _exist = false;
{
    _x params ["_id", "_amountOf"];
    if (_id == _classID) exitWith {
        _x set [1, _amountOf + _impact];
        TRACE_2("adding to existing bandagedWound",_id,_bodyPart);
        _exist = true;
    };
} forEach (_bandagedWounds getOrDefault [_bodyPart, []]);

if (!_exist) then {
    TRACE_2("adding new bandagedWound",_classID,_bodyPart);
    private _bandagedInjury = +_injury;
    _bandagedInjury set [1, _impact];
    (_bandagedWounds getOrDefault [_bodyPart, [], true]) pushBack _bandagedInjury;
};

_target setVariable [VAR_BANDAGED_WOUNDS, _bandagedWounds, true];

// _reopeningChance = 1;
// _reopeningMinDelay = 5;
// _reopeningMaxDelay = 6;

private _plateletCount = GET_PLATELET_COUNT(_target);
private _plateletEffect = linearConversion [2.5, 1, _plateletCount, 0.5, 1, true];
private _willClot = random 1 < (linearConversion [2, 1, _plateletCount, 1, 0, true]);

TRACE_1("",_reopeningChance);
// Check if we are ever going to reopen this
if (random 1 <= _reopeningChance * _plateletEffect * ACEGVAR(medical_treatment,woundReopenChance)) then {
    private _delay = _reopeningMinDelay + random (_reopeningMaxDelay - _reopeningMinDelay);
    TRACE_1("Will open",_delay);

    if (_willClot) then {
        [{
            params ["_target", "_impact", "_bodyPart", "_injuryIndex", "_injury"];
            TRACE_5("reopen delay finished",_target,_impact,_bodyPart,_injuryIndex,_injury);

            private _bandagedWounds = GET_BANDAGED_WOUNDS(_target);
            private _bandagedWoundsOnPart = _bandagedWounds getOrDefault [_bodyPart, []];

            if (count _bandagedWoundsOnPart < 1) exitWith {};

            _injury params ["_classID"];

            private _targetIndex = _bandagedWoundsOnPart findIf {(_x select 0) isEqualTo _classID};

            if (_targetIndex < 0) exitWith {};

            (_bandagedWoundsOnPart select _targetIndex) params ["", "_bAmount", "_bBleed", "_bDamage"];

            private _clottedWounds = GET_CLOTTED_WOUNDS(_target);
            private _clottedwoundsOnPart = _clottedWounds getOrDefault [_bodyPart, []];

            if (_clottedwoundsOnPart isEqualTo []) then {
                _clottedWounds set [_bodyPart, [[_classID, _impact, _bBleed, _bDamage]]];
            } else {
                private _clottedIndex = _clottedwoundsOnPart findIf {(_x select 0) isEqualTo _classID};
                if (_clottedIndex < 0) then {
                    _clottedwoundsOnPart pushBack [_classID, _impact, _bBleed, _bDamage];
                } else {
                    (_clottedwoundsOnPart select _clottedIndex) params ["", "_cAmount", "_cBleed", "_cDamage"];
                    _clottedwoundsOnPart set [_clottedIndex, [_classID, (_cAmount + _impact), _cBleed, _cDamage]];
                };
                _clottedWounds set [_bodyPart, _clottedwoundsOnPart];
            };

            _target setVariable [VAR_CLOTTED_WOUNDS, _clottedWounds, true];

            _bandagedWoundsOnPart set [_targetIndex, [_classID, (_bAmount - _impact), _bBleed, _bDamage]];

            _bandagedWounds set [_bodyPart, _bandagedWoundsOnPart];
            _target setVariable [VAR_BANDAGED_WOUNDS, _bandagedWounds, true];

            [_target, 0] call EFUNC(damage,refreshWounds);

            private _partIndex = ALL_BODY_PARTS find _bodyPart;

            // Re-add trauma and damage visuals
            if (ACEGVAR(medical_treatment,clearTrauma) == 2) then {
                private _injuryDamage = _bDamage * _impact;
                private _bodyPartDamage = _target getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];
                private _newDam = (_bodyPartDamage select _partIndex) + _injuryDamage;

                _bodyPartDamage set [_partIndex, _newDam];
                _target setVariable [QACEGVAR(medical,bodyPartDamage), _bodyPartDamage, true];
                switch (_partIndex) do {
                    case 0: { [_target, true, false, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                    case 1: { [_target, false, true, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                    case 2;
                    case 3: { [_target, false, false, true, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                    default { [_target, false, false, false, true] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                };
            };

            // Check if we gained limping from this wound re-opening
            if ((ACEGVAR(medical,limping) == 1) && {_partIndex > 3}) then {
                [_target] call ACEFUNC(medical_engine,updateDamageEffects);
            };

            private _plateletCount = GET_PLATELET_COUNT(_target);

            if (random 1 < (linearConversion [2.5, 1, _plateletCount, 1, 0.1, true])) exitWith {};

            private _reopenTimeMid = (linearConversion [2.5, 1, _plateletCount, 360, 150, true]);
            private _reopenTime = random [_reopenTimeMid - 60, _reopenTimeMid, _reopenTimeMid + 60];

            [{
                params ["_target", "_bodyPart", "_id", "_impact"];

                private _clottedWounds = GET_CLOTTED_WOUNDS(_target);
                private _clottedWoundsOnPart = _clottedWounds getOrDefault [_bodyPart, []];

                private _targetIndex = _clottedWoundsOnPart findIf {(_x select 0) isEqualTo _id && {_x select 1 > 0}};

                if (_targetIndex < 0) exitWith {};

                (_clottedWoundsOnPart select _targetIndex) params ["", "_cAmountOf", "_cBleeding", "_cDamage"];

                private _openWounds = GET_OPEN_WOUNDS(_target);
                private _openWoundsOnPart = _openWounds getOrDefault [_bodyPart, []];

                if (_openWoundsOnPart isEqualTo []) then {
                    _openWoundsOnPart pushBack [_id, _impact, _cBleeding, _cDamage];
                } else {
                    private _openWoundIndex = _openWoundsOnPart findIf {(_x select 0) isEqualTo _id};

                    if (_openWoundIndex < 0) then {
                        _openWoundsOnPart pushBack [_id, _impact, _cBleeding, _targetDamage];
                    } else {
                        (_openWoundsOnPart select _openWoundIndex) params ["", "_openAmountOf", "_openBleeding", "_openDamage"];
                        _openWoundsOnPart set [_openWoundIndex, [_id, (_openAmountOf + _impact), _openBleeding, _openDamage]]
                    };
                };

                _clottedWoundsOnPart set [_targetIndex, [_id, (0 max (_cAmountOf - _impact)), _cBleeding, _cDamage]];
                _clottedWounds set [_bodyPart, _clottedWoundsOnPart];
                _target setVariable [VAR_CLOTTED_WOUNDS, _clottedWounds, true];

                _openWounds set [_bodyPart, _openWoundsOnPart];
                _target setVariable [VAR_OPEN_WOUNDS, _openWounds, true];

                [_target, 1] call EFUNC(damage,refreshWounds);

                [_target] call ACEFUNC(medical_status,updateWoundBloodLoss);

                private _partIndex = ALL_BODY_PARTS find _bodyPart;

                switch (_partIndex) do {
                    case 0: { [_target, true, false, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                    case 1: { [_target, false, true, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                    case 2;
                    case 3: { [_target, false, false, true, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                    default { [_target, false, false, false, true] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                };

                if ((ACEGVAR(medical,limping) == 1) && {_partIndex > 3}) then {
                    [_target] call ACEFUNC(medical_engine,updateDamageEffects);
                };
            }, [_target, _bodyPart, _classID, _impact], _reopenTime] call CBA_fnc_waitAndExecute;
        }, [_target, _impact, _bodyPart, _injuryIndex, +_injury], _delay] call CBA_fnc_waitAndExecute;
    } else {
        [{
            params ["_target", "_impact", "_bodyPart", "_injuryIndex", "_injury"];
            TRACE_5("reopen delay finished",_target,_impact,_bodyPart,_injuryIndex,_injury);

            private _openWounds = GET_OPEN_WOUNDS(_target);
            private _woundsOnPart = _openWounds getOrDefault [_bodyPart, []];
            if (count _woundsOnPart - 1 < _injuryIndex) exitWith { TRACE_2("index bounds",_injuryIndex,count _woundsOnPart); };

            _injury params ["_classID"];

            private _selectedInjury = _woundsOnPart select _injuryIndex;
            _selectedInjury params ["_selClassID", "_selAmount"];

            if (_selClassID == _classID) then { // matching the IDs
                private _bandagedWounds = GET_BANDAGED_WOUNDS(_target);
                private _exist = false;
                {
                    _x params ["_id", "_amountOf"];
                    if (_id == _classID) exitWith {
                        TRACE_2("bandagedWound exists",_id,_classID);
                        _x set [1, 0 max (_amountOf - _impact)];
                        _exist = true;
                    };
                } forEach (_bandagedWounds getOrDefault [_bodyPart, []]);

                if (_exist) then {
                    TRACE_2("Reopening Wound",_bandagedWounds,_openWounds);
                    _selectedInjury set [1, _selAmount + _impact];
                    _target setVariable [VAR_BANDAGED_WOUNDS, _bandagedWounds, true];
                    _target setVariable [VAR_OPEN_WOUNDS, _openWounds, true];

                    [_target] call ACEFUNC(medical_status,updateWoundBloodLoss);

                    private _partIndex = ALL_BODY_PARTS find _bodyPart;

                    // Re-add trauma and damage visuals
                    if (ACEGVAR(medical_treatment,clearTrauma) == 2) then {
                        private _injuryDamage = (_selectedInjury select 3) * _impact;
                        private _bodyPartDamage = _target getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];
                        private _newDam = (_bodyPartDamage select _partIndex) + _injuryDamage;
                        _bodyPartDamage set [_partIndex, _newDam];

                        _target setVariable [QACEGVAR(medical,bodyPartDamage), _bodyPartDamage, true];

                        switch (_partIndex) do {
                            case 0: { [_target, true, false, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                            case 1: { [_target, false, true, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                            case 2;
                            case 3: { [_target, false, false, true, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                            default { [_target, false, false, false, true] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
                        };
                    };

                    // Check if we gained limping from this wound re-opening
                    if ((ACEGVAR(medical,limping) == 1) && {_partIndex > 3}) then {
                        [_target] call ACEFUNC(medical_engine,updateDamageEffects);
                    };
                };
            } else {
                TRACE_3("no match",_selectedInjury,_classID,_bodyPart);
            };
        }, [_target, _impact, _bodyPart, _injuryIndex, +_injury], _delay] call CBA_fnc_waitAndExecute;
    };
};
