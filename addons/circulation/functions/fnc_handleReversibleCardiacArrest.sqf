#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle reversible cardiac arrest (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleReversibleCardiacArrest;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] != 0 || _patient getVariable [QGVAR(ReversibleCardiacArrest_PFH), -1] != -1) exitWith {};

_patient setVariable [QGVAR(ReversibleCardiacArrest_State), true, true];
_patient setVariable [QGVAR(ReversibleCardiacArrest_Time), CBA_missionTime];
_patient setVariable [QGVAR(CardiacArrest_RhythmState), 5, true];

[_patient] call FUNC(updateCirculationState);

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _time = _patient getVariable [QGVAR(ReversibleCardiacArrest_Time), -1];
    private _reversibleCause = _patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false] || ((_patient getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0] > ACM_TENSIONHEMOTHORAX_THRESHOLD)) || (GET_BLOOD_VOLUME(_patient) <= ACM_REVERSIBLE_CA_BLOODVOLUME) || (GET_OXYGEN(_patient) < ACM_OXYGEN_HYPOXIA);
    
    if (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] != 5 || !_reversibleCause || !(IN_CRDC_ARRST(_patient)) || !(alive _patient) || ((_time + 360) < CBA_missionTime)) exitWith {
        _patient setVariable [QGVAR(ReversibleCardiacArrest_State), false, true];
        
        if (IN_CRDC_ARRST(_patient) && (alive _patient) && ((_time + 360) > CBA_missionTime) && _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] == 5) then { // Reversed
            [QGVAR(attemptROSC), _patient] call CBA_fnc_localEvent;
        } else {
            if (IN_CRDC_ARRST(_patient) && (alive _patient)) then { // Timed out (deteriorated)
                [QGVAR(handleCardiacArrest), _patient] call CBA_fnc_localEvent;
            };
        };

        _patient setVariable [QGVAR(ReversibleCardiacArrest_PFH), -1];

        [_patient] call FUNC(updateCirculationState);

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 5, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(ReversibleCardiacArrest_PFH), _PFH];