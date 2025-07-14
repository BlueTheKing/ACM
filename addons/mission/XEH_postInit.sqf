#include "script_component.hpp"

["CBA_settingsInitialized", {
    GVAR(TrainingCasualtyGroup) = createGroup [civilian, false];
}] call CBA_fnc_addEventHandler;