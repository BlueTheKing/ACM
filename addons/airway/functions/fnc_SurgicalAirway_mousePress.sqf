#include "..\script_component.hpp"
#include "..\SurgicalAirway_defines.hpp"
/*
 * Author: Blue
 * Handle mouse click while establishing surgical airway. (LOCAL)
 *
 * Arguments:
 * 0: Button <NUMBER>
 * 1: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0,0] call ACM_airway_fnc_SurgicalAirway_mousePress;
 *
 * Public: No
 */

params ["_button", ["_type", 0]];

private _display = uiNamespace getVariable [QGVAR(SurgicalAirway_DLG), displayNull];

getMousePosition params ["_mouseX", "_mouseY"];

private _outOfBounds = !([(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_ACTIONAREA)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone));

if (_button == 0) then { // Left
    if (_outOfBounds || GVAR(SurgicalAirway_SelectedItem) != 0) exitWith {};

    if (_type == 0) then {
        GVAR(SurgicalAirway_IsCutting) = true;
        GVAR(SurgicalAirway_IncisionSize) = 0;
        GVAR(SurgicalAirway_IncisionStartPos) = [_mouseX, _mouseY];

        private _incisionCount = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_IncisionCount), 0];

        GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_IncisionCount), (_incisionCount + 1), true];
        [GVAR(SurgicalAirway_Target), 0.9] call ACEFUNC(medical,adjustPainLevel);

        if (GVAR(SurgicalAirway_IncisionAngleVertical)) then {
            GVAR(SurgicalAirway_ActiveIncision_VisualCtrl) = [(_display ctrlCreate ["ACM_SurgicalAirway_VisualIncision", -1, (_display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_INCISIONGROUP)])];
            (GVAR(SurgicalAirway_ActiveIncision_VisualCtrl) select 0) ctrlShow true;
        };

        [{
            params ["_display"];

            getMousePosition params ["_mouseX", "_mouseY"];

            !([(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_ACTIONAREA)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone)) || !(GVAR(SurgicalAirway_IsCutting))
        }, {
            GVAR(SurgicalAirway_IsCutting) = false;
        }, [_display], 3600] call CBA_fnc_waitUntilAndExecute;
    } else {
        GVAR(SurgicalAirway_IsCutting) = false;

        private _ctrlIncision = _display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_INCISION;

        if !([(ctrlPosition _ctrlIncision), (ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE))] call EFUNC(GUI,isZoneOverlapping)) exitWith {
            GVAR(SurgicalAirway_Failed) = true;
        };

        (ctrlPosition _ctrlIncision) params ["_incisionX", "_incisionY", "_incisionW", "_incisionH"];

        private _startPosition = [_incisionX, _incisionY];
        private _endPosition = [(_incisionX + _incisionW), (_incisionY + _incisionH)];

        if (GVAR(SurgicalAirway_IncisionAngleVertical)) then {
            private _ctrlVerticalIncisionSite = _display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_INCISION_VERTICAL;

            (ctrlPosition _ctrlVerticalIncisionSite) params ["", "_incisionSiteY", "", "_incisionSiteH"];
            
            if (!(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_IncisionVerticalSuccess), false]) && ([(ctrlPosition _ctrlIncision), (ctrlPosition _ctrlVerticalIncisionSite)] call EFUNC(GUI,isZoneOverlapping)) && {(_startPosition select 1) < _incisionSiteY && (_endPosition select 1) > (_incisionSiteY + _incisionSiteH)}) then {
                GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_IncisionVerticalSuccess), true, true];
                GVAR(SurgicalAirway_IncisionX) = (ctrlPosition (GVAR(SurgicalAirway_ActiveIncision_VisualCtrl) select 0) select 0);
            };
        } else {
            private _ctrlHorizontalIncisionSite = _display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_INCISION_HORIZONTAL;

            (ctrlPosition _ctrlHorizontalIncisionSite) params ["_incisionSiteX", "", "_incisionSiteW"];

            if ([(ctrlPosition _ctrlIncision), (ctrlPosition _ctrlHorizontalIncisionSite)] call EFUNC(GUI,isZoneOverlapping) && {(_startPosition select 0) < _incisionSiteX && (_endPosition select 0) > _incisionSiteX + _incisionSiteW}) then {
                GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_IncisionHorizontalSuccess), true, true];
                [0] call FUNC(SurgicalAirway_action);

                (_display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_INCISIONBIG) ctrlSetText QPATHTOF(ui\surgical_airway\incision_1_0.paa);
            };
        };
    };
} else { // Right
    if (GVAR(SurgicalAirway_SelectedItem) == SURGICAL_AIRWAY_SELECTED_SCALPEL) then {
        if (_type == 1 && !GVAR(SurgicalAirway_IsCutting)) then {
            if !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_IncisionVerticalSuccess), false]) exitWith {};
            GVAR(SurgicalAirway_IncisionAngleVertical) = !GVAR(SurgicalAirway_IncisionAngleVertical);

            (_display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_ACTIVEITEM) ctrlSetText ([QPATHTOF(ui\surgical_airway\active_scalpel_h.paa), QPATHTOF(ui\surgical_airway\active_scalpel_v.paa)] select GVAR(SurgicalAirway_IncisionAngleVertical));
        };
    } else {
        if (_outOfBounds) exitWith {
            GVAR(SurgicalAirway_IsPalpating) = false;
        };

        if (GVAR(SurgicalAirway_SelectedItem) != SURGICAL_AIRWAY_SELECTED_NONE) exitWith {
            GVAR(SurgicalAirway_IsPalpating) = false;
        };

        if (_type == 0) then {
            GVAR(SurgicalAirway_IsPalpating) = true;

            if ([(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRY)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone) && !(GVAR(SurgicalAirway_IncisionSpread))) then {
                GVAR(SurgicalAirway_IncisionSpread) = true;
                private _ctrlIncisionVisual = _display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_INCISIONBIG;

                _ctrlIncisionVisual ctrlSetPositionX GVAR(SurgicalAirway_IncisionX);
                _ctrlIncisionVisual ctrlCommit 0;
                _ctrlIncisionVisual ctrlShow true;
                [LLSTRING(SurgicalAirway_IncisionExpanded), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
            };

            [{
                params ["_display"];

                getMousePosition params ["_mouseX", "_mouseY"];

                !([(ctrlPosition (_display displayCtrl IDC_SURGICAL_AIRWAY_SPACE_ACTIONAREA)), [_mouseX, _mouseY]] call EFUNC(GUI,inZone)) || !(GVAR(SurgicalAirway_IsPalpating))
            }, {
                GVAR(SurgicalAirway_IsPalpating) = false;
            }, [_display], 3600] call CBA_fnc_waitUntilAndExecute;
        } else {
            GVAR(SurgicalAirway_IsPalpating) = false;
        };
    };
};