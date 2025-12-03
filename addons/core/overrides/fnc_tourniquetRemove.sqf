#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Removes the tourniquet from the patient on the given body part.
 * Note: Patient may not be local
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftLeg"] call ace_medical_treatment_fnc_tourniquetRemove
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];
TRACE_3("tourniquetRemove",_medic,_patient,_bodyPart);

// Remove tourniquet from body part, exit if no tourniquet applied
private _partIndex = GET_BODYPART_INDEX(_bodyPart);
private _tourniquets = GET_TOURNIQUETS(_patient);

if (_tourniquets select _partIndex == 0) exitWith {
    if (_medic == ACE_player) then {
        [ACELSTRING(medical_treatment,noTourniquetOnBodyPart), 1.5] call ACEFUNC(common,displayTextStructured);
    };
};

_tourniquets set [_partIndex, 0];
_patient setVariable [VAR_TOURNIQUET, _tourniquets, true];

[_patient] call ACEFUNC(medical_status,updateWoundBloodLoss);

private _nearPlayers = (_patient nearEntities ["CAManBase", 6]) select {_x call ACEFUNC(common,isPlayer)};
TRACE_1("clearConditionCaches: tourniquetRemove",_nearPlayers);
[QACEGVAR(interact_menu,clearConditionCaches), [], _nearPlayers] call CBA_fnc_targetEvent;

// Return tourniquet to removing unit
if (_medic call ACEFUNC(common,isPlayer)) then {
    [_medic, "ACE_tourniquet"] call ACEFUNC(common,addToInventory);
} else {
    // If the medic is AI, only return tourniquet if enabled
    if (missionNamespace getVariable [QACEGVAR(medical_ai,requireItems), 0] > 0) then {
        [_medic, "ACE_tourniquet"] call ACEFUNC(common,addToInventory);
    };
};

private _blockedMedication = _patient getVariable [QGVAR(BlockedMedication), []];
private _updateArray = false;

{
    _x params ["_entryMedication", "_entryRoute", "_entryPartIndex", "_entryDose"];
    
    if (_entryPartIndex == _partIndex) then {
        _updateArray = true;

        [_patient, _entryPartIndex, _entryMedication, _entryDose, _entryRoute] call EFUNC(circulation,administerMedication);
        _blockedMedication deleteAt _forEachIndex;
    };
} forEachReversed _blockedMedication;

if (_updateArray) then {
    _patient setVariable [QGVAR(BlockedMedication), _blockedMedication, true];
};

private _tourniquetsTime = _patient getVariable [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]];
_tourniquetsTime set [_partIndex, -1];
_patient setVariable [QEGVAR(disability,Tourniquet_ApplyTime), _tourniquetsTime, true];