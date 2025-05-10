#include "..\script_component.hpp"
#include "..\SurgicalAirway_defines.hpp"
/*
 * Author: Blue
 * Start surgical airway process.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_establishSurgicalAirway;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (_patient getVariable [QGVAR(SurgicalAirway_InProgress), false]) exitWith {
    [LLSTRING(SurgicalAirway_AlreadyInProgress), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
};

_patient setVariable [QGVAR(SurgicalAirway_InProgress), true, true];

[[_medic, _patient], { // On Start
    params ["_medic", "_patient"];

    GVAR(SurgicalAirway_Target) = _patient;

    GVAR(SurgicalAirway_Failed) = false;

    GVAR(SurgicalAirway_SelectedItem) = SURGICAL_AIRWAY_SELECTED_NONE;

    GVAR(SurgicalAirway_IsPalpating) = false;

    GVAR(SurgicalAirway_ActiveIncision_VisualCtrl) = [controlNull];

    GVAR(SurgicalAirway_IsCutting) = false;
    GVAR(SurgicalAirway_IncisionStartPos) = nil;
    GVAR(SurgicalAirway_IncisionSize) = 0;
    GVAR(SurgicalAirway_IncisionEnd) = 0;
    GVAR(SurgicalAirway_IncisionX) = -1;

    GVAR(SurgicalAirway_IncisionAngleVertical) = true;

    GVAR(SurgicalAirway_IncisionSpread) = false;

    _patient setVariable [QGVAR(SurgicalAirway_Progress), 0, true];
    _patient setVariable [QGVAR(SurgicalAirway_TubeInserted), false, true];
    _patient setVariable [QGVAR(SurgicalAirway_HookInserted), false, true];

    _patient setVariable [QGVAR(SurgicalAirway_Incision), false, true];
    _patient setVariable [QGVAR(SurgicalAirway_IncisionStitched), false, true];

    _patient setVariable [QGVAR(SurgicalAirway_IncisionCount), 0, true];
    _patient setVariable [QGVAR(SurgicalAirway_IncisionSeverity), 0, true];

    _patient setVariable [QGVAR(SurgicalAirway_IncisionVerticalSuccess), false, true];
    _patient setVariable [QGVAR(SurgicalAirway_IncisionHorizontalSuccess), false, true];

    _patient setVariable [QGVAR(SurgicalAirway_CuffInflated), false, true];
    _patient setVariable [QGVAR(SurgicalAirway_StyletInserted), true, true];

    _patient setVariable [QGVAR(SurgicalAirway_StrapConnected), false, true];
    _patient setVariable [QGVAR(SurgicalAirway_StrapSecure), false, true];

    _patient setVariable [QGVAR(SurgicalAirway_TubeUnSecure), false, true];

    createDialog QGVAR(SurgicalAirway_Dialog);

    GVAR(SurgicalAirway_LeftMouseDownID) = [0xF0, [false, false, false], {
        [0] call FUNC(SurgicalAirway_mousePress);
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

    GVAR(SurgicalAirway_LeftMouseUpID) = [0xF0, [false, false, false], {
        [0,1] call FUNC(SurgicalAirway_mousePress);
    }, "keyup", "", false, 0] call CBA_fnc_addKeyHandler;

    GVAR(SurgicalAirway_RightMouseDownID) = [0xF1, [false, false, false], {
        [1] call FUNC(SurgicalAirway_mousePress);
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

    GVAR(SurgicalAirway_RightMouseUpID) = [0xF1, [false, false, false], {
        [1,1] call FUNC(SurgicalAirway_mousePress);
    }, "keyup", "", false, 0] call CBA_fnc_addKeyHandler;

    uiNamespace setVariable [QGVAR(SurgicalAirway_DLG),(findDisplay IDC_SURGICAL_AIRWAY)];

    private _display = uiNamespace getVariable [QGVAR(SurgicalAirway_DLG), displayNull];
    private _ctrlText = _display displayCtrl IDC_SURGICAL_AIRWAY_TARGET;

    _ctrlText ctrlSetText ([_patient, false, true] call ACEFUNC(common,getName));
}, { // On cancel
    params ["_medic", "_patient"];

    [GVAR(SurgicalAirway_LeftMouseDownID), "keydown"] call CBA_fnc_removeKeyHandler;
    [GVAR(SurgicalAirway_LeftMouseUpID), "keyup"] call CBA_fnc_removeKeyHandler;
    [GVAR(SurgicalAirway_RightMouseDownID), "keydown"] call CBA_fnc_removeKeyHandler;
    [GVAR(SurgicalAirway_RightMouseUpID), "keyup"] call CBA_fnc_removeKeyHandler;

    if !(isNull findDisplay IDC_SURGICAL_AIRWAY) then {
        closeDialog 0;
    };

    GVAR(SurgicalAirway_IsPalpating) = false;
    GVAR(SurgicalAirway_IsCutting) = false;
    GVAR(SurgicalAirway_IncisionStartPos) = nil;

    _patient setVariable [QGVAR(SurgicalAirway_InProgress), false, true];

    private _incisionCount = _patient getVariable [QGVAR(SurgicalAirway_IncisionCount), 0]; 

    if (GVAR(SurgicalAirway_Failed)) exitWith {
        [LLSTRING(SurgicalAirway_Failed), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

        for "_i" from 1 to _incisionCount do {
            [_patient, 1, "head", "incision", _medic] call ACEFUNC(medical,addDamageToUnit);
        };

        [_patient, "activity", LLSTRING(SurgicalAirway_Cancelled_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
    };

    if !(_patient getVariable [QGVAR(SurgicalAirway_State), false]) then {
        if (_incisionCount == 0) then {
            [_medic, "ACM_CricKit"] call ACEFUNC(common,addToInventory);
        } else {
            for "_i" from 1 to _incisionCount do {
                [_patient, 1, "head", "incision", _medic] call ACEFUNC(medical,addDamageToUnit);
            };

            [_patient, "activity", LLSTRING(SurgicalAirway_Cancelled_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
        };

        _patient setVariable [QGVAR(SurgicalAirway_Progress), 0, true];
        _patient setVariable [QGVAR(SurgicalAirway_Incision), false, true];

        [LLSTRING(SurgicalAirway_Cancelled), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    } else {
        [_patient, "activity", LLSTRING(SurgicalAirway_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
        [_patient, LLSTRING(SurgicalAirway)] call ACEFUNC(medical_treatment,addToTriageCard);

        if (_patient getVariable [QGVAR(SurgicalAirway_StrapSecure), false]) then {
            if (_patient getVariable [QGVAR(SurgicalAirway_Strap_PFH), -1] != -1) exitWith {};
            
            private _PFH = [{
                params ["_args", "_idPFH"];
                _args params ["_patient"];

                if (!(alive _patient) || _patient getVariable [QGVAR(SurgicalAirway_StrapSecure), false] || !(_patient getVariable [QGVAR(SurgicalAirway_State), false])) exitWith {
                    _patient setVariable [QGVAR(SurgicalAirway_Strap_PFH), -1];
                    [_idPFH] call CBA_fnc_removePerFrameHandler;
                };

                if (_patient getVariable [QGVAR(SurgicalAirway_Incision), false]) exitWith {};

                if ([_patient] call ACEFUNC(common,isBeingCarried) && {random 1 < 0.7}) then {
                    _patient setVariable [QGVAR(SurgicalAirway_Incision), true, true];
                };

                if ([_patient] call ACEFUNC(common,isBeingDragged) && {random 1 < 0.5}) then {
                    _patient setVariable [QGVAR(SurgicalAirway_Incision), true, true];
                };

                if !(_patient getVariable [QGVAR(SurgicalAirway_TubeUnSecure), false]) then {
                    _patient setVariable [QGVAR(SurgicalAirway_TubeUnSecure), true, true];
                };
            }, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

            _patient setVariable [QGVAR(SurgicalAirway_Strap_PFH), _PFH];
        };
    };
}, { // PerFrame
    params ["_medic", "_patient"];

    if (GVAR(SurgicalAirway_Failed) || (!(IS_UNCONSCIOUS(_patient)) && alive _patient) || !(_patient getVariable [QGVAR(SurgicalAirway_InProgress), false])) exitWith {
        EGVAR(core,ContinuousAction_Active) = false;
    };

    private _display = uiNamespace getVariable [QGVAR(SurgicalAirway_DLG), displayNull];

    private _ctrlMarker = _display displayCtrl IDC_SURGICAL_AIRWAY_PALPATE;

    getMousePosition params ["_mouseX", "_mouseY"];

    if (GVAR(SurgicalAirway_IsPalpating)) then {
        (ctrlPosition _ctrlMarker) params ["_markerX", "_markerY", "_markerW", "_markerH"];

        _ctrlMarker ctrlSetPosition [_mouseX - (_markerW / 2), _mouseY - (_markerH / 2), _markerW, _markerH];
        _ctrlMarker ctrlCommit 0;

        private _markerCenterPos = [(_markerX + (_markerW / 2)), (_markerY + (_markerH / 2))];

        private _verticalIncision = _patient getVariable [QGVAR(SurgicalAirway_IncisionVerticalSuccess), false];

        private _ctrlShape_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE);
        private _ctrlShape2_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE2);
        private _ctrlUpper_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_UPPER);
        private _ctrlUpperMiddle_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_UPPERMIDDLE);
        private _ctrlLower_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_LOWER);
        private _ctrlEntry_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRY);
        private _ctrlEntryArea_pos = ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRYAREA);

        private _color = switch (true) do {
            case (_patient getVariable [QGVAR(SurgicalAirway_TubeInserted), false]): {
                [1,1,1,0.2];
            };
            case (_verticalIncision && [_ctrlEntry_pos, _markerCenterPos] call EFUNC(GUI,inZone)): { // Hole
                [0,1,1,0.7];
            };
            case (!_verticalIncision && [_ctrlEntryArea_pos, _markerCenterPos] call EFUNC(GUI,inZone)): { // Hole Area
                [1,0.1,0.7,0.7];
            };
            case ([_ctrlUpperMiddle_pos, _markerCenterPos] call EFUNC(GUI,inZone)): { // Upper Middle
                [1,0.9,0,0.7];
            };
            case ([_ctrlUpper_pos, _markerCenterPos] call EFUNC(GUI,inZone)): { // Upper
                [1,0.7,0.5,0.7];
            };
            case ([_ctrlLower_pos, _markerCenterPos] call EFUNC(GUI,inZone)): { // Lower
                [1,0.5,0.5,0.7];
            };
            case ([_ctrlShape_pos, _markerCenterPos] call EFUNC(GUI,inZone) || [_ctrlShape2_pos, _markerCenterPos] call EFUNC(GUI,inZone)): {
                [1,0,0,0.7];
            };
            default {[1,1,1,0.2]};
        };

        _ctrlMarker ctrlSetTextColor _color;
        _ctrlMarker ctrlShow true;

        if (_patient getVariable [QGVAR(SurgicalAirway_IncisionVerticalSuccess), false] && [(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRY)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone) && !(GVAR(SurgicalAirway_IncisionSpread))) then {
            GVAR(SurgicalAirway_IncisionSpread) = true;
            private _ctrlIncisionVisual = _display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_INCISIONBIG;

            _ctrlIncisionVisual ctrlSetPositionX GVAR(SurgicalAirway_IncisionX);
            _ctrlIncisionVisual ctrlCommit 0;
            _ctrlIncisionVisual ctrlShow true;
            [LLSTRING(SurgicalAirway_IncisionExpanded), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        };
    } else {
        _ctrlMarker ctrlSetTextColor [1,0,0,0.7];
        _ctrlMarker ctrlShow false;
    };

    if (GVAR(SurgicalAirway_SelectedItem) > SURGICAL_AIRWAY_SELECTED_NONE) then {
        private _ctrlActiveItemVisual = _display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_ACTIVEITEM;

        (ctrlPosition _ctrlActiveItemVisual) params ["_itemX", "_itemY", "_itemW", "_itemH"];

        _ctrlActiveItemVisual ctrlSetPosition [_mouseX - (_itemW / 2), _mouseY - (_itemH / 2), _itemW, _itemH];
        _ctrlActiveItemVisual ctrlCommit 0;

        if ([(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_ACTIONAREA)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone) || {
        GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SYRINGE && ([(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_ACTION_INFLATECUFF)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone))}) then {
            _ctrlActiveItemVisual ctrlSetTextColor [1,1,1,1];
        } else {
            _ctrlActiveItemVisual ctrlSetTextColor [0.5,0.5,0.5,1];
        };
    };

    if (GVAR(SurgicalAirway_IsCutting)) then {
        private _ctrlIncisionSpace = _display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_INCISION;
        (ctrlPosition _ctrlIncisionSpace) params ["_incisionSpaceX", "_incisionSpaceY", "_incisionSpaceW", "_incisionSpaceH"];

        private _incisionStartPos = GVAR(SurgicalAirway_IncisionStartPos);

        _incisionStartPos params ["_incisionStartX", "_incisionStartY"];

        if (GVAR(SurgicalAirway_IncisionAngleVertical)) then {
            private _ctrlIncisionVisual = (GVAR(SurgicalAirway_ActiveIncision_VisualCtrl) select 0);
            (ctrlPosition _ctrlIncisionVisual) params ["_incisionX", "_incisionY", "_incisionW", "_incisionH"];

            private _incisionVisualAdd = linearConversion [0, 0.1, GVAR(SurgicalAirway_IncisionSize), 0, 0.04, true];

            _ctrlIncisionVisual ctrlSetPosition [_incisionStartX - (_incisionW / 2), _incisionStartY, _incisionW, ((GVAR(SurgicalAirway_IncisionEnd) + _incisionVisualAdd - _incisionStartY) max 0)];
            _ctrlIncisionVisual ctrlCommit 0;

            _ctrlIncisionSpace ctrlSetPosition [_incisionStartX - (_incisionSpaceW / 2), _incisionStartY, ACM_SURGICAL_AIRWAY_SPACE_INCISION_W, ((GVAR(SurgicalAirway_IncisionEnd) - _incisionStartY) max 0)];
            _ctrlIncisionSpace ctrlCommit 0;

            GVAR(SurgicalAirway_IncisionEnd) = _mouseY max GVAR(SurgicalAirway_IncisionEnd);

            GVAR(SurgicalAirway_IncisionSize) = GVAR(SurgicalAirway_IncisionEnd) - _incisionStartY;

            setMousePosition [_incisionStartX, GVAR(SurgicalAirway_IncisionEnd) max _mouseY];
        } else {
            _ctrlIncisionSpace ctrlSetPosition [_incisionStartX, _incisionStartY - (_incisionSpaceH / 2), ((GVAR(SurgicalAirway_IncisionEnd) - _incisionStartX) max 0), ACM_SURGICAL_AIRWAY_SPACE_INCISION_H];
            _ctrlIncisionSpace ctrlCommit 0;

            GVAR(SurgicalAirway_IncisionEnd) = _mouseX max GVAR(SurgicalAirway_IncisionEnd);

            setMousePosition [GVAR(SurgicalAirway_IncisionEnd) max _mouseX, _incisionStartY];
        };
    };
}, false, IDC_SURGICAL_AIRWAY] call EFUNC(core,beginContinuousAction);