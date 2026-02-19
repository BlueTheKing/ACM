#include "..\script_component.hpp"
#include "..\SurgicalAirway_defines.hpp"
/*
 * Author: Blue
 * Handle selecting inventory item when establishing surgical airway. (LOCAL)
 *
 * Arguments:
 * 0: Item <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0] call ACM_airway_fnc_SurgicalAirway_select;
 *
 * Public: No
 */

params ["_item"];

private _display = uiNamespace getVariable [QGVAR(SurgicalAirway_DLG), displayNull];

private _tubeInserted = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_TubeInserted), false];
private _hookInserted = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_HookInserted), false];
private _cuffInflated = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_CuffInflated), false];
private _strapSecured = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StrapSecure), false];

if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_NONE) then {
    GVAR(SurgicalAirway_SelectedItem) = _item;
} else {
    switch (_item) do {
        case SURGICAL_AIRWAY_SELECTED_SCALPEL: {
            if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SCALPEL) then {
                GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;
            };
        };
        case SURGICAL_AIRWAY_SELECTED_HOOK: {
            if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_HOOK) then {
                GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;
            };
        };
        case SURGICAL_AIRWAY_SELECTED_TUBE: {
            if (_tubeInserted) exitWith {};
            if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_TUBE) then {
                GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;
            };
        };
        case SURGICAL_AIRWAY_SELECTED_SYRINGE: {
            if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SYRINGE) then {
                GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;
            };
        };
        case SURGICAL_AIRWAY_SELECTED_STRAP: {
            if (_strapSecured) exitWith {};
            if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_STRAP) then {
                GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;
            };
        };
        default {
            GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;
        };
    };
};

private _ctrlScalpelButton = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_SCALPEL;
private _ctrlHookButton = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_HOOK;
private _ctrlTubeButton = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_TUBE;
private _ctrlSyringeButton = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_SYRINGE;
private _ctrlStrapButton = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_STRAP;

private _ctrlScalpelImage = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_SCALPEL_IMG;
private _ctrlHookImage = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_HOOK_IMG;
private _ctrlTubeImage = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_TUBE_IMG;
private _ctrlSyringeImage = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_SYRINGE_IMG;
private _ctrlStrapImage = _display displayCtrl IDC_SURGICAL_AIRWAY_INVBUTTON_STRAP_IMG;

private _ctrlActiveItem = _display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_ACTIVEITEM;

private _progress = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_Progress), -1];

if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SCALPEL) then {
    _ctrlScalpelImage ctrlSetTextColor [0,0,0,1];
    _ctrlScalpelButton ctrlSetTooltip LLSTRING(SurgicalAirway_PutBack);

    _ctrlActiveItem ctrlSetText ([QPATHTOF(ui\surgical_airway\active_scalpel_h.paa), QPATHTOF(ui\surgical_airway\active_scalpel_v.paa)] select GVAR(SurgicalAirway_IncisionAngleVertical));
} else {
    if (_progress > 0) then {
        _ctrlScalpelImage ctrlSetTextColor [0.2,0.2,0.2,1];
        _ctrlScalpelButton ctrlSetTooltip "";
        _ctrlScalpelButton ctrlEnable false;
    } else {
        _ctrlScalpelImage ctrlSetTextColor [1,1,1,1];
        _ctrlScalpelButton ctrlSetTooltip LLSTRING(SurgicalAirway_Scalpel);
    };
};

if (_hookInserted) then {
    _ctrlHookImage ctrlSetTextColor [0,0,0,1];
    _ctrlHookButton ctrlSetTooltip "";
    _ctrlHookButton ctrlEnable false;
} else {
    if (_progress > 3 && GVAR(SurgicalAirway_SelectedItem) != SURGICAL_AIRWAY_SELECTED_HOOK) then {
        _ctrlHookImage ctrlSetTextColor [0.2,0.2,0.2,1];
        _ctrlHookButton ctrlSetTooltip "";
        _ctrlHookButton ctrlEnable false;
    } else {
        _ctrlHookButton ctrlEnable true;
        if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_HOOK) then {
            _ctrlHookImage ctrlSetTextColor [0,0,0,1];
            _ctrlHookButton ctrlSetTooltip LLSTRING(SurgicalAirway_PutBack);
            _ctrlActiveItem ctrlSetText QPATHTOF(ui\surgical_airway\active_hook.paa);
        } else {
            _ctrlHookImage ctrlSetTextColor [1,1,1,1];
            _ctrlHookButton ctrlSetTooltip LLSTRING(SurgicalAirway_Hook);
        };
    };
};

if (_tubeInserted) then {
    _ctrlTubeImage ctrlSetTextColor [0,0,0,1];
    _ctrlTubeButton ctrlSetTooltip "";
    _ctrlTubeButton ctrlEnable false;
} else {
    _ctrlTubeButton ctrlEnable true;
    if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_TUBE) then {
        _ctrlTubeImage ctrlSetTextColor [0,0,0,1];
        _ctrlTubeButton ctrlSetTooltip LLSTRING(SurgicalAirway_PutBack);
        _ctrlActiveItem ctrlSetText QPATHTOF(ui\surgical_airway\active_tube.paa);
        _ctrlActiveItem ctrlSetPositionW ACM_SURGICAL_AIRWAY_POS_W(50);
        _ctrlActiveItem ctrlSetPositionH ACM_SURGICAL_AIRWAY_POS_H(50);
        _ctrlActiveItem ctrlCommit 0;
    } else {
        _ctrlTubeImage ctrlSetTextColor [1,1,1,1];
        _ctrlTubeButton ctrlSetTooltip LLSTRING(SurgicalAirway_Tube);
    };
};

if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SYRINGE) then {
    _ctrlSyringeImage ctrlSetTextColor [0,0,0,1];
    _ctrlSyringeButton ctrlSetTooltip LLSTRING(SurgicalAirway_PutBack);

    _ctrlActiveItem ctrlSetText QPATHTOF(ui\surgical_airway\active_syringe.paa);
} else {
    if (_cuffInflated && GVAR(SurgicalAirway_SelectedItem) != SURGICAL_AIRWAY_SELECTED_SYRINGE) then {
        _ctrlSyringeImage ctrlSetTextColor [0.2,0.2,0.2,1];
        _ctrlSyringeButton ctrlSetTooltip "";
        _ctrlSyringeButton ctrlEnable false;
    } else {
        _ctrlSyringeImage ctrlSetTextColor [1,1,1,1];
        _ctrlSyringeButton ctrlSetTooltip LLSTRING(SurgicalAirway_Syringe);
    };
};

if (_strapSecured) then {
    _ctrlStrapImage ctrlSetTextColor [0,0,0,1];
    _ctrlStrapButton ctrlSetTooltip "";
    _ctrlStrapButton ctrlEnable false;
} else {
    _ctrlStrapButton ctrlEnable true;
    if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_STRAP) then {
        _ctrlStrapImage ctrlSetTextColor [0,0,0,1];
        _ctrlStrapButton ctrlSetTooltip LLSTRING(SurgicalAirway_PutBack);
        _ctrlActiveItem ctrlSetText QPATHTOF(ui\surgical_airway\active_strap.paa);
        _ctrlActiveItem ctrlCommit 0;
    } else {
        _ctrlStrapImage ctrlSetTextColor [1,1,1,1];
        _ctrlStrapButton ctrlSetTooltip LLSTRING(SurgicalAirway_Strap);
    };
};

if (GVAR(SurgicalAirway_SelectedItem) < 0) then {
    _ctrlActiveItem ctrlShow false;
    _ctrlActiveItem ctrlSetText "";
    _ctrlActiveItem ctrlSetPositionW ACM_SURGICAL_AIRWAY_POS_W(25);
    _ctrlActiveItem ctrlSetPositionH ACM_SURGICAL_AIRWAY_POS_H(25);
    _ctrlActiveItem ctrlCommit 0;
} else {
    _ctrlActiveItem ctrlShow true;
};

[] call FUNC(SurgicalAirway_updateActions);