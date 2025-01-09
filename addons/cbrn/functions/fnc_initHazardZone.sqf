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
 * 4: Affect AI <BOOL>
 * 5: Manual Placement <BOOL>
 *
 * Return Value:
 * Hazard Origin Object <OBJECT>
 *
 * Example:
 * [cursorTarget, false, "Chemical_CS", [5,5,0,false,-1], false, false] call ACM_CBRN_fnc_initHazardZone;
 *
 * Public: No
 */

params ["_target", ["_attached", false], "_hazardType", ["_radiusDimensions", [5,5,0,false,-1]], ["_affectAI", false], ["_manualPlaced", true]];

private _originObject = "ACM_HazardOriginObject" createVehicle (position _target);
private _helperObject = objNull;

if (_manualPlaced) then {
    _helperObject = "ACM_HazardHelperObject" createVehicle (position _originObject);
    _helperObject attachTo [_originObject, [0,0,-100]];
    _originObject setVariable [QGVAR(referenceObject), _helperObject, true];
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

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_originObject", "_helperObject", "_zoneID", "_hazardRadius", "_manualPlaced"];

    private _hazardType = _originObject getVariable [QGVAR(hazardType), ""];
    private _affectAI = _originObject getVariable [QGVAR(affectAI), false];

    if (isNull _originObject || _hazardType == "") exitWith { // Remove everything if zone is deleted
        if (_manualPlaced) then {
            if !(isNull _helperObject) then {
                private _visualArray = _helperObject getVariable [QGVAR(visualArray), []];
                if (count _visualArray > 0) then {
                    {
                        deleteVehicle _x;
                    } forEachReversed _visualArray;
                };
                deleteVehicle _helperObject;
            };
        };
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
            systemchat format ["%1",_x];
            [QGVAR(initHazardUnit), [_x, _hazardType], _x] call CBA_fnc_targetEvent;
        };
    } forEach _unitsInZone;
}, 1, [_originObject, _helperObject, _zoneID, _hazardRadius, _manualPlaced]] call CBA_fnc_addPerFrameHandler;

_originObject setVariable [QGVAR(HazardEmitter_PFH), _PFH];

_originObject attachTo [_target, [0,0,0]];

if !(_attached) then {
    detach _originObject;

    _originObject setPosATL [(getPosATL _originObject) select 0, (getPosATL _originObject) select 1, ((getPosATL _originObject) select 2) max 0];
};

_originObject;