#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Update total wound bleeding based on open wounds and tourniquets
 * Wound bleeding = percentage of cardiac output lost
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player] call ace_medical_status_fnc_updateWoundBloodLoss
 *
 * Public: No
 */

params ["_unit"];

private _tourniquets = GET_TOURNIQUETS(_unit);
private _bodyPartBleeding = [0,0,0,0,0,0];
{
    private _partIndex = ALL_BODY_PARTS find _x;
    if (_tourniquets select _partIndex == 0) then {
        {
            _x params ["", "_amountOf", "_bleeding"];
            _bodyPartBleeding set [_partIndex, (_bodyPartBleeding select _partIndex) + (_amountOf * _bleeding)];
        } forEach _y;
    };
} forEach GET_OPEN_WOUNDS(_unit);

// Internal bleeding
private _bodyPartInternalBleeding = [0,0,0,0,0,0];
{
    private _partIndex = ALL_BODY_PARTS find _x;
    if (_tourniquets select _partIndex == 0) then {
        {
            _x params ["", "_woundCount", "_bleedRate"];

            _bodyPartInternalBleeding set [_partIndex, (_bodyPartInternalBleeding select _partIndex) + (_woundCount * _bleedRate)];
        } forEach _y;
    };
} forEach GET_INTERNAL_WOUNDS(_unit);

/*if (GVAR(Hardcore_InternalBleeding)) then {
    [_unit] call EFUNC(damage,handleHardcoreInternalBleeding);
};*/

if (_bodyPartInternalBleeding isEqualTo [0,0,0,0,0,0]) then {
    _unit setVariable [VAR_INTERNAL_BLEEDING, 0, true];
} else {
    _bodyPartInternalBleeding params ["_headB", "_bodyB", "_leftArmB", "_rightArmB", "_leftLegB", "_rightLegB"];

    private _bodyBleedingRate = ((_headB min 0.9) + (_bodyB min 1.0)) min 1.0;
    private _limbBleedingRate = ((_leftArmB min 0.3) + (_rightArmB min 0.3) + (_leftLegB min 0.5) + (_rightLegB min 0.5)) min 1.0;

    _limbBleedingRate = _limbBleedingRate * (1 - _bodyBleedingRate);

    _unit setVariable [VAR_INTERNAL_BLEEDING, (_bodyBleedingRate + _limbBleedingRate), true];
    
    if (EGVAR(circulation,coagulationClotting) && (EGVAR(circulation,coagulationClottingAffectAI) || (!(EGVAR(circulation,coagulationClottingAffectAI)) && isPlayer _unit))) then {
        [{
            params ["_unit"];

            [QEGVAR(damage,handleIBCoagulationPFH), [_unit], _unit] call CBA_fnc_targetEvent;
        }, [_unit], 3] call CBA_fnc_waitAndExecute;
    };
};

if (_bodyPartBleeding isEqualTo [0,0,0,0,0,0]) then {
    TRACE_1("updateWoundBloodLoss-none",_unit);
    _unit setVariable [VAR_WOUND_BLEEDING, 0, true];
} else {
    _bodyPartBleeding params ["_headB", "_bodyB", "_leftArmB", "_rightArmB", "_leftLegB", "_rightLegB"];

    private _bodyBleedingRate = 0; 
    private _limbBleedingRate = 0;
    
    if (GET_INTERNAL_BLEEDING(_unit) > 0.3) then { // Severe internal bleeding slows external bleeding
        _bodyPartInternalBleeding params ["_headIB", "_bodyIB", "_leftArmIB", "_rightArmIB", "_leftLegIB", "_rightLegIB"];

        _bodyBleedingRate = (((_headB - _headIB) min 0.9) + ((_bodyB - _bodyIB) min 1.0)) min 1.0;
        _limbBleedingRate = (((_leftArmB - _leftArmIB) min 0.3) + ((_rightArmB - _rightArmIB) min 0.3) + ((_leftLegB - _leftLegIB) min 0.5) + ((_rightLegB - _rightLegIB) min 0.5)) min 1.0;
    } else {
        _bodyBleedingRate = ((_headB min 0.9) + (_bodyB min 1.0)) min 1.0;
        _limbBleedingRate = ((_leftArmB min 0.3) + (_rightArmB min 0.3) + (_leftLegB min 0.5) + (_rightLegB min 0.5)) min 1.0;
    };

    // limb bleeding is scaled down based on the amount of body bleeding
    _limbBleedingRate = _limbBleedingRate * (1 - _bodyBleedingRate);

    TRACE_3("updateWoundBloodLoss-bleeding",_unit,_bodyBleedingRate,_limbBleedingRate);
    _unit setVariable [VAR_WOUND_BLEEDING, _bodyBleedingRate + _limbBleedingRate, true];

    if (EGVAR(circulation,coagulationClotting) && (EGVAR(circulation,coagulationClottingAffectAI) || (!(EGVAR(circulation,coagulationClottingAffectAI)) && isPlayer _unit))) then {
        [{
            params ["_unit"];

            [QEGVAR(damage,handleCoagulationPFH), [_unit], _unit] call CBA_fnc_targetEvent;
        }, [_unit], 3] call CBA_fnc_waitAndExecute;
    };
};
