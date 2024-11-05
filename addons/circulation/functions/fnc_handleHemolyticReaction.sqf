#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle blood transfusion reaction
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call ACM_circulation_fnc_handleHemolyticReaction;
 *
 * Public: No
 */

params ["_patient"];

[{
    params ["_patient"];

    if (_patient getVariable [QGVAR(HemolyticReaction_PFH), -1] != -1) exitWith {};

    _patient setVariable [QGVAR(HemolyticReaction_Severity), 1, true];

    private _PFH = [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        // ace_medical_vitals_fnc_handleUnitVitals
        private _lastTimeValuesSynced = _patient getVariable [QACEGVAR(medical_vitals,lastMomentValuesSynced), 0];
        private _syncValues = (CBA_missionTime - _lastTimeValuesSynced) >= (10 + floor(random 10));

        private _reactionVolume = _patient getVariable [QGVAR(HemolyticReaction_Volume), 0];

        if (!(alive _patient) || ((_reactionVolume <= 0) && {count (_patient getVariable [QGVAR(IV_Bags), createHashMap]) == 0})) exitWith {
            _patient setVariable [QGVAR(HemolyticReaction_PFH), -1];
            _patient setVariable [QGVAR(HemolyticReaction_Severity), 0, true];
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        if (_reactionVolume > 0.1) then {
            private _severity = linearConversion [0.1, 1, _reactionVolume, 1, 10];

            if (GET_PAIN(_patient) < (_severity * 0.07)) then {
                [_patient, ((_severity * 0.07) min 1)] call ACEFUNC(medical,adjustPainLevel);
            };

            _patient setVariable [QGVAR(HemolyticReaction_Severity), _severity, _syncValues];
        } else {
            _patient setVariable [QGVAR(HemolyticReaction_Severity), 0, _syncValues];
        };

    }, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

    _patient setVariable [QGVAR(HemolyticReaction_PFH), _PFH];
}, [_patient], ((random 30) + 30)] call CBA_fnc_waitAndExecute;