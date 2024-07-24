#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Open transfusion menu.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftArm"] call ACM_circulation_fnc_openTransfusionMenu;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

if !(isNull findDisplay IDC_TRANSFUSIONMENU) exitWith {};

private _medicalMenuKeybind = (["ACE3 Common", QACEGVAR(medical_gui,openMedicalMenuKey)] call CBA_FUNC(getKeybind) select 5) select 0;

ACEGVAR(medical_gui,pendingReopen) = false; // Prevent medical menu from reopening

if (dialog) then { // If another dialog is open (medical menu) close it
    closeDialog 0;
};

GVAR(TransfusionMenu_CloseID) = [_medicalMenuKeybind, [false, false, false], { // H to close and open medical menu
    closeDialog 0;
    [ACEFUNC(medical_gui,openMenu), GVAR(TransfusionMenu_Target)] call CBA_fnc_execNextFrame;
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

GVAR(TransfusionMenu_Target) = _patient;

GVAR(TransfusionMenu_Selection_IVBags_LastUpdate) = CBA_missionTime;
GVAR(TransfusionMenu_Selection_IVBags) = [];

GVAR(TransfusionMenu_Selected_Inventory) = -1;

GVAR(TransfusionMenu_Selected_BodyPart) = toLowerANSI _bodyPart;

if (GVAR(TransfusionMenu_Selected_AccessSite) == -1) then {
    if ([_patient, _bodyPart, 0, -1] call FUNC(hasIV)) then {
        GVAR(TransfusionMenu_SelectIV) = true;
        private _ivAccess = (GET_IV(_patient) select (ALL_BODY_PARTS find GVAR(TransfusionMenu_Selected_BodyPart)));
        {
            if (_x > 0) exitWith {
                GVAR(TransfusionMenu_Selected_AccessSite) = _forEachIndex;
            };
        } forEach _ivAccess;
    } else {
        GVAR(TransfusionMenu_Selected_AccessSite) = 0;
        GVAR(TransfusionMenu_SelectIV) = false;
    };
};

createDialog QGVAR(TransfusionMenu_Dialog);
uiNamespace setVariable [QGVAR(TransfusionMenu_DLG),(findDisplay IDC_TRANSFUSIONMENU)];

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

call FUNC(TransfusionMenu_UpdateSelection);
call FUNC(TransfusionMenu_SwitchTargetInventory);
[false] call FUNC(TransfusionMenu_UpdateBagList);

private _ctrlPatientName = _display displayCtrl IDC_TRANSFUSIONMENU_PATIENTNAME;

_ctrlPatientName ctrlSetText ([_patient, false, true] call ACEFUNC(common,getName));

private _inVehicle = !(isNull objectParent ACE_player);

[{
    params ["_args", "_idPFH"];
    _args params ["_display", "_medic", "_patient", "_inVehicle"];

    private _dialogCondition = isNull findDisplay IDC_TRANSFUSIONMENU;
    private _patientCondition = (_patient isEqualTo objNull);
    private _medicCondition = (!(alive _medic) || IS_UNCONSCIOUS(_medic) || (_medic isEqualTo objNull));
    private _vehicleCondition = !(objectParent _medic isEqualTo objectParent _patient);
    private _distanceCondition = (_patient distance2D _medic > ACEGVAR(medical_gui,maxDistance));

    if (_medicCondition || _patientCondition || _dialogCondition || (_inVehicle && _vehicleCondition) || (!_inVehicle && _distanceCondition)) exitWith {
        [GVAR(TransfusionMenu_CloseID), "keydown"] call CBA_fnc_removeKeyHandler;
        GVAR(TransfusionMenu_Target) = objNull;
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _partIndex = ALL_BODY_PARTS find GVAR(TransfusionMenu_Selected_BodyPart);

    private _ctrlIVLeftArmUpper = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_LEFTARM_UPPER;
    private _ctrlIVLeftArmMiddle = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_LEFTARM_MIDDLE;
    private _ctrlIVLeftArmLower = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_LEFTARM_LOWER;
    private _ctrlIVRightArmUpper = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_RIGHTARM_UPPER;
    private _ctrlIVRightArmMiddle = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_RIGHTARM_MIDDLE;
    private _ctrlIVRightArmLower = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_RIGHTARM_LOWER;

    private _ctrlIVLeftLegUpper = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_LEFTLEG_UPPER;
    private _ctrlIVLeftLegMiddle = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_LEFTLEG_MIDDLE;
    private _ctrlIVLeftLegLower = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_LEFTLEG_LOWER;
    private _ctrlIVRightLegUpper = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_RIGHTLEG_UPPER;
    private _ctrlIVRightLegMiddle = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_RIGHTLEG_MIDDLE;
    private _ctrlIVRightLegLower = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IV_RIGHTLEG_LOWER;

    private _IVCtrlArray = [[_ctrlIVLeftArmUpper, _ctrlIVLeftArmMiddle, _ctrlIVLeftArmLower], [_ctrlIVRightArmUpper, _ctrlIVRightArmMiddle, _ctrlIVRightArmLower], [_ctrlIVLeftLegUpper, _ctrlIVLeftLegMiddle, _ctrlIVLeftLegLower], [_ctrlIVRightLegUpper, _ctrlIVRightLegMiddle, _ctrlIVRightLegLower]];

    private _IVArray = GET_IV(_patient);

    {
        _x params ["_xUpper", "_xMiddle", "_xLower"];

        private _accessSiteArray = (_IVArray select (_forEachIndex + 2));

        _accessSiteArray params ["_IVUpper", "_IVMiddle", "_IVLower"];

        _xUpper ctrlShow (_IVUpper > 0);
        _xMiddle ctrlShow (_IVMiddle > 0);
        _xLower ctrlShow (_IVLower > 0);
        
        if (GVAR(TransfusionMenu_SelectIV) && (_forEachIndex + 2) == _partIndex) then {
            switch (GVAR(TransfusionMenu_Selected_AccessSite)) do {
                case 0: {
                    _xUpper ctrlSetTextColor [1,1,1,1];
                    _xMiddle ctrlSetTextColor [0.2, 0.65, 0.2, 1];
                    _xLower ctrlSetTextColor [0.2, 0.65, 0.2, 1];
                };
                case 1: {
                    _xUpper ctrlSetTextColor [0.2, 0.65, 0.2, 1];
                    _xMiddle ctrlSetTextColor [1,1,1,1];
                    _xLower ctrlSetTextColor [0.2, 0.65, 0.2, 1];
                };
                case 2: {
                    _xUpper ctrlSetTextColor [0.2, 0.65, 0.2, 1];
                    _xMiddle ctrlSetTextColor [0.2, 0.65, 0.2, 1];
                    _xLower ctrlSetTextColor [1,1,1,1];
                };
            };
        } else {
            _xUpper ctrlSetTextColor [0.2, 0.65, 0.2, 1];
            _xMiddle ctrlSetTextColor [0.2, 0.65, 0.2, 1];
            _xLower ctrlSetTextColor [0.2, 0.65, 0.2, 1];
        };
    } forEach _IVCtrlArray;

    private _ctrlIOLeftArm = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IO_LEFTARM;
    private _ctrlIORightArm = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IO_RIGHTARM;
    private _ctrlIOLeftLeg = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IO_LEFTLEG;
    private _ctrlIORightLeg = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IO_RIGHTLEG;
    private _ctrlIOTorso = _display displayCtrl IDC_TRANSFUSIONMENU_BG_IO_TORSO;

    private _IOCtrlArray = [_ctrlIOTorso, _ctrlIOLeftArm, _ctrlIORightArm, _ctrlIOLeftLeg, _ctrlIORightLeg];
    private _IOArray = GET_IO(_patient);

    {
        _x ctrlShow ((_IOArray select (_forEachIndex + 1)) > 0);

        if (!(GVAR(TransfusionMenu_SelectIV)) && (_forEachIndex + 1) == _partIndex) then {
            _x ctrlSetTextColor [1,1,1,1];
        } else {
            _x ctrlSetTextColor [0.2, 0.65, 0.2, 1];
        };
    } forEach _IOCtrlArray;

    private _ctrlStopTransfusionButton = _display displayCtrl IDC_TRANSFUSIONMENU_BUTTON_STOPIV;

    private _siteFlowRate = [(GET_IO_FLOW(_patient) select _partIndex), ((GET_IV_FLOW(_patient) select _partIndex) select GVAR(TransfusionMenu_Selected_AccessSite))] select GVAR(TransfusionMenu_SelectIV);

    private _typeString = ["IO","IV"] select GVAR(TransfusionMenu_SelectIV);

    if (_siteFlowRate > 0) then {
        _ctrlStopTransfusionButton ctrlSetText (format ["Stop %1 Transfusion", _typeString]);
        _ctrlStopTransfusionButton ctrlSetTooltip (format ["Stop fluid transfusion on selected %1", _typeString]);
    } else {
        _ctrlStopTransfusionButton ctrlSetText (format ["Start %1 Transfusion", _typeString]);
        _ctrlStopTransfusionButton ctrlSetTooltip (format ["Start fluid transfusion on selected %1", _typeString]);
    };

    if ((GVAR(TransfusionMenu_Selection_IVBags_LastUpdate) + 1) < CBA_missionTime) then {
        GVAR(TransfusionMenu_Selection_IVBags_LastUpdate) = CBA_missionTime;
        [true] call FUNC(TransfusionMenu_UpdateBagList);
    };
}, 0, [_display, ACE_player, GVAR(TransfusionMenu_Target), _inVehicle]] call CBA_fnc_addPerFrameHandler;