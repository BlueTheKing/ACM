#include "..\script_component.hpp"
/*
 * Author: Blue
 * List fluid bags on selected body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Is IV? <BOOL>
 * 3: Access Site <NUMBER>
 * 4: Access Type <NUMBER>
 *
 * Return Value:
 * Fluid bag volume on bodypart <STRING>
 *
 * Example:
 * [player, 2, true, 0, ACM_IV_16G_M] call ACM_GUI_fnc_getBodyPartIVBags;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", ["_iv", true], ["_accessSite", -1], ["_accessType", -1]];

private _bloodVolume = 0;
private _freshBloodVolume = 0;
private _plasmaVolume = 0;
private _salineVolume = 0;
private _FBTKVolume = 0;

private _accessBodyPart = (_patient getVariable [QEGVAR(circulation,IV_Bags), createHashMap]) getOrDefault [_bodyPart, []];

if (_iv) then {
    {
        _x params ["_type", "_volumeRemaining", "_bagAccessType", "_bagAccessSite", "_iv"];

        if (_iv && _accessType == _accessType && _bagAccessSite == _accessSite) then {
            switch (_type) do {
                case "Plasma": {_plasmaVolume = _plasmaVolume + _volumeRemaining;};
                case "Saline": {_salineVolume = _salineVolume + _volumeRemaining;};
                case "FBTK": {_FBTKVolume = _FBTKVolume + _volumeRemaining;};
                case "FreshBlood": {_freshBloodVolume = _freshBloodVolume + _volumeRemaining;};
                default {_bloodVolume = _bloodVolume + _volumeRemaining;};
            };
        };
    } forEach _accessBodyPart;
} else {
    {
        _x params ["_type", "_volumeRemaining", "_bagAccessType", "_bagAccessSite", "_iv"];

        if !(_iv) then {
            switch (_type) do {
                case "Plasma": {_plasmaVolume = _plasmaVolume + _volumeRemaining;};
                case "Saline": {_salineVolume = _salineVolume + _volumeRemaining;};
                case "FreshBlood": {_freshBloodVolume = _freshBloodVolume + _volumeRemaining;};
                default {_bloodVolume = _bloodVolume + _volumeRemaining;};
            };
        };
    } forEach _accessBodyPart;
};

private _output = [];

if (_FBTKVolume > 0) then {
	_output pushBack format ["%1: %2ml", LELSTRING(circulation,GUI_TransfusingVolume_FieldBloodTransfusionKit_Short), floor(_FBTKVolume)];
};

if (_freshBloodVolume > 0) then {
    _output pushBack format ["%1: %2ml", LELSTRING(circulation,GUI_TransfusingVolume_FreshWholeBlood_Short), floor(_freshBloodVolume)];
};

if (_bloodVolume > 0) then {
    _output pushBack format ["%1: %2ml", LELSTRING(circulation,GUI_TransfusingVolume_Blood_Short), floor(_bloodVolume)];
};

if (_plasmaVolume > 0) then {
	_output pushBack format ["%1: %2ml", LELSTRING(circulation,GUI_TransfusingVolume_Plasma_Short), floor(_plasmaVolume)];
};

if (_salineVolume > 0) then {
	_output pushBack format ["%1: %2ml", LELSTRING(circulation,GUI_TransfusingVolume_Saline_Short), floor(_salineVolume)];
};

_output joinString " ";