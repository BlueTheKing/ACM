#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle anesthetic effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Classname <STRING>
 * 3: Medication Dose <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "", "Ketamine", 1] call ACM_circulation_fnc_handleAnestheticEffects;
 *
 * Public: No
 */

params ["_patient", "", "_classname", "_dose"];

if (_patient != ACE_player) exitWith {};

switch (_classname) do {
    case "Ketamine": {
        if (_patient getVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false]) exitWith {};

        [{
            params ["_patient", "_classname"];

            ([_patient, _classname, false] call ACEFUNC(medical_status,getMedicationCount) == 0);
        }, {}, [_patient, _classname], (30 / (0.1 max _dose min 1.2)), {
            _patient setVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), true];
        }] call CBA_fnc_waitUntilAndExecute;
    };
    case "Ketamine_IV": {
        if (_patient getVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false]) exitWith {};

        [{
            params ["_patient", "_classname"];

            ([_patient, _classname, false] call ACEFUNC(medical_status,getMedicationCount) == 0);
        }, {}, [_patient, _classname], (5 / (0.1 max _dose min 1.2)), {
            _patient setVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), true];
        }] call CBA_fnc_waitUntilAndExecute;
    };
    /*case "Lidocaine": {
        if (GVAR(AnestheticEffect_Lidocaine_Absorbed)) exitWith {};

        [{
            params ["_patient", "_classname"];

            ([_patient, "Lidocaine", false] call ACEFUNC(medical_status,getMedicationCount) >= 1);
        }, {
            params ["_patient", "_classname"];

            GVAR(AnestheticEffect_Lidocaine_Absorbed) = true;
        }, [_patient, _classname], 30, {}] call CBA_fnc_waitUntilAndExecute;
    };*/
};

if (_patient getVariable [QGVAR(AnestheticEffect_PFH), -1] != -1) exitWith {};

GVAR(AnestheticEffect_NextPulse) = -1;

EGVAR(core,ppAnestheticEffect_chrom) ppEffectEnable true;

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _lidocaineEffect = [_patient, "Lidocaine", false] call ACEFUNC(medical_status,getMedicationCount);
    private _ketamineIMEffect = [_patient, "Ketamine", false] call ACEFUNC(medical_status,getMedicationCount);
    private _ketamineIVEffect = [_patient, "Ketamine_IV", false] call ACEFUNC(medical_status,getMedicationCount);

    private _ketamineEffect = (_ketamineIMEffect * 0.4) + (_ketamineIVEffect * 0.8);

    private _anestheticEffect = 0;

    _anestheticEffect = _anestheticEffect + _lidocaineEffect * 0.3;

    if !(_patient getVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false]) then {
        _anestheticEffect = _anestheticEffect + _ketamineEffect;
    } else {
        _anestheticEffect = _anestheticEffect + ((linearConversion [0.999, 1, _ketamineIMEffect, 0, 1, true]) * 0.4) + ((linearConversion [0.999, 1, _ketamineIVEffect, 0, 1, true]) * 0.8);
    };

    _anestheticEffect = _anestheticEffect min 4;

    if (((_patient getVariable [QGVAR(AnestheticEffect_PFH), -1]) == -1) || !(alive _patient) || IS_UNCONSCIOUS(_patient) || ((_patient getVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false]) && _anestheticEffect < 0.1)) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;

        _patient setVariable [QGVAR(AnestheticEffect_PFH), -1];

        _patient setVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false];

        if (!(alive _patient) || IS_UNCONSCIOUS(_patient)) then {
            EGVAR(core,ppAnestheticEffect_chrom) ppEffectEnable false;
        } else {
            EGVAR(core,ppAnestheticEffect_chrom) ppEffectAdjust [0,0, true];
            EGVAR(core,ppAnestheticEffect_chrom) ppEffectCommit 8;

            [{
                params ["_patient"];

                if (_anestheticEffect < 0.1) then {
                    EGVAR(core,ppAnestheticEffect_chrom) ppEffectEnable false;
                };
            }, [_patient], 10] call CBA_fnc_waitAndExecute;
        };        
    };

    if (GVAR(AnestheticEffect_NextPulse) > CBA_missionTime) exitWith {};
    private _HR = GET_HEART_RATE(_patient);

    if (_HR == 0) exitWith {};

    private _delay = 60 / _HR;

    GVAR(AnestheticEffect_NextPulse) = CBA_missionTime + _delay;

    private _maxIntensity = linearConversion [0, 1, _anestheticEffect, 0, 0.06, true];

    private _highIntensity = [_maxIntensity, _maxIntensity, true];
    private _lowIntensity = [_maxIntensity * 0.3, _maxIntensity * 0.3, true];

    EGVAR(core,ppAnestheticEffect_chrom) ppEffectAdjust _highIntensity;
    EGVAR(core,ppAnestheticEffect_chrom) ppEffectCommit (_delay / 3);

    [{
        params ["_lowIntensity", "_delay"];

        EGVAR(core,ppAnestheticEffect_chrom) ppEffectAdjust _lowIntensity;
        EGVAR(core,ppAnestheticEffect_chrom) ppEffectCommit _delay;
    }, [_lowIntensity, _delay], (_delay / 3)] call CBA_fnc_waitAndExecute;
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AnestheticEffect_PFH), _PFH];