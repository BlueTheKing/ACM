#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient cardiac arrest event. (LOCAL)
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

if (_patient getVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Sinus] == ACM_Rhythm_Asystole || !_active) exitWith {};

[_patient] call EFUNC(circulation,updateCirculationState);

if (!(GET_CIRCULATIONSTATE(_patient)) || (GET_BLOOD_VOLUME(_patient) < ACM_REVERSIBLE_CA_BLOODVOLUME)) then {
    if !(IN_CRDC_ARRST(_patient)) then {
        [QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;
    };
    [QEGVAR(circulation,handleReversibleCardiacArrest), [_patient], _patient] call CBA_fnc_targetEvent;
    _patient setVariable [QEGVAR(circulation,CardiacArrest_Time), CBA_missionTime, true];
} else {
    if (random 1 < EGVAR(circulation,cardiacArrestChance) || _patient getVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_Sinus] != ACM_Rhythm_Sinus) then {
        [QEGVAR(circulation,handleCardiacArrest), _patient] call CBA_fnc_localEvent;
        _patient setVariable [QEGVAR(circulation,CardiacArrest_Time), CBA_missionTime, true];
    } else {
        [_patient] call FUNC(handleKnockOut);
        [QEGVAR(circulation,attemptROSC), _patient] call CBA_fnc_localEvent;
    };
};