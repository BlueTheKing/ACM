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
private _isClone = _target isKindOf QACEGVAR(dragging,clone);

// Drop cloned dead units
if (_isClone) then {
    _target = [_unit, _target, _inBuilding] call ACEFUNC(dragging,deleteClone);
};

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

    if (isNull objectParent _unit && {_unit call ACEFUNC(common,isAwake)}) then {
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

// Reselect weapon and re-enable sprint
private _previousWeaponState = _unit getVariable QACEGVAR(dragging,previousWeapon);

if (!isNil "_previousWeaponState") then {
    _unit selectWeapon _previousWeaponState;

    _unit setVariable [QACEGVAR(dragging,previousWeapon), nil, true];
};

[_unit] call ACEFUNC(weaponselect,putWeaponAway);

[_unit, "forceWalk", QUOTE(ACE_ADDON(dragging)), false] call ACEFUNC(common,statusEffect_set);
[_unit, "blockSprint", QUOTE(ACE_ADDON(dragging)), false] call ACEFUNC(common,statusEffect_set);
[_unit, "blockThrow", QUOTE(ACE_ADDON(dragging)), false] call ACEFUNC(common,statusEffect_set);

// Prevent object from flipping inside buildings
if (_inBuilding && {!_isClone}) then {
    _target setPosASL (getPosASL _target vectorAdd [0, 0, 0.05]);
    TRACE_2("setPos",getPosASL _unit,getPosASL _target);
};

_unit setVariable [QACEGVAR(dragging,isCarrying), false, true];
_unit setVariable [QACEGVAR(dragging,carriedObject), objNull, true];

// Make object accessible for other units
[objNull, _target, true] call ACEFUNC(common,claim);

if !(_target isKindOf "CAManBase") then {
    [QACEGVAR(common,fixPosition), _target, _target] call CBA_fnc_targetEvent;
    [QACEGVAR(common,fixFloating), _target, _target] call CBA_fnc_targetEvent;
};

// Reenable UAV crew
private _UAVCrew = _target getVariable [QACEGVAR(dragging,isUAV), []];

if (_UAVCrew isNotEqualTo []) then {
    // Reenable AI
    {
        [_x, false] call ACEFUNC(common,disableAiUAV);
    } forEach _UAVCrew;

    _target setVariable [QACEGVAR(dragging,isUAV), nil, true];
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
            if (GETACEGVAR(medical,enabled,false)) then {
                [_unit, _target, _cursorObject] call ACEFUNC(medical_treatment,loadUnit);
            } else {
                [_unit, _target, _cursorObject] call ACEFUNC(common,loadPerson);
            };

            // Repurpose variable for flag used in event below
            _loadCargo = true;
        };
    };
};

// API
[QACEGVAR(dragging,stoppedCarry), [_unit, _target, _loadCargo]] call CBA_fnc_localEvent;