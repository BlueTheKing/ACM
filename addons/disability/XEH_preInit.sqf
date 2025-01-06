#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

[
    QGVAR(tourniquetImpactLimbs),
    "CHECKBOX",
    [LLSTRING(SETTING_TourniquetImpactLimbs), LLSTRING(SETTING_TourniquetImpactLimbs_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowInspectForFracture),
    "LIST",
    ["Allow Inspecting For Fracture", "Training level required to inspect for fractures"],
    [ACM_SETTINGS_CATEGORY, "Fracture Management"],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowClosedReduction),
    "LIST",
    ["Allow Peforming Closed Reduction", "Training level required to perform closed reduction"],
    [ACM_SETTINGS_CATEGORY, "Fracture Management"],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

ADDON = true;
