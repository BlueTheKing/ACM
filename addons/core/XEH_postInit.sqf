#include "script_component.hpp"

[QACEGVAR(medical,FatalInjury), LINKFUNC(onFatalInjury)] call CBA_fnc_addEventHandler;
["ace_cardiacArrest", LINKFUNC(onCardiacArrest)] call CBA_fnc_addEventHandler;
["ace_unconscious", LINKFUNC(onUnconscious)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,fullHealLocalMod), LINKFUNC(fullHealLocal)] call CBA_fnc_addEventHandler;

["ace_treatmentSucceded", {
    params ["_medic", "_patient", "", "_classname"];

    if (IS_UNCONSCIOUS(_patient)) then {
        _patient setVariable [QGVAR(WasTreated), true, true];
    };
}] call CBA_fnc_addEventHandler;