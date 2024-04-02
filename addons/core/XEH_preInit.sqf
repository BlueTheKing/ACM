#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define AMS_SETTINGS_CATEGORY "AMS: Core"

//ACEGVAR(medical,STATE_MACHINE) = (configFile >> "AMS_StateMachine") call CBA_statemachine_fnc_createFromConfig; // TODO statemachine fuckery

[
    QGVAR(treatmentTimeTakeOffTourniquet),
    "SLIDER",
    "Take Off Tourniquet Time",
    [AMS_SETTINGS_CATEGORY, ""],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

// Coagulation

[
    QGVAR(coagulationAffectAI),
    "CHECKBOX",
    "Coagulation for AI",
    [AMS_SETTINGS_CATEGORY, "Coagulation"],
    [true],
    true
] call CBA_fnc_addSetting;

// Items

/*[
    QGVAR(treatmentTimeWrap),
    "SLIDER",
    ["Wrap Time", "Time to wrap whole body part"],
    [AMS_SETTINGS_CATEGORY, "Items"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(treatmentTimeWrappedStitch),
    "SLIDER",
    ["Wrapped Stitch Time", "Time to stitch a wrapped wound"],
    [AMS_SETTINGS_CATEGORY, "Items"],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSAMSplint),
    "SLIDER",
    ["SAM Splint Time", "Time to apply SAM Splint"],
    [AMS_SETTINGS_CATEGORY, "Items"],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeWrapSplint),
    "SLIDER",
    ["Wrap Splint Time", "Time to wrap SAM Splint"],
    [AMS_SETTINGS_CATEGORY, "Items"],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(splintFallOffTime),
    "SLIDER",
    ["Splint minimum fall off time", "Minimum time for unwrapped SAM Splint to fall off"],
    [AMS_SETTINGS_CATEGORY, "Items"],
    [1, 300, 60, 1],
    true
] call CBA_fnc_addSetting;

ADDON = true;