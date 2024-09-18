#include "..\script_component.hpp"
/*
 * Author: Blue
 * Inspect IV catheter for abnormalities.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Access Site <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 0] call ACM_circulation_fnc_inspectIV;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_accessSite", 0]];

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

private _leaked = false;

private _hintHeight = 1.5;

private _hint = LLSTRING(InspectIV_Clear);
private _hintLog = LLSTRING(InspectIV_Clear_Short);

private _hasFlow = GET_IV_FLOW_X(_patient,_partIndex,_accessSite) > 0;
private _activeBag = false;

if (_hasFlow) then {
    private _bagList = (_patient getVariable [QGVAR(IV_Bags), createHashMap]) getOrDefault [_bodyPart, []];

    private _index = _bagList findIf {
        _x params ["", "", "", "_bagAccessSite", "_iv"];

        _iv && _bagAccessSite == _accessSite;
    };

    _activeBag = (_index > -1);
};

switch (true) do {
    case !(_hasFlow): {
        _hint = LLSTRING(InspectIV_NoFlow);
        _hintLog = LLSTRING(InspectIV_NoFlow_Short);
    };
    case (_activeBag): {
        _hint = LLSTRING(InspectIV_NormalFlow);
        _hintLog = LLSTRING(InspectIV_NormalFlow_Short);
    };
    /*case (false): {
       _hint =  "IV Catheter is loose";
       _hintLog = "loose";
    };*/
    default {};
};

if (_leaked) then {
    _hint = format ["%1<br/>%2", _hint, LLSTRING(InspectIV_Swelling)];
    _hintLog = format ["%1, %2", _hint, LLSTRING(InspectIV_Swelling_Short)];
    _hintHeight = 2;
};

[_hint, _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", LLSTRING(InspectIV_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);