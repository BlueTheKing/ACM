#include "script_component.hpp"

if !(hasInterface) exitWith {};

[QACEGVAR(medical_gui,updateBodyImage), LINKFUNC(updateBodyImage)] call CBA_fnc_addEventHandler;

GVAR(lastSelectedCategory) = "";
GVAR(lastSelectedBodyPart) = -1;
GVAR(lastTarget) = objNull;