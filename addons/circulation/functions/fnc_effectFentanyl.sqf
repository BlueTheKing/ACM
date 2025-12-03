#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Fentanyl effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_effectFentanyl;
 *
 * Public: No
 */

params ["_patient"];

[{
    params ["_patient"];

    [_patient] call FUNC(handleNauseaEffects);
}, [_patient], 5] call CBA_fnc_waitAndExecute;