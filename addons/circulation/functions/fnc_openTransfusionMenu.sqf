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

GVAR(TransfusionMenu_Target) = _patient;
GVAR(TransfusionMenu_SelectIV) = true;
GVAR(TransfusionMenu_Selected_BodyPart) = _bodyPart;
GVAR(TransfusionMenu_Selected_AccessSite) = 0;

createDialog QGVAR(TransfusionMenu_Dialog);
uiNamespace setVariable [QGVAR(TransfusionMenu_DLG),(findDisplay IDC_TRANSFUSIONMENU)];

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

call FUNC(TransfusionMenu_UpdateSelection);

private _ctrlPatientName = _display displayCtrl IDC_TRANSFUSIONMENU_PATIENTNAME;

_ctrlPatientName ctrlSetText ([_patient, false, true] call ACEFUNC(common,getName));

[{
    params ["_args", "_idPFH"];
    //_args params [];

    if (isNull findDisplay IDC_TRANSFUSIONMENU) exitWith {
        systemchat "closed";
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    
}, 0, []] call CBA_fnc_addPerFrameHandler;