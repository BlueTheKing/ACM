#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle tourniquet effects for patient. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_disability_fnc_handleTourniquetEffects;
 *
 * Public: No
 */

params ["_patient"];

if ((_patient getVariable [QGVAR(TourniquetEffects_PFH), -1]) != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _tourniquets = GET_TOURNIQUETS(_patient);

    private _tourniquetNecrosis = GET_TOURNIQUET_NECROSIS(_patient);

    private _TQLeftArm = (_tourniquets select 2) > 0;
    private _TQRightArm = (_tourniquets select 3) > 0;
    private _TQLeftLeg = (_tourniquets select 4) > 0;
    private _TQRightLeg = (_tourniquets select 5) > 0;

    private _armsImpacted = _TQLeftArm || _TQRightArm;
    private _legsImpacted = _TQLeftLeg || _TQRightLeg;

    if (!(alive _patient) || (_tourniquetNecrosis isEqualTo DEFAULT_TOURNIQUET_NECROSIS && (!_armsImpacted && !_legsImpacted))) exitWith {
        _patient setVariable [QGVAR(TourniquetEffects_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    _tourniquetNecrosis params ["_TQNecrosisLeftArm", "_TQNecrosisRightArm", "_TQNecrosisLeftLeg", "_TQNecrosisRightLeg"];

    private _newTQNecrosisLeftArm = _TQNecrosisLeftArm;
    private _newTQNecrosisRightArm = _TQNecrosisRightArm;
    private _newTQNecrosisLeftLeg = _TQNecrosisLeftLeg;
    private _newTQNecrosisRightLeg = _TQNecrosisRightLeg;

    private _tourniquetNecrosisThresholds = GET_TOURNIQUET_NECROSIS_T(_patient);
    _tourniquetNecrosisThresholds params ["_TQThresholdNecrosisLeftArm", "_TQThresholdNecrosisRightArm", "_TQThresholdNecrosisLeftLeg", "_TQThresholdNecrosisRightLeg"];

    private _newTQNecrosisArray = [_newTQNecrosisLeftArm, _newTQNecrosisRightArm, _newTQNecrosisLeftLeg, _newTQNecrosisRightLeg];
    private _TQNecrosisThresholdArray = [_TQThresholdNecrosisLeftArm, _TQThresholdNecrosisRightArm, _TQThresholdNecrosisLeftLeg, _TQThresholdNecrosisRightLeg];

    private _TQNecrosisArray = [_TQNecrosisLeftArm, _TQNecrosisRightArm, _TQNecrosisLeftLeg, _TQNecrosisRightLeg];

    private _update = false;

    {
        private _newNecrosis = _newTQNecrosisArray select _forEachIndex;
        private _lastThreshold = _TQNecrosisThresholdArray select _forEachIndex;
        if (_x) then {
            if (_newNecrosis < 1) then {
                _newNecrosis = _newNecrosis + 0.01;
                _newTQNecrosisArray set [_forEachIndex, _newNecrosis];

                switch (true) do {
                    case (_newNecrosis > _lastThreshold && _newNecrosis >= NECROSIS_THRESHOLD_SEVERE && _lastThreshold < NECROSIS_THRESHOLD_SEVERE): {
                        _TQNecrosisThresholdArray set [_forEachIndex, NECROSIS_THRESHOLD_SEVERE];
                        _update = true;
                    };
                    case (_newNecrosis > _lastThreshold && _newNecrosis >= NECROSIS_THRESHOLD_MODERATE && _lastThreshold < NECROSIS_THRESHOLD_MODERATE): {
                        _TQNecrosisThresholdArray set [_forEachIndex, NECROSIS_THRESHOLD_MODERATE];
                        _update = true;
                    };
                    case (_newNecrosis > _lastThreshold && _newNecrosis >= NECROSIS_THRESHOLD_LIGHT && _lastThreshold < NECROSIS_THRESHOLD_LIGHT): {
                        _TQNecrosisThresholdArray set [_forEachIndex, NECROSIS_THRESHOLD_LIGHT];
                        _update = true;
                    };
                    default {};
                };
            } else {
                _newTQNecrosisArray set [_forEachIndex, 1];
                _TQNecrosisThresholdArray set [_forEachIndex, 1];
            };
        } else {
            if (_newNecrosis > 0) then {
                _newNecrosis = _newNecrosis - 0.1;
                _newTQNecrosisArray set [_forEachIndex, _newNecrosis];

                switch (true) do {
                    case (_newNecrosis < _lastThreshold && _newNecrosis <= NECROSIS_THRESHOLD_SEVERELOW && _lastThreshold > NECROSIS_THRESHOLD_SEVERELOW): {
                        _TQNecrosisThresholdArray set [_forEachIndex, NECROSIS_THRESHOLD_SEVERELOW];
                        _update = true;
                    };
                    case (_newNecrosis < _lastThreshold && _newNecrosis <= NECROSIS_THRESHOLD_MODERATELOW && _lastThreshold > NECROSIS_THRESHOLD_MODERATELOW): {
                        _TQNecrosisThresholdArray set [_forEachIndex, NECROSIS_THRESHOLD_MODERATELOW];
                        _update = true;
                    };
                    case (_newNecrosis < _lastThreshold && _newNecrosis <= NECROSIS_THRESHOLD_LIGHTLOW && _lastThreshold > NECROSIS_THRESHOLD_LIGHTLOW): {
                        _TQNecrosisThresholdArray set [_forEachIndex, NECROSIS_THRESHOLD_LIGHTLOW];
                        _update = true;
                    };
                    default {};
                };
            } else {
                _newTQNecrosisArray set [_forEachIndex, 0];
                _TQNecrosisThresholdArray set [_forEachIndex, 0];
            };
        };
    } forEach [_TQLeftArm, _TQRightArm, _TQLeftLeg, _TQRightLeg];

    _patient setVariable [VAR_TOURNIQUET_NECROSIS, _newTQNecrosisArray];
    _patient setVariable [VAR_TOURNIQUET_NECROSIS_T, _TQNecrosisThresholdArray];

    if (_update) then {
        [_patient] call ACEFUNC(medical_engine,updateDamageEffects);
    };
}, 5, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(TourniquetEffects_PFH), _PFH];