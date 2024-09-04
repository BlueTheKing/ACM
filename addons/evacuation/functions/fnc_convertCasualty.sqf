#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle converting casualty from player to AI.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_evacuation_fnc_convertCasualty;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[false] call FUNC(setCasualtyTicket);

[QGVAR(createReinforcmentAndSwitch), [_patient], _patient] call CBA_fnc_targetEvent;
_patient setVariable [QGVAR(casualtyTicketClaimed), true, true];

[{
    params ["_medic", "_patient"];

    [_patient] call ACEFUNC(common,setName);
    _patient disableAI "ALL";
    [_patient] joinSilent GVAR(CasualtyGroup);
    [LLSTRING(ConvertCasualty_Complete), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
}, [_medic, _patient], 2] call CBA_fnc_waitAndExecute;