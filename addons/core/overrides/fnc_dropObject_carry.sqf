#include "..\script_component.hpp"
/*
 * Author: commy2
 * Drops a carried object.
 *
 * Arguments:
 * 0: Unit that carries the other object <OBJECT>
 * 1: Carried object to drop <OBJECT>
 * 2: Try loading object into vehicle <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ace_dragging_fnc_dropObject_carry;
 *
 * Public: No
 */

params ["_unit", "_target", ["_tryLoad", false]];
TRACE_1("params",_this);

// Remove drop action
[_unit, "DefaultAction", _unit getVariable [QACEGVAR(dragging,releaseActionID), -1]] call ACEFUNC(common,removeActionEventHandler);
_unit setVariable [QACEGVAR(dragging,releaseActionID), nil];

private _inBuilding = _unit call ACEFUNC(dragging,isObjectOnObject);

// Prevent collision damage
[QACEGVAR(common,fixCollision), _unit] call CBA_fnc_localEvent;
[QACEGVAR(common,fixCollision), _target, _target] call CBA_fnc_targetEvent;

private _cursorObject = cursorObject;
_tryLoad = _tryLoad && {!isNull _cursorObject} && {[_unit, _cursorObject, ["isNotCarrying"]] call ACEFUNC(common,canInteractWith)};
private _loadCargo = false;

// Don't release object if loading into vehicle (object might be released into vehicle)
if (_tryLoad && {!(_target isKindOf "CAManBase")} && {["ace_cargo"] call ACEFUNC(common,isModLoaded)} && {[_target, _cursorObject] call ACEFUNC(cargo,canLoadItemIn)}) then {
    _loadCargo = true;
} else {
    // Release object
    detach _target;
};

// Fix anim when aborting carrying persons
if (_target isKindOf "CAManBase" || {animationState _unit in CARRY_ANIMATIONS}) then {

    if (!(_target getVariable [QGVAR(Lying_State), false]) && IS_UNCONSCIOUS(_target)) then {
        _target setVariable [QGVAR(Lying_State), true, true];
    };

    if (isNull objectParent _unit && {!(_unit getVariable ["ACE_isUnconscious", false])}) then {
        [_unit, "", 2] call ACEFUNC(common,doAnimation);
    };

    if (IS_UNCONSCIOUS(_target) || (_target getVariable [QGVAR(Lying_State), false])) then {
        [QACEGVAR(common,switchMove), [_target, "ACM_LyingState"]] call CBA_fnc_globalEvent;
    } else {
        [QACEGVAR(common,switchMove), [_target, "AidlPpneMstpSnonWnonDnon_G01"]] call CBA_fnc_globalEvent;
    };

    if (!(IS_UNCONSCIOUS(_target)) && _target getVariable [QGVAR(Lying_State), false]) then {
        [QGVAR(getUpPrompt), [_target], _target] call CBA_fnc_targetEvent;
    };
};

// Properly remove fake weapon
_unit removeWeapon "ACE_FakePrimaryWeapon";

_unit setVariable [QACEGVAR(dragging,previousWeapon), nil, true];

[_unit] call ACEFUNC(weaponselect,putWeaponAway);

[_unit, "forceWalk", QUOTE(ACE_ADDON(dragging)), false] call ACEFUNC(common,statusEffect_set);
[_unit, "blockSprint", QUOTE(ACE_ADDON(dragging)), false] call ACEFUNC(common,statusEffect_set);
[_unit, "blockThrow", QUOTE(ACE_ADDON(dragging)), false] call ACEFUNC(common,statusEffect_set);

// Prevent object from flipping inside buildings
if (_inBuilding) then {
    _target setPosASL (getPosASL _target vectorAdd [0, 0, 0.05]);
};

_unit setVariable [QACEGVAR(dragging,isCarrying), false, true];
_unit setVariable [QACEGVAR(dragging,carriedObject), objNull, true];

// Make object accessible for other units
[objNull, _target, true] call ACEFUNC(common,claim);

if !(_target isKindOf "CAManBase") then {
    [QACEGVAR(common,fixPosition), _target, _target] call CBA_fnc_targetEvent;
    [QACEGVAR(common,fixFloating), _target, _target] call CBA_fnc_targetEvent;
};

// Recreate UAV crew (add a frame delay or this may cause the vehicle to be moved to [0,0,0])
if (_target getVariable [QACEGVAR(dragging,isUAV), false]) then {
    _target setVariable [QACEGVAR(dragging,isUAV), nil, true];

    [{
        params ["_target"];
        if (!alive _target) exitWith {};
        TRACE_2("restoring uav crew",_target,getPosASL _target);
        createVehicleCrew _target;
    }, [_target]] call CBA_fnc_execNextFrame;
};

// Reset mass
private _mass = _target getVariable [QACEGVAR(dragging,originalMass), 0];

if (_mass != 0) then {
    [QACEGVAR(common,setMass), [_target, _mass]] call CBA_fnc_globalEvent; // Force global sync
};

// Reset temp direction
_target setVariable [QACEGVAR(dragging,carryDirection_temp), nil];

// (Try) loading into vehicle
if (_loadCargo) then {
    [_unit, _target, _cursorObject] call ACEFUNC(cargo,startLoadIn);
} else {
    if (_tryLoad && {_unit distance _cursorObject <= MAX_LOAD_DISTANCE_MAN} && {_target isKindOf "CAManBase"}) then {
        private _vehicles = [_cursorObject, 0, true] call ACEFUNC(common,nearestVehiclesFreeSeat);

        if ([_cursorObject] isEqualTo _vehicles) then {
            if (["ace_medical"] call ACEFUNC(common,isModLoaded)) then {
                [_unit, _target, _cursorObject] call ACEFUNC(medical_treatment,loadUnit);
            } else {
                [_unit, _target, _cursorObject] call ACEFUNC(common,loadPerson);
            };
        };
    };
};
