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
 * 2: Body Part <STRING>
 * 3: Syringe Size? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftArm", 10] call ACM_circulation_fnc_Syringe_Draw;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_size", 10]];

private _inject = true;

if (isNull _patient) then {
    _inject = false;
    _patient = _medic;
};

GVAR(SyringeDraw_MedicationList) = [];
GVAR(SyringeDraw_InventorySelection) = 0;

GVAR(SyringeDraw_MedicationSelected) = false;
GVAR(SyringeDraw_MedicationSelected_Index) = -1;

GVAR(SyringeDraw_IVAccess) = false;

GVAR(SyringeDraw_Target) = objNull;
GVAR(SyringeDraw_TargetPart) = "";
GVAR(SyringeDraw_DrawnAmount) = 0;
GVAR(SyringeDraw_MaxDose) = 0;
GVAR(SyringeDraw_Medication) = "";
GVAR(SyringeDraw_Size) = 10;

private _fnc_updateSelectedMedication = {
    params ["_display", "_ctrlMedList"];

    GVAR(SyringeDraw_Medication) = _ctrlMedList lbData (lbCurSel _ctrlMedList);
    GVAR(SyringeDraw_MedicationSelected_Index) = lbCurSel _ctrlMedList ;

    private _concentration = getText (configFile >> "ACM_Medication" >> "Concentration" >> GVAR(SyringeDraw_Medication) >> "dose");

    private _ctrlText = _display displayCtrl IDC_SYRINGEDRAW_TEXT;
    _ctrlText ctrlSetText format [LLSTRING(Syringe_Drawing), GVAR(SyringeDraw_Medication), _concentration, GVAR(SyringeDraw_Size)];
    GVAR(SyringeDraw_MaxDose) = getNumber (configFile >> "ACM_Medication" >> "Concentration" >> GVAR(SyringeDraw_Medication) >> "volume");
};

[[_medic, _patient, _bodyPart, [_inject, _size, _fnc_updateSelectedMedication]], { // On Start
    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["_inject", "_size"];

    createDialog QGVAR(SyringeDraw_Dialog);
    uiNamespace setVariable [QGVAR(SyringeDraw_DLG),(findDisplay IDC_SYRINGEDRAW)];

    private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];
    private _ctrlText = _display displayCtrl IDC_SYRINGEDRAW_TEXT;

    GVAR(SyringeDraw_MedicationList) = [] call FUNC(Syringe_GetMedicationList);
    [] call FUNC(Syringe_UpdateMedicationList);

    GVAR(SyringeDraw_Moving) = false;
    GVAR(SyringeDraw_DrawnAmount) = 0;
    GVAR(SyringeDraw_Size) = _size;

    if (_inject) then {
        GVAR(SyringeDraw_TargetPart) = _bodyPart;
    } else {
        private _ctrlInjectButton = _display displayCtrl IDC_SYRINGEDRAW_BUTTON_INJECT;
        _ctrlInjectButton ctrlShow false;
    };

    if (GVAR(SyringeDraw_MedicationSelected)) then {
        private _concentration = getText (configFile >> "ACM_Medication" >> "Concentration" >> GVAR(SyringeDraw_Medication) >> "dose");
        _ctrlText ctrlSetText format [LLSTRING(Syringe_Drawing), GVAR(SyringeDraw_Medication), _concentration, _size];
        GVAR(SyringeDraw_MaxDose) = getNumber (configFile >> "ACM_Medication" >> "Concentration" >> GVAR(SyringeDraw_Medication) >> "volume");
    }; 

    GVAR(SyringeDraw_Ctrl_PlungerVisual) = IDC_SYRINGEDRAW_SYRINGE_10_PLUNGER;
    GVAR(SyringeDraw_Ctrl_LimitTop) = SYRINGEDRAW_LIMIT_10_TOP;
    GVAR(SyringeDraw_Ctrl_LimitBottom) = SYRINGEDRAW_LIMIT_10_BOTTOM;
    GVAR(SyringeDraw_Ctrl_LimitTopMouse) = SYRINGEDRAW_LIMIT_10_TOP_MOUSE;
    GVAR(SyringeDraw_Ctrl_PlungerAdjustment) = SYRINGEDRAW_10_Y_OFFSET;

    private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;
    (ctrlPosition _ctrlPlunger) params ["_plungerX","","_plungerW","_plungerH"];

    switch (_size) do {
        case 1: { // 1ml
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_1_BACKBIT) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_1_BARREL) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_1_PLUNGER) ctrlShow true;

            GVAR(SyringeDraw_Ctrl_PlungerVisual) = IDC_SYRINGEDRAW_SYRINGE_1_PLUNGER;
            GVAR(SyringeDraw_Ctrl_LimitTop) = SYRINGEDRAW_LIMIT_1_TOP;
            GVAR(SyringeDraw_Ctrl_LimitBottom) = SYRINGEDRAW_LIMIT_1_BOTTOM;
            GVAR(SyringeDraw_Ctrl_LimitTopMouse) = SYRINGEDRAW_LIMIT_1_TOP_MOUSE;
            GVAR(SyringeDraw_Ctrl_PlungerAdjustment) = SYRINGEDRAW_1_Y_OFFSET;
            
            _ctrlPlunger ctrlSetPosition [_plungerX, SYRINGEDRAW_LIMIT_1_TOP, _plungerW, _plungerH];
            _ctrlPlunger ctrlCommit 0;
        };
        case 3: { // 3ml
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_3_BACKBIT) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_3_BARREL) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_3_PLUNGER) ctrlShow true;

            GVAR(SyringeDraw_Ctrl_PlungerVisual) = IDC_SYRINGEDRAW_SYRINGE_3_PLUNGER;
            GVAR(SyringeDraw_Ctrl_LimitTop) = SYRINGEDRAW_LIMIT_3_TOP;
            GVAR(SyringeDraw_Ctrl_LimitBottom) = SYRINGEDRAW_LIMIT_3_BOTTOM;
            GVAR(SyringeDraw_Ctrl_LimitTopMouse) = SYRINGEDRAW_LIMIT_3_TOP_MOUSE;
            GVAR(SyringeDraw_Ctrl_PlungerAdjustment) = SYRINGEDRAW_3_Y_OFFSET;

            _ctrlPlunger ctrlSetPosition [_plungerX, SYRINGEDRAW_LIMIT_3_TOP, _plungerW, _plungerH];
            _ctrlPlunger ctrlCommit 0;
        };
        case 5: { // 5ml
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_5_BACKBIT) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_5_BARREL) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_5_PLUNGER) ctrlShow true;

            GVAR(SyringeDraw_Ctrl_PlungerVisual) = IDC_SYRINGEDRAW_SYRINGE_5_PLUNGER;
            GVAR(SyringeDraw_Ctrl_LimitTop) = SYRINGEDRAW_LIMIT_5_TOP;
            GVAR(SyringeDraw_Ctrl_LimitBottom) = SYRINGEDRAW_LIMIT_5_BOTTOM;
            GVAR(SyringeDraw_Ctrl_LimitTopMouse) = SYRINGEDRAW_LIMIT_5_TOP_MOUSE;
            GVAR(SyringeDraw_Ctrl_PlungerAdjustment) = SYRINGEDRAW_5_Y_OFFSET;

            _ctrlPlunger ctrlSetPosition [_plungerX, SYRINGEDRAW_LIMIT_5_TOP, _plungerW, _plungerH];
            _ctrlPlunger ctrlCommit 0;
        };
        default { // 10ml
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_10_BACKBIT) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_10_BARREL) ctrlShow true;
            (_display displayCtrl IDC_SYRINGEDRAW_SYRINGE_10_PLUNGER) ctrlShow true;
        };
    };

    if ([GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart)] call FUNC(hasIV) || [GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart)] call FUNC(hasIO)) then {
        GVAR(SyringeDraw_IVAccess) = true;
        private _ctrlPushButton = _display displayCtrl IDC_SYRINGEDRAW_BUTTON_PUSH;
        _ctrlPushButton ctrlShow true;
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
}, {
    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["", "_size", "_fnc_updateSelectedMedication"];

    private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];
    private _ctrlMedList = _display displayCtrl IDC_SYRINGEDRAW_MEDLIST;
    private _ctrlMedListButton = _display displayCtrl IDC_SYRINGEDRAW_MEDLIST_SELECTION_BUTTON;
 
    private _cachedMedication = [] call FUNC(Syringe_GetMedicationList);

    if (count _cachedMedication != count GVAR(SyringeDraw_MedicationList)) then {
        GVAR(SyringeDraw_MedicationList) = [] call FUNC(Syringe_GetMedicationList);
        [] call FUNC(Syringe_UpdateMedicationList);
    };

    if (([GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart)] call FUNC(hasIV) || [GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart)] call FUNC(hasIO)) != GVAR(SyringeDraw_IVAccess)) then {
        GVAR(SyringeDraw_IVAccess) = ([GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart)] call FUNC(hasIV) || [GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart)] call FUNC(hasIO));
        private _ctrlPushButton = _display displayCtrl IDC_SYRINGEDRAW_BUTTON_PUSH;
        _ctrlPushButton ctrlShow GVAR(SyringeDraw_IVAccess);
    };

    if(GVAR(SyringeDraw_MedicationSelected)) then {
        if (ctrlEnabled _ctrlMedList) then {
            if (GVAR(SyringeDraw_DrawnAmount) > 0) then {
                _ctrlMedList ctrlEnable false;
                _ctrlMedListButton ctrlEnable false;
            } else {
                if (GVAR(SyringeDraw_MedicationSelected_Index) != lbCurSel _ctrlMedList) then {
                    GVAR(SyringeDraw_MedicationSelected_Index) = lbCurSel _ctrlMedList;

                    [_display, _ctrlMedList] call _fnc_updateSelectedMedication;
                };
            };
        } else {
            if (GVAR(SyringeDraw_DrawnAmount) == 0) then {
                _ctrlMedList ctrlEnable true;
                _ctrlMedListButton ctrlEnable true;
            };
        };
    } else {
        if (lbCurSel _ctrlMedList > -1) then {
            GVAR(SyringeDraw_MedicationSelected) = true;
            [_display, _ctrlMedList] call _fnc_updateSelectedMedication;

            private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;
            _ctrlPlunger ctrlSetTooltip LLSTRING(Syringe_MovePlunger);
        };
    };

    if (GVAR(SyringeDraw_Moving)) then {
        private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;
        private _ctrlPlungerVisual = _display displayCtrl GVAR(SyringeDraw_Ctrl_PlungerVisual);

        private _bottomLimit = linearConversion [0, _size, GVAR(SyringeDraw_MaxDose), GVAR(SyringeDraw_Ctrl_LimitTop), GVAR(SyringeDraw_Ctrl_LimitBottom), true];
        private _bottomLimitMouse = _bottomLimit + (0.026 * (0.55 / (getResolution select 5)));

        getMousePosition params ["_mouseX", "_mouseY"];
        setMousePosition [SYRINGEDRAW_MOUSE_X, (_bottomLimitMouse min _mouseY max GVAR(SyringeDraw_Ctrl_LimitTopMouse))];

        (ctrlPosition _ctrlPlunger) params ["_plungerX","","_plungerW","_plungerH"];

        private _newY = _mouseY - (_plungerH / 2);

        _newY = _bottomLimit min _newY max GVAR(SyringeDraw_Ctrl_LimitTop);

        _ctrlPlunger ctrlSetPosition [_plungerX, _newY, _plungerW, _plungerH];
        _ctrlPlunger ctrlCommit 0;

        (ctrlPosition _ctrlPlungerVisual) params ["_plungerVX","","_plungerVW","_plungerVH"];

        _ctrlPlungerVisual ctrlSetPosition [_plungerVX, (_newY - GVAR(SyringeDraw_Ctrl_PlungerAdjustment)), _plungerVW, _plungerVH];
        _ctrlPlungerVisual ctrlCommit 0;

        private _amountDrawn = linearConversion [GVAR(SyringeDraw_Ctrl_LimitTop), GVAR(SyringeDraw_Ctrl_LimitBottom), _newY, 0, _size, true];

        GVAR(SyringeDraw_DrawnAmount) = _amountDrawn;
    };
}, IDC_SYRINGEDRAW] call EFUNC(core,beginContinuousAction);