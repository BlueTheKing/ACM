#include "..\script_component.hpp"
/*
 * Author: Blue
 * Clear blindness visual effect. (LOCAL)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_CBRN_fnc_clearBlindEffect;
 *
 * Public: No
 */

params [];

GVAR(blindnessEffectActive) = false;
EGVAR(core,ppBlindness) ppEffectEnable false;