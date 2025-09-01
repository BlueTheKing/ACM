#include "..\script_component.hpp"
/*
 * Author: Blue
 * Add actions to object to perform evacuation.
 *
 * Arguments:
 * 0: Reference Object <OBJECT>
 * 1: Side <NUMBER>
 *   0: BLUFOR
 *   1: REDFOR
 *   2: GREENFOR
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object, _side] call ACM_evacuation_fnc_defineEvacuationPoint;
 *
 * Public: No
 */

params ["_object", ["_side", 0]];

_object setVariable [QGVAR(EvacuationSide), GET_SIDE(_side), true];

private _actions = [];

_actions pushBack (["ACM_Evacuation_EvacuatePatient",
LLSTRING(EvacuatePatient),
"",
{
    params ["_object", "_unit"];

    private _casualty = _unit getVariable [QACEGVAR(dragging,carriedObject), objNull];

    if (alive _casualty) then {
        [_unit, _casualty] call ACEFUNC(dragging,dropObject_carry);

        deleteVehicle _casualty;
        [true, (_casualty getVariable [QGVAR(CasualtySide), 0])] call FUNC(setCasualtyTicket);
        [LLSTRING(EvacuatePatient_Success), 2, _unit] call ACEFUNC(common,displayTextStructured);
    };
},
{
    params ["_object", "_unit"];

    if !(_unit getVariable [QACEGVAR(dragging,isCarrying), false]) exitWith {false};

    private _casualty = _unit getVariable [QACEGVAR(dragging,carriedObject), objNull];
    private _casualtySide = _casualty getVariable [QGVAR(CasualtySide), 0];
    
    private _evacuationSide = _object getVariable [QGVAR(EvacuationSide), sideEmpty];

    if (_evacuationSide == sideEmpty) exitWith {false};
    if (_evacuationSide != GET_SIDE(_casualtySide)) exitWith {false};

    ((_casualty getVariable [QGVAR(casualtyTicketClaimed), false]) && IS_UNCONSCIOUS(_casualty));
}, {}, [], [0,0,0], 4] call ACEFUNC(interact_menu,createAction));

{
    [_object, 0, [], _x] call ACEFUNC(interact_menu,addActionToObject);
} forEach _actions;