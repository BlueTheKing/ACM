#include "..\script_component.hpp"
/*
 * Author: mharis001
 * Updates the triage card for the given target.
 *
 * Arguments:
 * 0: Triage list <CONTROL>
 * 1: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrlTriage, _target] call ace_medical_gui_fnc_updateTriageCard
 *
 * Public: No
 */

params ["_ctrl", "_target"];

private _triageCard = _target getVariable [QACEGVAR(medical,triageCard), []];
lbClear _ctrl;

{
    _x params ["_item", "_time"];

    if (_item isEqualType []) then {
        _item params ["_formatString"];

        private _localizedArguments = _item select [1];
        private _localizedArray = [([_formatString, localize _formatString] select (isLocalized _formatString))];

        _localizedArguments = _localizedArguments apply {
            if (_x isEqualType "" && {isLocalized _x}) then {
                localize _x;
            } else {
                _x;
            };
        };

        _localizedArray append _localizedArguments;
        _item = format _localizedArray;
    } else {
        // Check for item displayName or localized text
        if (isClass (configFile >> "CfgWeapons" >> _item)) then {
            _item = getText (configFile >> "CfgWeapons" >> _item >> "displayName");
        } else {
            if (isLocalized _item) then {
                _item = localize _item;
            };
        };
    };

    _ctrl lbAdd format ["%1 - %2", _time, _item];
} forEach _triageCard;

// Handle no triage card entries
if (lbSize _ctrl == 0) then {
    _ctrl lbAdd localize ACELSTRING(medical_treatment,TriageCard_NoEntry);
};
