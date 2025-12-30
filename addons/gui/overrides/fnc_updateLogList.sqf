#include "..\script_component.hpp"
/*
 * Author: mharis001
 * Updates list control with given logs.
 *
 * Arguments:
 * 0: Log list <CONTROL>
 * 1: Log to add <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrlActivityLog, _activityLog] call ace_medical_gui_fnc_updateLogList
 *
 * Public: No
 */

params ["_ctrl", "_logs"];

lbClear _ctrl;

{
    _x params ["_message", "_timeStamp", "_arguments"];

    private _unlocalizedMessage = _message;

    // Localize message and arguments
    if (isLocalized _message) then {
        _message = localize _message;
    };

    private _complexArguments = false;

    {
        if (_x isEqualType []) exitWith {
            _complexArguments = true;
            break;
        };
        
    } forEach _arguments;

    if (_complexArguments) then {
        _arguments = _arguments apply {
            if (_x isEqualType []) then {
                private _entry = _x select 0;
                private _extraArguments = _x select [1];

                private _localizedArray = [([_entry, localize _entry] select (isLocalized _entry))];

                _extraArguments = _extraArguments apply {
                    if (_x isEqualType "" && {isLocalized _x}) then {
                        localize _x;
                    } else {
                        _x;
                    };
                };

                _localizedArray append _extraArguments;

                format _localizedArray;
            } else {
                if (_x isEqualType "" && {isLocalized _x}) then {
                    localize _x;
                } else {
                    _x;
                };
            };
        };
    } else {
        _arguments = _arguments apply {
            if (_x isEqualType "" && {isLocalized _x}) then {
                localize _x;
            } else {
                _x;
            };
        };
    };

    // Format message with arguments
    _message = format ([_message] + _arguments);

    private _row = _ctrl lbAdd format ["%1 %2", _timeStamp, _message];

    [QACEGVAR(medical_gui,logListAppended), [_ctrl, _row, _message, _unlocalizedMessage, _timeStamp, _arguments]] call CBA_fnc_localEvent;
} forEach _logs;
