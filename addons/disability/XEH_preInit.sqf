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

ADDON = true;
