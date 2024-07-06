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

[_patient] call EFUNC(circulation,updateCirculationState);

if (!(GET_CIRCULATIONSTATE(_patient)) || (GET_BLOOD_VOLUME(_patient) < ACM_REVERSIBLE_CA_BLOODVOLUME)) then {
    if !(IN_CRDC_ARRST(_patient)) then {
        [QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;
    };
    [QEGVAR(circulation,handleReversibleCardiacArrest), [_patient], _patient] call CBA_fnc_targetEvent;
} else {
    if (random 1 < EGVAR(circulation,cardiacArrestChance) || _patient getVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), 0] != 0) then {
        [QEGVAR(circulation,handleCardiacArrest), _patient] call CBA_fnc_localEvent;
    } else {
        _patient setVariable [QGVAR(KnockOut_State), true];

        if (isPlayer _patient || {(!(isPlayer _patient) && {!(random 1 < EGVAR(damage,AIStayDownChance))})}) then {
            [{
                params ["_patient"];

                _patient setVariable [QGVAR(KnockOut_State), false];

                if !(_patient getVariable [QEGVAR(airway,AirwayReflex_State), false]) then { // Able to wake up
                    _patient setVariable [QEGVAR(airway,AirwayReflex_State), true, true];
                };
            }, [_patient], (15 + (random 20))] call CBA_fnc_waitAndExecute;
        };
        [QEGVAR(circulation,attemptROSC), _patient] call CBA_fnc_localEvent;
    };
};