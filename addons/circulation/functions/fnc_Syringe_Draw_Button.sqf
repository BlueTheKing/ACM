#include "..\script_component.hpp"
#include "..\SyringeDraw_defines.hpp"
/*
 * Author: Blue
 * Handle button press in syringe draw dialog.
 *
 * Arguments:
 * 0: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0] call ACM_circulation_fnc_Syringe_Draw_Button;
 *
 * Public: No
 */

params [["_type", false]];

if (GVAR(SyringeDraw_DrawnAmount) <= 0) exitWith {};

if (_type > 0 && (isNull GVAR(SyringeDraw_Target))) exitWith {};

[ACE_player, GVAR(SyringeDraw_Medication), GVAR(SyringeDraw_DrawnAmount), GVAR(SyringeDraw_Size)] call FUNC(Syringe_PrepareFinish);

if (_type > 0) then { // Push/Inject
    private _iv = true;
    if (_type == 2) then {
        _iv = false;
    };

    [2.5, [_iv], {
        (_this select 0) params ["_iv"];

        [ACE_player, GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart), GVAR(SyringeDraw_Medication), GVAR(SyringeDraw_Size), _iv, true] call FUNC(Syringe_Inject);
    }, {}, (format[([LLSTRING(Syringe_Injecting), LLSTRING(Syringe_Pushing)] select _iv), GVAR(SyringeDraw_Medication)])] call ACEFUNC(common,progressBar);
} else { // Draw
    [(format [LLSTRING(Syringe_Drawn), GVAR(SyringeDraw_Medication)]), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
    closeDialog 0;
};