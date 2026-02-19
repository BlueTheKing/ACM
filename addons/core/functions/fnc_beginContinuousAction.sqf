#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin continuous action
 *
 * Arguments:
 * 0: Arguments <ARRAY>
 *   0: Medic <OBJECT>
 *   1: Patient <OBJECT>
 *   2: Body Part <STRING>
 * 1: On Start <CODE>
 * 2: On Cancel <CODE>
 * 3: Per Frame Code <CODE>
 * 4: Allowed Prone <BOOL>
 * 5: Dialog ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[player, cursorTarget, "Head"], {}, {}, {}] call ACM_core_fnc_beginContinuousAction;
 *
 * Public: No
 */

params ["_args", "_onStart", "_onCancel", "_perFrame", ["_allowProne", false], ["_dialogID", -1]];
_args params ["_medic", "_patient", "_bodyPart", ["_extraArgs", []]];

if (GVAR(ContinuousAction_Active)) exitWith {};

GVAR(ContinuousAction_IsDialog) = (_dialogID != -1);
GVAR(ContinuousAction_Active) = true;
GVAR(ContinuousAction_ShouldReopen) = false;

ACEGVAR(medical_gui,pendingReopen) = false; // Prevent medical menu from reopening

if (dialog) then { // If another dialog is open (medical menu) close it
    closeDialog 0;
};

if (GVAR(ContinuousAction_IsDialog)) then {
    GVAR(ContinuousAction_OpenMedicalMenu_ID) = [0x23, [false, false, false], { // H to close and open medical menu
        GVAR(ContinuousAction_ShouldReopen) = true;
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;
} else {
    GVAR(ContinuousAction_Cancel_EscapeID) = [0x01, [false, false, false], { // ESC to close
        GVAR(ContinuousAction_Active) = false;
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;
};

private _notInVehicle = isNull objectParent _medic;

private _medicStance = stance _medic;
private _isProne = (_medicStance == "PRONE") && _allowProne;

if (_notInVehicle) then {
    switch (stance _medic) do {
        case "STAND": {
            [_medic, "AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation); // 0.650

            [{
                params ["_medic"];

                if (GVAR(ContinuousAction_Active)) then {
                    [_medic, "ACM_GenericContinuous", 2] call ACEFUNC(common,doAnimation);
                };
            }, [_medic], 0.65] call CBA_fnc_waitAndExecute;
        };
        case "PRONE": {
            if (_allowProne) then {
                [_medic, "ACM_ProneContinuous", 2] call ACEFUNC(common,doAnimation);
            } else {
                [_medic, "AmovPpneMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation); // 1.116

                [{
                    params ["_medic"];

                    if (GVAR(ContinuousAction_Active)) then {
                        [_medic, "ACM_GenericContinuous", 2] call ACEFUNC(common,doAnimation);
                    };
                }, [_medic], 1.116] call CBA_fnc_waitAndExecute;
            };
        };
        case "CROUCH": {
            [_medic, "ACM_GenericContinuous", 2] call ACEFUNC(common,doAnimation);
        };
        default {};
    };
};

if (currentWeapon _medic != "") then {
    [_medic] call ACEFUNC(weaponselect,putWeaponAway);
};

_args call _onStart;

[{
    params ["_args", "_idPFH"];
    _args params ["_medic", "_patient", "_bodyPart", "_extraArgs", "_notInVehicle", "_isProne", "_perFrame", "_onCancel", "_dialogID"];

    private _patientCondition = (_patient isEqualTo objNull);
    private _medicCondition = (!(alive _medic) || IS_UNCONSCIOUS(_medic) || _medic isEqualTo objNull);
    private _vehicleCondition = (objectParent _medic isNotEqualTo objectParent _patient);
    private _distanceCondition = (_patient distance2D _medic > ACEGVAR(medical_gui,maxDistance));

    private _dialogCondition = dialog;
    
    if (GVAR(ContinuousAction_IsDialog)) then {
        _dialogCondition = isNull (findDisplay _dialogID);
    };
    
    if (_patientCondition || _medicCondition || !GVAR(ContinuousAction_Active) || _dialogCondition || {(!_notInVehicle && _vehicleCondition) || {(_notInVehicle && _distanceCondition)}}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;

        if (GVAR(ContinuousAction_IsDialog)) then {
            [GVAR(ContinuousAction_OpenMedicalMenu_ID), "keydown"] call CBA_fnc_removeKeyHandler;
        } else {
            [GVAR(ContinuousAction_Cancel_EscapeID), "keydown"] call CBA_fnc_removeKeyHandler;
        };

        GVAR(ContinuousAction_Active) = false;

        [_medic, _patient, _bodyPart, _extraArgs, _notInVehicle] call _onCancel;

        if (_notInVehicle) then {
            private _animation = ["AmovPknlMstpSnonWnonDnon", "AmovPpneMstpSnonWnonDnon"] select _isProne;
            [_medic, _animation, 2] call ACEFUNC(common,doAnimation);
        };

        ["ace_treatmentFailed", [_medic, _patient, _bodyPart, "ACM_ContinuousAction", "", "", false]] call CBA_fnc_localEvent;

        if (GVAR(ContinuousAction_ShouldReopen)) then {
            [QGVAR(openMedicalMenu), _patient] call CBA_fnc_localEvent;
        };
    };

    _args call _perFrame;
}, 0, [_medic, _patient, _bodyPart, _extraArgs, _notInVehicle, _isProne, _perFrame, _onCancel, _dialogID]] call CBA_fnc_addPerFrameHandler;