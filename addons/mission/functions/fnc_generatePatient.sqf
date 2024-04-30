#include "..\script_component.hpp"
/*
 * Author: Blue
 * Spawn patient
 *
 * Arguments:
 * 0: Interaction Object <OBJECT>
 * 1: Spawn Reference Object <OBJECT>
 * 2: Initiator Unit <OBJECT>
 * 3: Severity Preset <NUMBER>
 * 4: Injury Type <NUMBER>
 * 5: Single Patient Spawning <BOOL>
 *
 * Return Value:
 * Patient <OBJECT>
 *
 * Example:
 * [_object, _location, player, 0, 0, true] call ACM_mission_fnc_generatePatient;
 *
 * Public: No
 */

params ["_object", "_location", "_initiator", "_severity", "_type", ["_singlePatient", true]];

if (_singlePatient) then {
    private _activePatient = _object getVariable [QGVAR(ActivePatient), objNull];

    if !(isNull _activePatient) then {
        deleteVehicle _activePatient;
        _object setVariable [QGVAR(ActivePatient), objNull, true];
    };

    private _activePatients = _object getVariable [QGVAR(ActivePatients), []];

    if (count _activePatients > 0) then {
        {
            deleteVehicle _x;
        } forEachReversed _activePatients;
        _object setVariable [QGVAR(ActivePatients), [], true];
    };
};

private _fnc_generateWounds = {
    params ["_type", "_severity", ["_multiplier", 1]];

    private _targetPart = "body";
    private _mechanism = "";
    private _damageAmount = _multiplier;

    if (_type == 0) then { // Random
        _type = switch (_severity) do {
            case 1: {[1,2,5,6] select (round (random 3))};
            case 2: {[1,2,3,4] select (round (random 3))};
            case 3: {[1,3] select (round (random 1))};
            case 4: {[1,2,3] select (round (random 2))};
        };
    };

    _targetPart = ALL_BODY_PARTS select (round (random 5));

    switch (_type) do {
        case 1: { // Gunshot
            _mechanism = "bullet";
        };
        case 2: { // Shrapnel
            _mechanism = "grenade";
        };
        case 3: { // Explosion
            _mechanism = "explosive";
        };
        case 4: { // Collision
            _mechanism = "collision";
            _targetPart = "body";
        };
        case 5: { // Falling
            _mechanism = "falling";
            _targetPart = ALL_BODY_PARTS select (4 + (round (random 1)));
        };
        case 6: { // Backblast
            _mechanism = "backblast";
        };
    };

    [_targetPart,_mechanism,_damageAmount];
};

private _patient = GVAR(TrainingCasualtyGroup) createUnit ["B_Survivor_F", position _location, [], 0, "FORM"];

_patient disableAI "MOVE";

removeAllWeapons _patient;
removeAllItems _patient;
removeAllAssignedItems _patient;
removeGoggles _patient;

[_patient, true, 30] call ACEFUNC(medical,setUnconscious);

private _injuryArray = [];

if (_severity == 0) then { // Random
    _severity =  1 + (round (random 3));
};

private _damageMultiplier = 1;

private _woundCount = 2;

switch (_severity) do {
    case 1: { // Routine
        _damageMultiplier = random [1,1.25,1.5];
        _woundCount = round (random [2,2,3]);
    };
    case 2: { // Priority
        _damageMultiplier = random [2.5,3,4];
        _woundCount = round (random [3,4,5]);
    };
    case 3: { // Immediate
        _damageMultiplier = random [3.5,4,5];
        _woundCount = round (random [5,6,7]);
    };
    case 4: { // Expectant
        _damageMultiplier = random [7,8,9];
        _woundCount = round (random [7,8,10]);
    };
};

for "_i" from 1 to _woundCount do {
    _injuryArray pushBack ([_type, _severity, _damageMultiplier] call _fnc_generateWounds);
};

{
    _x params ["_targetPart", "_mechanism", "_damageAmount"];

    [_patient, _damageAmount, _targetPart, _mechanism, _initiator] call ACEFUNC(medical,addDamageToUnit);
} forEach _injuryArray;

if (_singlePatient) then {
    _object setVariable [QGVAR(ActivePatient), _patient, true];
};

_patient;