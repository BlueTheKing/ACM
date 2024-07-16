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
 * 4: Is IV? <BOOL>
 * 5: Access Site <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1, true, 0] call ACM_circulation_fnc_setIVLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_iv", "_accessSite"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

if (_iv) then {
    private _IVState = GET_IV(_patient);
    private _IVStateBodyPart = +(_IVState select _bodyPart);

    _IVStateBodyPart set [_accessSite, _type];
    _IVState set [_partIndex, _IVStateBodyPart];

    _patient setVariable [QGVAR(IV_Placement), _IVState, true];
} else {
    private _IOState = GET_IO(_patient);

    _IOState set [_partIndex, _type];

    _patient setVariable [QGVAR(IO_Placement), _IOState, true];
};

if (_type == 0) then {
    private _ivBags = _patient getVariable [QGVAR(IV_Bags), createHashMap];
    private _ivBagsBodyPart = _ivBags getOrDefault [_bodyPart, []];

    {
        _x params ["_bagType", "_volume", "_accessType", "_bagAccessSite", "_bagIV", "_bloodType"];
        
        if (_bagIV == _iv && _bagAccessSite == _accessSite) then {
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

    _ivBags set [_bodyPart, _ivBagsBodyPart];

    _patient setVariable [QGVAR(IV_Bags), _ivBags, true];
};