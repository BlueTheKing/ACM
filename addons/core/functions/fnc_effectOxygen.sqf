#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handles the low oxygen saturation effect.
 *
 * Arguments:
 * 0: Enable effect <BOOL>
 * 1: Current Oxygen Saturation <NUMBER>
 * 2: Current Respiration Rate <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false, 100, 18] call ACM_core_fnc_effectOxygen;
 *
 * Public: No
 */

params ["_enable", "_oxygenSaturation", "_respirationRate"];

if (!_enable || {_oxygenSaturation > 92 && _respirationRate > 12}) exitWith {
    if (GVAR(ppLowOxygenTunnelVision) != -1) then { GVAR(ppLowOxygenTunnelVision) ppEffectEnable false; };
};

if (_oxygenSaturation > 90 && _respirationRate > 10) exitWith {
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

private _effectIntensity = ((linearConversion [79, 90, _oxygenSaturation, 1, 0, true]) max (linearConversion [6, 10, _respirationRate, 1, 0, true]));
private _tunnelVisionIntensity = 0.5 * _effectIntensity;

_initialAdjust = [1, 1, 0, [0, 0, 0, _effectIntensity * 0.95], [0.1, 0.1, 0.1, 0.1], [0, 0, 0, 0], [0.85 - _tunnelVisionIntensity, 0.8 - _tunnelVisionIntensity, 0, 0, 0, 0, 8]];
_delayedAdjust = [1, 1, 0, [0, 0, 0, _effectIntensity], [0, 0, 0, 0], [0, 0, 0, 0], [0.75 - _tunnelVisionIntensity, 0.7 - _tunnelVisionIntensity, 0, 0, 0, 0, 8]];

GVAR(ppLowOxygenTunnelVision) ppEffectAdjust _initialAdjust;
GVAR(ppLowOxygenTunnelVision) ppEffectCommit 0.3;

[{
    params ["_adjust"];

    GVAR(ppLowOxygenTunnelVision) ppEffectAdjust _adjust;
    GVAR(ppLowOxygenTunnelVision) ppEffectCommit 0.7;
}, [_delayedAdjust], 0.3] call CBA_fnc_waitAndExecute;