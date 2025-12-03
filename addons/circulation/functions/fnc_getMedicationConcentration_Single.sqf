#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get current medication concentration.
 *
 * Arguments:
 * 0: Dose <NUMBER>
 * 1: Administration Time <NUMBER>
 * 2: Absorption Time <NUMBER>
 * 3: Maintain Time <NUMBER>
 * 4: Elimination Time <NUMBER>
 *
 * Return Value:
 * Concentration <NUMBER>
 *
 * Example:
 * [5, CBA_missionTime, 30, 30, 30] call ACM_circulation_fnc_getMedicationConcentration_Single;
 *
 * Public: No
 */

params ["_entryDose", "_entryAdminTime", "_entryAbsorbTime", "_entryMaintainTime", "_entryEliminateTime"];
    
private _entryConcentration = 0;

private _timeSinceAdmin = CBA_missionTime - _entryAdminTime;

private _timeToAbsorb = _entryAbsorbTime;
private _timeToMaintain = _timeToAbsorb + _entryMaintainTime + MAINTAIN_TIME;
private _timeToEliminate = _timeToMaintain + _entryEliminateTime;

private _peakCrossed = _timeSinceAdmin > _timeToAbsorb + MAINTAIN_TIME;
private _maintainPhaseCrossed = _timeSinceAdmin > _timeToMaintain;
private _eliminatePhaseCrossed = _timeSinceAdmin > _timeToEliminate;

_entryConcentration =
    ([
        (linearConversion [0, _timeToAbsorb, _timeSinceAdmin, 0, _entryDose, true]),
        ([
            (linearConversion [_timeToAbsorb, _timeToMaintain, _timeSinceAdmin, _entryDose, (_entryDose / 2), true]),
            (linearConversion [_timeToMaintain, _timeToEliminate, _timeSinceAdmin, (_entryDose / 2), 0, true])
        ] select (_maintainPhaseCrossed))
    ] select _peakCrossed);

_entryConcentration;