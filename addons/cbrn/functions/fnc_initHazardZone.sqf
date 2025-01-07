#include "..\script_component.hpp"
/*
 * Author: Blue
 * Initialize hazard zone radius
 *
 * Arguments:
 * 0:  <LOGIC>
 *
 * Return Value:
 * Hazard origin object <OBJECT>
 *
 * Example:
 * [cursorTarget, false, "chemical_cs", [5,5,0,false,-1], false] call ACM_CBRN_fnc_initHazardZone;
 *
 * Public: No
 */

params ["_target", ["_attached", false], "_hazardType", ["_radiusDimensions", [5,5,0,false,-1]], ["_affectAI", false]];

systemchat format ["%1", _target];

private _originObject = "ACM_HazardOriginObject" createVehicle (position _target);

private _helperObject = "ACM_HazardHelperObject" createVehicle (position _originObject);
_helperObject attachTo [_originObject, [0,0,0]];
_originObject setVariable [QGVAR(referenceObject), _helperObject, true];

private _hazardRadius = [_originObject, "AREA:", _radiusDimensions, "ACT:", ["NONE", "PRESENT", false], "STATE:", ["false", "", ""]] call CBA_fnc_createTrigger;
_hazardRadius = _hazardRadius select 0;

private _zoneID = -1;
private _zoneList = missionNamespace getVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), []];

if (count _zoneList > 0) then {
    private _newID = (_zoneList select ((count _zoneList) - 1) select 0) + 1;
    _zoneID = _newID;
    _zoneList pushBack [_newID, _hazardRadius];
} else {
    _zoneID = 1;
    _zoneList pushBack [1, _hazardRadius];
};

missionNamespace setVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), _zoneList, true];

_originObject setVariable [QGVAR(zoneID), _zoneID, true];
_originObject setVariable [QGVAR(hazardType), _hazardType, true];
_originObject setVariable [QGVAR(affectAI), _affectAI, true];

private _pfh = [{
    params ["_args", "_idPFH"];
    _args params ["_originObject", "_helperObject", "_hazardRadius"];

    private _zoneID = _originObject getVariable [QGVAR(zoneID), -1];
    private _hazardType = _originObject getVariable [QGVAR(hazardType), ""];
    private _affectAI = _originObject getVariable [QGVAR(affectAI), false];

    if (isNull _originObject || _hazardType == "") exitWith { // Remove everything if zone is deleted
        if !(isNull _helperObject) then {
            private _visualArray = _helperObject getVariable [QGVAR(visualArray), []];
            if (count _visualArray > 0) then {
                for "_i" from 0 to ((count _visualArray) - 1) do {
                    deleteVehicle (_visualArray select _i);
                };
            };
            deleteVehicle _helperObject;
        };
        deleteVehicle _hazardRadius;

        private _allZones = missionNamespace getVariable [(format ["ACM_CBRN_%1_HazardZones", toLower _hazardType]), []];
        private _clearIndex = _allZones findIf {_x select 0 isEqualTo _zoneID};

        if (_clearIndex != -1) then {
            _allZones deleteAt _clearIndex;
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
}, 1, [_originObject, _helperObject, _hazardRadius]] call CBA_fnc_addPerFrameHandler;

_originObject setVariable [QGVAR(HazardEmitter_PFH), _pfh];

_originObject attachTo [_target, [0,0,0]];

if !(_attached) then {
    detach _originObject;

    _originObject setPosATL [(getPosATL _originObject) select 0, (getPosATL _originObject) select 1, ((getPosATL _originObject) select 2) max 0];
};

_originObject;