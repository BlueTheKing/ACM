#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY "ACM: Core"

//ACEGVAR(medical,STATE_MACHINE) = (configFile >> "ACM_StateMachine") call CBA_statemachine_fnc_createFromConfig; // TODO statemachine fuckery

[
    QGVAR(grazingInjuryChance),
    "SLIDER",
    ["Chance to ignore fatal injury", "Chance to ignore fatal injury and try to inflict reversible cardiac arrest instead of regular cardiac arrest, if vitals are too stable knock out unit for a random time (15-35s)"],
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 100, 0, 1],
    true
] call CBA_fnc_addSetting;

// Items

[
    QGVAR(treatmentTimeTakeOffTourniquet),
    "SLIDER",
    "Take Off Tourniquet Time",
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(treatmentTimeWrap),
    "SLIDER",
    ["Wrap Time", "Time to wrap whole body part"],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(treatmentTimeWrappedStitch),
    "SLIDER",
    ["Wrapped Stitch Time", "Time to stitch a wrapped wound"],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 2, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSAMSplint),
    "SLIDER",
    ["SAM Splint Time", "Time to apply SAM Splint"],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeWrapSplint),
    "SLIDER",
    ["Wrap Splint Time", "Time to wrap SAM Splint"],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(splintFallOffTime),
    "SLIDER",
    ["Splint minimum fall off time", "Minimum time for unwrapped SAM Splint to fall off"],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 300, 60, 1],
    true
] call CBA_fnc_addSetting;

ADDON = true;