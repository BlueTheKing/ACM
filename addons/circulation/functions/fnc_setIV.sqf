#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV placement on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 * 4: State <BOOL>
 * 5: Is IV? <BOOL>
 * 6: Access Site <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1, true, true, 0] call ACM_circulation_fnc_setIV;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_state", ["_iv", true], ["_accessSite", -1]];

private _hintState = LELSTRING(core,Common_Inserted);
private _hintType = LLSTRING(IV_16g);

private _exit = false;
private _accessSiteHint = "";
private _givePain = 0;
private _successChance = 1;

switch (_type) do {
    case ACM_IV_14G_M: {
        _hintType = LLSTRING(IV_14g);
    };
    case ACM_IO_FAST1_M: {
        _hintType = LLSTRING(IO_FAST1);
        _givePain = 0.5;
    };
    case ACM_IO_EZ_M: {
        _hintType = LLSTRING(IO_EZ);
        _givePain = 0.25;
    };
    default {};
};

if (_iv) then {
    _accessSiteHint = [LLSTRING(IV_Upper), LLSTRING(IV_Middle), LLSTRING(IV_Lower)] select _accessSite;

    if (_state && [_patient, _bodyPart, 0, _accessSite] call FUNC(hasIV)) exitWith {
        _exit = true;
        [(format [LLSTRING(IV_Already), toLower ([_bodyPart] call EFUNC(core,getBodyPartString)), _accessSiteHint]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
} else {
    if (_state && [_patient, _bodyPart] call FUNC(hasIO)) exitWith {
        _exit = true;
        [(format [LLSTRING(IO_Already), toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
};

private _severeDamage = false;

if (_iv && _state) then {
    private _partIndex = GET_BODYPART_INDEX(_bodyPart);

    switch (true) do {
        case (IN_CRDC_ARRST(_patient)): {
            _successChance = linearConversion [0, 180, (CBA_missionTime - _patient getVariable [QGVAR(CardiacArrest_Time), 0]), 0.9, 0, true];
        };
        case (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex)): {
            _successChance = linearConversion [0, 90, (CBA_missionTime - ((_patient getVariable [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]]) select _partIndex)), 0.9, 0, true];
        };
        default {
            GET_BLOOD_PRESSURE(_patient) params ["_diastolic", "_systolic"];

            if (_bodyPart in ["leftarm","rightarm"]) then {
                _successChance = linearConversion [70, 110, _systolic, 0, 1, true];
            } else {
                _successChance = linearConversion [60, 100, _systolic, 0, 1, true];
            };
        };
    };

    if (_successChance > 0.1) then {
        private _bodyPartDamage = (_patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]]) select _partIndex;
        
        private _modifier = 0;

        if (_type == ACM_IV_14G_M) then {
            _modifier = linearConversion [0, 6, _bodyPartDamage, 0, 1, true];
        } else {
            _modifier = linearConversion [5, 12, _bodyPartDamage, 0, 0.2, true];
        };

        _successChance = _successChance - _modifier;

        if (_modifier > 0.6) then {
            _severeDamage = true;
        };
        _successChance = _successChance max 0;
    };

    if (_successChance > 0 && _successChance < 1) then {
        switch (true) do {
            case ([_medic, 2] call ACEFUNC(medical_treatment,isMedic)): { // Doctor
                _successChance = _successChance + 0.1;
            };
            case ([_medic, 1] call ACEFUNC(medical_treatment,isMedic)): {}; // Medic
            default {
                _successChance = _successChance - 0.1;
                _successChance = _successChance max 0;
            };
        };
    };
};

if !(random 1 < _successChance) then {
    _exit = true;
    
    if (_severeDamage) then {
        [(format ["%1, %2", LLSTRING(IV_FailedToLocateVein), (toLower (LLSTRING(IV_BodyPartTooDamaged)))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    } else {
        [LLSTRING(IV_FailedToLocateVein), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    };
};

if (_exit) exitWith {};

private _setState = _type;

if (_state) then {
    if !(_iv) then {
        [_patient, _givePain] call ACEFUNC(medical,adjustPainLevel);
    };
} else {
    _hintState = LELSTRING(core,Common_Removed);
    _setState = 0;
};

if (_iv) then {
    [_patient, "activity", "%1 %2 %3 (%4)", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _hintState), _hintType, _accessSiteHint]] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "activity", "%1 %2 %3", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _hintState), _hintType]] call ACEFUNC(medical_treatment,addToLog);
};

[QGVAR(setIVLocal), [_medic, _patient, _bodyPart, _setState, _iv, _accessSite], _patient] call CBA_fnc_targetEvent;