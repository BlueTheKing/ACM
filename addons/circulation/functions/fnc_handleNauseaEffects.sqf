#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle nausea effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleNauseaEffects;
 *
 * Public: No
 */

params ["_patient"];

if (_patient != ACE_player) exitWith {};

if (_patient getVariable [QGVAR(NauseaEffect_PFH), -1] != -1) exitWith {};

GVAR(NauseaEffect_Active) = true;
GVAR(NauseaEffect_NextPulse) = -1;

EGVAR(core,ppNauseaEffect_chrom) ppEffectEnable true;
EGVAR(core,ppNauseaEffect_blur) ppEffectEnable true;

_patient setVariable [QGVAR(NauseaEffect_Strength), 0];
_patient setVariable [QGVAR(NauseaEffect_LastUpdate), CBA_missionTime];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _deltaT = (CBA_missionTime - (_patient getVariable [QGVAR(NauseaEffect_LastUpdate), 0])) min 2;

    private _lidocaineDose_IM = [_patient, "Lidocaine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
    private _lidocaineDose_IV = [_patient, "Lidocaine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
    private _morphineDose = [_patient, "Morphine"] call FUNC(getMedicationConcentration);
    private _fentanylDose = [_patient, "Fentanyl"] call FUNC(getMedicationConcentration);
    private _ketamineDose = [_patient, "Ketamine"] call FUNC(getMedicationConcentration);
    private _TXADose = [_patient, "TXA"] call FUNC(getMedicationConcentration);
    private _paracetamolDose = [_patient, "Paracetamol"] call FUNC(getMedicationConcentration);

    private _hasNauseaMedication = (_lidocaineDose_IM + _lidocaineDose_IV + _morphineDose + _fentanylDose + _ketamineDose + _TXADose) > 0;

    private _ondansetronDose = [_patient, "Ondansetron"] call FUNC(getMedicationConcentration);
    private _naloxoneDose = [_patient, "Naloxone"] call FUNC(getMedicationConcentration);

    private _weight = GET_BODYWEIGHT(_patient);

    private _lidocaineEffect = ((linearConversion [60, 100, _lidocaineDose_IM, 0, 0.5]) max 0) + ((linearConversion [(1.5 * _weight), (3 * _weight), _lidocaineDose_IV, 0, 0.8]) max 0);
    private _morphineEffect = (linearConversion [(0.08 * _weight), (0.1 * _weight), _morphineDose, 0, 0.8]) max 0;
    private _fentanylEffect = (linearConversion [(0.95 * _weight), (1 * _weight), _fentanylDose, 0, 0.7]) max 0;
    private _ketamineEffect = (linearConversion [(0.5 * _weight), (0.8 * _weight), _ketamineDose, 0, 0.8]) max 0;
    private _TXAEffect = (linearConversion [1000, 2000, _TXADose, 0, 0.7]) max 0;
    private _paracetamolEffect = (linearConversion [2000, 3000, _paracetamolDose, 0, 0.3]) max 0;

    if (_naloxoneDose > 0) then {
        if (_morphineDose > 0) then {
            private _reversalStrength = ([(linearConversion [0, 4, _naloxoneDose, 0, 20, true]), (linearConversion [4, 10, _naloxoneDose, 20, 50, true])] select (_naloxoneDose > 4));
            private _blockEffect = linearConversion [0, 1, ((_morphineDose - _reversalStrength) / _morphineDose), 0.5, 1, true];

            _morphineEffect = _morphineEffect * _blockEffect;
        };
        if (_fentanylDose > 0) then {
            private _reversalStrength = ([(linearConversion [0, 4, _naloxoneDose, 0, 200, true]), (linearConversion [4, 10, _naloxoneDose, 200, 500, true])] select (_naloxoneDose > 4));
            private _blockEffect = linearConversion [0, 1, ((_morphineDose - _reversalStrength) / _morphineDose), 0.5, 1, true];

            _fentanylEffect = _fentanylEffect * _blockEffect;
        };
    };

    private _nauseaAdd = _lidocaineEffect + _morphineEffect + _fentanylEffect + _ketamineEffect + _TXAEffect + _paracetamolEffect;

    private _nauseaReduce = [
        ([
            (linearConversion [0, 4, _ondansetronDose, 0, 1.5, true]), 
            (linearConversion [4, 8, _ondansetronDose, 1.5, 3, true])
        ] select (_ondansetronDose > 4)),
        (linearConversion [8, 24, _ondansetronDose, 3, 2.5])
    ] select (_ondansetronDose > 8);

    private _nauseaStrength = _patient getVariable [QGVAR(NauseaEffect_Strength), 0];

    if !(_deltaT < 1) then {
        private _targetNauseaStrength = _nauseaAdd - _nauseaReduce;
        private _nauseaChange = (_targetNauseaStrength - _nauseaStrength) / 4;
    
        if (_nauseaChange > 0) then {
            _nauseaStrength = _nauseaStrength + (_nauseaChange * _deltaT);
        } else {
            if (_nauseaChange < 0) then {
                _nauseaStrength = _nauseaStrength + (_nauseaChange * _deltaT);
            };
        };

        _nauseaStrength = 0 max _nauseaStrength min 1;

        _patient setVariable [QGVAR(NauseaEffect_Strength), _nauseaStrength];
        _patient setVariable [QGVAR(NauseaEffect_LastUpdate), CBA_missionTime];
    };

    if (((_patient getVariable [QGVAR(NauseaEffect_PFH), -1]) == -1) || !(alive _patient) || ((_nauseaStrength < 0.1) && !_hasNauseaMedication)) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;

        _patient setVariable [QGVAR(NauseaEffect_PFH), -1];

        if !(alive _patient) then {
            EGVAR(core,ppNauseaEffect_chrom) ppEffectEnable false;
            EGVAR(core,ppNauseaEffect_blur) ppEffectEnable false;
            GVAR(NauseaEffect_Active) = false;
        } else {
            EGVAR(core,ppNauseaEffect_chrom) ppEffectAdjust [0,0, true];
            EGVAR(core,ppNauseaEffect_chrom) ppEffectCommit 8;

            EGVAR(core,ppNauseaEffect_blur) ppEffectAdjust [0];
            EGVAR(core,ppNauseaEffect_blur) ppEffectCommit 8;

            [{
                params ["_patient", "_nauseaStrength"];

                if (_nauseaStrength < 0.1) then {
                    EGVAR(core,ppNauseaEffect_chrom) ppEffectEnable false;
                    EGVAR(core,ppNauseaEffect_blur) ppEffectEnable false;
                    GVAR(NauseaEffect_Active) = false;
                };
            }, [_patient, _nauseaStrength], 10] call CBA_fnc_waitAndExecute;
        };        
    };

    if (IS_UNCONSCIOUS(_patient)) exitWith {
        if (GVAR(NauseaEffect_Active)) then {
            EGVAR(core,ppNauseaEffect_chrom) ppEffectEnable false;
            EGVAR(core,ppNauseaEffect_blur) ppEffectEnable false;
            GVAR(NauseaEffect_Active) = false;
        };
    };

    if !(GVAR(NauseaEffect_Active)) then {
        EGVAR(core,ppNauseaEffect_chrom) ppEffectEnable true;
        EGVAR(core,ppNauseaEffect_blur) ppEffectEnable true;
        GVAR(NauseaEffect_Active) = true;
    };

    if (GVAR(NauseaEffect_NextPulse) > CBA_missionTime) exitWith {};
    private _HR = GET_HEART_RATE(_patient);

    if (_HR == 0) exitWith {};

    private _delay = 60 / _HR;

    GVAR(NauseaEffect_NextPulse) = CBA_missionTime + _delay;

    if (_nauseaStrength < 0.1) then {
        _nauseaStrength = 0;
    };

    private _maxIntensity = linearConversion [0, 1, _nauseaStrength, 0, 0.06, true];
    private _minIntensity = [0, (_maxIntensity * 0.3)] select (_nauseaStrength > 0);

    private _highIntensity = [_maxIntensity, _maxIntensity, true];
    private _lowIntensity = [_minIntensity, _minIntensity, true];

    EGVAR(core,ppNauseaEffect_chrom) ppEffectAdjust _highIntensity;
    EGVAR(core,ppNauseaEffect_chrom) ppEffectCommit (_delay / 3);

    EGVAR(core,ppNauseaEffect_blur) ppEffectAdjust [(_maxIntensity * 9)];
    EGVAR(core,ppNauseaEffect_blur) ppEffectCommit (_delay / 3);

    [{
        params ["_minIntensity", "_lowIntensity", "_delay"];

        EGVAR(core,ppNauseaEffect_chrom) ppEffectAdjust _lowIntensity;
        EGVAR(core,ppNauseaEffect_chrom) ppEffectCommit _delay;

        EGVAR(core,ppNauseaEffect_blur) ppEffectAdjust [(_minIntensity * 9)];
        EGVAR(core,ppNauseaEffect_blur) ppEffectCommit _delay;
    }, [_minIntensity, _lowIntensity, _delay], (_delay / 3)] call CBA_fnc_waitAndExecute;
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(NauseaEffect_PFH), _PFH];