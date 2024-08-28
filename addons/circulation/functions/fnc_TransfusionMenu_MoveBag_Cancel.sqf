#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
/*
 * Author: Blue
 * Handle exiting transfusion menu while moving fluid bag.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call ACM_circulation_fnc_TransfusionMenu_MoveBag_Cancel;
 *
 * Public: No
 */

params ["_patient"];

private _originIV = GVAR(TransfusionMenu_Move_OriginIV);
private _originBodyPart = GVAR(TransfusionMenu_Move_OriginBodyPart);

GVAR(TransfusionMenu_Move_IVBagContents) params ["_type", "_remainingVolume", "_accessType", "_accessSite", "_iv", "_bloodType", "_volume"];

if !([([_patient, _originBodyPart, 0] call FUNC(hasIO)), ([_patient, _originBodyPart, 0, GVAR(TransfusionMenu_Move_OriginAccessSite)] call FUNC(hasIV))] select _originIV) exitWith { // Can't return to list
    private _returnAmount = [_volume] call FUNC(getReturnVolume);

    if (_returnAmount > 0) then {
        ["Fluid bag returned", 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
        private _itemClassName = [_type, _targetVolume, _bloodType] call FUNC(formatFluidBagName);
        [ACE_player, _itemClassname] call ACEFUNC(common,addToInventory);
    };
};

private _IVBags = _patient getVariable [QGVAR(IV_Bags), createHashMap];
private _IVBagsOnBodyPart = _IVBags getOrDefault [GVAR(TransfusionMenu_Selected_BodyPart), []];

_IVBagsOnBodyPart pushBack [_type, _remainingVolume, ([_patient, _originIV, (ALL_BODY_PARTS find tolowerANSI _originBodyPart), GVAR(TransfusionMenu_Move_OriginAccessSite)] call FUNC(getAccessType)), _accessSite, _originIV, _bloodType, _volume];
_IVBags set [GVAR(TransfusionMenu_Selected_BodyPart), _IVBagsOnBodyPart];

_patient setVariable [QGVAR(IV_Bags), _IVBags, true];
[_patient, _bodyPart] call EFUNC(circulation,updateActiveFluidBags);