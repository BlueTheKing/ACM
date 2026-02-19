#include "..\script_component.hpp"
#include "..\SurgicalAirway_defines.hpp"
/*
 * Author: Blue
 * Handle showing and hiding available actions while establishing surgical airway. (LOCAL)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_airway_fnc_SurgicalAirway_updateActions;
 *
 * Public: No
 */

params [];

private _display = uiNamespace getVariable [QGVAR(SurgicalAirway_DLG), displayNull];

private _ctrlOpenIncisionAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_OPENINCISION;
private _ctrlLiftIncisionAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_LIFTINCISION;
private _ctrlRemoveHookAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_REMOVEHOOK;
private _ctrlInsertTubeAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_INSERTTUBE;
private _ctrlInflateCuffAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_INFLATECUFF;
private _ctrlRemoveStyletAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_REMOVESTYLET;
private _ctrlConnectStrapAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_CONNECTSTRAP;
private _ctrlSecureStrapAction = _display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_SECURESTRAP;

private _progress = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_Progress), 0];

switch (true) do {
    case (_progress == 1 && GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_HOOK): {
        _ctrlLiftIncisionAction ctrlShow true;
        _ctrlRemoveHookAction ctrlShow false;
        _ctrlInsertTubeAction ctrlShow false;
        _ctrlInflateCuffAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow false;
        _ctrlConnectStrapAction ctrlShow false;
        _ctrlSecureStrapAction ctrlShow false;
    };
    case (_progress == 2 && GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_TUBE): {
        _ctrlLiftIncisionAction ctrlShow false;
        _ctrlRemoveHookAction ctrlShow false;
        _ctrlInsertTubeAction ctrlShow true;
        _ctrlInflateCuffAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow false;
        _ctrlConnectStrapAction ctrlShow false;
        _ctrlSecureStrapAction ctrlShow false;
    };
    case (_progress == 3 && GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_NONE): {
        _ctrlLiftIncisionAction ctrlShow false;
        _ctrlRemoveHookAction ctrlShow true;
        _ctrlInsertTubeAction ctrlShow false;
        _ctrlInflateCuffAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow false;
        _ctrlConnectStrapAction ctrlShow false;
        _ctrlSecureStrapAction ctrlShow false;
    };
    case (_progress > 3 && GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_NONE): {
        _ctrlLiftIncisionAction ctrlShow false;
        _ctrlRemoveHookAction ctrlShow false;
        _ctrlInsertTubeAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow (GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StyletInserted), false]);
        _ctrlInflateCuffAction ctrlShow false;
        _ctrlConnectStrapAction ctrlShow false;
        _ctrlSecureStrapAction ctrlShow false;
    };
    case (_progress > 3 && GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SYRINGE): {
        _ctrlLiftIncisionAction ctrlShow false;
        _ctrlRemoveHookAction ctrlShow false;
        _ctrlInsertTubeAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow false;
        _ctrlInflateCuffAction ctrlShow !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_CuffInflated), false]);
        _ctrlConnectStrapAction ctrlShow false;
        _ctrlSecureStrapAction ctrlShow false;
    };
    case (_progress > 3 && GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_STRAP): {
        _ctrlLiftIncisionAction ctrlShow false;
        _ctrlRemoveHookAction ctrlShow false;
        _ctrlInsertTubeAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow false;
        _ctrlInflateCuffAction ctrlShow false;

        if (GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StyletInserted), false] || GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StrapSecure), false] || GVAR(SurgicalAirway_SelectedItem) != SURGICAL_AIRWAY_SELECTED_STRAP) then {
            _ctrlConnectStrapAction ctrlShow false;
            _ctrlSecureStrapAction ctrlShow false;
        } else {
            _ctrlConnectStrapAction ctrlShow !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StrapConnected), false]);
            _ctrlSecureStrapAction ctrlShow (GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StrapConnected), false]);
        };
    };
    default {
        _ctrlLiftIncisionAction ctrlShow false;
        _ctrlRemoveHookAction ctrlShow false;
        _ctrlInsertTubeAction ctrlShow false;
        _ctrlRemoveStyletAction ctrlShow false;
        _ctrlInflateCuffAction ctrlShow false;
        _ctrlConnectStrapAction ctrlShow false;
        _ctrlSecureStrapAction ctrlShow false;
    };
};