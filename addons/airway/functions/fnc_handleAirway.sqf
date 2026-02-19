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

if (!(GVAR(enable)) || !(IS_UNCONSCIOUS(_patient))) exitWith {};

private _airwayReflexDelay = 20 + (random 25);

[{
    params ["_patient"];

    if !(IS_UNCONSCIOUS(_patient)) exitWith {};

    if (_patient getVariable [QGVAR(AirwayReflex_State), false]) then {
        _patient setVariable [QGVAR(AirwayReflex_State), false, true];
    };

    if ([_patient, "head"] call EFUNC(damage,isBodyPartBleeding) && (GVAR(airwayObstructionBloodChance) > 0)) then {
        [QGVAR(handleAirwayObstruction_Blood), [_patient], _patient] call CBA_fnc_targetEvent;
    };
}, [_patient], _airwayReflexDelay] call CBA_fnc_waitAndExecute;

[{
    params ["_patient"];

    [QGVAR(handleAirwayCollapse), [_patient], _patient] call CBA_fnc_targetEvent;
}, [_patient], (_airwayReflexDelay + (240 + (random 60)))] call CBA_fnc_waitAndExecute;

if (GVAR(airwayObstructionVomitChance) > 0) then {
    private _medicationEffect = [_patient] call EFUNC(circulation,getNauseaMedicationEffects);

    if ((((GET_BODYPART_DAMAGE(_patient) select 0) > 1) && (random 1 < (0.8 + _medicationEffect))) || random 1 < (0.3 + _medicationEffect)) then {
        [{
            params ["_patient"];

            [QGVAR(handleAirwayObstruction_Vomit), [_patient], _patient] call CBA_fnc_targetEvent;
        }, [_patient], (_airwayReflexDelay + (60 + (random 60)))] call CBA_fnc_waitAndExecute;
    };
};