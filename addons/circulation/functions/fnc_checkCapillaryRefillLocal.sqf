#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check Capillary Refill Time of patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm"] call ACM_circulation_fnc_checkCapillaryRefillLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

private _CRT = 4;
private _bloodVolume = GET_BLOOD_VOLUME(_patient);
private _bodyPartString = [ACELSTRING(medical_gui,Torso),ACELSTRING(medical_gui,LeftArm),ACELSTRING(medical_gui,RightArm)] select (_partIndex - 1);

if !(IN_CRDC_ARRST(_patient)) then {
    if (_partIndex in [2,3]) then {
        if !(HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex)) then {
            _CRT = linearConversion [5.8, 5.2, _bloodVolume, 2, 4];
        };
    } else {
        _CRT = linearConversion [5.5, 4.8, _bloodVolume, 2, 4];
    };
};

private _MAP = GET_MAP_PATIENT(_patient);

if (_bloodVolume > 5) then {
    _CRT = _CRT + ([(linearConversion [87, 70, _MAP, 0, 2, true]), (linearConversion [95, 110, _MAP, 0, -2, true])] select (_MAP > 95));
};

private _hintLog = "";
private _hint = "";
switch (true) do {
    case (_CRT < 2): {
        _hint = "~2";
        _hintLog = _hint;
    };
    case (_CRT < 3): {
        _hint = "&lt;3";
        _hintLog = "<3";
    };
    case (_CRT < 4): {
        _hint = "~3";
        _hintLog = _hint;
    };
    default {
        _hint = "&gt;4";
        _hintLog = ">4";
    };
};

[QACEGVAR(common,displayTextStructured), [(format [LLSTRING(CapillaryRefill_Hint), _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", LSTRING(CapillaryRefill_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _hintLog, _bodyPartString]] call ACEFUNC(medical_treatment,addToLog);