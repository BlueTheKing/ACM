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

params [["_type", 0]];

if (GVAR(SyringeDraw_DrawnAmount) <= 0) exitWith {};

if (_type > 0 && (isNull GVAR(SyringeDraw_Target))) exitWith {};

private _medicationName = localize (format ["STR_ACM_Circulation_Medication_%1", GVAR(SyringeDraw_Medication)]);

if (_type > 0) then { // Push/Inject
    private _iv = true;
    if (_type == 2) then {
        _iv = false;
    };

    [ACE_player, GVAR(SyringeDraw_Medication), GVAR(SyringeDraw_DrawnAmount), GVAR(SyringeDraw_Size)] call FUNC(Syringe_PrepareFinish);

    [2.5, [_iv], {
        (_this select 0) params ["_iv"];

        [ACE_player, GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart), GVAR(SyringeDraw_Medication), GVAR(SyringeDraw_Size), _iv, true] call FUNC(Syringe_Inject);
    }, {}, (format[([LLSTRING(Syringe_Injecting), LLSTRING(Syringe_Pushing)] select _iv), _medicationName]), {true}, ["isNotInside", "isNotSwimming", "isNotInZeus"]] call ACEFUNC(common,progressBar);
} else { // Draw
    
    [4, [_medicationName], {
        (_this select 0) params ["_medicationName"];

        [ACE_player, GVAR(SyringeDraw_Medication), GVAR(SyringeDraw_DrawnAmount), GVAR(SyringeDraw_Size)] call FUNC(Syringe_PrepareFinish);
        [(format [LLSTRING(Syringe_Drawn), _medicationName]), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
    }, {}, (format[LLSTRING(Syringe_Drawing), _medicationName]), {true}, ["isNotInside", "isNotSwimming", "isNotInZeus"]] call ACEFUNC(common,progressBar);
};