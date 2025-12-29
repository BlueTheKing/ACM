#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV placement on patient.
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

private _hintState = ELSTRING(core,Common_Inserted);
private _hintAccessType = LSTRING(IV_16g);

private _bodyPartString = [_bodyPart, false] call EFUNC(core,getBodyPartString);

private _exit = false;
private _hintAccessSite = "";
private _givePain = 0;
private _giveComplication = false;
private _successChance = 1;
private _classname = "ACM_IV_16g";

switch (_type) do {
    case ACM_IV_14G_M: {
        _hintAccessType = LSTRING(IV_14g);
        _classname = "ACM_IV_14g";
    };
    case ACM_IO_FAST1_M: {
        _hintAccessType = LSTRING(IO_FAST1);
        _classname = "ACM_IO_FAST";
        _givePain = 0.31;
    };
    case ACM_IO_EZ_M: {
        _hintAccessType = LSTRING(IO_EZ);
        _classname = "ACM_IO_EZ";
        _givePain = 0.31;
    };
    default {};
};

if (_iv) then {
    _hintAccessSite = [LSTRING(IV_Upper), LSTRING(IV_Middle), LSTRING(IV_Lower)] select _accessSite;

    if (_state) then {
        if ([_patient, _bodyPart, 0, _accessSite] call FUNC(hasIV)) exitWith {
            _exit = true;
            [[LSTRING(IV_Already), _bodyPartString, _hintAccessSite], 2, _medic] call ACEFUNC(common,displayTextStructured);
        };

        if (_accessSite == 0 && _bodyPart in ["leftarm","rightarm"] && {([_patient, _bodyPart] call FUNC(hasPressureCuff) || ([_patient, _bodyPart, 3] call FUNC(hasAED)))}) exitWith {
            _exit = true;
            [LSTRING(IV_Blocked_PressureCuff), 2, _medic] call ACEFUNC(common,displayTextStructured);
        };
    };
} else {
    if (_state && [_patient, _bodyPart] call FUNC(hasIO)) exitWith {
        _exit = true;
        [[LSTRING(IO_Already), _bodyPartString], 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
};

private _severeDamage = false;

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

if (_iv && _state && !_exit) then {
    switch (true) do {
        case !(alive _patient): {
            _successChance = linearConversion [0, 90, (CBA_missionTime - (_patient getVariable [QEGVAR(core,TimeOfDeath), 0])), 0.75, 0, true];
        };
        case (IN_CRDC_ARRST(_patient)): {
            if ([_patient] call EFUNC(core,cprActive)) then {
                _successChance = linearConversion [6, 3, GET_BLOOD_VOLUME(_patient), 0.8, 0, true];
            } else {
                _successChance = linearConversion [0, 120, (CBA_missionTime - (_patient getVariable [QGVAR(CardiacArrest_Time), 0])), 0.8, 0, true];
            };
        };
        case (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex)): {
            _successChance = linearConversion [0, 90, (CBA_missionTime - ((_patient getVariable [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]]) select _partIndex)), 0.9, 0, true];
        };
        default {
            GET_BLOOD_PRESSURE(_patient) params ["_diastolic", "_systolic"];

            if (_bodyPart in ["leftarm","rightarm"]) then {
                _successChance = linearConversion [70, 90, _systolic, 0, 1, true];
            } else {
                _successChance = linearConversion [60, 80, _systolic, 0, 1, true];
            };
        };
    };

    if (_successChance > 0.1) then {
        private _bodyPartDamage = GET_BODYPART_DAMAGE(_patient) select _partIndex;
        
        private _modifier = 0;

        if (_type == ACM_IV_14G_M) then {
            _modifier = linearConversion [ACM_IV_COMPLICATION_THRESHOLD_14_L, ACM_IV_COMPLICATION_THRESHOLD_14_H, _bodyPartDamage, 0, 1, true];
            _giveComplication = (random 1 < (linearConversion [ACM_IV_COMPLICATION_THRESHOLD_14_L, ACM_IV_COMPLICATION_THRESHOLD_14_H, _bodyPartDamage, 0, 1, true]));
        } else {
            _modifier = linearConversion [ACM_IV_COMPLICATION_THRESHOLD_16_L, ACM_IV_COMPLICATION_THRESHOLD_16_H, _bodyPartDamage, 0, 0.2, true];
            _giveComplication = (random 1 < (linearConversion [ACM_IV_COMPLICATION_THRESHOLD_16_L, ACM_IV_COMPLICATION_THRESHOLD_16_H, _bodyPartDamage, 0, 0.5, true]));
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

if (!_exit && !(random 1 < _successChance)) then {
    _exit = true;
    
    if (_severeDamage) then {
        [["%1<br />%2", LSTRING(IV_FailedToLocateVein), LSTRING(IV_BodyPartTooDamaged)], 2, _medic] call ACEFUNC(common,displayTextStructured);
    } else {
        [LSTRING(IV_FailedToLocateVein), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    };
};

if (_exit) exitWith {
    [_medic, _classname] call ACEFUNC(common,addToInventory);
};

private _setState = _type;

if (_state) then {
    if (_iv) then {
        if (GVAR(IVComplications)) then {
            if (_giveComplication) then {
                [_patient, _type, _bodyPart, _accessSite] call FUNC(setIVComplication);
            };
        };
    };
} else {
    _hintState = ELSTRING(core,Common_Removed);
    _setState = 0;
};

if (_iv) then {
    [_patient, "activity", "%1 %2 %3 (%4)", [[_medic, false, true] call ACEFUNC(common,getName), _hintState, _hintAccessType, _hintAccessSite]] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "activity", "%1 %2 %3", [[_medic, false, true] call ACEFUNC(common,getName), _hintState, _hintAccessType]] call ACEFUNC(medical_treatment,addToLog);
};

[QGVAR(setIVLocal), [_medic, _patient, _bodyPart, _setState, _iv, _accessSite], _patient] call CBA_fnc_targetEvent;