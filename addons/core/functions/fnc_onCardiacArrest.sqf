#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient cardiac arrest event
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_core_fnc_onCardiacArrest;
 *
 * Public: No
 */

params ["_patient"];

[{
    params ["_patient"];

    if (_patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false] || (GET_BLOOD_VOLUME(_patient) <= BLOOD_VOLUME_CLASS_4_HEMORRHAGE) || (GET_OXYGEN(_patient) < AMS_OXYGEN_HYPOXIA)) then {
        if !(IN_CRDC_ARRST(_patient)) then {
            [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
        };
        [QEGVAR(circulation,handleReversibleCardiacArrest), [_patient], _patient] call CBA_fnc_targetEvent;
    } else {
        if (_patient getVariable [QGVAR(FatalInjury_Grazed), false]) then {
            _patient setVariable [QGVAR(KnockOut_State), true];
            [{
                params ["_patient"];

                _patient setVariable [QGVAR(KnockOut_State), false];
            }, [_patient], (15 + (random 20))] call CBA_fnc_waitAndExecute;
            [QACEGVAR(medical,CPRSucceeded), _patient] call CBA_fnc_localEvent;
        } else {
            [QEGVAR(circulation,handleCardiacArrest), _patient] call CBA_fnc_localEvent;
        };
    };
}, [_patient], 1] call CBA_fnc_waitAndExecute;