#include "..\script_component.hpp"
/*
 * Author: Glowbal, kymckay
 * Get the cardiac output from the Heart, based on current Heart Rate and Blood Volume.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * Current cardiac output (liter per second) <NUMBER>
 *
 * Example:
 * [player] call ace_medical_status_fnc_getCardiacOutput
 *
 * Public: No
 */

/*
    Cardiac output (Q or or CO ) is the volume of blood being pumped by the heart, in particular by a left or right ventricle in the CBA_missionTime interval of one second. CO may be measured in many ways, for example dm3/min (1 dm3 equals 1 liter).
    Source: http://en.wikipedia.org/wiki/Cardiac_output
*/

// Value taken from https://doi.org/10.1093%2Feurheartj%2Fehl336
// as 94/95 ml ± 15 ml
#define VENTRICLE_STROKE_VOL 0.095

params ["_patient"];

private _heartRate = GET_HEART_RATE(_patient);

// Blood volume ratio dictates how much is entering the ventricle (this is an approximation)
private _entering = 1 min (linearConversion [6, 3, GET_BLOOD_VOLUME(_patient), 1, 0.15]) max 0;

private _strokeVolume = VENTRICLE_STROKE_VOL * (linearConversion [55, 100, GET_HEART_FATIGUE(_patient), 1, 0.5, true]);

private _cardiacOutput = (_entering * _strokeVolume) * (0 max ([(linearConversion [60, 120, _heartRate, 1, 2]), (linearConversion [140, 200, _heartRate, 2.33333, 1.2])] select (_heartRate > 140)));

// 0.126667 @ 80

0 max _cardiacOutput
