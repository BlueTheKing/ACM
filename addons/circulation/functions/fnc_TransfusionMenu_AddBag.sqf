#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Handle add bag button.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_TransfusionMenu_AddBag;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

private _ctrlInventoryPanel = _display displayCtrl IDC_TRANSFUSIONMENU_RIGHTLISTPANEL;

private _targetIndex = lbCurSel _ctrlInventoryPanel;

if (_targetIndex < 0) exitWith {};

((_ctrlInventoryPanel lbData _targetIndex) splitString "|") params ["_itemClassname", "_actionClassname"];

private _medic = ACE_player;
private _patient = GVAR(TransfusionMenu_Target);

private _vehicle = objectParent _medic;

private _inVehicle = !isNull _vehicle;

private _target = [_medic, _patient, _vehicle] select GVAR(TransfusionMenu_Selected_Inventory);

if (GVAR(TransfusionMenu_Selected_Inventory) == 2) then {
    _vehicle addItemCargoGlobal [_itemClassname, -1];
} else {
    _target removeItem _itemClassname;
};

if (stance _medic in ["STAND","CROUCH"]) then {
    _medic call ACEFUNC(common,goKneeling);
};

[6, [_medic, _patient, _target, _itemClassname, _actionClassname, _inVehicle], {
    params ["_args"];
    _args params ["_medic", "_patient", "_target", "_itemClassname", "_actionClassname"];

    [_medic, _patient, GVAR(TransfusionMenu_Selected_BodyPart), _actionClassname, objNull, _itemClassname, GVAR(TransfusionMenu_SelectIV), GVAR(TransfusionMenu_Selected_AccessSite)] call ACEFUNC(medical_treatment,ivBag);
    GVAR(TransfusionMenu_Reopen) = true;
}, {
    params ["_args"];
    _args params ["_medic", "_patient", "_target", "_itemClassname"];

    if (GVAR(TransfusionMenu_Selected_Inventory) == 2) then {
        _vehicle addItemCargoGlobal [_itemClassname, 1];
    } else {
        [_target, _itemClassname] call ACEFUNC(common,addToInventory);
    };
    [_medic, _patient, GVAR(TransfusionMenu_Selected_BodyPart)] call FUNC(openTransfusionMenu);
}, format ["Connecting fluid bag..."], 
{
    params ["_args"];
    _args params ["_medic", "_patient", "_target", "_itemClassname", "_actionClassname", "_inVehicle"];

    private _patientCondition = !(_patient isEqualTo objNull);
    private _medicCondition = ((alive _medic) && !(IS_UNCONSCIOUS(_medic)) && !(_medic isEqualTo objNull));
    private _vehicleCondition = (objectParent _medic isEqualTo objectParent _patient);
    private _distanceCondition = (_patient distance2D _medic <= ACEGVAR(medical_gui,maxDistance));

    _patientCondition && _medicCondition && ((_inVehicle && _vehicleCondition) || (!_inVehicle && _distanceCondition))
}] call ACEFUNC(common,progressBar);