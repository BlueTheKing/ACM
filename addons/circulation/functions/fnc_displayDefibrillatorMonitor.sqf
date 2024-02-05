#include "..\script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Blue
 * 
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_circulation_fnc_displayDefibrillatorMonitor;
 *
 * Public: No
 */

params ["_medic", "_patient"];

createDialog QGVAR(Lifepak_Monitor_Dialog);

GVAR(EKG_RefreshDisplay) = [];
GVAR(EKG_RefreshStep) = 0;
GVAR(EKG_Tick) = CBA_missionTime;

GVAR(EKG_Display) = [];
GVAR(EKG_Display) resize [175, 0];

private _dlg = findDisplay IDC_LIFEPAK_MONITOR;

private _fnc_getLineIDC = {
    params ["_index"];

    IDC_EKG_LINE_0 + _index;
};

private _fnc_adjustLine = {
    params ["_ctrlLine", "_previousHeight", "_targetHeight"];

    private _actualTargetHeight = _targetHeight - _previousHeight;

    _ctrlLine ctrlSetPosition [(ctrlPosition _ctrlLine select 0), AMS_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlLine select 2), AMS_pxToScreen_H((_targetHeight - _previousHeight))];
    _ctrlLine ctrlCommit 0;
};

private _fnc_generateSequence = {
    params ["_rhythm", "_spacing", "_maxLength"];

    private _stepSpacingArray = [];

    if (_spacing > 4) then {
        for "_i" from 0 to (ceil(_spacing/4)) do {
            _stepSpacingArray = _stepSpacingArray + [(random [0, 0.1, 0.5]),(random [0.5, 1, 1.5]),(random [0, 0.1, 0.5]),(random [-1, -0.5, 0])];
        };
    } else {
        _stepSpacingArray = [(random [0, 0.1, 0.5]),(random [0.5, 1, 1.5]),(random [0, 0.1, 0.5]),(random [-1, -0.5, 0])];
    };
    _stepSpacingArray resize _spacing;

    private _rhythmArray = [];

    switch (_rhythm) do {
        //case 1: { };
        case 0: {
            private _stepArray = [0,-1,-5,0.1,2,-4,-40,25,5,2,1,-5,-7,-1,5,4,2,0.8] + _stepSpacingArray;

            private _repeat = ceil((count GVAR(EKG_Display)) / (count _stepArray));

            for "_i" from 0 to _repeat do {
                _rhythmArray = _rhythmArray + _stepArray;
            };
        };
    };

    _rhythmArray resize _maxLength;
    _rhythmArray;
};

_patient setVariable [QGVAR(EKG_Refresh), CBA_missionTime, true];
_patient setVariable [QGVAR(EKG_Rhythm), (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0]), true];

GVAR(EKG_RefreshDisplay) = [0,10,(count GVAR(EKG_Display))] call _fnc_generateSequence;

{
    GVAR(EKG_Display) set [_forEachIndex, GVAR(EKG_RefreshDisplay) select _forEachIndex];

    private _ctrlLine = _dlg displayCtrl ([_forEachIndex] call _fnc_getLineIDC);

    private _previousIndex = (_forEachIndex - 1);

    if (_previousIndex < 0) then {
        _previousIndex = 0;
    };

    [_ctrlLine, (GVAR(EKG_RefreshDisplay) select _previousIndex), (GVAR(EKG_RefreshDisplay) select _forEachIndex)] call _fnc_adjustLine;
} forEach GVAR(EKG_Display);










/*[{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_ekgDisplay"];

    if (false) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _rhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
    private _stepSpacing = 10;
    private _currentStep = GVAR(EKG_Display_RhythmStep);

    if (_patient getVariable [QGVAR(EKG_Refresh), -1] + 5 < CBA_missionTime || (_rhythm != _patient setVariable [QGVAR(EKG_Rhythm), -1])) then {
        _patient setVariable [QGVAR(EKG_Refresh), CBA_missionTime, true];

        GVAR(EKG_RefreshDisplay) = [_rhythm, _stepSpacing] call _fnc_generateSequence;
    };

    if (GVAR(EKG_Tick) < (CBA_missionTime + 28.571)) then {
        GVAR(EKG_Tick) = CBA_missionTime;
        if (GVAR(EKG_RefreshStep) < 174) then {
            GVAR(EKG_RefreshStep) = GVAR(EKG_RefreshStep) + 1;
        } else {
            GVAR(EKG_RefreshStep) = 0;
        };

        GVAR(EKG_Display) set [GVAR(EKG_RefreshStep), GVAR(EKG_RefreshStep) select GVAR(EKG_RefreshStep)];


    };
    
}, 0, [_patient, _ekgDisplay]] call CBA_fnc_addPerFrameHandler;*/