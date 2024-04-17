#include "..\script_component.hpp"
/*
 * Author: Blue
 * List fluid bags on selected body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Bodypart Index <NUMBER>
 *
 * Return Value:
 * Fluid bag volume on bodypart <STRING>
 *
 * Example:
 * [player, 2] call ACM_GUI_fnc_getBodyPartIVBags;
 *
 * Public: No
 */

params ["_patient", "_partIndex"];

private _bloodVolume = 0;
private _plasmaVolume = 0;
private _salineVolume = 0;

{
    _x params ["_bodyPart", "_type", "_volumeRemaining"];

    if (_bodyPart == _partIndex) then {

        switch (_type) do {
            case "Plasma": {_plasmaVolume = _plasmaVolume + _volumeRemaining;};
            case "Saline": {_salineVolume = _salineVolume + _volumeRemaining;};
            default {_bloodVolume = _bloodVolume + _volumeRemaining;};
        };
    };
} forEach (_patient getVariable [QACEGVAR(medical,ivBags), []]);

private _output = [];

if (_bloodVolume > 0) then {
    _output pushBack format ["B: %1ml", floor(_bloodVolume)];
};

if (_plasmaVolume > 0) then {
	_output pushBack format ["P: %1ml", floor(_plasmaVolume)];
};

if (_salineVolume > 0) then {
	_output pushBack format ["S: %1ml", floor(_salineVolume)];
};

_output joinString " ";