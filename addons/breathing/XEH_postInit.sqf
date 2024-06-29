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

["isNotUsingBVM", {!((_this select 0) getVariable [QGVAR(isUsingBVM), false])}] call ACEFUNC(common,addCanInteractWithCondition);

if (GVAR(pneumothoraxEnabled)) then {
    [QGVAR(Pneumothorax), {
        ([(linearConversion [0, 4, (_this getVariable [QGVAR(Pneumothorax_State), 0]), 1, 2, true]), 2] select ((_this getVariable [QGVAR(TensionPneumothorax_State), false]) || (_this getVariable [QGVAR(Hardcore_Pneumothorax), false]) || ((_this getVariable [QGVAR(Hemothorax_Fluid), 0]) > 1)));
    }] call ACEFUNC(advanced_fatigue,addDutyFactor);
};