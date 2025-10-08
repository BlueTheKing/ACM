#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle setting fracture severity. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Part Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 2] call ACM_disability_fnc_handleFracture;
 *
 * Public: No
 */

params ["_patient", "_partIndex"];

if !(GVAR(enableFractureSeverity)) exitWith {};

private _bodyDamage = _patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];
private _bodyPartDamage = _bodyDamage select _partIndex;

private _preparedArray = _patient getVariable [QGVAR(Fracture_Prepared), [false,false,false,false,false,false]];

if (_preparedArray select _partIndex) then {
    _preparedArray set [_partIndex, false];
    _patient setVariable [QGVAR(Fracture_Prepared), _preparedArray, true];
};

private _complication = random 1 < 0.5;
private _targetFracture = 0;

private _splintNoEffect = false;
private _givePain = false;
private _canReFracture = false;

switch (true) do {
    case (GVAR(Hardcore_ComplexFracture) && _bodyPartDamage > FRACTURE_THRESHOLD_COMPLEX): {
        _givePain = true;
        _splintNoEffect = true;
        _targetFracture = ACM_FRACTURE_COMPLEX;
    };
    case (_bodyPartDamage < FRACTURE_THRESHOLD_MILD);
    case (_bodyPartDamage < FRACTURE_THRESHOLD_SEVERE && !_complication): {
        _targetFracture = ACM_FRACTURE_MILD;
    };
    case (_bodyPartDamage < FRACTURE_THRESHOLD_SEVERE && _complication): {
        _givePain = random 1 < 0.5;
        _canReFracture = random 1 < 0.3;
        _targetFracture = ACM_FRACTURE_MILD;
    };
    default {
        _splintNoEffect = random 1 < 0.3;

        if !(_splintNoEffect) then {
            _canReFracture = random 1 < 0.5;
        };
        
        _targetFracture = ACM_FRACTURE_SEVERE;
    };
};

private _fractureArray = _patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]];
private _fractureState = _fractureArray select _partIndex;

if (_targetFracture > _fractureState) then {
    _fractureArray set [_partIndex, _targetFracture];
    _patient setVariable [QGVAR(Fracture_State), _fractureArray, true];
};

private _fracturePainArray = _patient getVariable [QGVAR(Fracture_Pain), [false,false,false,false,false,false]];
private _fracturePainState = _fracturePainArray select _partIndex;

if (!_fracturePainState && _givePain) then {
    _fracturePainArray set [_partIndex, _givePain];
    _patient setVariable [QGVAR(Fracture_Pain), _fracturePainArray, true];
};

private _reFractureArray = _patient getVariable [QGVAR(Fracture_ReFracture), [false,false,false,false,false,false]];
private _reFractureState = _reFractureArray select _partIndex;

if (!_reFractureState && _canReFracture) then {
    _reFractureArray set [_partIndex, _canReFracture];
    _patient setVariable [QGVAR(Fracture_ReFracture), _reFractureArray, true];
};

private _noEffectArray = _patient getVariable [QGVAR(Fracture_NoEffect), [false,false,false,false,false,false]];
private _noEffectState = _noEffectArray select _partIndex;

if (GVAR(Hardcore_ComplexFracture) && _splintNoEffect && !_noEffectState) then {
    _noEffectArray set [_partIndex, true];
    _patient setVariable [QGVAR(Fracture_NoEffect), _noEffectArray, true];
};

if ((_patient getVariable [QGVAR(Fracture_PFH), -1]) != -1 || (!_canReFracture && !_splintNoEffect) || _splintNoEffect) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _fractureArray = _patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]];

    if (_fractureArray isEqualTo [0,0,0,0,0,0]) exitWith {
        _patient setVariable [QGVAR(Fracture_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _fractures = GET_FRACTURES(_patient);

    private _givePain = false;
    private _updateDamage = false;

    private _givePainArray = _patient getVariable [QGVAR(Fracture_Pain), [false,false,false,false,false,false]];
    private _reFractureArray = _patient getVariable [QGVAR(Fracture_ReFracture), [false,false,false,false,false,false]];

    for "_i" from 2 to 5 do {
        if (!_givePain && _givePainArray select _i) then {
            _givePain = true;
        };

        if ((_fractures select _i) == -1 && _reFractureArray select _i) then {
            private _reFractureChance = 0.25;
            
            if (_i in [2,3]) then {
                _reFractureChance = 0.1;
            };

            if (random 1 < _reFractureChance) then {
                _updateDamage = true;
                _fractures set [_i, 1];
            };
        };
    };

    if (_givePain) then {
        [_patient, 1] call ACEFUNC(medical,adjustPainLevel);
    };

    if (_updateDamage) then {
        _patient setVariable [VAR_FRACTURES, _fractures, true];
        [_patient] call ACEFUNC(medical_engine,updateDamageEffects);
    };

}, 30, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Fracture_PFH), _PFH];