#include "script_component.hpp"

[QGVAR(forceWakeUp), {
    params ["_patient"];

    _patient setVariable [QGVAR(KnockOut_State), false];
    [_patient, false] call ACEFUNC(medical,setUnconscious);
}] call CBA_fnc_addEventHandler;

[QGVAR(givePain), {
    params ["_patient", "_amount"];

    [_patient, _amount] call ACEFUNC(medical,adjustPainLevel);
}] call CBA_fnc_addEventHandler;