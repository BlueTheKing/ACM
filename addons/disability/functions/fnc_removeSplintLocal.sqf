#include "..\script_component.hpp"
/*
 * Author: Blue
 * Remove splint from limb
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Re-fracture limb <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftleg", true] call ACM_disability_fnc_removeSplintLocal;
 *
 * Public: No
 */

params [["_medic", objNull], "_patient", "_bodyPart", ["_reFracture", true]];

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

private _splintStatus = GET_SPLINTS(_patient);

_splintStatus set [_partIndex, 0];
_patient setVariable [VAR_SPLINTS, _splintStatus, true];

if (_reFracture && ((_patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]]) select _partIndex) > 0) then {
    private _fractures = GET_FRACTURES(_patient);
    _fractures set [_partIndex, 1];

    _patient setVariable [VAR_FRACTURES, _fractures, true];
    [_patient] call ACEFUNC(medical_engine,updateDamageEffects);

    private _preparedArray = _patient getVariable [QGVAR(Fracture_Prepared), [false,false,false,false,false,false]];
    
    if (_preparedArray select _partIndex) then {
        _preparedArray set [_partIndex, false];
        _patient setVariable [QGVAR(Fracture_Prepared), _preparedArray, true];
    };
};

if (_medic isEqualTo objNull) then {
    [_patient, "ACM_SAMsplint"] call ACEFUNC(common,addToInventory);
} else {
    [_medic, "ACM_SAMsplint"] call ACEFUNC(common,addToInventory);
};