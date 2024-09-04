#include "..\script_component.hpp"
/*
 * Author: Blue
 * Add actions to object to perform evacuation.
 *
 * Arguments:
 * 0: Reference Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object] call ACM_evacuation_fnc_defineEvacuationPoint;
 *
 * Public: No
 */

params ["_object"];

private _actions = [];

_actions pushBack (["ACM_Evacuation_EvacuatePatient",
LLSTRING(EvacuatePatient),
"",
{
    params ["_object", "_unit"];

    private _casualty = _unit getVariable [QACEGVAR(dragging,carriedObject), objNull];

    if (alive _casualty) then {
        deleteVehicle _casualty;
        [true] call FUNC(setCasualtyTicket);
        [LLSTRING(EvacuatePatient_Success), 2, _unit] call ACEFUNC(common,displayTextStructured);
    };
},
{
    params ["_object", "_unit"];

    if !(_unit getVariable [QACEGVAR(dragging,isCarrying), false]) exitWith {false};

    private _casualty = _unit getVariable [QACEGVAR(dragging,carriedObject), objNull];
    ((_casualty getVariable [QGVAR(casualtyTicketClaimed), false]) && IS_UNCONSCIOUS(_casualty));
}] call ACEFUNC(interact_menu,createAction));

{
    [_object, 0, ["ACE_MainActions"], _x] call ACEFUNC(interact_menu,addActionToObject);
} forEach _actions;