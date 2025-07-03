#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle hazard zone spawning from fired artillery. (LOCAL)
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
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
 * [] call ACM_CBRN_fnc_handleFiredArtillery;
 *
 * Public: No
 */

params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

if !(_ammo in ["ACM_Mortar_Shell_CS_A","ACM_Mortar_Shell_Chlorine_A","ACM_Mortar_Shell_Sarin_A","ACM_Mortar_Shell_Lewisite_A"]) exitWith {};

_projectile setVariable [QGVAR(ChemicalPayload), _ammo];

_projectile addEventHandler ["Explode", {
    params ["_projectile", "_pos", "_velocity"];

    private _agent = "";
    private _lifetime = 60;
    private _payload = _projectile getVariable [QGVAR(ChemicalPayload), ""];
    switch (true) do {
        case (_payload in ["ACM_Mortar_Shell_CS_A"]): {
            _agent = "chemical_cs";
            _lifetime = 80;
        };
        case (_payload in ["ACM_Mortar_Shell_Chlorine_A"]): {
            _agent = "chemical_chlorine";
            _lifetime = 70;
        };
        case (_payload in ["ACM_Mortar_Shell_Sarin_A"]): {
            _agent = "chemical_sarin";
            _lifetime = 40;
        };
        case (_payload in ["ACM_Mortar_Shell_Lewisite_A"]): {
            _agent = "chemical_lewisite";
            _lifetime = 50;
        };
        default {};
    };

    [QGVAR(initHazardZone), [_projectile, false, _agent, [], _lifetime, true, false, true, ACE_player]] call CBA_fnc_serverEvent;
    _projectile removeEventHandler [_thisEvent, _thisEventHandler];
}];