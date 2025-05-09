#include "..\script_component.hpp"
#include "..\SurgicalAirway_defines.hpp"
/*
 * Author: Blue
 * Handle performing action while establishing surgical airway. (LOCAL)
 *
 * Arguments:
 * 0: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0] call ACM_airway_fnc_SurgicalAirway_action;
 *
 * Public: No
 */

params ["_type"];

private _progress = GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_Progress), 0];

private _display = uiNamespace getVariable [QGVAR(SurgicalAirway_DLG), displayNull];
private _ctrlPlacedHook = _display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_PLACED_HOOK;

if (_progress > 0) then {
    if (_progress == _type && _progress < 4) then {
        _progress = _type + 1;
        GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_Progress), _progress, true];
    };

    private _ctrlPlacedTube = _display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_PLACED_TUBE;

    switch (true) do {
        case (!(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_HookInserted), false]) && _progress == 2): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_HookInserted), true, true];
            [SURGICAL_AIRWAY_SELECTED_NONE] call FUNC(SurgicalAirway_select);
            [LLSTRING(SurgicalAirway_LiftIncision_Complete), 2, ACE_player] call ACEFUNC(common,displayTextStructured);

            (_display displayCtrl IDC_SURGICAL_AIRWAY_VISUAL_INCISIONBIG) ctrlSetText QPATHTOF(ui\surgical_airway\incision_2_0.paa);
            _ctrlPlacedHook ctrlShow true;
        };
        case (GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_HookInserted), false] && _progress == 4): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_HookInserted), false, true];
            [SURGICAL_AIRWAY_SELECTED_HOOK] call FUNC(SurgicalAirway_select);
            [LLSTRING(SurgicalAirway_RemoveHook_Complete), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);

            _ctrlPlacedHook ctrlShow false;
        };
        case (!(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_TubeInserted), false]) && _progress == 3): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_TubeInserted), true, true];
            [SURGICAL_AIRWAY_SELECTED_NONE] call FUNC(SurgicalAirway_select);
            [LLSTRING(SurgicalAirway_InsertTube_Complete), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);

            _ctrlPlacedTube ctrlShow true;
        };
        case (_progress > 3 && _type == 4 && GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_TubeInserted), false] && !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_HookInserted), false])): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_CuffInflated), true, true];
            [LLSTRING(SurgicalAirway_InflateTubeCuff_Complete), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);

            if (!(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_State), false]) && !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StyletInserted), false])) then {
                GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_State), true, true];
            };
        };
        case (_progress > 3 && _type == 5 && GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_TubeInserted), false] && !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_HookInserted), false])): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_StyletInserted), false, true];
            [LLSTRING(SurgicalAirway_RemoveTubeStylet_Complete), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);

            if (!(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_State), false]) && GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_CuffInflated), false]) then {
                GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_State), true, true];
            };

            _ctrlPlacedTube ctrlSetText QPATHTOF(ui\surgical_airway\placed_tube_1.paa);
        };
        case (_progress > 3 && _type == 6 && GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_TubeInserted), false] && !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StyletInserted), false])): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_StrapConnected), true, true];
            [LLSTRING(SurgicalAirway_ConnectStrap_Complete), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
        };
        case (_progress > 3 && _type == 7 && GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_TubeInserted), false] && !(GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StyletInserted), false]) && GVAR(SurgicalAirway_Target) getVariable [QGVAR(SurgicalAirway_StrapConnected), false]): {
            GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_StrapSecure), true, true];
            [SURGICAL_AIRWAY_SELECTED_NONE] call FUNC(SurgicalAirway_select);
            [LLSTRING(SurgicalAirway_SecureStrap_Complete), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);

            _ctrlPlacedTube ctrlSetText QPATHTOF(ui\surgical_airway\placed_tube_2.paa);
        };
        default {};
    };
} else {
    if (_type == 0) then {
        GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_Progress), 1, true];
        GVAR(SurgicalAirway_Target) setVariable [QGVAR(SurgicalAirway_Incision), true, true];

        _ctrlPlacedHook ctrlSetPositionX ((GVAR(SurgicalAirway_IncisionX) + (ACM_SURGICAL_AIRWAY_VISUAL_INCISION_W / 2)) - (((ctrlPosition _ctrlPlacedHook) select 2) / 2));
        _ctrlPlacedHook ctrlCommit 0;
    };
};
 
[] call FUNC(SurgicalAirway_updateActions);