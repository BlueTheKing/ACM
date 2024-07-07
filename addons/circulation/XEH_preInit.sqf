#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY "ACM: Circulation"

// Basic

[
    QGVAR(cardiacArrestBleedRate),
    "SLIDER",
    "Cardiac Arrest Bleed Rate",
    [ACM_SETTINGS_CATEGORY, ""],
    [0.01, 1, 0.05, 2],
    true
] call CBA_fnc_addSetting;

// Coagulation

[
    QGVAR(coagulationClotting),
    "CHECKBOX",
    "Enable Clotting",
    [ACM_SETTINGS_CATEGORY, "Coagulation"],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(coagulationClottingAffectAI),
    "CHECKBOX",
    "Clotting for AI",
    [ACM_SETTINGS_CATEGORY, "Coagulation"],
    [true],
    true
] call CBA_fnc_addSetting;

// Cardiac Arrest

[
    QGVAR(cardiacArrestChance),
    "SLIDER",
    ["Critical Damage Cardiac Arrest Chance", "Sets chance for unit to go into cardiac arrest after taking critical damage"],
    [ACM_SETTINGS_CATEGORY, "Cardiac Arrest"],
    [0, 1, 0.1, 1, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(cardiacArrestDeteriorationRate),
    "SLIDER",
    ["Rhythm Deterioration Multiplier", "Chance that rhythm will deteriorate while in cardiac arrest"],
    [ACM_SETTINGS_CATEGORY, "Cardiac Arrest"],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_PostCardiacArrest),
    "CHECKBOX",
    ["[HARDCORE] Post Cardiac Arrest Complications", "[HARDCORE] Sets whether there should be a decrease in cardiac output after ROSC requiring further treatment to fully treat"],
    [ACM_SETTINGS_CATEGORY, "Cardiac Arrest"],
    [false],
    true
] call CBA_fnc_addSetting;

// Defibrillator

[
    QGVAR(allowAED),
    "LIST",
    ["Allow AED", "Training level required to use AED"],
    [ACM_SETTINGS_CATEGORY, "Defibrillator"],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(treatmentTimePads),
    "SLIDER",
    ["Apply Pads Time", "Time to apply AED pads"],
    [ACM_SETTINGS_CATEGORY, "Defibrillator"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimePulseOximeter),
    "SLIDER",
    ["Connect Pulse Oximeter Time", "Time to connect AED Pulse Oximeter"],
    [ACM_SETTINGS_CATEGORY, "Defibrillator"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(AEDDistanceLimit),
    "SLIDER",
    ["AED Distance Limit", "Distance over which the AED will disconnect itself from the patient"],
    [ACM_SETTINGS_CATEGORY, "Defibrillator"],
    [3, 8, 5, 1],
    true
] call CBA_fnc_addSetting;

// CPR

[
    QGVAR(CPREffectiveness),
    "SLIDER",
    ["CPR Effectiveness Multiplier", "Set overall CPR effectiveness"],
    [ACM_SETTINGS_CATEGORY, "CPR"],
    [0.1, 4, 1, 1],
    true
] call CBA_fnc_addSetting;

// IV/IO

[
    QGVAR(allowIV),
    "LIST",
    ["Allow IV", "Training level required to use IVs"],
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowIO),
    "LIST",
    ["Allow IO", "Training level required to use IOs"],
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIV_16),
    "SLIDER",
    "16g IV Time",
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIV_14),
    "SLIDER",
    "14g IV Time",
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [1, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIO_FAST1),
    "SLIDER",
    "IO Time",
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(selfIV),
    "LIST",
    ["Allow Self IV", "Allow self-application of IV"],
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [[0, 1], [ACELSTRING(common,No), ACELSTRING(common,Yes)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(selfIO),
    "LIST",
    ["Allow Self IO", "Allow self-application of IO"],
    [ACM_SETTINGS_CATEGORY, "IV/IO"],
    [[0, 1], [ACELSTRING(common,No), ACELSTRING(common,Yes)], 0],
    true
] call CBA_fnc_addSetting;

// Blood Types

{
    _x params ["_type", "_string", "_default"];

    [
        format ["ACM_circulation_BloodType_Ratio_%1", _type],
        "SLIDER",
        [format ["%1 Ratio", _string], format ["Ratio out of 100 that is taken by the %1 blood type, ratios must add up to exactly 100", _string]],
        [ACM_SETTINGS_CATEGORY, "Blood Types"],
        [1, 100, _default, 0],
        true,
        {},
        true
    ] call CBA_fnc_addSetting;
} forEach [["O", "O+", 39],["ON", "O-", 5],["A", "A+", 28],["AN", "A-", 3],["B", "B+", 18],["BN", "B-", 2],["AB", "AB+", 4],["ABN", "AB-", 1]];

ADDON = true;
