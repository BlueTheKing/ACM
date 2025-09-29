#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create hazard zone. (Eden)
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 * 1: Synchronized objects <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC, [], true] call ACM_CBRN_fnc_moduleCreateChemicalDevice_Eden;
 *
 * Public: No
 */

params ["_logic", "_syncedObjects", "_activated"];

if (!_activated || !(GVAR(enable))) exitWith {};

[{
    params ["_logic", "_syncedObjects"];

    private _attachedObject = _syncedObjects select 0;

    private _hazardTypeSelection = _logic getVariable ["HazardType", 0];
    private _hazardType = switch (_hazardTypeSelection) do {
        case 1: {"chemical_sarin"};
        case 2: {"chemical_lewisite"};
        default {"chemical_chlorine"};
    };

    private _cloudSizeSelection = _logic getVariable ["ExplosionCloudSize", 0];

    private _radius = 1 max (_logic getVariable ["ZoneRadius", 0]);
    private _affectAI = _logic getVariable ["AffectAI", 0];

    private _effectTime = [(20 + (random 15)), -1] select (_logic getVariable ["PermanentHazard", 0]);

    [{
        params ["_attachedObject"];

        isNull _attachedObject || !(alive _attachedObject);
    }, {
        params ["_attachedObject", "_hazardType", "_radius", "_effectTime", "_affectAI", "_cloudSizeSelection"];

        if (isNull _attachedObject) exitWith {};

        [_attachedObject, _hazardType, _radius, _effectTime, _affectAI, _cloudSizeSelection] call FUNC(detonateChemicalDevice);
    }, [_attachedObject, _hazardType, _radius, _effectTime, _affectAI, _cloudSizeSelection], 3600] call CBA_fnc_waitUntilAndExecute;

    deleteVehicle _logic;
}, [_logic, _syncedObjects], 1] call CBA_fnc_waitAndExecute;