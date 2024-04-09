#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Handles the unconscious state
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ace_medical_statemachine_fnc_handleStateUnconscious;
 *
 * Public: No
 */

params ["_unit"];

// If the unit died the loop is finished
if (!alive _unit || {!local _unit}) exitWith {};

[_unit] call ACEFUNC(medical_vitals,handleUnitVitals);

// Handle spontaneous wake up from unconsciousness
if (ACEGVAR(medical,spontaneousWakeUpChance) > 0) then {
    if (_unit call ACEFUNC(medical_status,hasStableVitals) && !(_unit getVariable [QGVAR(KnockOut_State), false])) then {
        private _lastWakeUpCheck = _unit getVariable QACEGVAR(medical,lastWakeUpCheck);

        // Handle setting being changed mid-mission and still properly check
        // already unconscious units, should handle locality changes as well
        if (isNil "_lastWakeUpCheck") exitWith {
            TRACE_1("undefined lastWakeUpCheck: setting to current time",_lastWakeUpCheck);
            _unit setVariable [QACEGVAR(medical,lastWakeUpCheck), CBA_missionTime];
        };

        private _wakeUpCheckInterval = SPONTANEOUS_WAKE_UP_INTERVAL;
        if (ACEGVAR(medical,spontaneousWakeUpEpinephrineBoost) > 1) then {
            private _epiEffectiveness = [_unit, "Epinephrine", false] call ACEFUNC(medical_status,getMedicationCount);
            _wakeUpCheckInterval = _wakeUpCheckInterval * linearConversion [0, 1, _epiEffectiveness, 1, 1 / ACEGVAR(medical,spontaneousWakeUpEpinephrineBoost), true];
            TRACE_2("epiBoost",_epiEffectiveness,_wakeUpCheckInterval);
        };
        if (CBA_missionTime - _lastWakeUpCheck > _wakeUpCheckInterval) then {
            TRACE_2("Checking for wake up",_unit,ACEGVAR(medical,spontaneousWakeUpChance));
            _unit setVariable [QACEGVAR(medical,lastWakeUpCheck), CBA_missionTime];

            if (random 1 <= ACEGVAR(medical,spontaneousWakeUpChance)) then {
                TRACE_1("Spontaneous wake up!",_unit);
                [QACEGVAR(medical,WakeUp), _unit] call CBA_fnc_localEvent;
            };
        };
    } else {
        // Unstable vitals, procrastinate the next wakeup check
        private _lastWakeUpCheck = _unit getVariable [QACEGVAR(medical,lastWakeUpCheck), 0];
        _unit setVariable [QACEGVAR(medical,lastWakeUpCheck), _lastWakeUpCheck max CBA_missionTime];
    };
};
