#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Makes the unit heal itself.
 *
 * Arguments:
 * Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * cursorObject call ace_medical_ai_fnc_healSelf
 *
 * Public: No
 */

// Player will have to do this manually of course
if ([_this] call ACEFUNC(common,isPlayer)) exitWith {};
// Can't heal self when unconscious
if (IS_UNCONSCIOUS(_this) || IN_LYING_STATE(_this)) exitWith {
    _this setVariable [QACEGVAR(medical_ai,currentTreatment), nil];
};

[_this, _this] call ACEFUNC(medical_ai,healingLogic);
