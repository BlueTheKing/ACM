#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init child actions for spawn patients interactions
 *
 * Arguments:
 * 0: Interaction Object <OBJECT>
 * 1: Spawn Reference Object <OBJECT>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [this, ACM_Mission_TrainingSpot1] call ACM_mission_fnc_spawnPatients_childActions;
 *
 * Public: No
 */

params ["_object", "_spawnLocation"];

private _actions = [];

{
    _x params ["_casualtyCount", "_actionName"];

    _actions pushBack [[format ["ACM_Training_SpawnPatients_%1", _actionName],
    _actionName,
    "",
    {
        params ["", "_unit", "_args"];
        _args params ["_object", "_spawnPos", "_actionName", "_casualtyCount"];

        [_object, _spawnPos, _unit, _casualtyCount, 0] call FUNC(generatePatients);
    },
    {true},
    {
        params ["", "_unit", "_args"];
        _args params ["_object", "_spawnPos", "_actionName", "_casualtyCount"];

        private _childActions = [];

        private _severityArray = [[1,"Routine","#1be600"],[2,"Priority","#d19200"],[3,"Immediate","#d10000"],[4,"Expectant","#171717"]];

        {
            _x params ["_severity", "_subActionName", "_subActionColor"];

            _childActions pushBack [[format ["ACM_Training_SpawnPatients_%1_%2", _actionName, _subActionName],
            _subActionName,
            ["",_subActionColor],
            {
                params ["", "", "_args"];
                _args params ["_object", "_unit","_spawnPos", "_casualtyCount", "_severity"];

                [_object, _spawnPos, _unit, _casualtyCount, _severity] call FUNC(generatePatients);
            },
            {true},
            {},
            [_object, _unit, _spawnPos, _casualtyCount, _severity]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)];
        } forEach _severityArray;

        _childActions;
    },
    [_object, _spawnLocation, _actionName, _casualtyCount]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)];
} forEach [[2,"2"],[3,"3"],[4,"4"],[5,"5"],[6,"6"],[7,"7"],[8,"8"]];

_actions;