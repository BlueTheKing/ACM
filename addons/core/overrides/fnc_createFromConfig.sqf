#include "..\script_component.hpp"
/* ----------------------------------------------------------------------------
Function: CBA_statemachine_fnc_createFromConfig

Description:
    Creates a state machine from a config class.

Parameters:
    _config         - config path that contains a valid state machine config
                      (check the example.hpp file for the required structure)
                      <CONFIG>

Returns:
    _stateMachine   - a state machine <LOCATION>

Examples:
    (begin example)
        _stateMachine = [configFile >> "MyAddon_Statemachine"] call CBA_statemachine_fnc_createFromConfig;
    (end)

Author:
    BaerMitUmlaut
---------------------------------------------------------------------------- */
SCRIPT(createFromConfig);
params [["_config", configNull, [configNull]]];

if (isNull _config) exitWith {};

if ((configName _config) isEqualTo "ACE_Medical_StateMachine") exitWith {ACEGVAR(medical,STATE_MACHINE)}; // legendary level hack // TODO find another way

private _list = compile getText (_config >> "list");
private _skipNull = (getNumber (_config >> "skipNull")) > 0;
private _stateMachine = [_list, _skipNull] call CBA_EFUNC(statemachine,create);

{
    private _state = configName _x;
    SM_GET_FUNCTION(_onState,_x >> "onState");
    SM_GET_FUNCTION(_onStateEntered,_x >> "onStateEntered");
    SM_GET_FUNCTION(_onStateLeaving,_x >> "onStateLeaving");
    [_stateMachine, _onState, _onStateEntered, _onStateLeaving, _state] call CBA_EFUNC(statemachine,addState);

} forEach (configProperties [_config, "isClass _x", true]);

// We need to add the transitions in a second loop to make sure the states exist already
{
    private _state = configName _x;
    {
        private _transition = configName _x;
        private _targetState = _transition;
        if (isText (_x >> "targetState")) then {
            _targetState = getText (_x >> "targetState");
        };
        SM_GET_FUNCTION(_condition,_x >> "condition");
        SM_GET_FUNCTION(_onTransition,_x >> "onTransition");
        private _events = getArray (_x >> "events");

        if (_events isEqualTo []) then {
            [_stateMachine, _state, _targetState, _condition, _onTransition, _transition] call CBA_EFUNC(statemachine,addTransition);
        } else {
            [_stateMachine, _state, _targetState, _events, _condition, _onTransition, _transition] call CBA_EFUNC(statemachine,addEventTransition);
        };

    } forEach (configProperties [_x, "isClass _x", true]);

} forEach (configProperties [_config, "isClass _x", true]);

_stateMachine
