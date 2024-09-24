#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle resealing chest tube (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_resealChestTubeLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[QACEGVAR(common,displayTextStructured), [LLSTRING(ThoracostomyResealChestTube_Complete), 1.5, _medic], _medic] call CBA_fnc_targetEvent;

_patient setVariable [QGVAR(Pneumothorax_State), 0, true];
_patient setVariable [QGVAR(Thoracostomy_State), 2, true];
[_patient] call FUNC(updateBreathingState);

[{
    params ["_patient"];

    (!(IS_UNCONSCIOUS(_patient)) && !(_patient getVariable [QEGVAR(core,Lying_State), false])) || (_patient getVariable [QGVAR(Thoracostomy_State), 0] != 2) || !(alive _patient);
}, {
    params ["_patient"];

    if (alive _patient && (_patient getVariable [QGVAR(Thoracostomy_State), 0]) == 2) then {
        [{
            params ["_patient"];

            if (alive _patient && (_patient getVariable [QGVAR(Thoracostomy_State), 0]) == 2) then {
                _patient setVariable [QGVAR(Pneumothorax_State), 3, true];
                _patient setVariable [QGVAR(Thoracostomy_State), 3, true];
                [_patient] call FUNC(updateBreathingState);
                [_patient, 0.5] call ACEFUNC(medical,adjustPainLevel);
            };
        }, [_patient], (60 + (random 60))] call CBA_fnc_waitAndExecute;
    };
}, [_patient], 3600, {}] call CBA_fnc_waitUntilAndExecute;