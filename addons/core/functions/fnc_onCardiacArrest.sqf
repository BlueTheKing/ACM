#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient cardiac arrest event
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: In Cardiac Arrest <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call ACM_core_fnc_onCardiacArrest;
 *
 * Public: No
 */

params ["_patient", "_active"];

if (_patient getVariable [QEGVAR(circulation,CardiacArrest_RhythmState), 0] == 1 || !_active) exitWith {};

if ((_patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]) || ((_patient getVariable [QEGVAR(breathing,HemoPneumothorax_Fluid), 0]) > 1.2) || (GET_BLOOD_VOLUME(_patient) <= BLOOD_VOLUME_CLASS_4_HEMORRHAGE) || (GET_OXYGEN(_patient) < ACM_OXYGEN_HYPOXIA)) then {
    if !(IN_CRDC_ARRST(_patient)) then {
        [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
    };
    [QEGVAR(circulation,handleReversibleCardiacArrest), [_patient], _patient] call CBA_fnc_targetEvent;
} else {
    if (random 1 < GVAR(cardiacArrestChance)) then {
        [QEGVAR(circulation,handleCardiacArrest), _patient] call CBA_fnc_localEvent;
    } else {
        _patient setVariable [QGVAR(KnockOut_State), true];

        if (isPlayer _patient || {(!(isPlayer _patient) && {!(random 1 < EGVAR(damage,AIStayDownChance))})}) then {
            [{
                params ["_patient"];

                _patient setVariable [QGVAR(KnockOut_State), false];
            }, [_patient], (15 + (random 20))] call CBA_fnc_waitAndExecute;
        };
        [QACEGVAR(medical,CPRSucceeded), _patient] call CBA_fnc_localEvent;
    };
};