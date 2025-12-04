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
    private _IVStateBodyPart = +(_IVState select _partIndex);

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

    if (count _ivBagsBodyPart < 1) exitWith {};

    {
        _x params ["_bagType", "_volume", "_accessType", "_bagAccessSite", "_bagIV", "_bloodType"];
        
        if (_bagIV == _iv && _bagAccessSite == _accessSite) then {
            private _returnAmount = [_volume] call FUNC(getReturnVolume);

            if (_returnAmount > 0) then {
                private _itemClassName = [_bagType, _targetVolume, _bloodType] call FUNC(formatFluidBagName);
                [_medic, _itemClassname] call ACEFUNC(common,addToInventory);
            };
            _ivBagsBodyPart deleteAt _forEachIndex;
        };
    } forEachReversed _ivBagsBodyPart;

    _ivBags set [_bodyPart, _ivBagsBodyPart];

    _patient setVariable [QGVAR(IV_Bags), _ivBags, true];
} else {
    if !(_iv) then {
        private _givePain = [0, 0.31] select (_type in [ACM_IO_FAST1_M,ACM_IO_EZ_M]);

        private _suppressPain = linearConversion [0, 40, ([_patient, "Lidocaine", [ACM_ROUTE_IM], _partIndex] call FUNC(getMedicationConcentration)), 0, 0.3, true]; // 40mg IM
        private _pain = 0 max (_givePain - _suppressPain);

        [_patient, _pain] call ACEFUNC(medical,adjustPainLevel);

        if (_pain > 0.15) then {
            [_patient, "hit"] call ACEFUNC(medical_feedback,playInjuredSound);
        };
    };
};