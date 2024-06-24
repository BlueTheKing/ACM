#include "..\script_component.hpp"
#include "..\SyringeDraw_defines.hpp"
/*
 * Author: Blue
 * Handle button press in syringe draw dialog.
 *
 * Arguments:
 * 0: Push Medication? <BOOl>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false] call ACM_circulation_fnc_Syringe_Draw_Button;
 *
 * Public: No
 */

params [["_push", false]];

if (GVAR(SyringeDraw_DrawnAmount) <= 0) exitWith {};

if (_push && (isNull GVAR(SyringeDraw_Target))) exitWith {};

[ACE_player, GVAR(SyringeDraw_Medication), GVAR(SyringeDraw_DrawnAmount), GVAR(SyringeDraw_IV)] call FUNC(Syringe_PrepareFinish);

if (_push) then {
    private _string = "Pushing";

    if !(GVAR(SyringeDraw_IV)) then {
        _string = "Injecting";
    };
    
    [2.5, [], {
        [ACE_player, GVAR(SyringeDraw_Target), GVAR(SyringeDraw_TargetPart), GVAR(SyringeDraw_Medication), true, GVAR(SyringeDraw_IV)] call FUNC(Syringe_Inject);
    }, {}, (format["%1 %2...", _string, GVAR(SyringeDraw_Medication)])] call ACEFUNC(common,progressBar);
} else {
    [(format ["%1 Drawn", GVAR(SyringeDraw_Medication)]), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
    closeDialog 0;
};