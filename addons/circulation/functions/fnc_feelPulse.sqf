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

[[_medic, _patient, _bodyPart], { // On Start
    #define _x_pos(mult) (safezoneX + (safezoneW / 2) - (safezoneW / (160 / mult)))
    #define _y_pos(mult) (safezoneY + (safezoneH / 2) - (safezoneH / (160 / mult)))

    #define _w_pos(mult) (safezoneW / (80 / mult))
    #define _h_pos(mult) (safezoneH / (80 / mult))

    params ["_medic", "_patient", "_bodyPart"];

    "ACM_FeelPulse" cutRsc ["RscFeelPulse", "PLAIN", 0, false];

    GVAR(FeelPulse_NextPulse) = -1;
    GVAR(FeelPulse_Done) = true;

    private _display = uiNamespace getVariable ["ACM_FeelPulse", displayNull];
    private _ctrlText = _display displayCtrl IDC_FEELPULSE_TEXT; 

    private _bodyPartString = switch (_bodyPart) do {
        case "head": {
            "Carotid";
        };
        case "leftarm";
        case "rightarm": {
            "Radial";
        };
        case "leftleg";
        case "rightleg": {
            "Femoral";
        };
    };

    _ctrlText ctrlSetText format ["%1 (%2)", ([_patient, false, true] call ACEFUNC(common,getName)), _bodyPartString];
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart"];

    "ACM_FeelPulse" cutText ["","PLAIN", 0, false];

    if (_notInVehicle) then {
        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
    };

    ["Stopped feeling pulse", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart", "", "_notInVehicle"];

    private _display = uiNamespace getVariable ["ACM_FeelPulse", displayNull];
    private _ctrlHeart = _display displayCtrl IDC_FEELPULSE_HEART;

    private _HR = GET_HEART_RATE(_patient);

    private _partIndex = ALL_BODY_PARTS find _bodyPart;

    private _pressureCutoff = [60,0,80,80,70,70] select _partIndex;

    (GET_BLOOD_PRESSURE(_patient)) params ["", "_BPSystolic"];

    private _pressureTooLow = _pressureCutoff > _BPSystolic;

    if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex)) then {
        _HR = 0;
    };

    if (_HR > 0 && !_pressureTooLow && alive _patient) then {
        _ctrlHeart ctrlShow true;
        
        if (GVAR(FeelPulse_NextPulse) > CBA_missionTime) exitWith {};

        private _delay = 60 / _HR;
        private _strength = (linearConversion [(_pressureCutoff + 0.1), (_pressureCutoff + 40), _BPSystolic, 0.01, 1, true]) * 3;

        private _beatTime = 0.5 min (0.4 * _delay);
        private _releaseTime = 0.7 min (0.6 * _delay);

        _ctrlHeart ctrlSetPosition [_x_pos(_strength), _y_pos(_strength), _w_pos(_strength), _h_pos(_strength)];
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
}] call EFUNC(core,beginContinuousAction);