#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Ketamine effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_effectKetamine;
 *
 * Public: No
 */

params ["_patient"];

private _fnc_handleDissociateEffect = {
    params ["_patient"];

    if (_patient != ACE_player) exitWith {};

    if (_patient getVariable [QGVAR(DissociateEffect_PFH), -1] != -1) exitWith {};

    EGVAR(core,ppDisocciateEffect_chrom) ppEffectEnable true;
    EGVAR(core,ppDisocciateEffect_color) ppEffectEnable true;

    GVAR(DissociateEffect_Active) = true;
    GVAR(DissociateEffect_NextPulse) = 0;

    _patient setVariable [QGVAR(DissociateEffect_Active), false];
    _patient setVariable [QGVAR(DissociateEffect_LastUntil), 0];
    _patient setVariable [QGVAR(DissociateEffect_Strength), 0];
    _patient setVariable [QGVAR(DissociateEffect_LastUpdate), 0];

    private _PFH = [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        private _deltaT = (CBA_missionTime - (_patient getVariable [QGVAR(DissociateEffect_LastUpdate), 0])) min 2;

        private _ketamineDose_IV = [_patient, "Ketamine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
        private _ketamineDose_IM = [_patient, "Ketamine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);

        private _hasDissociateMedication = (_ketamineDose_IV + _ketamineDose_IM) > 0;

        private _weight = GET_BODYWEIGHT(_patient);

        private _ketamineEffect_IV = [
            (linearConversion [(0.15 * _weight), (0.3 * _weight), _ketamineDose_IV, 0, 0.25, true]),
            (linearConversion [(0.3 * _weight), (1 * _weight), _ketamineDose_IV, 0.25, 1])
        ] select (_ketamineDose_IV > (0.3 * _weight));

        private _ketamineEffect_IM = [
            (linearConversion [(0.6 * _weight), (0.8 * _weight), _ketamineDose_IV, 0, 0.15, true]),
            (linearConversion [(0.8 * _weight), (2 * _weight), _ketamineDose_IV, 0.15, 0.6])
        ] select (_ketamineDose_IV > (0.8 * _weight));

        private _ketamineCauseDissociation = _ketamineEffect_IV > (0.25 * _weight) || _ketamineEffect_IM > (0.7 * _weight);

        private _ketamineEffect = _ketamineEffect_IV + _ketamineEffect_IM;

        private _effectActive = _patient getVariable [QGVAR(DissociateEffect_Active), false];

        private _fadeAwayMultiplier = 0;

        if (_effectActive) then {
            _fadeAwayMultiplier = linearConversion [((_patient getVariable [QGVAR(DissociateEffect_LastUntil), 0]) - 120), (_patient getVariable [QGVAR(DissociateEffect_LastUntil), 0]), CBA_missionTime, 1, 0, true];
        } else {
            if (_ketamineEffect > 0) then {
                _patient setVariable [QGVAR(DissociateEffect_Active), true];
                _patient setVariable [QGVAR(DissociateEffect_LastUntil), (CBA_missionTime + 120)];
            };
        };

        private _effectAdd = 0;

        if (_fadeAwayMultiplier > 0) then {
            _effectAdd = _ketamineEffect * _fadeAwayMultiplier;
        } else {
            if (_ketamineCauseDissociation) then {
                _effectAdd = _ketamineEffect;
            };
        };

        private _effectStrength = _patient getVariable [QGVAR(DissociateEffect_Strength), 0];

        if !(_deltaT < 1) then {
            private _targetEffectStrength = _effectAdd;
            private _effectChange = (_targetEffectStrength - _effectStrength) / 4;

            if (_effectChange > 0) then {
                _effectStrength = _effectStrength + (_effectChange * _deltaT);
            } else {
                if (_effectChange < 0) then {
                    _effectStrength = _effectStrength + (_effectChange * _deltaT);
                };
            };

            _effectStrength = 0 max _effectStrength min 1;

            _patient setVariable [QGVAR(DissociateEffect_Strength), _effectStrength];
            _patient setVariable [QGVAR(DissociateEffect_LastUpdate), CBA_missionTime];
        };
        
        if (((_patient getVariable [QGVAR(DissociateEffect_PFH), -1]) == -1) || !(alive _patient) || (_effectStrength < 0.1 && !_hasDissociateMedication)) exitWith {
            [_idPFH] call CBA_fnc_removePerFrameHandler;

            _patient setVariable [QGVAR(DissociateEffect_PFH), -1];

            _patient setVariable [QGVAR(DissociateEffect_Active), false];

            if !(alive _patient) then {
                EGVAR(core,ppDisocciateEffect_chrom) ppEffectEnable false;
                EGVAR(core,ppDisocciateEffect_color) ppEffectEnable false;
                GVAR(DissociateEffect_Active) = false;
            } else {
                EGVAR(core,ppDisocciateEffect_chrom) ppEffectAdjust [0, 0, true];
                EGVAR(core,ppDisocciateEffect_chrom) ppEffectCommit 8;

                EGVAR(core,ppDisocciateEffect_color) ppEffectAdjust [0, 0, 0];
                EGVAR(core,ppDisocciateEffect_color) ppEffectCommit 8;

                [{
                    params ["_patient", "_effectStrength"];

                    if (_effectStrength < 0.1) then {
                        EGVAR(core,ppDisocciateEffect_chrom) ppEffectEnable false;
                        EGVAR(core,ppDisocciateEffect_color) ppEffectEnable false;
                        GVAR(DissociateEffect_Active) = false;
                    };
                }, [_patient, _effectStrength], 10] call CBA_fnc_waitAndExecute;
            };
        };

        if (IS_UNCONSCIOUS(_patient)) exitWith {
            if (GVAR(DissociateEffect_Active)) then {
                EGVAR(core,ppDisocciateEffect_chrom) ppEffectEnable false;
                EGVAR(core,ppDisocciateEffect_color) ppEffectEnable false;
                GVAR(DissociateEffect_Active) = false;
            };
        };

        if !(GVAR(DissociateEffect_Active)) then {
            EGVAR(core,ppDisocciateEffect_chrom) ppEffectEnable true;
            EGVAR(core,ppDisocciateEffect_color) ppEffectEnable true;
            GVAR(DissociateEffect_Active) = true;
        };

        if (GVAR(DissociateEffect_NextPulse) > CBA_missionTime) exitWith {};
        private _HR = GET_HEART_RATE(_patient);

        if (_HR == 0) exitWith {};

        private _delay = (60 / _HR) * 2;

        GVAR(DissociateEffect_NextPulse) = CBA_missionTime + _delay;

        if (_effectStrength < 0.05) then {
            _effectStrength = 0;
        };

        private _effectStrong = linearConversion [0, 1, _effectStrength, 0, 0.04, true];

        EGVAR(core,ppDisocciateEffect_chrom) ppEffectAdjust [_effectStrong, _effectStrong, true];
        EGVAR(core,ppDisocciateEffect_chrom) ppEffectCommit (_delay / 3);

        private _effectColor = [(random 1), (random 1), (random 1)];

        _effectColor = _effectColor apply {_x * _effectStrength};

        EGVAR(core,ppDisocciateEffect_color) ppEffectAdjust _effectColor;
        EGVAR(core,ppDisocciateEffect_color) ppEffectCommit (_delay / 3);

        [{
            params ["_effectStrength", "_effectColor", "_delay"];

            _effectColor = _effectColor apply {_x / 3};

            private _effectWeak = linearConversion [0, 1, _effectStrength, 0, 0.02, true];

            EGVAR(core,ppDisocciateEffect_chrom) ppEffectAdjust [_effectWeak, _effectWeak, true];
            EGVAR(core,ppDisocciateEffect_chrom) ppEffectCommit _delay;

            EGVAR(core,ppDisocciateEffect_color) ppEffectAdjust _effectColor;
            EGVAR(core,ppDisocciateEffect_color) ppEffectCommit _delay;
        }, [_effectStrength, _effectColor, _delay], (_delay / 3)] call CBA_fnc_waitAndExecute;
    }, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

    _patient setVariable [QGVAR(DissociateEffect_PFH), _PFH];
};

[{
    params ["_patient", "_fnc_handleDissociateEffect"];

    [_patient] call FUNC(handleNauseaEffects);
    [_patient] call _fnc_handleDissociateEffect;
}, [_patient, _fnc_handleDissociateEffect], 5] call CBA_fnc_waitAndExecute;