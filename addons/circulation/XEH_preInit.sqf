#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

// Basic

[
    QGVAR(cardiacArrestBleedRate),
    "SLIDER",
    [LLSTRING(SETTING_CardiacArrestBleedRate), LLSTRING(SETTING_CardiacArrestBleedRate_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [0.01, 1, 0.05, 2],
    true
] call CBA_fnc_addSetting;

// Coagulation

[
    QGVAR(coagulationClotting),
    "CHECKBOX",
    [LLSTRING(SETTING_CoagulationClotting), LLSTRING(SETTING_CoagulationClotting_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Coagulation)],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(coagulationClottingAffectAI),
    "CHECKBOX",
    [LLSTRING(SETTING_CoagulationClottingAffectAI), LLSTRING(SETTING_CoagulationClottingAffectAI_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Coagulation)],
    [true],
    true
] call CBA_fnc_addSetting;

// Cardiac Arrest

[
    QGVAR(cardiacArrestChance),
    "SLIDER",
    [LLSTRING(SETTING_CardiacArrestChance), LLSTRING(SETTING_CardiacArrestChance_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_CardiacArrest)],
    [0, 1, 0.1, 1, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(cardiacArrestDeteriorationRate),
    "SLIDER",
    [LLSTRING(SETTING_CardiacArrestDeteriorationRate), LLSTRING(SETTING_CardiacArrestDeteriorationRate_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_CardiacArrest)],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_PostCardiacArrest),
    "CHECKBOX",
    [LLSTRING(SETTING_Hardcore_PostCardiacArrest), LLSTRING(SETTING_Hardcore_PostCardiacArrest_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_CardiacArrest)],
    [false],
    true
] call CBA_fnc_addSetting;

// Defibrillator

[
    QGVAR(allowAED),
    "LIST",
    [LLSTRING(SETTING_Allow_AED), LLSTRING(SETTING_Allow_AED_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Defibrillator)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AEDDistanceLimit),
    "SLIDER",
    [LLSTRING(SETTING_AEDDistanceLimit), LLSTRING(SETTING_AEDDistanceLimit_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Defibrillator)],
    [3, 8, 5, 1],
    true
] call CBA_fnc_addSetting;

// CPR

[
    QGVAR(CPREffectiveness),
    "SLIDER",
    [LLSTRING(SETTING_CPREffectiveness), LLSTRING(SETTING_CPREffectiveness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_CPR)],
    [0.1, 4, 1, 1],
    true
] call CBA_fnc_addSetting;

// IV/IO

[
    QGVAR(IVComplications),
    "CHECKBOX",
    [LLSTRING(SETTING_IVComplications), LLSTRING(SETTING_IVComplications_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(IVComplicationsDeteriorate),
    "CHECKBOX",
    [LLSTRING(SETTING_IVComplicationsDeteriorate), LLSTRING(SETTING_IVComplicationsDeteriorate_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowIV),
    "LIST",
    [LLSTRING(SETTING_Allow_IV), LLSTRING(SETTING_Allow_IV_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowIO),
    "LIST",
    [LLSTRING(SETTING_Allow_IO), LLSTRING(SETTING_Allow_IO_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIV_16),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_IV_16), LLSTRING(SETTING_TreatmentTime_IV_16_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIV_14),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_IV_14), LLSTRING(SETTING_TreatmentTime_IV_14_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [1, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIO_EZ),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_IO_EZ), LLSTRING(SETTING_TreatmentTime_IO_EZ_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeIO_FAST1),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_IO_FAST1), LLSTRING(SETTING_TreatmentTime_IO_FAST1_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(selfIV),
    "LIST",
    [LLSTRING(SETTING_SelfIV), LLSTRING(SETTING_SelfIV_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [[0, 1], [ACELSTRING(common,No), ACELSTRING(common,Yes)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(selfIO),
    "LIST",
    [LLSTRING(SETTING_SelfIO), LLSTRING(SETTING_SelfIO_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_IV_IO)],
    [[0, 1], [ACELSTRING(common,No), ACELSTRING(common,Yes)], 0],
    true
] call CBA_fnc_addSetting;

// Medication

[
    QGVAR(reusableSyringe),
    "LIST",
    [LLSTRING(SETTING_ReusableSyringe), LLSTRING(SETTING_ReusableSyringe_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Medication)],
    [[0, 1, 2], [ACELSTRING(common,No), ACELSTRING(common,Yes), LLSTRING(SETTING_ReusableSyringe_Option)], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSyringe),
    "LIST",
    [LLSTRING(SETTING_Allow_Syringe), LLSTRING(SETTING_Allow_Syringe_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Medication)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowAmmoniaInhalant),
    "LIST",
    [LLSTRING(SETTING_Allow_AmmoniaInhalant), LLSTRING(SETTING_Allow_AmmoniaInhalant_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Medication)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowFentanylLozenge),
    "LIST",
    [LLSTRING(SETTING_Allow_FentanylLozenge), LLSTRING(SETTING_Allow_FentanylLozenge_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Medication)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

// Blood Types

{
    _x params ["_type", "_string", "_default"];

    [
        format ["ACM_circulation_BloodType_Ratio_%1", _type],
        "SLIDER",
        [format [LLSTRING(SETTING_BloodType_Ratio_%1), _string], format [LLSTRING(SETTING_BloodType_Ratio_%1_Desc), _string]],
        [ACM_SETTINGS_CATEGORY, LLSTRING(Category_BloodTypes)],
        [1, 100, _default, 0],
        true,
        {},
        true
    ] call CBA_fnc_addSetting;
} forEach [["O", "O+", 39],["ON", "O-", 5],["A", "A+", 28],["AN", "A-", 3],["B", "B+", 18],["BN", "B-", 2],["AB", "AB+", 4],["ABN", "AB-", 1]];

[
    QGVAR(customBloodTypeList_enable),
    "CHECKBOX",
    [LLSTRING(SETTING_CustomBloodTypeList), LLSTRING(SETTING_CustomBloodTypeList_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_BloodTypes)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

ADDON = true;
