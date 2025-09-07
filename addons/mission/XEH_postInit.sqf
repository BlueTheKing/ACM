#include "script_component.hpp"

[QGVAR(initFullHealFacility), {
    params ["_object"];

    [_object] call FUNC(initFullHealFacility);
}] call CBA_fnc_addEventHandler;

["CBA_settingsInitialized", {
    GVAR(TrainingCasualtyGroup) = createGroup [civilian, false];
}] call CBA_fnc_addEventHandler;