#include "script_component.hpp"

[QGVAR(handleChestInjury), LINKFUNC(handleChestInjury)] call CBA_fnc_addEventHandler;

[QGVAR(inspectChestLocal), LINKFUNC(inspectChestLocal)] call CBA_fnc_addEventHandler;
[QGVAR(checkBreathingLocal), LINKFUNC(checkBreathingLocal)] call CBA_fnc_addEventHandler;

[QGVAR(applyChestSealLocal), LINKFUNC(applyChestSealLocal)] call CBA_fnc_addEventHandler;
[QGVAR(performNCDLocal), LINKFUNC(performNCDLocal)] call CBA_fnc_addEventHandler;

[QGVAR(Thoracostomy_startLocal), LINKFUNC(Thoracostomy_startLocal)] call CBA_fnc_addEventHandler;
[QGVAR(Thoracostomy_closeLocal), LINKFUNC(Thoracostomy_closeLocal)] call CBA_fnc_addEventHandler;
[QGVAR(Thoracostomy_insertChestTubeLocal), LINKFUNC(Thoracostomy_insertChestTubeLocal)] call CBA_fnc_addEventHandler;
[QGVAR(Thoracostomy_drainLocal), LINKFUNC(Thoracostomy_drainLocal)] call CBA_fnc_addEventHandler;

[QGVAR(setPulseOximeterLocal), LINKFUNC(setPulseOximeterLocal)] call CBA_fnc_addEventHandler;

["isNotPerformingCPR", {!(alive ((_this select 0) getVariable [QACEGVAR(medical,CPR_provider), objNull]))}] call ACEFUNC(common,addCanInteractWithCondition);