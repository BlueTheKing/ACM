#include "..\script_component.hpp"
/*
 * Author: mharis001
 * Updates the action buttons based currently avaiable treatments.
 *
 * Arguments:
 * 0: Medical Menu display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call ace_medical_gui_fnc_updateActions
 *
 * Public: No
 */

params ["_display"];

private _selectedCategory = ACEGVAR(medical_gui,selectedCategory);

private _group = _display displayCtrl IDC_ACTION_BUTTON_GROUP;
private _actionButtons = allControls _group;

// Handle triage list (no actions shown)
private _ctrlTriage = _display displayCtrl IDC_TRIAGE_CARD;
private _showTriage = _selectedCategory == "triage";
_ctrlTriage ctrlEnable _showTriage;
_group ctrlEnable !_showTriage;

lbClear _ctrlTriage;

if (_showTriage) exitWith {
    { ctrlDelete _x } forEach _actionButtons;
    [_ctrlTriage, ACEGVAR(medical_gui,target)] call ACEFUNC(medical_gui,updateTriageCard);
};

if (GVAR(showActionItemIcons) && (GVAR(lastSelectedCategory) != ACEGVAR(medical_gui,selectedCategory) || GVAR(lastSelectedBodyPart) != ACEGVAR(medical_gui,selectedBodyPart) || GVAR(lastTarget) != ACEGVAR(medical_gui,target))) exitWith {
    { ctrlDelete _x } forEach _actionButtons;
    GVAR(lastSelectedCategory) = ACEGVAR(medical_gui,selectedCategory);
    GVAR(lastSelectedBodyPart) = ACEGVAR(medical_gui,selectedBodyPart);
    GVAR(lastTarget) = ACEGVAR(medical_gui,target);
    [_display] call ACEFUNC(medical_gui,updateActions);
};

// Show treatment options on action buttons
private _shownIndex = 0;
{
    _x params ["_displayName", "_category", "_condition", "_statement", "_items", ["_menuIcon", ""]];

    // Check action category and condition
    if (_category == _selectedCategory && {call _condition}) then {
        private _buttonClass = format ["ACM_MedicalMenu_ActionButton_%1", (["None", _menuIcon] select (_menuIcon != ""))];

        private _ctrl = if (_shownIndex >= count _actionButtons) then {
            _actionButtons pushBack (_display ctrlCreate [_buttonClass, -1, _group]);
        };
        _ctrl = _actionButtons # _shownIndex;
        _ctrl ctrlRemoveAllEventHandlers "ButtonClick";
        _ctrl ctrlSetPositionY POS_H(1.1 * _shownIndex);
        _ctrl ctrlCommit 0;

        private _countText = "";
        if (_items isNotEqualTo []) then {
            if ("ACE_surgicalKit" in _items && {ACEGVAR(medical_treatment,consumeSurgicalKit) == 2}) then {
                _items = ["ACE_suture"];
            };
            private _counts = [_items] call ACEFUNC(medical_gui,countTreatmentItems);
            _countText = _counts call ACEFUNC(medical_gui,formatItemCounts);
        };
        _ctrl ctrlSetTooltipColorText [1, 1, 1, 1];
        _ctrl ctrlSetTooltip _countText;

        // Show warning if tourniquet will interfere with action
        if (
            ACEGVAR(medical_gui,tourniquetWarning) &&
            {(_category in ["examine", "medication"]) || (_items findIf {"IV" in _x}) > -1} &&
            {HAS_TOURNIQUET_APPLIED_ON(ACEGVAR(medical_gui,target),ACEGVAR(medical_gui,selectedBodyPart))}
        ) then {
            _ctrl ctrlSetTooltipColorText [1, 1, 0, 1];
            _ctrl ctrlSetTooltip ACELLSTRING(medical_gui,TourniquetWarning);
        };

        _ctrl ctrlSetText _displayName;
        _ctrl ctrlShow true;

        _ctrl ctrlAddEventHandler ["ButtonClick", _statement];
        _ctrl ctrlAddEventHandler ["ButtonClick", {ACEGVAR(medical_gui,pendingReopen) = true}];

        _shownIndex = _shownIndex + 1;
        if (GVAR(showActionItemIcons)) then {GVAR(actionsList) pushBack _forEachIndex;};
    };
} forEach ACEGVAR(medical_gui,actions);

if (GVAR(showActionItemIcons)) then {
    if (GVAR(lastActionsListReady)) then {
        if (GVAR(lastActionsList) isNotEqualTo GVAR(actionsList)) then {
            { ctrlDelete _x } forEach _actionButtons;
            GVAR(lastActionsListReady) = false;
            GVAR(lastActionsList) = [];
        };
        GVAR(actionsList) = [];
    } else {
        GVAR(lastActionsListReady) = true;
        GVAR(lastActionsList) = +(GVAR(actionsList));
        GVAR(actionsList) = [];
    };
};

{ ctrlDelete _x } forEach (_actionButtons select [_shownIndex, 9999]);
