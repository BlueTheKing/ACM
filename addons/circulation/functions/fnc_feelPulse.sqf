#include "..\script_component.hpp"
#include "..\FeelPulse_defines.hpp"
/*
 * Author: Blue
 * Handle feeling for pulse of patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "Head"] call ACM_circulation_fnc_feelPulse;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

#define _x_pos(mult) (safezoneX + (safezoneW / 2) - (safezoneW / (160 / mult)))
#define _y_pos(mult) (safezoneY + (safezoneH / 2) - (safezoneH / (160 / mult)))

#define _w_pos(mult) (safezoneW / (80 / mult))
#define _h_pos(mult) (safezoneH / (80 / mult))

ACEGVAR(medical_gui,pendingReopen) = false; // Prevent medical menu from reopening

if (dialog) then { // If another dialog is open (medical menu) close it
    closeDialog 0;
};

"ACM_FeelPulse" cutRsc ["RscFeelPulse", "PLAIN", 0, false];

GVAR(FeelPulseCancel_EscapeID) = [0x01, [false, false, false], { // ESC to close
    GVAR(FeelingPulse) = false;
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

private _notInVehicle = isNull objectParent _medic;

if (_notInVehicle) then {
    switch (stance _medic) do {
        case "STAND": {
            [_medic, "AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation); // 0.650
            [{
                params ["_medic"];

                if (GVAR(FeelingPulse)) then {
                    [_medic, "ACM_FeelPulse", 2] call ACEFUNC(common,doAnimation);
                };
            }, [_medic], 0.65] call CBA_fnc_waitAndExecute;
        };
        case "PRONE": {
            [_medic, "AmovPpneMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation); // 1.116

            [{
                params ["_medic"];

                if (GVAR(FeelingPulse)) then {
                    [_medic, "ACM_FeelPulse", 2] call ACEFUNC(common,doAnimation);
                };
            }, [_medic], 1.116] call CBA_fnc_waitAndExecute;
        };
        case "CROUCH": {
            [_medic, "ACM_FeelPulse", 2] call ACEFUNC(common,doAnimation);
        };
        default {};
    };
};

GVAR(FeelingPulse) = true;

if (currentWeapon _medic != "") then {
    [_medic] call ACEFUNC(weaponselect,putWeaponAway);
};

GVAR(FeelPulse_NextPulse) = -1;
GVAR(FeelPulse_Done) = true;

private _display = uiNamespace getVariable ["ACM_FeelPulse", displayNull];
private _ctrlText = _display displayCtrl IDC_FEELPULSE_TEXT; 
_ctrlText ctrlSetText format ["%1 (%2)", ([_patient, false, true] call ACEFUNC(common,getName)), (localize (format ["STR_ace_medical_gui_%1",_bodyPart]))]; 

[{
    params ["_args", "_idPFH"];
    _args params ["_medic", "_patient", "_notInVehicle"];

    private _patientCondition = (_patient isEqualTo objNull);
    private _medicCondition = (!(alive _medic) || IS_UNCONSCIOUS(_medic) || _medic isEqualTo objNull);
    private _vehicleCondition = !(objectParent _medic isEqualTo objectParent _patient);
    private _distanceCondition = (_patient distance2D _medic > ACEGVAR(medical_gui,maxDistance));
    
    if (_patientCondition || _medicCondition || !(GVAR(FeelingPulse)) || dialog || {(!_notInVehicle && _vehicleCondition) || {(_notInVehicle && _distanceCondition)}}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;

        [GVAR(FeelPulseCancel_EscapeID), "keydown"] call CBA_fnc_removeKeyHandler;
        [GVAR(FeelPulseCancel_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;

        GVAR(FeelingPulse) = false;

        "ACM_FeelPulse" cutText ["","PLAIN", 0, false];

        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);

        ["Stopped feeling pulse", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    };

    private _display = uiNamespace getVariable ["ACM_FeelPulse", displayNull];

    private _ctrlHeart = _display displayCtrl IDC_FEELPULSE_HEART;

    private _HR = GET_HEART_RATE(_patient);

    if (_HR != 0) then {
        _ctrlHeart ctrlShow true;

        private _delay = 60 / _HR;

        if (GVAR(FeelPulse_NextPulse) > CBA_missionTime) exitWith {};

        private _beatTime = 0.5 min (0.4 * _delay);
        private _releaseTime = 0.7 min (0.6 * _delay);

        _ctrlHeart ctrlSetPosition [_x_pos(3), _y_pos(3), _w_pos(3), _h_pos(3)];
        _ctrlHeart ctrlCommit _beatTime;

        [{
            params ["_ctrlHeart", "_releaseTime"];

            _ctrlHeart ctrlSetPosition [_x_pos(1), _y_pos(1), _w_pos(1), _h_pos(1)];
            _ctrlHeart ctrlCommit _releaseTime;
        }, [_ctrlHeart, _releaseTime], _beatTime] call CBA_fnc_waitAndExecute;

        GVAR(FeelPulse_NextPulse) = (CBA_missionTime + _delay);
        GVAR(FeelPulse_Hiding) = false;
        GVAR(FeelPulse_Done) = false;
    } else {
        if (GVAR(FeelPulse_Done)) then {
            _ctrlHeart ctrlShow false;
            GVAR(FeelPulse_Hiding) = false;
        } else {
            if !(GVAR(FeelPulse_Hiding)) then {
                GVAR(FeelPulse_Hiding) = true;
                _ctrlHeart ctrlSetPosition [_x_pos(0.1), _y_pos(0.1), _w_pos(0.1), _h_pos(0.1)];
                _ctrlHeart ctrlCommit 1;

                [{
                    GVAR(FeelPulse_Done) = true;
                }, [], 1] call CBA_fnc_waitAndExecute;
            };
        };
    };

    private _color = linearConversion [_w_pos(0.5), _w_pos(2.9), ((ctrlPosition _ctrlHeart) select 2), 0.1, 1, false];
    _ctrlHeart ctrlSetTextColor [1, 0, 0, _color];
}, 0, [_medic, _patient, _notInVehicle]] call CBA_fnc_addPerFrameHandler;