#include "script_component.hpp"

[QGVAR(initHazardZone), LINKFUNC(initHazardZone)] call CBA_fnc_addEventHandler;
[QGVAR(initHazardUnit), LINKFUNC(initHazardUnit)] call CBA_fnc_addEventHandler;

if (true) then { // TODO setting
    GVAR(HazardType_List) = createHashMap;

    private _hazardCategoryArray = "true" configClasses (configFile >> "ACM_CBRN_Hazards");

    {
        private _hazardTypeArray = [];
        
        {
            _hazardTypeArray pushBack (configName _x);
        } forEach ("true" configClasses _x);

        GVAR(HazardType_List) set [configName _x, _hazardTypeArray];
    } forEach _hazardCategoryArray;
};

GVAR(PPE_List) = createHashMapFromArray [
    ["respirator", ["G_RegulatorMask_F","G_AirPurifyingRespirator_01_F","G_AirPurifyingRespirator_02_black_F","G_AirPurifyingRespirator_02_olive_F","G_AirPurifyingRespirator_02_sand_F"]],
    ["suit", ["U_C_CBRN_Suit_01_Blue_F","U_B_CBRN_Suit_01_MTP_F","U_B_CBRN_Suit_01_Tropic_F","U_C_CBRN_Suit_01_White_F","U_B_CBRN_Suit_01_Wdl_F","U_I_CBRN_Suit_01_AAF_F","U_I_E_CBRN_Suit_01_EAF_F"]],
    ["goggles", ["G_Combat", "G_Combat_Goggles_tna_F","G_Lowprofile","G_Balaclava_combat"]],
    ["mask_goggles", ["G_Balaclava_TI_G_blk_F","G_Balaclava_TI_G_tna_F"]],
    ["mask", ["G_Respirator_blue_F","G_Respirator_white_F","G_Respirator_yellow_F"]],
    ["mask_makeshift", ["G_Balaclava_TI_blk_F","G_Balaclava_TI_tna_F","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_BlueFlame1","G_Bandanna_BlueFlame2","G_Bandanna_CandySkull","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_OrangeFlame1","G_Bandanna_RedFlame1","G_Bandanna_shades","G_Bandanna_Skull1","G_Bandanna_Skull2","G_Bandanna_sport","G_Bandanna_Syndikat1","G_Bandanna_Syndikat2","G_Bandanna_tan","G_Bandanna_Vampire_01"]]
]; // TODO setting