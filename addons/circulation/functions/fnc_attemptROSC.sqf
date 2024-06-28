#include "..\script_component.hpp"
/*
 * Author: Blue
 * Attempt ROSC, fail if not reversed (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Successful? <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm"] call ACM_circulation_fnc_attemptROSC;
 *
 * Public: No
 */

params ["_patient"];

[_patient] call FUNC(updateCirculationState);

if (!(IN_CRDC_ARRST(_patient)) || !(alive _patient)) exitWith {false};

if (GET_CIRCULATIONSTATE(_patient) && (GET_BLOOD_VOLUME(_patient) > ACM_REVERSIBLE_CA_BLOODVOLUME)) exitWith {
    [QACEGVAR(medical,CPRSucceeded), _patient] call CBA_fnc_localEvent;
    if (GVAR(Hardcore_PostCardiacArrest)) then {
        _patient setVariable [QGVAR(Hardcore_PostCardiacArrest), true, true];
    };
    true;
};

[QGVAR(handleReversibleCardiacArrest), _patient] call CBA_fnc_localEvent;

false;