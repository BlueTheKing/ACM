#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handles the low oxygen saturation effect.
 *
 * Arguments:
 * 0: Enable effect <BOOL>
 * 1: Current Oxygen Saturation <NUMBER>
 * 2: Current Respiration Rate <NUMBER>
 * 3: Chest Injury Severity <NUMBER>
 * 4: In Critical State <BOOL>
 * 5: Is Exposed To Chemical Agent <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false, 100, 18, 0, false, false] call ACM_core_fnc_effectOxygen;
 *
 * Public: No
 */

params ["_enable", "_oxygenSaturation", "_respirationRate", "_chestInjurySeverity", "_criticalState", "_isExposed"];

if (GVAR(ppLowOxygenTunnelVision_Finalized) && (!_enable || {_oxygenSaturation > (ACM_OXYGEN_VISION + 2) && _respirationRate > 12 && _chestInjurySeverity == 0 && !_criticalState && !_isExposed})) exitWith {
    if (GVAR(ppLowOxygenTunnelVision) != -1) then { GVAR(ppLowOxygenTunnelVision) ppEffectEnable false; };
};

if (_oxygenSaturation > ACM_OXYGEN_VISION && _respirationRate > 10 && _chestInjurySeverity == 0 && !_criticalState && !_isExposed) exitWith {
    if (GVAR(ppLowOxygenTunnelVision) != -1) then {
        if !(GVAR(ppLowOxygenTunnelVision_Finalized)) then {
            GVAR(ppLowOxygenTunnelVision) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0]];
            GVAR(ppLowOxygenTunnelVision) ppEffectCommit 0.5;
            GVAR(ppLowOxygenTunnelVision_Finalized) = true;
        };
    };
};

if (GVAR(ppLowOxygenTunnelVision) != -1) then { GVAR(ppLowOxygenTunnelVision) ppEffectEnable true; };

GVAR(ppLowOxygenTunnelVision_Finalized) = false;

// Trigger effect every 2s
private _showNextTick = missionNamespace getVariable [QGVAR(showppLowOxygenTunnelVision), true];
GVAR(showppLowOxygenTunnelVision) = !_showNextTick;
if (_showNextTick) exitWith {};

private _initialAdjust = [];
private _delayedAdjust = [];

private _criticalStateTime = [30, ((ACE_player getVariable [QGVAR(CriticalVitals_Time), -20]) - CBA_missionTime)] select _criticalState;

private _effectIntensity = (((linearConversion [79, ACM_OXYGEN_VISION, _oxygenSaturation, 1, 0, true]) max (linearConversion [6, 10, _respirationRate, 1, 0, true])) max (linearConversion [4, 0, _chestInjurySeverity, 1, 0, true])) max (linearConversion [1, 20, _criticalStateTime, 1, 0, true]) max ([0, 0.1] select _isExposed);
private _tunnelVisionIntensity = 0.6 * _effectIntensity;

_initialAdjust = [1, 1, 0, [0, 0, 0, _effectIntensity * 0.95], [0.1, 0.1, 0.1, 0.1], [0, 0, 0, 0], [0.85 - _tunnelVisionIntensity, 0.8 - _tunnelVisionIntensity, 0, 0, 0, 0, 8]];
_delayedAdjust = [1, 1, 0, [0, 0, 0, _effectIntensity], [0.01, 0.01, 0.01, 0.01], [0, 0, 0, 0], [0.75 - _tunnelVisionIntensity, 0.7 - _tunnelVisionIntensity, 0, 0, 0, 0, 8]];

GVAR(ppLowOxygenTunnelVision) ppEffectAdjust _initialAdjust;
GVAR(ppLowOxygenTunnelVision) ppEffectCommit 0.3;

[{
    params ["_adjust"];

    GVAR(ppLowOxygenTunnelVision) ppEffectAdjust _adjust;
    GVAR(ppLowOxygenTunnelVision) ppEffectCommit 0.7;
}, [_delayedAdjust], 0.3] call CBA_fnc_waitAndExecute;