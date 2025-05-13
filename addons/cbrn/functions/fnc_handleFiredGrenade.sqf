#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle hazard zone spawning from fired/thrown grenade. (LOCAL)
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Weapon <STRING>
 * 2: Muzzle <STRING>
 * 3: Mode <STRING>
 * 4: Ammo <STRING>
 * 5: Magazine <STRING>
 * 6: Projectile <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_CBRN_fnc_handleFiredGrenade;
 *
 * Public: No
 */

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

if !(_ammo in ["ACM_Grenade_CS_A", "ACM_Grenade_Shell_CS_A"]) exitWith {};

private _agent = "";
private _fuseTime = 0;
private _lifetime = 52;

if (_ammo in ["ACM_Grenade_CS_A", "ACM_Grenade_Shell_CS_A"]) then {
    _agent = "Chemical_CS";
    _fuseTime = 2;
};

[{
    params ["_unit", "_projectile", "_agent", "_lifetime"];

    [QGVAR(initHazardZone), [_projectile, true, _agent, [], _lifetime, true, false, false, ACE_player]] call CBA_fnc_serverEvent;
}, [_unit, _projectile, _agent, _lifetime], _fuseTime] call CBA_fnc_waitAndExecute;