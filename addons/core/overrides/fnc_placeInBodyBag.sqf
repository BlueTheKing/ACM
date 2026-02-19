#include "..\script_component.hpp"
/*
 * Author: Glowbal, drofseh
 * Places a dead body inside a body bag.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part (unused) <STRING>
 * 3: Treatment (unused) <STRING>
 * 4: Item user (unused) <OBJECT>
 * 5: Body bag classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject] call ace_medical_treatment_fnc_placeInBodyBag
 *
 * Public: No
 */

params ["_medic", "_patient", "", "", "", "_item"];
TRACE_1("placeInBodyBag",_patient);

if ((alive _patient) && {!ACEGVAR(medical_treatment,allowBodyBagUnconscious)}) exitWith {
    [_medic, _item] call ACEFUNC(common,addToInventory); // re-add slighly used bodybag?
    [ACELSTRING(medical_treatment,bodybagWhileStillAlive)] call ACEFUNC(common,displayTextStructured);
};

private _tourniquetCount = 0;
private _pulseOximeterCount = 0;
private _pressureCuffCount = 0;

{
    if (_x > 0) then {
        _tourniquetCount = _tourniquetCount + 1;
    };
} forEach GET_TOURNIQUETS(_patient);

{
    if (_x) then {
        _pulseOximeterCount = _pulseOximeterCount + 1;
    };
} forEach GET_PULSEOX(_patient);

{
    if (_x) then {
        _pressureCuffCount = _pressureCuffCount + 1;
    };
} forEach GET_PRESSURECUFF(_patient);

if ((_tourniquetCount + _pulseOximeterCount + _pressureCuffCount) > 0) then {
    for "_i" from 1 to _tourniquetCount do {
        [_medic, "ACE_tourniquet"] call ACEFUNC(common,addToInventory);
    };

    for "_i" from 1 to _pulseOximeterCount do {
        [_medic, "ACM_PulseOximeter"] call ACEFUNC(common,addToInventory);
    };

    for "_i" from 1 to _pressureCuffCount do {
        [_medic, "ACM_PressureCuff"] call ACEFUNC(common,addToInventory);
    };

    [LLSTRING(BodyBagReturnedItems), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

// Body bag needs to be a little higher to prevent it from flipping
private _bodyBagClass = getText (configFile >> "CfgWeapons" >> _item >> QACEGVAR(medical_treatment,bodyBagObject));
[_this, _bodyBagClass, [0, 0, 0.2], 0, false] call ACEFUNC(medical_treatment,placeInBodyBagOrGrave);
