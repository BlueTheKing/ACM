#include "script_component.hpp"

[QGVAR(wrapBruisesLocal), LINKFUNC(wrapBruisesLocal)] call CBA_fnc_addEventHandler;
[QGVAR(wrapBodyPartLocal), LINKFUNC(wrapBodyPartLocal)] call CBA_fnc_addEventHandler;

[QGVAR(handleCoagulationPFH), LINKFUNC(handleCoagulationPFH)] call CBA_fnc_addEventHandler;
[QGVAR(handleIBCoagulationPFH), LINKFUNC(handleIBCoagulationPFH)] call CBA_fnc_addEventHandler;