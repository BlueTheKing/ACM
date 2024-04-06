#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define AMS_SETTINGS_CATEGORY "AMS: Circulation"

// Basic

[
    QGVAR(cardiacArrestBleedRate),
    "SLIDER",
    "Cardiac Arrest Bleed Rate",
    [AMS_SETTINGS_CATEGORY, ""],
    [0.01, 1, 0.05, 2],
    true
] call CBA_fnc_addSetting;

// Coagulation

[
    QGVAR(coagulationClotting),
    "CHECKBOX",
    "Enable Clotting",
    [AMS_SETTINGS_CATEGORY, "Coagulation"],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(coagulationClottingAffectAI),
    "CHECKBOX",
    "Clotting for AI",
    [AMS_SETTINGS_CATEGORY, "Coagulation"],
    [true],
    true
] call CBA_fnc_addSetting;

// Cardiac Rhythms

[
    QGVAR(cardiacArrestDeteriorationRate),
    "SLIDER",
    ["Rhythm Deterioration Multiplier", "Chance that rhythm will deteriorate while in cardiac arrest"],
    [AMS_SETTINGS_CATEGORY, "Cardiac Rhythms"],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

// Defibrillator

[
    QGVAR(allowAED),
    "LIST",
    ["Allow AED", "Training level required to use AED"],
    [AMS_SETTINGS_CATEGORY, "Defibrillator"],
    [SETTING_SLIDER_SKILL, 0],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(treatmentTimePads),
    "SLIDER",
    ["Apply Pads Time", "Time to apply AED pads"],
    [AMS_SETTINGS_CATEGORY, "Defibrillator"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimePulseOximeter),
    "SLIDER",
    ["Connect Pulse Oximeter Time", "Time to connect AED Pulse Oximeter"],
    [AMS_SETTINGS_CATEGORY, "Defibrillator"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(AEDDistanceLimit),
    "SLIDER",
    ["AED Distance Limit", "Distance over which the AED will disconnect itself from the patient"],
    [AMS_SETTINGS_CATEGORY, "Defibrillator"],
    [3, 8, 5, 1],
    true
] call CBA_fnc_addSetting;

// CPR

[
    QGVAR(CPREffectiveness),
    "SLIDER",
    ["CPR Effectiveness Multiplier", "Set overall CPR effectiveness"],
    [AMS_SETTINGS_CATEGORY, "CPR"],
    [0.1, 4, 1, 1],
    true
] call CBA_fnc_addSetting;

// IV/IO

[
    QGVAR(allowIV),
    "LIST",
    ["Allow IV", "Training level required to use IVs"],
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowIO),
    "LIST",
    ["AllowIO", "Training level required to use IOs"],
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIV_16),
    "SLIDER",
    "16g IV Time",
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIV_14),
    "SLIDER",
    "14g IV Time",
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [1, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIO_FAST1),
    "SLIDER",
    "IO Time",
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(selfIV),
    "LIST",
    ["Allow Self IV", "Allow self-application of IV"],
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [[0, 1], [ACELSTRING(common,No), ACELSTRING(common,Yes)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(selfIO),
    "LIST",
    ["Allow Self IO", "Allow self-application of IO"],
    [AMS_SETTINGS_CATEGORY, "IV/IO"],
    [[0, 1], [ACELSTRING(common,No), ACELSTRING(common,Yes)], 0],
    true
] call CBA_fnc_addSetting;

// Blood Types

{
    _x params ["_type", "_string", "_default"];

    [
        format ["AMS_Circulation_BloodTypeRatio_%1", _type],
        "SLIDER",
        [format ["%1 Ratio", _string], format ["Ratio out of 100 that is taken by the %1 blood type", _string]],
        [AMS_SETTINGS_CATEGORY, "Blood Types"],
        [1, 100, _default, 0],
        true,
        {},
        true
    ] call CBA_fnc_addSetting;
} forEach [["O", "O+", 41],["A", "A+", 30],["B", "B+", 20],["ON", "O-", 7],["AB", "AB+", 5],["AN", "A-", 4],["BN", "B-", 2],["ABN", "AB-", 1]];

if (isServer) then {
    call FUNC(generateBloodTypeList);
};

ADDON = true;
