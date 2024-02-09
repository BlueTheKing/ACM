#include "script_component.hpp"

[QGVAR(handleReversibleCardiacArrest), LINKFUNC(handleReversibleCardiacArrest)] call CBA_fnc_addEventHandler;

[QGVAR(setIVLocal), LINKFUNC(setIVLocal)] call CBA_fnc_addEventHandler;
[QGVAR(setAEDLocal), LINKFUNC(setAEDLocal)] call CBA_fnc_addEventHandler;