#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset circulation variables to default values
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

if (_patient == ACE_player) then {
    _patient setVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false];
    _patient setVariable [QGVAR(AnestheticEffect_PFH), -1];
};

_patient setVariable [QGVAR(ROSC_Time), -30, true];

_patient setVariable [QGVAR(Hardcore_PostCardiacArrest), false, true];

_patient setVariable [QGVAR(IV_Placement), [0,0,0,0,0,0], true];
_patient setVariable [QGVAR(Blood_Volume), 6, true];
_patient setVariable [QGVAR(Plasma_Volume), 0, true];
_patient setVariable [QGVAR(Saline_Volume), 0, true];

_patient setVariable [QGVAR(Platelet_Count), 3, true];

_patient setVariable [QGVAR(CardiacArrest_RhythmState), 0, true];
_patient setVariable [QGVAR(CardiacArrest_TargetRhythm), 0];

_patient setVariable [QGVAR(ReversibleCardiacArrest_Time), nil];
_patient setVariable [QGVAR(ReversibleCardiacArrest_State), false, true];
_patient setVariable [QGVAR(CardiacArrest_Time), nil];

_patient setVariable [QGVAR(AED_LastShock), nil, true];
_patient setVariable [QGVAR(AED_ShockTotal), 0, true];

_patient setVariable [QGVAR(CPR_StoppedTotal), nil, true];
_patient setVariable [QGVAR(CPR_StoppedTime), nil, true];

_patient setVariable [QGVAR(CPR_Medic), objNull, true];
_patient setVariable [QGVAR(isPerformingCPR), false, true];

_patient setVariable [QGVAR(AmmoniaInhalant_LastUse), -1, true];

[_patient] call FUNC(updateCirculationState);
[_patient] call FUNC(generateBloodType);
[_patient] call FUNC(updateActiveFluidBags);