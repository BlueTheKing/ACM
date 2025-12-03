#include "script_component.hpp"

[QGVAR(initHazardZone), LINKFUNC(initHazardZone)] call CBA_fnc_addEventHandler;
[QGVAR(initHazardUnit), LINKFUNC(initHazardUnit)] call CBA_fnc_addEventHandler;
[QGVAR(spawnChemicalMist), LINKFUNC(spawnChemicalMist)] call CBA_fnc_addEventHandler;
[QGVAR(spawnChemicalDetonationEffect), LINKFUNC(spawnChemicalDetonationEffect)] call CBA_fnc_addEventHandler;
[QGVAR(showRadius), LINKFUNC(showRadius)] call CBA_fnc_addEventHandler;

[QGVAR(showBlindEffect), LINKFUNC(showBlindEffect)] call CBA_fnc_addEventHandler;

[QGVAR(updateHazardZoneSize), {
    params ["_hazardRadius", "_radiusDimensions"];

    _hazardRadius setTriggerArea _radiusDimensions;
}] call CBA_fnc_addEventHandler;

[QGVAR(detectorPFH), LINKFUNC(detectorPFH)] call CBA_fnc_addEventHandler;

GVAR(HazardType_List) = createHashMap;
GVAR(HazardType_Array) = [];

["CBA_settingsInitialized", {
    if !(GVAR(enable)) exitWith {};

    private _hazardCategoryArray = "true" configClasses (configFile >> "ACM_CBRN_Hazards");

    {
        private _hazardTypeArray = [];
        private _hazardCategory = configName _x;

        {
            private _entry = configName _x;
            _hazardTypeArray pushBack _entry;
            GVAR(HazardType_Array) pushBack (format ["%1_%2", _hazardCategory, _entry]);
        } forEach ("true" configClasses _x);

        GVAR(HazardType_List) insert [[_hazardCategory, _hazardTypeArray]];
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

    ["multiplier", {
        private _sarinBuildup = ACE_player getVariable [QGVAR_BUILDUP(Chemical_Sarin), 0];
        if (([_patient, "Midazolam"] call EFUNC(circulation,getMedicationConcentration)) > 8) exitWith {1};
        [1, (5 min (1 + (_sarinBuildup / 10)))] select (_sarinBuildup > 1);
    }, QUOTE(ADDON)] call ACEFUNC(common,addSwayFactor);

    GVAR(PPE_List) = createHashMapFromArray [
        ["gasmask", ["G_RegulatorMask_F","G_AirPurifyingRespirator_01_F","G_AirPurifyingRespirator_02_black_F","G_AirPurifyingRespirator_02_olive_F","G_AirPurifyingRespirator_02_sand_F"]],
        ["suit", ["U_C_CBRN_Suit_01_Blue_F","U_B_CBRN_Suit_01_MTP_F","U_B_CBRN_Suit_01_Tropic_F","U_C_CBRN_Suit_01_White_F","U_B_CBRN_Suit_01_Wdl_F","U_I_CBRN_Suit_01_AAF_F","U_I_E_CBRN_Suit_01_EAF_F"]],
        ["goggles", ["G_Combat", "G_Combat_Goggles_tna_F","G_Lowprofile","G_Balaclava_combat"]],
        ["mask_goggles", ["G_Balaclava_TI_G_blk_F","G_Balaclava_TI_G_tna_F"]],
        ["mask", ["G_Respirator_blue_F","G_Respirator_white_F","G_Respirator_yellow_F"]],
        ["mask_makeshift", ["G_Balaclava_TI_blk_F","G_Balaclava_TI_tna_F","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_BlueFlame1","G_Bandanna_BlueFlame2","G_Bandanna_CandySkull","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_OrangeFlame1","G_Bandanna_RedFlame1","G_Bandanna_shades","G_Bandanna_Skull1","G_Bandanna_Skull2","G_Bandanna_sport","G_Bandanna_Syndikat1","G_Bandanna_Syndikat2","G_Bandanna_tan","G_Bandanna_Vampire_01"]]
    ];

    GVAR(Vehicle_List) = createHashMapFromArray [
        ["cbrn", ["B_APC_Tracked_01_rcws_F"]],
        ["sealed", ["B_MRAP_01_F"]]
    ];

    {
        _x params ["_hashMap", "_key", "_settingsList"];

        private _list = _hashMap get _key;
        private _customList = _settingsList splitString ",";
        _list insert [-1, _customList, true];

        _hashMap set [_key, _list];
    } forEach [
        [GVAR(PPE_List), "gasmask", GVAR(customPPEList_gasmask)],
        [GVAR(PPE_List), "suit", GVAR(customPPEList_suit)],
        [GVAR(Vehicle_List), "cbrn", GVAR(customVehicleList_CBRN)],
        [GVAR(Vehicle_List), "sealed", GVAR(customVehicleList_sealed)]
    ];

    ["featureCamera", {
        params ["_unit", "_newCamera"];

        if (_newCamera == "") then { // switched back to player view
            if IS_BLINDED(_unit) then {
                [_unit, true, true] call FUNC(showBlindEffect);
            };
        } else { // camera view
            [_unit, false, true] call FUNC(showBlindEffect);
        };
    }] call CBA_fnc_addPlayerEventHandler;

    {
        [QACEGVAR(field_rations,helper), 0, [QACEGVAR(field_rations,waterSource)], _x] call ACEFUNC(interact_menu,addActionToClass);
    } forEach (call FUNC(addWaterSourceActions));

    ["ace_firedPlayer", LINKFUNC(handleFiredGrenade)] call CBA_fnc_addEventHandler;
    ["ace_firedNonPlayer", LINKFUNC(handleFiredGrenade)] call CBA_fnc_addEventHandler;
    ["ace_firedPlayerVehicle", LINKFUNC(handleFiredArtillery)] call CBA_fnc_addEventHandler;
    ["ace_firedNonPlayerVehicle", LINKFUNC(handleFiredArtillery)] call CBA_fnc_addEventHandler;
    
    ["CAManBase", "GetInMan", LINKFUNC(handleVehicleDoorOpen)] call CBA_fnc_addClassEventHandler;
    ["CAManBase", "GetOutMan", LINKFUNC(handleVehicleDoorOpen)] call CBA_fnc_addClassEventHandler;
}] call CBA_fnc_addEventHandler;