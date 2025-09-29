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
 * [LOGIC, [], true] call ACM_CBRN_fnc_moduleCreateHazardZone_Eden;
 *
 * Public: No
 */

params ["_logic", "_syncedObjects", "_activated"];

if (!_activated || !(GVAR(enable))) exitWith {};

[{
    params ["_logic", "_syncedObjects"];

    private _attach = (_logic getVariable ["AttachToObject", false]) && (count _syncedObjects > 0);
    private _targetObject = [_logic, (_syncedObjects select 0)] select _attach;

    private _hazardTypeSelection = _logic getVariable ["HazardType", 0];
    private _hazardType = switch (_hazardTypeSelection) do {
        case 1: {"chemical_cs"};
        case 2: {"chemical_chlorine"};
        case 3: {"chemical_sarin"};
        case 4: {"chemical_lewisite"};
        default {"chemical_placebo"};
    };

    private _radius = 1 max (_logic getVariable ["ZoneRadius", 0]);
    private _showMist = _logic getVariable ["ShowMist", 0];
    private _affectAI = _logic getVariable ["AffectAI", 0];

    private _effectTime = _logic getVariable ["EffectTime", 0];
    _effectTime = [-1, (_effectTime * 60)] select (_effectTime > 0);

    [QGVAR(initHazardZone), [_targetObject, _attach, _hazardType, [_radius,_radius,0,false,-1], _effectTime, _affectAI, false, _showMist]] call CBA_fnc_serverEvent;
    deleteVehicle _logic;
}, [_logic, _syncedObjects], 1] call CBA_fnc_waitAndExecute;