#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle detonating chemical device.
 *
 * Arguments:
 * 0: Target Object <OBJECT>
 * 1: Hazard Type <STRING>
 * 2: Zone Radius <NUMBER>
 * 3: Effect Time <NUMBER>
 * 4: Affect AI <BOOL>
 * 5: Cloud Effect Size <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "chemical_chlorine", 5, -1, false, 1] call ACM_CBRN_fnc_detonateChemicalDevice;
 *
 * Public: No
 */

params ["_object", "_hazardType", "_radius", "_effectTime", "_affectAI", "_effectSize"];

if (_effectSize > 0) then {
    [QGVAR(spawnChemicalDetonationEffect), [_object, _hazardType, _effectSize]] call CBA_fnc_globalEvent;
};
[QGVAR(initHazardZone), [_object, true, _hazardType, [_radius,_radius,0,false,-1], _effectTime, _affectAI, false, true, ACE_player]] call CBA_fnc_serverEvent;