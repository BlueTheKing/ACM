#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_initUnit;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(Detector_State), false, true];
_patient setVariable [QGVAR(Detector_Alarm_State), true, true];

if (!(isPlayer _patient) && GVAR(chemicalAffectAISkill)) then {
    _patient setVariable [QGVAR(AISkill_Initial), (skill _patient)];
};