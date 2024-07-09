#include "..\script_component.hpp"
/*
 * Author: Blue
 * Discard syringe medication
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Medication Classname <STRING>
 * 2: Is IV? <BOOL>
 * 3: Medication Amount <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 'Epinephrine', false, 100] call ACM_circulation_fnc_Syringe_Discard;
 *
 * Public: No
 */

params ["_medic", "_medication", ["_IV", false], "_amount"];

private _sourceString = ["IM","IV"] select _IV;

_medic call ACEFUNC(common,goKneeling);

private _containers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];

{
    private _exit = false;
    private _container = _x;

    private _containerItems = ((magazinesAmmoCargo _container) select {(((_x select 0) splitString "_") select 3) == _medication});  

    if (count _containerItems < 1) then {
        continue;
    };

    {
        _x params ["_classname", "_dose"];

        if (_dose == _amount) then {
            _container addMagazineAmmoCargo [_classname, -1, _amount];
            _exit = true;
            break;
        };
        
    } forEach _containerItems;

    if (_exit) then {
        break;
    };
} forEach _containers;

[2.5, [_medic, _medication, _sourceString, _amount], {
    params ["_args"];
    _args params ["_medic", "_medication", "_sourceString"];

    [_medic, (format ["ACM_Syringe_%1", _sourceString])] call ACEFUNC(common,addToInventory);
    ["Discarded syringe contents", 2, _medic] call ACEFUNC(common,displayTextStructured);
}, {
    params ["_args"];
    _args params ["_medic", "_medication", "_sourceString", "_amount"];

    [_medic, (format ["ACM_Syringe_%1_%2", _sourceString, _medication]), "", _amount] call ACEFUNC(common,addToInventory);
}, (format ["Discarding %1 from %2 syringe...", _medication, _sourceString])] call ACEFUNC(common,progressBar);

