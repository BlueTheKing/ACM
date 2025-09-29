#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(SETTING_Enable), LLSTRING(SETTING_Enable_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(clearCasualtyLoadout),
    "CHECKBOX",
    [LLSTRING(SETTING_ClearCasualtyLoadout), LLSTRING(SETTING_ClearCasualtyLoadout_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [false],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireAntibiotics),
    "CHECKBOX",
    [LLSTRING(SETTING_RequireAntibiotics), LLSTRING(SETTING_RequireAntibiotics_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(ticketCountRespawn),
    "SLIDER",
    [LLSTRING(SETTING_TicketCountRespawn), LLSTRING(SETTING_TicketCountRespawn_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Tickets)],
    [1, 1000, 20, 0],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(ticketCountCasualty),
    "SLIDER",
    [LLSTRING(SETTING_TicketCountCasualty), LLSTRING(SETTING_TicketCountCasualty_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Tickets)],
    [1, 20, 5, 0],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(convertedCasualtyDeathPenalty),
    "SLIDER",
    [LLSTRING(SETTING_ConvertedCasualtyDeathPenalty), LLSTRING(SETTING_ConvertedCasualtyDeathPenalty_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Tickets)],
    [1, 100, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowConvert),
    "LIST",
    [LLSTRING(SETTING_Allow_Convert), LLSTRING(SETTING_Allow_Convert_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_CasualtyConversion)],
    [SETTING_DROPDOWN_SKILL, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(locationConvert),
    "LIST",
    [LLSTRING(SETTING_Location_Convert), LLSTRING(SETTING_Location_Convert_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_CasualtyConversion)],
    [SETTING_DROPDOWN_LOCATION, 0],
    true
] call CBA_fnc_addSetting;

GVAR(ReinforcePoint_BLUFOR) = objNull;
GVAR(ReinforcePoint_REDFOR) = objNull;
GVAR(ReinforcePoint_GREENFOR) = objNull;

ADDON = true;
