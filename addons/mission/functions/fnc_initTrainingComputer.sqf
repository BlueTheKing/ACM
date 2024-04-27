#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init interactions for spawning patient
 *
 * Arguments:
 * 0: Interaction Object <OBJECT>
 * 1: Spawn Reference Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [this, ACM_Mission_TrainingSpot1] call ACM_mission_fnc_initTrainingComputer;
 *
 * Public: No
 */

params ["_object", "_spawnLocation"];

GVAR(TrainingCasualtyGroup) = createGroup [civilian, false];

private _actions = [];

_actions pushBack (["ACM_Training_SpawnPatient",
"Spawn Patient",
"",
{
    params ["_object", "_unit", "_args"];
    _args params ["_spawnPos"];

    [_object, _spawnPos, _unit, 0, 0] call FUNC(generatePatient);
},
{true},
{
    params ["_object", "_unit", "_args"];
    _args params ["_spawnPos"];

    [_object, _spawnPos] call FUNC(spawnPatient_childActions);
},
[_spawnLocation]] call ACEFUNC(interact_menu,createAction));

_actions pushBack (["ACM_Training_SpawnPatients",
"Spawn Patients",
"",
{
    params ["_object", "_unit", "_args"];
    _args params ["_spawnPos"];

    [_object, _spawnPos, _unit, 0, 0] call FUNC(generatePatients);
},
{true},
{
    params ["_object", "_unit", "_args"];
    _args params ["_spawnPos"];

    [_object, _spawnPos] call FUNC(spawnPatients_childActions);
},
[_spawnLocation]] call ACEFUNC(interact_menu,createAction));

_actions pushBack (["ACM_Training_HealPatient",
"Heal Patient(s)",
"",
{
    params ["_object", "_unit", "_args"];
    _args params ["_location"];

    private _targetUnits = _location nearEntities ["Man", 3];

    {
        [QACEGVAR(medical_treatment,fullHealLocal), [_x], _x] call CBA_fnc_targetEvent;
    } forEach _targetUnits;
},
{
    params ["_object", "_unit", "_args"];
    _args params ["_location"];

    (count (_location nearEntities ["Man", 3])) > 0;
},
{
    params ["_object", "_unit", "_args"];
    _args params ["_location"];

    private _targetUnits = _location nearEntities ["Man", 3];

    private _actions = [];

    {
        _actions pushBack [[format ["ACM_Training_HealPatient_%1", [_x, false, true] call ACEFUNC(common,getName)],
        [_x, false, true] call ACEFUNC(common,getName),
        "",
        {
            params ["", "", "_args"];
            _args params ["_target"];

            [QACEGVAR(medical_treatment,fullHealLocal), [_target], _target] call CBA_fnc_targetEvent;
        },
        {true},
        {},
        [_x]
        ] call ACEFUNC(interact_menu,createAction), [], (_this select 1)];

        _actions;
    } forEach _targetUnits;
},
[_spawnLocation]] call ACEFUNC(interact_menu,createAction));

{
    [_object, 0, ["ACE_MainActions"], _x] call ACEFUNC(interact_menu,addActionToObject);
} forEach _actions;
