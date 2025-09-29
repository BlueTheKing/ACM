#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle coagulation for internal bleeding (LOCAL)
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Coagulation was initiated by TXA <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_damage_fnc_handleIBCoagulationPFH;
 *
 * Public: No
 */

params ["_patient", ["_fromTXA", false]];

if (_patient getVariable [QGVAR(IBCoagulation_PFH), -1] != -1 || !(IS_I_BLEEDING(_patient))) exitWith {};

_patient setVariable [QGVAR(IBCoagulation_Active), true, true];

_patient setVariable [QGVAR(IBCoagulation_NextAttempt), (CBA_missionTime + (5 + random 4))];

private _id = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", ["_fromTXA", false]];

    private _plateletCount = _patient getVariable [QEGVAR(circulation,Platelet_Count), 3];

    if !(alive _patient) exitWith {
        _patient setVariable [QGVAR(IBCoagulation_PFH), -1];
        _patient setVariable [QGVAR(IBCoagulation_Active), false, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
    
    private _txaCount = ([_patient, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount)) min 2.2;

    if ((_patient getVariable [QGVAR(IBCoagulation_NextAttempt), 0]) > CBA_missionTime) exitWith {};
    _patient setVariable [QGVAR(IBCoagulation_NextAttempt), (CBA_missionTime + 9 - ((_txaCount * 3) + _plateletCount))];

    if (GET_HEART_RATE(_patient) < 20 || (_plateletCount < 0.1 && _txaCount < 0.1) || (GET_EFF_BLOOD_VOLUME(_patient) < 3.6)) exitWith {};

    private _exit = true;

    private _clotEffectiveness = 1;

    if (_plateletCount > 4 || _txaCount > 0.35) then {
        _clotEffectiveness = 2;
    };

    {
        private _internalWounds = GET_INTERNAL_WOUNDS(_patient);
        private _internalWoundsOnPart = _internalWounds getOrDefault [_x, []];

        if (_internalWoundsOnPart isEqualTo []) then {
            continue;
        };

        if ([_patient, _x] call ACEFUNC(medical_treatment,hasTourniquetAppliedTo)) then {
            _exit = false;
            continue;
        };
        
        private _woundIndex = _internalWoundsOnPart findIf {(_x select 1) > 0};

        if (_woundIndex != -1) exitWith {
            (_internalWoundsOnPart select _woundIndex) params ["_woundType", "_woundCount", "_woundBleeding"];
            
            private _woundSeverity = _woundType % 10;
            private _txaEffect = 1 + (2 min _txaCount);
            private _bloodVolumEffect = (GET_EFF_BLOOD_VOLUME(_patient) / 4.5) min 1;

            if (_woundSeverity == 1 || {_woundSeverity == 2 && (random 1 < 0.3 * _txaEffect * _bloodVolumEffect)}) then {
                private _newWoundCount = _woundCount - _clotEffectiveness;

                if (_newWoundCount < 1) then {
                    _internalWoundsOnPart deleteAt _woundIndex;
                } else {
                    private _newWoundBleeding = (_woundBleeding / _woundCount) * _newWoundCount;
                    _internalWoundsOnPart set [_woundIndex, [_woundType, _newWoundCount, _newWoundBleeding]];
                };

                _patient setVariable [VAR_INTERNAL_WOUNDS, _internalWounds, true];
                [_patient] call ACEFUNC(medical_status,updateWoundBloodLoss);
            };

            _exit = false;
        };
    } forEach ALL_BODY_PARTS_PRIORITY;

    if (_exit) exitWith {
        _patient setVariable [QGVAR(IBCoagulation_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(IBCoagulation_PFH), _id];