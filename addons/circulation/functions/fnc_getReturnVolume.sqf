#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get rounded down return volume of fluid.
 *
 * Arguments:
 * 0: Volume <NUMBER>
 *
 * Return Value:
 * Volume <NUMBER>
 *
 * Example:
 * [500] call ACM_circulation_fnc_getReturnVolume;
 *
 * Public: No
 */

params ["_volume"];

private _returnVolume = 1000;

if (_volume < 1000) then {
    if (_volume < 500) then {
        if (_volume < 250) then {
            _returnVolume = 0;
        } else {
            _returnVolume = 250;
        };
    } else {
        _returnVolume = 500;
    };
};

_returnVolume;