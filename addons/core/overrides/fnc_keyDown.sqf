#include "..\script_component.hpp"
/*
 * Author: NouberNou and esteldunedain
 * Handle interactions key down
 *
 * Arguments:
 * 0: Type of key: 0 interaction / 1 self interaction <NUMBER>
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [0] call ACE_interact_menu_fnc_keyDown
 *
 * Public: No
 */

#include "\a3\ui_f\hpp\defineResincl.inc"

params ["_menuType"];

if (ACEGVAR(interact_menu,openedMenuType) == _menuType) exitWith {true};

// Conditions: Don't open when editing a text box
private _focusedTextIndex = allDisplays findIf {(ctrlType (focusedCtrl _x)) == CT_EDIT};
private _isTextEditing = _focusedTextIndex != -1;

// Map's controls remain open and focused despite map not being visible, workaround
if (_isTextEditing) then {
    if (ctrlIDD (allDisplays select _focusedTextIndex) == IDD_MAIN_MAP) then {
        _isTextEditing = visibleMap;
    };
};

// Conditions: canInteract (these don't apply to zeus)
if (
    _isTextEditing ||
    {(isNull curatorCamera) && {
        !([ACE_player, objNull, ["isNotInLyingState", "isNotInside","isNotDragging", "isNotCarrying", "isNotSwimming", "notOnMap", "isNotEscorting", "isNotSurrendering", "isNotSitting", "isNotOnLadder", "isNotRefueling"]] call ACEFUNC(common,canInteractWith))
    }
}) exitWith {false};

while {dialog} do {
    closeDialog 0;
};

if (_menuType == 0) then {
    ACEGVAR(interact_menu,keyDown) = true;
    ACEGVAR(interact_menu,keyDownSelfAction) = false;
} else {
    ACEGVAR(interact_menu,keyDown) = false;
    ACEGVAR(interact_menu,keyDownSelfAction) = true;
};
ACEGVAR(interact_menu,keyDownTime) = diag_tickTime;

// Raise MenuClosed event whenever one type is replaced with another, because KeyUp code is not guaranteed.
if (ACEGVAR(interact_menu,openedMenuType) != -1) then {
    ["ace_interactMenuClosed", [ACEGVAR(interact_menu,openedMenuType)]] call CBA_fnc_localEvent;
};

ACEGVAR(interact_menu,openedMenuType) = _menuType;
ACEGVAR(interact_menu,lastTimeSearchedActions) = -1000;
ACEGVAR(interact_menu,ParsedTextCached) = [];

ACEGVAR(interact_menu,useCursorMenu) = (vehicle ACE_player != ACE_player) ||
                      (!(isNull (ACE_controlledUAV select 0))) ||
                      visibleMap ||
                      (!isNull curatorCamera) ||
                      {(_menuType == 1) && {(isWeaponDeployed ACE_player) || ACEGVAR(interact_menu,alwaysUseCursorSelfInteraction) || {cameraView == "GUNNER"}}} ||
                      {(_menuType == 0) && ACEGVAR(interact_menu,alwaysUseCursorInteraction)};

// Delete existing controls in case there's any left
ACEGVAR(interact_menu,iconCount) = 0;
for "_i" from 0 to (count ACEGVAR(interact_menu,iconCtrls))-1 do {
    ctrlDelete (ACEGVAR(interact_menu,iconCtrls) select _i);
    ACEGVAR(interact_menu,ParsedTextCached) set [_i, ""];
};
ACEGVAR(interact_menu,iconCtrls) resize ACEGVAR(interact_menu,iconCount);

if (ACEGVAR(interact_menu,useCursorMenu)) then {
    // Don't close zeus interface if open
    if (isNull curatorCamera) then {
        (findDisplay 46) createDisplay QACEGVAR(interact_menu,cursorMenu); //"RscCinemaBorder";//
    } else {
        createDialog QACEGVAR(interact_menu,cursorMenu);
    };
    (finddisplay 91919) displayAddEventHandler ["KeyUp", {[_this,'keyup'] call CBA_events_fnc_keyHandler}];
    (finddisplay 91919) displayAddEventHandler ["KeyDown", {
        // Handle the escape key being pressed with menu open:
        if ((_this select [1,4]) isEqualTo [1,false,false,false]) exitWith { // escape key with no modifiers
            [displayNull] call ACEFUNC(interact_menu,handleEscapeMenu);
        };
        [_this,'keydown'] call CBA_events_fnc_keyHandler;
    }];
    // The dialog sets:
    // uiNamespace getVariable QACEGVAR(interact_menu,dlgCursorMenu);
    // uiNamespace getVariable QACEGVAR(interact_menu,cursorMenuOpened);
    ACEGVAR(interact_menu,cursorPos) = [0.5,0.5,0];

    private _ctrl = (findDisplay 91919) ctrlCreate ["RscStructuredText", 9922];
    _ctrl ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
    _ctrl ctrlCommit 0;

    // handles Mouse moving and LMB in cursor mode when action on keyrelease is disabled
    ((finddisplay 91919) displayctrl 9922) ctrlAddEventHandler ["MouseMoving", DACEFUNC(ACE_ADDON(interact_menu),handleMouseMovement)];
    ((finddisplay 91919) displayctrl 9922) ctrlAddEventHandler ["MouseButtonDown", DACEFUNC(ACE_ADDON(interact_menu),handleMouseButtonDown)];
    setMousePosition [0.5, 0.5];
} else {
    if (uiNamespace getVariable [QACEGVAR(interact_menu,cursorMenuOpened),false]) then {
        (findDisplay 91919) closeDisplay 2;
    };
};

ACEGVAR(interact_menu,selfMenuOffset) = (AGLtoASL (positionCameraToWorld [0, 0, 2])) vectorDiff (AGLtoASL (positionCameraToWorld [0, 0, 0]));

//Auto expand the first level when self, mounted vehicle or zeus (skips the first animation as there is only one choice)
if (ACEGVAR(interact_menu,openedMenuType) == 0) then {
    if (isNull curatorCamera) then {
        if (!(isNull (ACE_controlledUAV select 0))) then {
            ACEGVAR(interact_menu,menuDepthPath) = [["ACE_SelfActions", (ACE_controlledUAV select 0)]];
            ACEGVAR(interact_menu,expanded) = true;
            ACEGVAR(interact_menu,expandedTime) = diag_tickTime;
            ACEGVAR(interact_menu,lastPath) = +ACEGVAR(interact_menu,menuDepthPath);
            ACEGVAR(interact_menu,startHoverTime) = -1000;
        } else {
            if (vehicle ACE_player != ACE_player) then {
                ACEGVAR(interact_menu,menuDepthPath) = [["ACE_SelfActions", (vehicle ACE_player)]];
                ACEGVAR(interact_menu,expanded) = true;
                ACEGVAR(interact_menu,expandedTime) = diag_tickTime;
                ACEGVAR(interact_menu,lastPath) = +ACEGVAR(interact_menu,menuDepthPath);
                ACEGVAR(interact_menu,startHoverTime) = -1000;
            };
        };
    } else {
        ACEGVAR(interact_menu,menuDepthPath) = [["ACE_ZeusActions", (getAssignedCuratorLogic player)]];
        ACEGVAR(interact_menu,expanded) = true;
        ACEGVAR(interact_menu,expandedTime) = diag_tickTime;
        ACEGVAR(interact_menu,lastPath) = +ACEGVAR(interact_menu,menuDepthPath);
        ACEGVAR(interact_menu,startHoverTime) = -1000;
    };
} else {
    ACEGVAR(interact_menu,menuDepthPath) = [["ACE_SelfActions", ACE_player]];
    ACEGVAR(interact_menu,expanded) = true;
    ACEGVAR(interact_menu,expandedTime) = diag_tickTime;
    ACEGVAR(interact_menu,lastPath) = +ACEGVAR(interact_menu,menuDepthPath);
    ACEGVAR(interact_menu,startHoverTime) = -1000;
};

["ace_interactMenuOpened", [_menuType]] call CBA_fnc_localEvent;

//Remove the old "DefaultAction" action event handler if it already exists
ACEGVAR(interact_menu,blockDefaultActions) params [["_player", objNull], ["_ehid", -1]];
TRACE_2("blockDefaultActions",_player,_ehid);
if (!isNull _player) then {
    [_player, "DefaultAction", _ehid] call ACEFUNC(common,removeActionEventHandler);
    ACEGVAR(interact_menu,blockDefaultActions) = [];
};
//Add the "DefaultAction" action event handler
if (alive ACE_player) then {
    private _ehid = [ACE_player, "DefaultAction", {ACEGVAR(interact_menu,openedMenuType) >= 0}, {
        if (!ACEGVAR(interact_menu,actionOnKeyRelease) && ACEGVAR(interact_menu,actionSelected)) then {
            [ACEGVAR(interact_menu,openedMenuType),true] call ACEFUNC(interact_menu,keyUp);
        };
    }] call ACEFUNC(common,addActionEventHandler);
    TRACE_2("Added",ACE_player,_ehid);
    ACEGVAR(interact_menu,blockDefaultActions) = [ACE_player, _ehid];
};

true
