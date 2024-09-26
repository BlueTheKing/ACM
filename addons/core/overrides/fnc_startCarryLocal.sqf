#include "..\script_component.hpp"
/*
 * Author: commy2, PiZZADOX
 * Starts the carrying process.
 *
 * Arguments:
 * 0: Unit that should do the carrying <OBJECT>
 * 1: Object to carry <OBJECT>
 * 2: If object was successfully claimed <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, true] call ace_dragging_fnc_startCarryLocal
 *
 * Public: No
 */

params ["_unit", "_target", "_claimed"];
TRACE_3("params",_unit,_target,_claimed);

if (!_claimed) exitWith { WARNING_1("already claimed %1",_this) };

// Exempt from weight check if object has override variable set
private _weight = 0;

if !(_target getVariable [QACEGVAR(dragging,ignoreWeightCarry), false]) then {
    _weight = _target call ACEFUNC(dragging,getWeight);
};

// Exit if object weight is over global var value
if (_weight > GETMVAR(ACE_maxWeightCarry,1E11)) exitWith {
    // Release claim on object
    [objNull, _target, true] call ACEFUNC(common,claim);

    [ACELLSTRING(dragging,UnableToDrag)] call ACEFUNC(common,displayTextStructured);
};

private _timer = CBA_missionTime + 5;

// Handle objects vs. persons
if (_target isKindOf "CAManBase") then {
    // Create clone for dead units
    if (!alive _target) then {
        _target = [_unit, _target] call ACEFUNC(dragging,createClone);
    };

    private _primaryWeapon = primaryWeapon _unit;

    // Add a primary weapon if the unit has none
    if (_primaryWeapon == "") then {
        _unit addWeapon "ACE_FakePrimaryWeapon";
        _primaryWeapon = "ACE_FakePrimaryWeapon";
    };

    // Select primary, otherwise the carry animation actions don't work
    _unit selectWeapon _primaryWeapon; // This turns off lasers/lights

    // Move a bit closer and adjust direction when trying to pick up a person
    [QACEGVAR(common,setDir), [_target, getDir _unit + 180], _target] call CBA_fnc_targetEvent;
    _target setPosASL (getPosASL _unit vectorAdd (vectorDir _unit));

    if (_target getVariable [QGVAR(CarryAssist_State), false]) then {
        _timer = CBA_missionTime + 1;
    } else {
        [_unit, "AcinPknlMstpSnonWnonDnon_AcinPercMrunSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
        [_target, "AinjPfalMstpSnonWrflDnon_carried_Up", 2] call ACEFUNC(common,doAnimation);

        _timer = CBA_missionTime + 10;
    };
} else {
    // Select no weapon and stop sprinting
    if (currentWeapon _unit != "") then {
        _unit setVariable [QACEGVAR(dragging,previousWeapon), (weaponState _unit) select [0, 3], true];

        _unit action ["SwitchWeapon", _unit, _unit, 299];
    };

    [_unit, "AmovPercMstpSnonWnonDnon", 0] call ACEFUNC(common,doAnimation);

    private _canRun = _weight call ACEFUNC(dragging,canRun_carry);

    // Only force walking if we're overweight
    [_unit, "forceWalk", QUOTE(ACE_ADDON(dragging)), !_canRun] call ACEFUNC(common,statusEffect_set);
    [_unit, "blockSprint", QUOTE(ACE_ADDON(dragging)), _canRun] call ACEFUNC(common,statusEffect_set);
};

[_unit, "blockThrow", QUOTE(ACE_ADDON(dragging)), true] call ACEFUNC(common,statusEffect_set);

// Prevents dragging and carrying at the same time
_unit setVariable [QACEGVAR(dragging,isCarrying), true, true];

// Required for aborting (animation & keybind)
_unit setVariable [QACEGVAR(dragging,carriedObject), _target, true];

[ACELINKFUNC(dragging,startCarryPFH), 0.2, [_unit, _target, _timer]] call CBA_fnc_addPerFrameHandler;

// Disable collisions by setting the PhysX mass to almost zero
private _mass = getMass _target;

if (_mass > 1) then {
    _target setVariable [QACEGVAR(dragging,originalMass), _mass, true];
    [QACEGVAR(common,setMass), [_target, 1e-12]] call CBA_fnc_globalEvent; // Force global sync
};

// API
[QACEGVAR(dragging,setupCarry), [_unit, _target]] call CBA_fnc_localEvent;