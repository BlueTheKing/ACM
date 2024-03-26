#include "script_component.hpp"

[QGVAR(handleChestInjury), LINKFUNC(handleChestInjury)] call CBA_fnc_addEventHandler;

[QGVAR(inspectChestLocal), LINKFUNC(inspectChestLocal)] call CBA_fnc_addEventHandler;
[QGVAR(checkBreathingLocal), LINKFUNC(checkBreathingLocal)] call CBA_fnc_addEventHandler;

[QGVAR(applyChestSealLocal), LINKFUNC(applyChestSealLocal)] call CBA_fnc_addEventHandler;
[QGVAR(performNCDLocal), LINKFUNC(performNCDLocal)] call CBA_fnc_addEventHandler;

[QGVAR(setPulseOximeterLocal), LINKFUNC(setPulseOximeterLocal)] call CBA_fnc_addEventHandler;

["isNotPerformingCPR", {!((_this select 0) getVariable [QGVAR(isPerformingCPR), false])}] call ACEFUNC(common,addCanInteractWithCondition);