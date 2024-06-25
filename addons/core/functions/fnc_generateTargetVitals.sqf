#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate target vitals based off SteamID in multiplayer, randomize if AI or in singleplayer.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_generateTargetVitals;
 *
 * Public: No
 */

params ["_patient"];

private _weight = IDEAL_BODYWEIGHT;
private _maxHeartRate = 200;
private _targetHeartRate = 77;
private _targetOxygenSaturation = 99;
private _targetRespirationRate = 18;

if (!(isMultiplayer) || !(isPlayer _patient)) then {
    _weight = random [75, IDEAL_BODYWEIGHT, 105];
    _maxHeartRate = random [195, 200, 202];
    _targetHeartRate = random [75, 78, 82];
    _targetOxygenSaturation = random [98, 98.9, 99];
    _targetRespirationRate = random [16, 18, 20];
} else {
    private _steamID = getPlayerUID _patient;

    private _uniqueNumber = parseNumber (_steamID select [8,7]);

    _weight = ((linearConversion [0, 10, (_uniqueNumber % 10), -8, 22, true]) + IDEAL_BODYWEIGHT);
	_maxHeartRate = ((linearConversion [0, 20, (_uniqueNumber % 20), -5, 2, true]) + 200);
	_targetHeartRate = ((linearConversion [0, 30, (_uniqueNumber % 30), -3, 4, true]) + 78);
	_targetOxygenSaturation = ((linearConversion [0, 40, (_uniqueNumber % 40), -0.3, 0.2, true]) + 98.8);
	_targetRespirationRate = ((linearConversion [0, 50, (_uniqueNumber % 50), -2, 2, true]) + 18);
};

_patient setVariable [QGVAR(BodyWeight), _weight, true];

_patient setVariable [QGVAR(TargetVitals_HeartRate), _targetHeartRate, true];
_patient setVariable [QGVAR(TargetVitals_MaxHeartRate), _maxHeartRate, true];
_patient setVariable [QGVAR(TargetVitals_OxygenSaturation), _targetOxygenSaturation, true];
_patient setVariable [QGVAR(TargetVitals_RespirationRate), _targetRespirationRate, true];