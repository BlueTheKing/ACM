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
 * [object, cursorTarget] call ACM_circulation_fnc_beginCPR;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if !(isNull (_patient getVariable [QGVAR(CPR_Medic), objNull])) exitWith {
    [LSTRING(CPR_Already), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

_patient setVariable [QACEGVAR(medical,CPR_provider), _medic, true];
_patient setVariable [QGVAR(CPR_Medic), _medic, true];

_medic setVariable [QGVAR(isPerformingCPR), true, true];

GVAR(CPRTarget) = _patient;
GVAR(CPRActive) = true;
GVAR(BVMActive) = false;

private _notInVehicle = isNull objectParent _medic;
private _initialAnimation = animationState _medic;
private _startDelay = 2;
GVAR(loopCPR) = true;

private _CPRStartTime = CBA_missionTime + _startDelay + 0.2;

[{
    params ["_medic", "_patient", "_notInVehicle", "_CPRStartTime"];
    
    [_patient, "activity", LSTRING(CPR_ActionLog_Started), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

    [{
        params ["_args", "_idPFH"];
        _args params ["_medic", "_patient", "_notInVehicle", "_CPRStartTime"];

        private _patientCondition = (!(IS_UNCONSCIOUS(_patient)) && alive _patient || _patient isEqualTo objNull);

        if (_patientCondition) exitWith { // Stop CPR
            [_idPFH] call CBA_fnc_removePerFrameHandler;

            private _CPRTime = CBA_missionTime - _CPRStartTime; 
            private _time = [_CPRTime, "MM:SS"] call BIS_fnc_secondsToString;

            [_patient, "activity", LSTRING(CPR_ActionLog_Stopped), [[_medic, false, true] call ACEFUNC(common,getName), _time]] call ACEFUNC(medical_treatment,addToLog);

            _patient setVariable [QGVAR(CPR_StoppedTotal), _CPRTime, true];
            _patient setVariable [QGVAR(CPR_StoppedTime), CBA_missionTime, true];

            if !(_patient getVariable [QACEGVAR(medical,CPR_provider), objNull] isEqualTo objNull) then {
                _patient setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
            };

            _patient setVariable [QGVAR(CPR_Medic), objNull, true];
            _medic setVariable [QGVAR(isPerformingCPR), false, true];

            [LSTRING(CPR_Stopped), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
            GVAR(CPRActive) = false;

            [QEGVAR(core,openMedicalMenu), GVAR(CPRTarget)] call CBA_fnc_localEvent;

            GVAR(CPRTarget) = objNull;
        };

        _medic setVariable [QGVAR(isPerformingCPR), GVAR(CPRActive), true];

        if (_notInVehicle && GVAR(loopCPR)) then {
            GVAR(loopCPR) = false;

            [{
                params ["_patient"];

                !([_patient] call EFUNC(core,cprActive));
            }, {}, [_patient], 9, {
                if !([_patient] call EFUNC(core,cprActive)) exitWith {};
                GVAR(loopCPR) = true;
            }] call CBA_fnc_waitUntilAndExecute;
        };
    }, 0, [_medic, _patient, _notInVehicle, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

    [QGVAR(handleCPR), [_patient, _CPRStartTime], _patient] call CBA_fnc_targetEvent;
}, [_medic, _patient, _notInVehicle, _CPRStartTime], _startDelay] call CBA_fnc_waitAndExecute;