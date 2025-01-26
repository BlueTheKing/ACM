#include "..\script_component.hpp"
/*
 * Author: Blue
 * Initialize hazard zone radius. (SERVER)
 *
 * Arguments:
 * 0: Placement Reference Object <OBJECT>
 * 1: Attached <BOOL>
 * 2: Hazard Type <STRING>
 * 3: Radius Dimensions <ARRAY[NUMBER,NUMBER,NUMBER,BOOL,NUMBER]>
 * 4: Effect Time <NUMBER>
 * 5: Affect AI <BOOL>
 * 6: Manual Placement <BOOL>
 * 7: Spawner (Player) <OBJECT>
 *
 * Return Value:
 * Hazard Origin Object <OBJECT>
 *
 * Example:
 * [cursorTarget, false, "Chemical_CS", [5,5,0,false,-1], -1, false, false, player] call ACM_CBRN_fnc_initHazardZone;
 *
 * Public: No
 */

params ["_target", ["_attached", false], "_hazardType", ["_radiusDimensions", []], ["_effectTime", -1], ["_affectAI", false], ["_manualPlaced", true], ["_spawner", objNull]];

private _originObject = "ACM_HazardOriginObject" createVehicle (position _target);

if (_radiusDimensions isEqualTo []) then {
    _radiusDimensions = [5,5,0,false,-1];
};

if !(_affectAI) then {
    _affectAI = false; //TODO setting
};
// [a (X), b (Y), angle, isRectangle, c (height)]
private _hazardRadius = [_originObject, "AREA:", _radiusDimensions, "ACT:", ["NONE", "PRESENT", false], "STATE:", ["false", "", ""]] call CBA_fnc_createTrigger;
_hazardRadius = _hazardRadius select 0;

private _zoneID = -1;
private _zoneList = missionNamespace getVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), createHashMap];

_zoneID = ([1, ((count _zoneList) + 1)] select (count _zoneList > 0));

if ((_zoneList getOrDefault [_zoneID, []]) isEqualTo []) then {
    while {(_zoneList getOrDefault [_zoneID, []]) isNotEqualTo []} do {
        _zoneID = _zoneID + 1;
    };
};

_zoneList set [_zoneID, [_hazardRadius, _affectAI]];

missionNamespace setVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), _zoneList, true];

_originObject setVariable [QGVAR(zoneID), _zoneID, true];
_originObject setVariable [QGVAR(hazardType), _hazardType, true];
_originObject setVariable [QGVAR(affectAI), _affectAI, true];

private _effectTimeOutTime = -1;

if (_effectTime > -1) then {
    _effectTimeOutTime = CBA_missionTime + _effectTime;
};

_originObject setVariable [QGVAR(effectTimeout), _effectTimeOutTime, true];

if (_attached) then {
    _hazardRadius attachTo [_target, [0,0,0]];
};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_originObject", "_zoneID", "_hazardRadius", "_manualPlaced", "_attached"];

    private _hazardType = _originObject getVariable [QGVAR(hazardType), ""];
    private _affectAI = _originObject getVariable [QGVAR(affectAI), false];

    private _effectTimeout = _originObject getVariable [QGVAR(effectTimeout), -1];

    private _effectDone = _effectTime > -1 && {_effectTimeout < CBA_missionTime};

    if (_effectDone || isNull _originObject || _hazardType == "") exitWith {
        deleteVehicle _hazardRadius;

        private _allZones = missionNamespace getVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), createHashMap];

        if ((_allZones getOrDefault [_zoneID, []]) isNotEqualTo []) then {
            _allZones deleteAt _zoneID;
            missionNamespace setVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), _allZones, true];
        };

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _unitsInZone = [];
    
    if (_affectAI) then {
        _unitsInZone = allUnits inAreaArray _hazardRadius;
    } else {
        _unitsInZone = allPlayers inAreaArray _hazardRadius;
    };

    {
        if (_x getVariable [(format ["ACM_CBRN_%1_PFH", toLower _hazardType]), -1] == -1) then {
            //systemchat format ["%1",_x];
            [QGVAR(initHazardUnit), [_x, _hazardType], _x] call CBA_fnc_targetEvent;
        };
    } forEach _unitsInZone;

    if (_attached) then {
        (getPosATL _hazardRadius) params ["_radiusPosX", "_radiusPosY", "_radiusPosZ"];
        _originObject setPos [_radiusPosX, _radiusPosY, 0];
    };
}, 1, [_originObject, _zoneID, _hazardRadius, _manualPlaced, _attached]] call CBA_fnc_addPerFrameHandler;

_originObject setVariable [QGVAR(HazardEmitter_PFH), _PFH];

if (_manualPlaced) then {
    if (isNull _spawner) exitWith {};
    [QGVAR(showRadius), [_spawner, _originObject, _radiusDimensions], _spawner] call CBA_fnc_targetEvent;
};

_originObject;