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

private _hintArray = ["%1",LSTRING(InspectIV_Clear)];
private _hintLogArray = [LSTRING(InspectIV_Clear_Short)];
private _hintLogFormat = "%1 %2 (%3): %4";

private _accessSiteHint = [LSTRING(IV_Upper), LSTRING(IV_Middle), LSTRING(IV_Lower)] select _accessSite;

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
        _hintArray set [1, LSTRING(InspectIV_NoFlow)];
        _hintLogArray set [0, LSTRING(InspectIV_NoFlow_Short)];
    };
    case (_activeBag): {
        _hintArray set [1, LSTRING(InspectIV_NormalFlow)];
        _hintLogArray set [0, LSTRING(InspectIV_NormalFlow_Short)];
    };
    /*case (false): {
        _hintArray set [1, "IV Catheter is loose"];
        _hintLogArray set [1, "loose"];
    };*/
    default {};
};

if (_leaked) then {
    _hintArray set [0, "%1<br/>%2"];
    _hintArray pushBack LSTRING(InspectIV_Swelling);

    _hintLogArray pushBack LSTRING(InspectIV_Swelling_Short);
    _hintLogFormat = "%1 %2 (%3): %4, %5";

    _hintHeight = 2;
};

private _logArray = [[_medic, false, true] call ACEFUNC(common,getName), LSTRING(InspectIV_ActionLog), _accessSiteHint];
_logArray append _hintLogArray;

[_hintArray, _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", _hintLogFormat, _logArray] call ACEFUNC(medical_treatment,addToLog);