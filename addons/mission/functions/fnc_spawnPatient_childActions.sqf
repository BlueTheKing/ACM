#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init child actions for spawn patient interactions
 *
 * Arguments:
 * 0: Interaction Object <OBJECT>
 * 1: Spawn Reference Object <OBJECT>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [this, ACM_Mission_TrainingSpot1] call ACM_mission_fnc_spawnPatient_childActions;
 *
 * Public: No
 */

params ["_object", "_spawnLocation"];

private _actions = [];

{
    _x params ["_severity", "_actionName", "_colorHex", "_childArray"];

    _actions pushBack [[format ["ACM_Training_SpawnPatient_%1", _actionName],
    _actionName,
    ["",_colorHex],
    {
        params ["", "_unit", "_args"];
        _args params ["_object", "_spawnPos", "_severity"];

        [_object, _spawnPos, _unit, _severity, 0] call FUNC(generatePatient);
    },
    {true},
    {
        params ["", "_unit", "_args"];
        _args params ["_object", "_spawnPos", "_severity", "_actionName", "_childArray"];

        private _childActions = [];

        {
            _x params ["_damageType", "_subActionName"];

            _childActions pushBack [[format ["ACM_Training_SpawnPatient_%1_%2", _actionName, _subActionName],
            _subActionName,
            "",
            {
                params ["", "", "_args"];
                _args params ["_object", "_unit","_spawnPos", "_severity", "_damageType"];

                [_object, _spawnPos, _unit, _severity, _damageType] call FUNC(generatePatient);
            },
            {true},
            {},
            [_object, _unit, _spawnPos, _severity, _damageType]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)];
        } forEach _childArray;

        _childActions;
    },
    [_object, _spawnLocation, _severity, _actionName, _childArray]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)];
} forEach [[1,"Routine","#1be600",[
    [1,"Gunshot"],[2,"Shrapnel"],[5,"Falling"],[6,"Backblast"]
]],
[2,"Priority","#d19200",[
    [1,"Gunshot"],[2,"Shrapnel"],[3,"Explosion"],[4,"Collision"]
]],
[3,"Immediate","#d10000",[
    [1,"Gunshot"],[3,"Explosion"]
]],
[4,"Expectant","#171717",[]]];

_actions;