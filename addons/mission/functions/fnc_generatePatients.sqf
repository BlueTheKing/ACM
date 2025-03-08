#include "..\script_component.hpp"
/*
 * Author: Blue
 * Spawn patients.
 *
 * Arguments:
 * 0: Interaction Object <OBJECT>
 * 1: Spawn Reference Object <OBJECT>
 * 2: Initiator Unit <OBJECT>
 * 3: Casualty Count <NUMBER>
 * 4: Severity Preset <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object, _location, player, 0, 0] call ACM_mission_fnc_generatePatients;
 *
 * Public: No
 */

params ["_object", "_location", "_initiator", "_casualtyCount", "_severity"];

[_object] call FUNC(clearPatients);

private _patientList = [];

if (_casualtyCount < 2) then {
    _casualtyCount = 2 + (round (random 6));
};

for "_i" from 1 to _casualtyCount do {
    private _patientSeverity = _severity;

    if (_patientSeverity == 0) then {
        _patientSeverity =  1 + (round (random 3));
    };

    _patientList pushBack ([_object, _location, _initiator, _patientSeverity, 0, false] call FUNC(generatePatient));
};

_object setVariable [QGVAR(ActivePatients), _patientList, true];