#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if pulse oximeter can be placed on body part
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Action Classname <STRING>
 *
 * Return Value:
 * Can place pulse oximeter <BOOL>
 *
 * Example:
 * [player, cursorTarget, "leftarm", "PlacePulseOximeter"] call ACM_breathing_fnc_canPlacePulseOximeter;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

private _return = HAS_PULSEOX(_patient,(_partIndex - 2));

if (_classname == "PlacePulseOximeter") then {
    !_return;
} else {
    _return;
};