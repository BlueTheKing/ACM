#include "script_component.hpp"

[QGVAR(splintLocal), LINKFUNC(splintLocal)] call CBA_fnc_addEventHandler;
[QGVAR(wrapSplintLocal), LINKFUNC(wrapSplintLocal)] call CBA_fnc_addEventHandler;
[QGVAR(removeSplintLocal), LINKFUNC(removeSplintLocal)] call CBA_fnc_addEventHandler;

[QGVAR(shakeAwakeLocal), LINKFUNC(shakeAwakeLocal)] call CBA_fnc_addEventHandler;
[QGVAR(slapAwakeLocal), LINKFUNC(slapAwakeLocal)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,tourniquetLocal), LINKFUNC(setTourniquetTime)] call CBA_fnc_addEventHandler;