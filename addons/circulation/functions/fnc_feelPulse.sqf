#include "..\script_component.hpp"
#include "..\FeelPulse_defines.hpp"
/*
 * Author: Blue
 * Handle feeling for pulse of patient.
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
 * [player, cursorObject, "Head"] call ACM_circulation_fnc_feelPulse;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _bodyPartString = switch (_bodyPart) do {
    case "head": {
        LLSTRING(FeelPulse_Carotid);
    };
    case "leftarm";
    case "rightarm": {
        LLSTRING(FeelPulse_Radial);
    };
    case "leftleg";
    case "rightleg": {
        LLSTRING(FeelPulse_Femoral);
    };
};

[_patient, "activity", LSTRING(FeelPulse_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), (toLower _bodyPartString)]] call ACEFUNC(medical_treatment,addToLog);

[[_medic, _patient, _bodyPart, [_bodyPartString]], { // On Start
    #define _x_pos(N) (ACM_FEELPULSE_POS_X(20) - (ACM_FEELPULSE_POS_W((ACM_FEELPULSE_FRONT_W * N)) / 2))
    #define _y_pos(N) (ACM_FEELPULSE_POS_Y(12.5) - (ACM_FEELPULSE_POS_H((ACM_FEELPULSE_FRONT_H * N)) / 2))
    #define _w_pos(N) ((ACM_FEELPULSE_FRONT_W * N) * GUI_GRID_W)
    #define _h_pos(N) ((ACM_FEELPULSE_FRONT_H * N) * GUI_GRID_H)

    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["_bodyPartString"];

    "ACM_FeelPulse" cutRsc ["RscFeelPulse", "PLAIN", 0, false];

    GVAR(FeelPulse_NextPulse) = -1;
    GVAR(FeelPulse_Done) = true;

    private _display = uiNamespace getVariable ["ACM_FeelPulse", displayNull];
    private _ctrlText = _display displayCtrl IDC_FEELPULSE_TEXT;

    _ctrlText ctrlSetText format ["%1 (%2)", ([_patient, false, true] call ACEFUNC(common,getName)), _bodyPartString];
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart"];

    "ACM_FeelPulse" cutText ["","PLAIN", 0, false];

    [LSTRING(FeelPulse_Stopped), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable ["ACM_FeelPulse", displayNull];
    private _ctrlHeart = _display displayCtrl IDC_FEELPULSE_HEART;

    private _HR = GET_HEART_RATE(_patient);

    private _partIndex = ALL_BODY_PARTS find _bodyPart;

    private _pressureCutoff = [60,0,80,80,70,70] select _partIndex;

    (GET_BLOOD_PRESSURE(_patient)) params ["", "_BPSystolic"];

    private _pressureTooLow = _pressureCutoff > _BPSystolic;

    if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex) || (!(HAS_PULSE_P(_patient)) && _partIndex != 0)) then {
        _HR = 0;
    };

    if (_HR > 0 && !_pressureTooLow && alive _patient) then {
        _ctrlHeart ctrlShow true;
        
        if (GVAR(FeelPulse_NextPulse) > CBA_missionTime) exitWith {};

        private _delay = 60 / _HR;
        private _pressureModifier = [0.6, 1] select (HAS_PULSE_P(_patient));
        private _fullStrength = (linearConversion [_pressureCutoff, (_pressureCutoff + 60), _BPSystolic * _pressureModifier, 0.8, 3, true]);
        private _releaseStrength = (linearConversion [_pressureCutoff, (_pressureCutoff + 60), _BPSystolic * _pressureModifier, 0.5, 2, true]);

        private _beatTime = 0.5 min (0.4 * _delay);
        private _releaseTime = 0.7 min (0.6 * _delay);

        _ctrlHeart ctrlSetPosition [_x_pos(_fullStrength), _y_pos(_fullStrength), _w_pos(_fullStrength), _h_pos(_fullStrength)];
        _ctrlHeart ctrlCommit _beatTime;

        [{
            params ["_ctrlHeart", "_releaseTime", "_releaseStrength"];

            _ctrlHeart ctrlSetPosition [_x_pos(_releaseStrength), _y_pos(_releaseStrength), _w_pos(_releaseStrength), _h_pos(_releaseStrength)];
            _ctrlHeart ctrlCommit _releaseTime;
        }, [_ctrlHeart, _releaseTime, _releaseStrength], _beatTime] call CBA_fnc_waitAndExecute;

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
                _ctrlHeart ctrlSetPosition [_x_pos(1), _y_pos(1), _w_pos(1), _h_pos(1)];
                _ctrlHeart ctrlCommit 1;

                [{
                    GVAR(FeelPulse_Done) = true;
                }, [], 1] call CBA_fnc_waitAndExecute;
            };
        };
    };

    private _color = linearConversion [_w_pos(1.1), _w_pos(2.8), ((ctrlPosition _ctrlHeart) select 2), 0.1, 1, false];
    _ctrlHeart ctrlSetTextColor [1, 0, 0, _color];
}, true] call EFUNC(core,beginContinuousAction);