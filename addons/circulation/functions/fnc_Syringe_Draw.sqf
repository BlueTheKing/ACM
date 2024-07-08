#include "..\script_component.hpp"
#include "..\SyringeDraw_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Handle visual for selecting medication dose.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <OBJECT>
 * 3: Is IV? <BOOL>
 * 4: Medication <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftArm", false, "Morphine"] call ACM_circulation_fnc_Syringe_Draw;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_IV", false], "_medication"];

private _inject = true;

if (isNull _patient) then {
    _inject = false;
    _patient = _medic;
};

GVAR(SyringeDraw_Target) = objNull;
GVAR(SyringeDraw_TargetPart) = "";
GVAR(SyringeDraw_DrawnAmount) = 0;
GVAR(SyringeDraw_MaxDose) = 0;
GVAR(SyringeDraw_Medication) = "";
GVAR(SyringeDraw_IV) = false;

[[_medic, _patient, _bodyPart, [_inject, _IV, _medication]], { // On Start
    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["_inject", "_IV", "_medication"];

    createDialog QGVAR(SyringeDraw_Dialog);
    uiNamespace setVariable [QGVAR(SyringeDraw_DLG),(findDisplay IDC_SYRINGEDRAW)];

    private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];
    private _ctrlText = _display displayCtrl IDC_SYRINGEDRAW_TEXT;

    private _sourceString = ["IM","IV"] select _IV;

    private _concentration = getText (configFile >> "ACM_Medication" >> "Concentration" >> _medication >> "dose");

    _ctrlText ctrlSetText format ["Drawing %1 (%2) into %3 syringe", _medication, _concentration, _sourceString];

    GVAR(SyringeDraw_Moving) = false;

    GVAR(SyringeDraw_TargetPart) = _bodyPart;
    GVAR(SyringeDraw_DrawnAmount) = 0;
    GVAR(SyringeDraw_MaxDose) = getNumber (configFile >> "ACM_Medication" >> "Concentration" >> _medication >> "volume");
    GVAR(SyringeDraw_Medication) = _medication;
    GVAR(SyringeDraw_IV) = _IV;

    if (_IV) then {
        (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_IM_GROUP) ctrlShow false;
    } else {
        private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;
        (ctrlPosition _ctrlPlunger) params ["_plungerX","","_plungerW","_plungerH"];
        _ctrlPlunger ctrlSetPosition [_plungerX, SYRINGEDRAW_LIMIT_IM_TOP, _plungerW, _plungerH];
        _ctrlPlunger ctrlCommit 0;

        private _ctrlInjectButton = _display displayCtrl IDC_SYRINGEDRAW_BUTTON_PUSH;
        _ctrlInjectButton ctrlSetText "Inject";

        (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_IV_GROUP) ctrlShow false;
    };

    if (_inject) then {
        GVAR(SyringeDraw_Target) = _patient;
        private _ctrlBText = _display displayCtrl IDC_SYRINGEDRAW_BOTTOMTEXT;

        _ctrlBText ctrlShow true;

        private _partIndex = ALL_BODY_PARTS find _bodyPart;
        private _bodyPartString = [
            ACELLSTRING(medical_gui,Torso),
            ACELLSTRING(medical_gui,LeftArm),
            ACELLSTRING(medical_gui,RightArm),
            ACELLSTRING(medical_gui,LeftLeg),
            ACELLSTRING(medical_gui,RightLeg)
        ] select (_partIndex - 1);

        _ctrlBText ctrlSetText format ["%1 (%2)", ([_patient, false, true] call ACEFUNC(common,getName)), _bodyPartString];
    };
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart", "", "_notInVehicle"];

    if !(isNull findDisplay IDC_SYRINGEDRAW) then {
        closeDialog 0;
    };
    
    if (_notInVehicle) then {
        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
    };
}, ([// PerFrame
{ // IM
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];

    if (GVAR(SyringeDraw_Moving)) then {
        private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;
        private _ctrlPlungerVisual = _display displayCtrl IDC_SYRINGEDRAW_SYRINGE_IM_PLUNGER;

        private _bottomLimit = linearConversion [0, 5, GVAR(SyringeDraw_MaxDose), 0.838804, 1.2836, true];
        private _bottomLimitMouse = _bottomLimit + 0.02;

        getMousePosition params ["_mouseX", "_mouseY"];
        setMousePosition [SYRINGEDRAW_MOUSE_X, (_bottomLimitMouse min _mouseY max SYRINGEDRAW_LIMIT_IM_TOP_MOUSE)];

        (ctrlPosition _ctrlPlunger) params ["_plungerX","","_plungerW","_plungerH"];

        private _newY = _mouseY - (_plungerH / 2);

        _newY = _bottomLimit min _newY max SYRINGEDRAW_LIMIT_IM_TOP;

        _ctrlPlunger ctrlSetPosition [_plungerX, _newY, _plungerW, _plungerH];
        _ctrlPlunger ctrlCommit 0;

        (ctrlPosition _ctrlPlungerVisual) params ["_plungerVX","","_plungerVW","_plungerVH"];

        _ctrlPlungerVisual ctrlSetPosition [_plungerVX, (_newY - ACM_pxToScreen_Y(1413)), _plungerVW, _plungerVH];
        _ctrlPlungerVisual ctrlCommit 0;

        private _amountDrawn = linearConversion [0.838804, 1.2836, _newY, 0, 5, true];

        GVAR(SyringeDraw_DrawnAmount) = _amountDrawn;
    };
},{ // IV
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];

    if (GVAR(SyringeDraw_Moving)) then {
        private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;
        private _ctrlPlungerVisual = _display displayCtrl IDC_SYRINGEDRAW_SYRINGE_IV_PLUNGER;

        private _bottomLimit = linearConversion [0, 10, GVAR(SyringeDraw_MaxDose), 0.862366, 1.319, true];
        private _bottomLimitMouse = _bottomLimit + 0.02;

        getMousePosition params ["_mouseX", "_mouseY"];
        setMousePosition [SYRINGEDRAW_MOUSE_X, (_bottomLimitMouse min _mouseY max SYRINGEDRAW_LIMIT_IV_TOP)];

        (ctrlPosition _ctrlPlunger) params ["_plungerX","","_plungerW","_plungerH"];

        private _newY = _mouseY - (_plungerH / 2);

        _newY = _bottomLimit min _newY max SYRINGEDRAW_LIMIT_IV_TOP;

        _ctrlPlunger ctrlSetPosition [_plungerX, _newY, _plungerW, _plungerH];
        _ctrlPlunger ctrlCommit 0;

        (ctrlPosition _ctrlPlungerVisual) params ["_plungerVX","","_plungerVW","_plungerVH"];

        _ctrlPlungerVisual ctrlSetPosition [_plungerVX, (_newY - ACM_pxToScreen_Y(1440)), _plungerVW, _plungerVH];
        _ctrlPlungerVisual ctrlCommit 0;

        private _amountDrawn = linearConversion [0.862366, 1.319, _newY, 0, 10, true];

        GVAR(SyringeDraw_DrawnAmount) = _amountDrawn;
    };
}] select _IV), IDC_SYRINGEDRAW] call EFUNC(core,beginContinuousAction);