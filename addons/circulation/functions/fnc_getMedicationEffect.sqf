#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get effect of medication depending on administration route
 *
 * Arguments:
 * 0: Administration Route <NUMBER>
    * 0: IM
    * 1: IV
    * 2: PO
    * 3: Inhale
 * 1: Time in system <NUMBER>
 * 2: Time until max effect <NUMBER>
 * 3: Max time in system <NUMBER>
 * 4: Max effect time <NUMBER>
 * 5: Medication Concentration <NUMBER>
 *
 * Return Value:
 * Medication effect <NUMBER>
 *
 * Example:
 * [0, 10, 60, 120, 60, 1] call ACM_circulation_fnc_getMedicationEffect;
 *
 * Public: No
 */

params ["_administrationType", "_timeInSystem", "_timeTillMaxEffect", "_maxTimeInSystem", "_maxEffectTime", "_concentration"];

private _eliminationTime = (_maxTimeInSystem - _maxEffectTime - _timeTillMaxEffect);
private _currentEliminationTime = (_timeInSystem - _maxEffectTime - _timeTillMaxEffect);

private _effect = 0;
private _maxEffect = _concentration;

if (_timeInSystem > _timeTillMaxEffect && _timeInSystem < _timeTillMaxEffect + _maxEffectTime) then {
    _effect = _maxEffect;
} else {
    _effect = switch (_administrationType) do {
        case ACM_ROUTE_IM: {
            [(1.1^(_timeInSystem - _timeTillMaxEffect)), (-((_currentEliminationTime^2)/(_eliminationTime^2)) + 1)] select (_timeInSystem > (_maxEffectTime + _timeTillMaxEffect));
        };
        case ACM_ROUTE_IV;
        case ACM_ROUTE_PO;
        case ACM_ROUTE_INHALE: {
            [(sin (deg (_timeInSystem / ((2 * _timeTillMaxEffect * pi) / (3.113 * pi))))), (((cos deg (_currentEliminationTime / (_eliminationTime / 3.1))) / 2) + 0.5)] select (_timeInSystem > (_maxEffectTime + _timeTillMaxEffect));
        };
        default {
            (((_timeInSystem / _timeTillMaxEffect) ^ 2) min 1) * (_maxTimeInSystem - _timeInSystem) / _maxTimeInSystem;
        };
    };
};

0 max (_effect * _concentration) min _maxEffect;