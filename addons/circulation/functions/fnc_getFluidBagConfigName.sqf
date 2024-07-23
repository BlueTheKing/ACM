#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get config entry for fluid bags.
 *
 * Arguments:
 * 0: Is ACE? <BOOL>
 * 1: Type <STRING>
 * 2: Volume <NUMBER>
 * 3: Blood Type <NUMBER>
 * 4: Don't add prefix <BOOL>
 *
 * Return Value:
 * Fluid Bag Config Name <STRING>
 *
 * Example:
 * [true, "Plasma", 1000, -1, false] call ACM_circulation_fnc_getFluidBagConfigName;
 *
 * Public: No
 */

params ["_isACE", "_type", "_volume", ["_bloodType", -1], ["_noPrefix", false]];

private _prefix = "";

if !(_noPrefix) then {
    _prefix = ["ACM_", "ACE_"] select _isACE;
};

if (_isACE) exitWith {
    private _volumeFormat = "";

    if (_volume < 1000) then {
        _volumeFormat = format ["_%1", _volume];
    };

    (format ["%1%2IV%3", _prefix, toLower _type, _volumeFormat]);
};

switch (_type) do {
    case "Blood": {
        format ["%1%2_%3_%4", _prefix, _type, ([_bloodType, 2] call FUNC(convertBloodType)), _volume];
    };
};