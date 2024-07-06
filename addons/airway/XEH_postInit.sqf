#include "script_component.hpp"

[QGVAR(handleAirwayCollapse), LINKFUNC(handleAirwayCollapse)] call CBA_fnc_addEventHandler;
[QGVAR(handleAirwayObstruction_Vomit), LINKFUNC(handleAirwayObstruction_Vomit)] call CBA_fnc_addEventHandler;
[QGVAR(handleAirwayObstruction_Blood), LINKFUNC(handleAirwayObstruction_Blood)] call CBA_fnc_addEventHandler;

[QGVAR(handleRecoveryPosition), LINKFUNC(handleRecoveryPosition)] call CBA_fnc_addEventHandler;

[QGVAR(handleSuctionLocal), LINKFUNC(handleSuctionLocal)] call CBA_fnc_addEventHandler;

["ace_unconscious", LINKFUNC(onUnconscious)] call CBA_fnc_addEventHandler;