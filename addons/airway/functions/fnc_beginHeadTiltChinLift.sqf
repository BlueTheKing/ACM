#include "..\script_component.hpp"
#include "..\HeadTilt_defines.hpp"
/*
 * Author: Blue
 * Perform head tilt-chin lift maneuver on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_beginHeadTiltChinLift;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (_patient getVariable [QGVAR(HeadTilt_State), false]) exitWith {
    [LSTRING(HeadTiltChinLift_Already), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

[[_medic, _patient, "head"], { // On Start
    params ["_medic", "_patient", "_bodyPart"];

    "ACM_HeadTilt" cutRsc ["RscHeadTilt", "PLAIN", 0, false];

    GVAR(HeadTiltCancel_MouseID) = [0xF0, [false, false, false], {
        EGVAR(core,ContinuousAction_Active) = false;
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

    [ACELLSTRING(common,Cancel), "", ""] call ACEFUNC(interaction,showMouseHint);
    [_patient, "activity", LSTRING(HeadTiltChinLift_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
    [LSTRING(HeadTiltChinLift_ActionHint), 2, _medic] call ACEFUNC(common,displayTextStructured);
    
    private _display = uiNamespace getVariable ["ACM_HeadTilt", displayNull];
    private _ctrlText = _display displayCtrl IDC_HEADTILT_TEXT;

    _ctrlText ctrlSetText ([_patient, false, true] call ACEFUNC(common,getName));

    _patient setVariable [QGVAR(HeadTilt_State), true, true];
    [_patient] call FUNC(updateAirwayState);
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart", "", "_notInVehicle"];

    [GVAR(HeadTiltCancel_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;

    ["", "", ""] call ACEFUNC(interaction,showMouseHint);

    "ACM_HeadTilt" cutText ["","PLAIN", 0, false];

    if (_notInVehicle) then {
        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
    };

    [LSTRING(HeadTiltChinLift_ActionCancelled), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

    _patient setVariable [QGVAR(HeadTilt_State), false, true];
    [_patient] call FUNC(updateAirwayState);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    if (_patient getVariable [QGVAR(RecoveryPosition_State), false] || _patient call ACEFUNC(medical_status,isBeingDragged) || _patient call ACEFUNC(medical_status,isBeingCarried)) then {
        EGVAR(core,ContinuousAction_Active) = false;
    };
}] call EFUNC(core,beginContinuousAction);