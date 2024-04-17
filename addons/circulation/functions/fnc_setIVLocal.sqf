#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV placement on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1] call ACM_circulation_fnc_setIVLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type"];

private _IVState = GET_IV(_patient);

private _partIndex = ALL_BODY_PARTS find _bodyPart;

_IVState set [_partIndex, _type];

_patient setVariable [QGVAR(IV_Placement), _IVState, true];

if (_type == 0) then {
    private _ivBags = _patient getVariable [QACEGVAR(medical,ivBags), []];

    {
        _x params ["_bodyPartIndex", "_type", "_volume", "_bloodType"];
        
        if (_bodyPartIndex == _partIndex) then {
            private _returnAmount = 500;

            if (_volume < 500) then {
                if (_volume < 250) then {
                    _returnAmount = 0;
                } else {
                    _returnAmount = 250;
                };
            };

            if (_returnAmount > 0) then {
                private _itemClassname = switch (_type) do {
                    case "Blood": {
                        format ["ACM_BloodBag_%1_%2", ([_bloodType, 2] call FUNC(convertBloodType)), _returnAmount];
                    };
                    case "Saline": {
                        format ["ACE_SalineIV_%1", _returnAmount];
                    };
                    default {
                        format ["ACE_PlasmaIV_%1", _returnAmount];
                    };
                };

                [_medic, _itemClassname] call ACEFUNC(common,addToInventory);
            };
            _ivBags deleteAt _forEachIndex;
        };
    } forEachReversed _ivBags;

    _patient setVariable [QACEGVAR(medical,ivBags), _ivBags, true];
};