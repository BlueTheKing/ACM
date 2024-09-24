#include "..\script_component.hpp"
#include "..\TreatmentText_defines.hpp"
/*
 * Author: Blue
 * Handle treatment text hud element. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_treatmentTextPFH;
 *
 * Public: No
 */

params ["_patient"];

if ((_patient getVariable [QGVAR(TreatmentText_PFH), -1]) != -1) exitWith {};

if (isNull (uiNamespace getVariable ["ACM_TreatmentText", displayNull])) then {
    "ACM_TreatmentText" cutRsc ["RscTreatmentText", "PLAIN", 0, false];
};

private _display = uiNamespace getVariable ["ACM_TreatmentText", displayNull];

private _ctrlText = _display displayCtrl IDC_TREATMENTTEXT_TEXT;

_ctrlText ctrlSetFade 1;
_ctrlText ctrlCommit 0;

_ctrlText ctrlSetFade 0;
_ctrlText ctrlCommit 0.5;

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _treatmentProviders = _patient getVariable [QGVAR(TreatmentText_Providers), []];
    private _display = uiNamespace getVariable ["ACM_TreatmentText", displayNull];
    private _ctrlText = _display displayCtrl IDC_TREATMENTTEXT_TEXT;

    if (count _treatmentProviders < 1 || !(alive _patient)) exitWith {
        _patient setVariable [QGVAR(TreatmentText_PFH), -1];
        
        _ctrlText ctrlSetFade 1;
        _ctrlText ctrlCommit 0.5;

        if !(alive _patient) then {
            _patient setVariable [QGVAR(TreatmentText_Providers), []];
        };

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _text = format [LLSTRING(TreatedBy), ([(_treatmentProviders select 0), false, true] call ACEFUNC(common,getName))];

    if (count _treatmentProviders > 1) then {
        _text = format ["%1 (+%2)", _text, ((count _treatmentProviders) - 1)];
    };

    _ctrlText ctrlSetText _text;
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(TreatmentText_PFH), _PFH];