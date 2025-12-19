#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update vasoconstriction state of patient.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Heart Rate <NUMBER>
 * 2: Blood Volume <NUMBER>
 * 3: Peripheral Vasoconstriction Adjustment <NUMBER>
 * 4: Time since last update <NUMBER>
 * 5: Sync value? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 6, 0, 1, false] call ACM_circulation_fnc_updateVasoconstriction;
 *
 * Public: No
 */

params ["_patient", "_heartRate", "_bloodVolume", "_peripheralVasoconstrictionAdjustment", "_deltaT", "_syncValues"];

private _vasoconstriction = GET_VASOCONSTRICTION(_patient);
private _targetVasoconstriction = 0;

if (_heartRate > 30) then {
    if (_bloodVolume < 5.9) then {
        _targetVasoconstriction = linearConversion [5.9, 4.5, _bloodVolume, 0, 50, true];
    };

    if (_bloodVolume > 4) then {
        private _MAPAdjustment = 0;
        private _MAP = GET_MAP_PATIENT(_patient);

        if (_MAP > 95) then {
            _MAPAdjustment = linearConversion [95, 120, _MAP, 0, -50, true];
        } else {
            if (_MAP < 95) then {
                _MAPAdjustment = linearConversion [95, 85, _MAP, 0, 50, true];
            };
        };

        _targetVasoconstriction = -50 max (_targetVasoconstriction + _MAPAdjustment) min 50;

        if (IS_BLEEDING(_patient) && _targetVasoconstriction < 0) then {
            _targetVasoconstriction = _targetVasoconstriction * 0.75;
        };
    };
};

_targetVasoconstriction = -50 max (_targetVasoconstriction + _peripheralVasoconstrictionAdjustment) min 50;

private _vasoconstrictionChange = (_targetVasoconstriction - _vasoconstriction) / 4;

if (_targetVasoconstriction > _vasoconstriction) then {
    _vasoconstriction = (_vasoconstriction + _vasoconstrictionChange * (_deltaT min 1.2)) min _targetVasoconstriction;
} else {
    _vasoconstriction = (_vasoconstriction + _vasoconstrictionChange * (_deltaT min 1.2)) max _targetVasoconstriction;
};

_patient setVariable [QGVAR(Vasoconstriction_State), _vasoconstriction, _syncValues];