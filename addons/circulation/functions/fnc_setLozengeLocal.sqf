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
    private _inSittingState = _patient getVariable [QEGVAR(core,Sitting_State), false];
    private _lozengeItem = _patient getVariable [QGVAR(LozengeItem), ""];

    if (_lozengeItem != _type || IS_UNCONSCIOUS(_patient) || _woreOff || (!_inLyingState && !_inSittingState)) exitWith {
        private _medicationList = +(_patient getVariable [QGVAR(ActiveMedication), []]);
        private _index = _medicationList findIf {(_x select 0) == _type && (_x select 1) == ACM_ROUTE_BUCC && (_x select 4) < (CBA_missionTime + 5)};

        if (!_woreOff && _index > -1) then {
            (_medicationList select _index) params ["_entryMedication", "_entryRoute", "_entryPartIndex", "_entryDose", "_entryAdministrationTime", "_entryAbsorptionTime", "_entryMaintainTime", "_entryEliminateTime", "_entryRouteMaximumConcentration"];

            private _timePassed = CBA_missionTime - _entryAdministrationTime;
            private _effectReached = [_entryDose, _entryAdministrationTime, _entryAbsorptionTime, _entryMaintainTime, _entryEliminateTime] call FUNC(getMedicationConcentration_Single);

            _medicationList set [_index, [_entryMedication, _entryRoute, _entryPartIndex, _entryDose * _effectReached, _entryAdministrationTime, _timePassed, _entryMaintainTime - _timePassed, _entryEliminateTime - _timePassed, _entryRouteMaximumConcentration]];

            _patient setVariable [QGVAR(ActiveMedication), _medicationList, true];
        };

        _patient setVariable [QGVAR(LozengeItem), "", true];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 0.1, [_patient, CBA_missionTime, _type]] call CBA_fnc_addPerFrameHandler;