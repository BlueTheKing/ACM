#include "script_component.hpp"

[QGVAR(initHazardZone), LINKFUNC(initHazardZone)] call CBA_fnc_addEventHandler;
[QGVAR(initHazardUnit), LINKFUNC(initHazardUnit)] call CBA_fnc_addEventHandler;
[QGVAR(showRadius), LINKFUNC(showRadius)] call CBA_fnc_addEventHandler;

if (true) then { // TODO setting
    GVAR(HazardType_List) = createHashMap;

    private _hazardCategoryArray = "true" configClasses (configFile >> "ACM_CBRN_Hazards");

    {
        private _hazardTypeArray = [];
        
        {
            _hazardTypeArray pushBack (configName _x);
        } forEach ("true" configClasses _x);

        GVAR(HazardType_List) insert [[configName _x, _hazardTypeArray]];
    } forEach _hazardCategoryArray;

    GVAR(HazardType_ThresholdList) = createHashMap;

    {
        private _category = _x;
        
        {
            private _hazardClass = configFile >> "ACM_CBRN_Hazards" >> _category >> _x;

            private _thresholdList = [0]; 
            private _thresholdPositiveRateList = [1]; 
            private _thresholdNegativeRateList = [1]; 
            
            if ((isArray (_hazardClass >> "thresholds")) && (isArray (_hazardClass >> "threshold_positiveRate"))) then {
                _thresholdList = getArray (_hazardClass >> "thresholds");
                _thresholdPositiveRateList = getArray (_hazardClass >> "threshold_positiveRate");
                _thresholdNegativeRateList = getArray (_hazardClass >> "threshold_negativeRate");
                _thresholdList pushBack 100;
            };

            if (isArray (_hazardClass >> "threshold_positiveRate")) then {
                _thresholdNegativeRateList = getArray (_hazardClass >> "threshold_negativeRate");
            };

            GVAR(HazardType_ThresholdList) insert [[toLower (format ["%1_%2", _category, _x]), [_thresholdList, _thresholdPositiveRateList, _thresholdNegativeRateList]]];
            
        } forEach _y;
    } forEach GVAR(HazardType_List);
};

GVAR(PPE_List) = createHashMapFromArray [
    ["respirator", ["G_RegulatorMask_F","G_AirPurifyingRespirator_01_F","G_AirPurifyingRespirator_02_black_F","G_AirPurifyingRespirator_02_olive_F","G_AirPurifyingRespirator_02_sand_F"]],
    ["suit", ["U_C_CBRN_Suit_01_Blue_F","U_B_CBRN_Suit_01_MTP_F","U_B_CBRN_Suit_01_Tropic_F","U_C_CBRN_Suit_01_White_F","U_B_CBRN_Suit_01_Wdl_F","U_I_CBRN_Suit_01_AAF_F","U_I_E_CBRN_Suit_01_EAF_F"]],
    ["goggles", ["G_Combat", "G_Combat_Goggles_tna_F","G_Lowprofile","G_Balaclava_combat"]],
    ["mask_goggles", ["G_Balaclava_TI_G_blk_F","G_Balaclava_TI_G_tna_F"]],
    ["mask", ["G_Respirator_blue_F","G_Respirator_white_F","G_Respirator_yellow_F"]],
    ["mask_makeshift", ["G_Balaclava_TI_blk_F","G_Balaclava_TI_tna_F","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_BlueFlame1","G_Bandanna_BlueFlame2","G_Bandanna_CandySkull","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_OrangeFlame1","G_Bandanna_RedFlame1","G_Bandanna_shades","G_Bandanna_Skull1","G_Bandanna_Skull2","G_Bandanna_sport","G_Bandanna_Syndikat1","G_Bandanna_Syndikat2","G_Bandanna_tan","G_Bandanna_Vampire_01"]]
]; // TODO setting

["CBA_settingsInitialized", {
    private _action = [QGVAR(Action_WashEyes),
    LLSTRING(WashEyes),
    "",
    {
        params ["_object", "_unit"];

        [3, [_object, _unit], {
            params ["_args"];
            _args params ["_object", "_unit"];

            private _waterSource = _object getVariable [QACEGVAR(field_rations,waterSource), objNull];
            private _waterRemaining = _waterSource call ACEFUNC(field_rations,getRemainingWater);

            [_waterSource, (_waterRemaining - 1) max 0] call ACEFUNC(field_rations,setRemainingWater);

            [_unit, _unit] call FUNC(washEyes);
        }, {
            params ["_args"];
            _args params ["_object", "_unit"];

            
        }, LLSTRING(WashEyes_Progress), {true}, ["isNotInside", "isNotSwimming", "isNotInZeus"]] call ACEFUNC(common,progressBar);
    },
    {
        params ["_object", "_unit"];

        if !([_unit] call FUNC(canWashEyes)) exitWith {false};

        private _waterSource = _object getVariable [QACEGVAR(field_rations,waterSource), objNull];
        private _waterRemaining = _waterSource call ACEFUNC(field_rations,getRemainingWater);
        _waterRemaining == -10 || _waterRemaining > 0;
    }] call ACEFUNC(interact_menu,createAction);

    [QACEGVAR(field_rations,helper), 0, [QACEGVAR(field_rations,waterSource)], _action] call ACEFUNC(interact_menu,addActionToClass);
}] call CBA_fnc_addEventHandler;

["ace_firedPlayer", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

    if !(local _unit) exitWith {};

    if !(_ammo in ["ACM_Grenade_CS_A", "ACM_Grenade_Shell_CS_A"]) exitWith {};
    
    private _fuseTime = 0;
    private _releaseTime = -1;
    
    if (_ammo in ["ACM_Grenade_CS_A", "ACM_Grenade_Shell_CS_A"]) then {
        _fuseTime = 2;
        _releaseTime = 50;
    };
    systemchat str _projectile;
    
    [{
        params ["_unit", "_projectile", "_releaseTime"];

        [QGVAR(initHazardZone), [_projectile, true, "Chemical_CS", [], _releaseTime, false, true, _unit]] call CBA_fnc_serverEvent;
    }, [_unit, _projectile, _releaseTime], _fuseTime] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;