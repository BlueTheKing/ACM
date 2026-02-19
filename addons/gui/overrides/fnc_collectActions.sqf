#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Collect treatment actions for medical menu from config.
 * Adds dragging actions if it exists.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ace_medical_gui_fnc_collectActions
 *
 * Public: No
 */

ACEGVAR(medical_gui,actions) = [];

{
    private _configName = configName _x;
    private _displayName = getText (_x >> "displayName");
    private _category = getText (_x >> "category");
    private _condition = compile format [QUOTE([ARR_4(ACE_player,ACEGVAR(medical_gui,target),%1 select ACEGVAR(medical_gui,selectedBodyPart),'%2')] call DACEFUNC(ACE_ADDON(medical_treatment),canTreatCached)), ALL_BODY_PARTS, _configName];
    private _statement = compile format [QUOTE([ARR_4(ACE_player,ACEGVAR(medical_gui,target),%1 select ACEGVAR(medical_gui,selectedBodyPart),'%2')] call DACEFUNC(ACE_ADDON(medical_treatment),treatment)), ALL_BODY_PARTS, _configName];
    private _items = getArray (_x >> "items");
    private _menuIcon = (["",getText (_x >> "ACM_menuIcon")] select GVAR(showActionItemIcons));

    ACEGVAR(medical_gui,actions) pushBack [_displayName, _category, _condition, _statement, _items, _menuIcon];
} forEach configProperties [configFile >> QACEGVAR(medical_treatment,actions), "isClass _x"];


if ("ace_dragging" call ACEFUNC(common,isModLoaded)) then {
    ACEGVAR(medical_gui,actions) pushBack [
        ACELLSTRING(dragging,Drag), "drag",
        {
            ACE_player != ACEGVAR(medical_gui,target) && {[ACE_player, ACEGVAR(medical_gui,target)] call ACEFUNC(dragging,canDrag)}
        },
        {
            ACEGVAR(medical_gui,pendingReopen) = false;
            [ACE_player, ACEGVAR(medical_gui,target)] call ACEFUNC(dragging,startDrag);
        }
    ];

    ACEGVAR(medical_gui,actions) pushBack [
        ACELLSTRING(dragging,Carry), "drag",
        {
            ACE_player != ACEGVAR(medical_gui,target) && {[ACE_player, ACEGVAR(medical_gui,target)] call ACEFUNC(dragging,canCarry)}
        },
        {
            ACEGVAR(medical_gui,pendingReopen) = false;
            [ACE_player, ACEGVAR(medical_gui,target)] call ACEFUNC(dragging,startCarry);
        }
    ];

    ACEGVAR(medical_gui,actions) pushBack [
        LLSTRING(AssistCarry), "drag",
        {
            ACE_player != ACEGVAR(medical_gui,target) && {[ACE_player, ACEGVAR(medical_gui,target)] call ACEFUNC(dragging,canCarry) && {!(ACEGVAR(medical_gui,target) getVariable [QEGVAR(core,CarryAssist_State), false])}}
        },
        {
            ACEGVAR(medical_gui,pendingReopen) = false;
            [ACE_player, ACEGVAR(medical_gui,target)] call EFUNC(core,beginCarryAssist);
        }
    ];

    ACEGVAR(medical_gui,actions) pushBack [
        LELSTRING(evacuation,ConvertCasualty), "drag",
        {
            ACE_player != ACEGVAR(medical_gui,target) && {[ACE_player, ACEGVAR(medical_gui,target)] call EFUNC(evacuation,canConvert)}
        },
        {
            [ACE_player, ACEGVAR(medical_gui,target)] call EFUNC(evacuation,convertCasualtyAction);
        }
    ];

    ACEGVAR(medical_gui,actions) pushBack [
        LELSTRING(core,SupinePosition_Action), "drag",
        {
            [ACEGVAR(medical_gui,target)] call ACEFUNC(common,isAwake) && ACE_player != ACEGVAR(medical_gui,target) && {!(ACEGVAR(medical_gui,target) getVariable [QEGVAR(core,Lying_State), false]) && stance ACEGVAR(medical_gui,target) == "PRONE" && currentWeapon ACEGVAR(medical_gui,target) == ""}
        },
        {
            if (ACEGVAR(medical_gui,target) getVariable [QEGVAR(core,Lying_State), false]) exitWith {};
            [ACEGVAR(medical_gui,target), "AinjPpneMstpSnonWrflDnon_rolltoback", 2] call ACEFUNC(common,doAnimation);

            [{
                ACEGVAR(medical_gui,target) setVariable [QEGVAR(core,Lying_State), true, true];
                [QACEGVAR(common,switchMove), [ACEGVAR(medical_gui,target), "ACM_LyingState"]] call CBA_fnc_globalEvent;
                [QEGVAR(core,getUpPrompt), [ACEGVAR(medical_gui,target)], ACEGVAR(medical_gui,target)] call CBA_fnc_targetEvent;
                [QACEGVAR(common,displayTextStructured), [LELSTRING(core,SupinePosition_Hint), 2, ACEGVAR(medical_gui,target)], ACEGVAR(medical_gui,target)] call CBA_fnc_targetEvent;
                [LELSTRING(core,SupinePosition_Complete), 2, ACE_player] call ACEFUNC(common,displayTextStructured);
            }, [], 1.85] call CBA_fnc_waitAndExecute;
        }
    ];
};

// testing code for multi-line
// for "_i" from 0 to 12 do {
//     GVAR(actions) pushBack [format ["Example %1", _i], "medication", {true}, compile format ['systemChat "%1"', _i]]
// };
