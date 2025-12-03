#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Paracetamol effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_effectParacetamol;
 *
 * Public: No
 */

params ["_patient"];

[{
    params ["_patient"];

    [_patient] call FUNC(handleNauseaEffects);
}, [_patient], 30] call CBA_fnc_waitAndExecute;