#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle airway deterioration while unconscious.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_airway_fnc_handleAirway;
 *
 * Public: No
 */

params ["_patient"];

if !(IS_UNCONSCIOUS(_patient)) exitWith {};

[{
    params ["_patient"];

    [QGVAR(handleAirwayCollapse), [_patient], _patient] call CBA_fnc_targetEvent;

    if ([_patient, "head"] call EFUNC(damage,isBodyPartBleeding)) then {
        [QGVAR(handleAirwayObstruction_Blood), [_patient], _patient] call CBA_fnc_targetEvent;
    };
}, [_patient], 10] call CBA_fnc_waitAndExecute;

if (random 1 < 0.5) then {
    [{
        params ["_patient"];

        [QGVAR(handleAirwayObstruction_Vomit), [_patient], _patient] call CBA_fnc_targetEvent;
    }, [_patient], (90 + (random 30))] call CBA_fnc_waitAndExecute;
};