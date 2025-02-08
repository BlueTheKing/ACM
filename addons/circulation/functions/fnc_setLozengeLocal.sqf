#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle setting lozenge for patient. (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Type <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "Fentanyl"] call ACM_circulation_fnc_setLozengeLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_type", ""]];

[{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_insertTime", "_type"];

    private _woreOff = CBA_missionTime - _insertTime > 180;
    private _inLyingState = _patient getVariable [QEGVAR(core,Lying_State), false];
    private _lozengeItem = _patient getVariable [QGVAR(LozengeItem), ""];

    if (_lozengeItem != _type || IS_UNCONSCIOUS(_patient) || _woreOff || !_inLyingState) exitWith {
        private _classname = format ["%1_BUC", _type];

        private _medicationList = +(_patient getVariable [VAR_MEDICATIONS,[]]);
        private _index = _medicationList findIf {(_x select 0) == _classname};

        if (!_woreOff && _index > -1) then {
            (_medicationList select _index) params ["", "_medAdministrationTime", "_medTimeToMaxEffect", "_medMaxTimeInSystem", "_medHRAdjust", "_medPainAdjust", "_medFlowAdjust", "_medAdministrationType", "_medMaxEffectTime", "_medRRAdjust", "_medCOSensitivityAdjust", "_medBreathingEffectivenessAdjust", "", "_medMedicationType"];

            private _timePassed = CBA_missionTime - _medAdministrationTime;
            private _effectReached = [_medAdministrationType, _timePassed, _medTimeToMaxEffect, _medMaxTimeInSystem, _medMaxEffectTime] call FUNC(getMedicationEffect);

            _medicationList set [_index, [_classname, _medAdministrationTime, _timePassed, _medMaxTimeInSystem, _medHRAdjust * _effectReached, _medPainAdjust * _effectReached, _medFlowAdjust * _effectReached, _medAdministrationType, _medMaxEffectTime * _effectReached, _medRRAdjust * _effectReached, _medCOSensitivityAdjust * _effectReached, _medBreathingEffectivenessAdjust * _effectReached, _effectReached, _medMedicationType, 0]];

            _patient setVariable [VAR_MEDICATIONS, _medicationList, true];
        };

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 0.1, [_patient, CBA_missionTime, _type]] call CBA_fnc_addPerFrameHandler;