#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY "ACM: Core"

//ACEGVAR(medical,STATE_MACHINE) = (configFile >> "ACM_StateMachine") call CBA_statemachine_fnc_createFromConfig;

// Items

[
    QGVAR(treatmentTimeTakeOffTourniquet),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_TakeOffTourniquet), LLSTRING(SETTING_TreatmentTime_TakeOffTourniquet_Desc)],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(treatmentTimeWrap),
    "SLIDER",
    [LELSTRING(damage,SETTING_TreatmentTime_WrapBodyPart), LELSTRING(damage,SETTING_TreatmentTime_WrapBodyPart_Desc)],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(treatmentTimeWrappedStitch),
    "SLIDER",
    [LELSTRING(damage,SETTING_TreatmentTime_WrappedStitch), LELSTRING(damage,SETTING_TreatmentTime_WrappedStitch_Desc)],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 2, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSAMSplint),
    "SLIDER",
    [LELSTRING(disability,SETTING_TreatmentTime_SAMSplint), LELSTRING(disability,SETTING_TreatmentTime_SAMSplint_Desc)],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeWrapSplint),
    "SLIDER",
    [LELSTRING(disability,SETTING_TreatmentTime_WrapSplint), LELSTRING(disability,SETTING_TreatmentTime_WrapSplint_Desc)],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(splintFallOffTime),
    "SLIDER",
    [LELSTRING(disability,SETTING_SplintFallOffTime), LELSTRING(disability,SETTING_SplintFallOffTime_Desc)],
    [ACM_SETTINGS_CATEGORY, "Items"],
    [1, 300, 60, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Dogtag_ShowWeight),
    "CHECKBOX",
    [LLSTRING(SETTING_Dogtag_ShowWeight), LLSTRING(SETTING_Dogtag_ShowWeight_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true,
    {},
    true
] call CBA_fnc_addSetting;

ADDON = true;