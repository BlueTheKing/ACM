#include "..\script_component.hpp"
/*
 * Author: Miss Heda (code based on beginCPR from Blue)
 * Begin automated CPR
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [object, cursorTarget] call ACM_circulation_fnc_beginCPR_CorpulsCPR;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if !(isNull (GETVAR(_patient,GVAR(CPR_Medic),objNull))) exitWith {
    [LSTRING(CPR_Already), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

_patient setVariable [QACEGVAR(medical,CPR_provider), _patient, true];
_patient setVariable [QGVAR(CPR_Medic), _patient, true];

GVAR(CPRTarget) = _patient;
GVAR(CPRActive) = true;
GVAR(BVMActive) = false;

private _startDelay = 2;
private _CPRStartTime = CBA_missionTime + _startDelay + 0.2;
GVAR(loopCPR) = true;

[{
    params ["_medic", "_patient", "_CPRStartTime"];
    
    [_patient, "activity", LSTRING(CPR_ActionLog_Started), ["Corpuls CPR"]] call ACEFUNC(medical_treatment,addToLog); // CHANGE
    _patient setVariable [QGVAR(CPR_CorpulsActive), true, false];

    [{
        params ["_args", "_idPFH"];
        _args params ["_medic", "_patient", "_CPRStartTime"];

        private _patientCondition = (!(IS_UNCONSCIOUS(_patient)) && alive _patient || _patient isEqualTo objNull || GETVAR(_patient,GVAR(CPR_CorpulsStop),false));

        if (_patientCondition) exitWith {
            [_idPFH] call CBA_fnc_removePerFrameHandler;

            private _CPRTime = CBA_missionTime - _CPRStartTime; 
            private _time = [_CPRTime, "MM:SS"] call BIS_fnc_secondsToString;

            [_patient, "activity", LSTRING(CPR_ActionLog_Stopped), ["Corpuls CPR", _time]] call ACEFUNC(medical_treatment,addToLog); // CHANGE

            _patient setVariable [QGVAR(CPR_StoppedTotal), _CPRTime, true];
            _patient setVariable [QGVAR(CPR_StoppedTime), CBA_missionTime, true];

            if !(GETVAR(_patient,ACEGVAR(medical,CPR_provider),objNull) isEqualTo objNull) then {
                _patient setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
            };

            _patient setVariable [QGVAR(CPR_Medic), objNull, true];
            _patient setVariable [QGVAR(CPR_CorpulsActive), false, true];
            _patient setVariable [QGVAR(CPR_CorpulsStop), false, true];

            //[LSTRING(CPR_Stopped), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
            GVAR(CPRActive) = false;

            //[QEGVAR(core,openMedicalMenu), GVAR(CPRTarget)] call CBA_fnc_localEvent;

            GVAR(CPRTarget) = objNull;
        };

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
    }, 0, [_medic, _patient, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

    [QGVAR(handleCPR), [_patient, _CPRStartTime], _patient] call CBA_fnc_targetEvent;
}, [_medic, _patient, _CPRStartTime], _startDelay] call CBA_fnc_waitAndExecute;