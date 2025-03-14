#include "..\script_component.hpp"
/*
 * Author: Blue
 * Spawn particle effects for chemical device detonation. (LOCAL)
 *
 * Arguments:
 * 0: Target Object <OBJECT>
 * 1: Hazard Type <STRING>
 * 2: Effect Size <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject, "chemical_chlorine", 1] call ACM_CBRN_fnc_spawnChemicalDetonationEffect;
 *
 * Public: No
 */

params ["_object", "_hazardType", "_size"];

private _severity = ["","_Small"] select (_size == 1);
private _hazard = switch (_hazardType) do {
    case "chemical_chlorine": {"Chlorine"};
    case "chemical_sarin": {"Sarin"};
    case "chemical_lewisite": {"Lewisite"};
};
private _particleClass = format ["ACM_ChemicalDevice_%1%2", _hazard, _severity];

private _chemicalExplosionEmitter = "#particlesource" createVehicleLocal getPos _attachedObject;
_chemicalExplosionEmitter setParticleClass _particleClass;

[{
    params ["_chemicalExplosionEmitter"];

    deleteVehicle _chemicalExplosionEmitter;
}, [_chemicalExplosionEmitter], ([2,5] select (_size - 1))] call CBA_fnc_waitAndExecute;