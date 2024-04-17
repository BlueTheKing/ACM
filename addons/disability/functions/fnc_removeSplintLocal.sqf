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
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_removeSplintLocal;
 *
 * Public: No
 */

params [["_medic", objNull], "_patient", "_bodyPart", ["_reFracture", true]];

private _partIndex = ALL_BODY_PARTS find toLower _bodyPart;

private _splintStatus = GET_SPLINTS(_patient);

_splintStatus set [_partIndex, 0];
_patient setVariable [VAR_SPLINTS, _splintStatus, true];

if (_reFracture) then {
    private _fractures = GET_FRACTURES(_patient);
    _fractures set [_partIndex, 1];

    _patient setVariable [VAR_FRACTURES, _fractures, true];
    [_patient] call ACEFUNC(medical_engine,updateDamageEffects);
};

if (_medic isEqualTo objNull) then {
    [_patient, "ACM_SAMsplint"] call ACEFUNC(common,addToInventory);
} else {
    [_medic, "ACM_SAMsplint"] call ACEFUNC(common,addToInventory);
};