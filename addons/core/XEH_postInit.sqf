#include "script_component.hpp"

[QACEGVAR(medical,FatalInjury), LINKFUNC(onFatalInjury)] call CBA_fnc_addEventHandler;
//["ace_cardiacArrest", LINKFUNC(onCardiacArrest)] call CBA_fnc_addEventHandler;
["ace_unconscious", LINKFUNC(onUnconscious)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,fullHealLocalMod), LINKFUNC(fullHealLocal)] call CBA_fnc_addEventHandler;