#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get config entry for fluid bags.
 *
 * Arguments:
 * 0: Type <STRING>
 * 1: Fluid Bag Volume <NUMBER>
 * 2: Blood Type <NUMBER>
 * 3: Don't add prefix <BOOL>
 *
 * Return Value:
 * Formatted name <STRING>
 *
 * Example:
 * ["Plasma", 1000, -1, false] call ACM_circulation_fnc_formatFluidBagName;
 *
 * Public: No
 */

params ["_type", "_targetVolume", ["_bloodType", -1], ["_noPrefix", false]];

[([true, _type, _targetVolume, -1, _noPrefix] call FUNC(getFluidBagConfigName)), ([false, _type, _targetVolume, _bloodType, _noPrefix] call FUNC(getFluidBagConfigName))] select (_type in ["Blood","FreshBlood","FBTK"])