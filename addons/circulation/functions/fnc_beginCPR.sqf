#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin CPR
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_circulation_fnc_beginCPR;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QACEGVAR(medical,CPR_provider), _medic, true];

GVAR(CPRTarget) = _patient;

GVAR(CPRCancel_EscapeID) = [0x01, [false, false, false], {
    GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

GVAR(CPRCancel_MouseID) = [0xF0, [false, false, false], {
    GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

private _CPRStartTime = CBA_missionTime + 2.5;

ACEGVAR(medical_gui,pendingReopen) = false; // Prevent medical menu from reopening

if (dialog) then { // If another dialog is open (medical menu) close it
    closeDialog 0;
};

private _notInVehicle = isNull objectParent _medic;
private _initialAnimation = animationState _medic;
private _startDelay = 2;
GVAR(loopCPR) = false;

if (_notInVehicle) then {
    [_medic, "AinvPknlMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon_medic", 1] call ACEFUNC(common,doAnimation);
    GVAR(loopCPR) = true;
};

if (_initialAnimation in ["amovpercmstpsnonwnondnon", "amovpknlmstpsnonwnondnon_gear", "amovpknlmstpsnonwnondnon"]) then { // Wack
    _startDelay = 1.8;
};

[{
    params ["_medic", "_patient", "_notInVehicle", "_CPRStartTime"];
    
    ["Stop CPR", "", ""] call ACEFUNC(interaction,showMouseHint);
    ["Started CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    [_patient, "activity", "%1 started CPR", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

    [{
        params ["_args", "_idPFH"];
        _args params ["_medic", "_patient", "_notInVehicle", "_CPRStartTime"];

        private _patientCondition = (!(IS_UNCONSCIOUS(_patient)) && alive _patient || _patient isEqualTo objNull);
        private _medicCondition = (!(alive _medic) || IS_UNCONSCIOUS(_medic) || _medic isEqualTo objNull);
        private _vehicleCondition = !(objectParent _medic isEqualTo objectParent _patient);
        private _distanceCondition = (_patient distance2D _medic > ACEGVAR(medical_gui,maxDistance));

        if (_patientCondition || _medicCondition || (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]) isEqualTo objNull || dialog || {(!_notInVehicle && _vehicleCondition) || {(_notInVehicle && _distanceCondition)}}) exitWith { // Stop CPR
            [_idPFH] call CBA_fnc_removePerFrameHandler;
            [] call ACEFUNC(interaction,hideMouseHint);
            [GVAR(CPRCancel_EscapeID), "keydown"] call CBA_fnc_removeKeyHandler;
            [GVAR(CPRCancel_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;

            if (_notInVehicle) then {
                [_medic, "AinvPknlMstpSnonWnonDnon_medicEnd", 2] call ACEFUNC(common,doAnimation);
            };

            private _CPRTime = CBA_missionTime - _CPRStartTime; 
            private _time = [_CPRTime, "MM:SS"] call BIS_fnc_secondsToString;

            [_patient, "activity", "%1 stopped CPR (%2)", [[_medic, false, true] call ACEFUNC(common,getName), _time]] call ACEFUNC(medical_treatment,addToLog);

            _patient setVariable [QGVAR(CPR_StoppedTotal), _CPRTime, true];
            _patient setVariable [QGVAR(CPR_StoppedTime), CBA_missionTime, true];

            if !(_patient getVariable [QACEGVAR(medical,CPR_provider), objNull] isEqualTo objNull) then {
                _patient setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
            };

            closeDialog 0;

            ["Stopped CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        };

        if (GVAR(loopCPR)) then {
            [QACEGVAR(common,switchMove), [_medic, "AMS_CPR"]] call CBA_fnc_globalEvent;
            GVAR(loopCPR) = false;

            [{
                params ["_medic"];

                !(isNull (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]));
            }, {}, [_medic], 9, {
                GVAR(loopCPR) = true;
            }] call CBA_fnc_waitUntilAndExecute;
        };
    }, 0, [_medic, _patient, _notInVehicle, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

    [QGVAR(handleCPR), [_patient, _CPRStartTime], _patient] call CBA_fnc_targetEvent;
}, [_medic, _patient, _notInVehicle, _CPRStartTime], _startDelay] call CBA_fnc_waitAndExecute;