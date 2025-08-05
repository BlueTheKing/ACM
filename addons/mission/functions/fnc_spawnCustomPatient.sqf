#include "..\script_component.hpp"
/*
 * Author: Blue
 * Spawn custom patient
 *
 * Arguments:
 * 0: Spawn Reference Object <OBJECT>
 * 1: Wound Array <ARRAY<ARRAY>>
   * 0: Wound <STRING>
   * 1: Wound Size <NUMBER>
   * 2: Wound Count <NUMBER>
   * 3: Has Internal Bleeding <BOOL>
   * 4: Body Part Classname <STRING>
 * 2: Fracture Array <ARRAY<BOOL>>
 * 3: Blood Volume <ARRAY<NUMBER>>
   * 0: Blood Volume <NUMBER>
   * 1: Plasma Volume <NUMBER>
   * 2: Saline Volume <NUMBER>
   * 3: Platelet Count <NUMBER>
 * 4: Airway State Array <ARRAY<NUMBER>
   * 0: Obstruction Severity <NUMBER>
   * 1: Collapse Severity <NUMBER>
 * 5: Chest Injury Array <ARRAY<NUMBER>>
   * 0: Chest Injury Type <NUMBER>
   * 1: Chest Injury Severity <NUMBER>
   * 2: Chest Injury Target Lung <NUMBER>
 *
 * Return Value:
 * Patient <OBJECT>
 *
 * Example:
 * [_location, [["Avulsion",2,1,true,"body"]], [false,false,false,false], [6,0,0,3], [0,0], [0,0,0]] call ACM_mission_fnc_spawnCustomPatient;
 *
 * Public: No
 */

params ["_location", ["_woundArray", []], ["_fractureArray", [false,false,false,false]], ["_bloodVolumeArray", [6,0,0,3]], ["_airwayStateArray", [0,0]], ["_chestInjuryArray", [0,0,0]]];

private _patient = GVAR(TrainingCasualtyGroup) createUnit ["B_Survivor_F", position _location, [], 0, "FORM"];

_patient disableAI "MOVE";

removeAllWeapons _patient;
removeAllItems _patient;
removeAllAssignedItems _patient;
removeGoggles _patient;

_patient setVariable [QACEGVAR(medical_statemachine,AIUnconsciousness), true, true];

[_patient, true, 30] call ACEFUNC(medical,setUnconscious);

_patient setVariable [QEGVAR(damage,InstantDeathImmune), true, true];

private _bodyPartDamage = GET_BODYPART_DAMAGE(_patient);
private _openWounds = GET_OPEN_WOUNDS(_patient);
private _totalPain = 0;

{
    _x params ["_name", "_size", "_count", "_hasInternalBleeding", "_bodyPart"];

    private _openWoundsPart = _openWounds getOrDefault [_bodyPart, [], true];

    private _partIndex = GET_BODYPART_INDEX(_bodyPart);

    private _woundClass = (ACEGVAR(medical_damage,woundClassNames) find _name) * 10 + (0 max _size min 2);

    (ACEGVAR(medical_damage,woundDetails) get _name) params ["","_injuryBleedingRate","_injuryPain","_causeLimping","_causeFracture"];

    private _woundDamage = 1.3 / ([4, 2, 1] select _size); // _dmgMultiplier is always 1

    _bodyPartDamage set [_partIndex, (_bodyPartDamage select _partIndex) + _woundDamage];

    private _bleeding = ([0.25, 0.5, 1] select _size) * _injuryBleedingRate;
    private _pain = ([0.25, 0.5, 1] select _size) * _injuryPain;
    private _wound = [_woundClass, round (_count), _bleeding, _woundDamage];

    _openWoundsPart pushBack _wound;
    _totalPain = _totalPain + _pain;

    private _internalWounds = GET_INTERNAL_WOUNDS(_patient);
    private _internalWoundsPart = _internalWounds getOrDefault [_bodyPart, [], true];

    private _bodyPartSeverity = [0.6,0.6,0.3,0.3,0.45,0.45] select _partIndex;

    _internalWoundsPart pushBack [_targetWoundID, 1, (_bleeding * _bodyPartSeverity)];

    if (!(_patient getVariable [QEGVAR(breathing,ChestInjury_State), false]) && _bodyPart == "body" && _name in ["VelocityWound","PunctureWound","Avulsion"]) then {
        _patient setVariable [QEGVAR(breathing,ChestInjury_State), true, true];
    };
} forEach _woundArray;

_patient setVariable [VAR_OPEN_WOUNDS, _openWounds, true];
_patient setVariable [VAR_BODYPART_DAMAGE, _bodyPartDamage, true];
_patient setVariable [VAR_INTERNAL_WOUNDS, _internalWounds, true];

[_patient] call ACEFUNC(medical_status,updateWoundBloodLoss);

[_patient, _totalPain] call ACEFUNC(medical_status,fnc_adjustPainLevel);

if (_fractureArray isNotEqualTo [false,false,false,false]) then {
    private _fractureState = GET_FRACTURES(_patient);

    {
        if (_x) then {
            private _partIndex = _forEachIndex + 2;
            _fractureState set [_partIndex, 1];
            [QACEGVAR(medical,fracture), [_patient, _partIndex], _patient] call CBA_fnc_targetEvent;
        };
    } forEach _fractureArray;

    _patient setVariable [VAR_FRACTURES, _fractureState, true];
};

if (_bloodVolumeArray isNotEqualTo [6,0,0,3]) then {
    _bloodVolumeArray params ["_bloodVolume", "_plasmaVolume", "_salineVolume", "_plateletCount"];

    _patient setVariable [QEGVAR(circulation,Blood_Volume), _bloodVolume, true];
    _patient setVariable [QEGVAR(circulation,Plasma_Volume), _plasmaVolume, true];
    _patient setVariable [QEGVAR(circulation,Saline_Volume), _salineVolume, true];
    _patient setVariable [QEGVAR(circulation,Platelet_Count), _plateletCount, true];
}; 

[_patient] call ACEFUNC(medical_engine,updateDamageEffects);
[_patient, true, true, true, true] call ACEFUNC(medical_engine,updateBodyPartVisuals);

_patient setVariable [QEGVAR(core,WasWounded), true, true];

[{
    params ["_patient", "_airwayStateArray", "_chestInjuryArray"];
    _airwayStateArray params ["_airwayObstruction", "_airwayCollapse"];
    _chestInjuryArray params ["_chestInjuryType", "_chestInjurySeverity", "_chestInjuryTarget"];

    if (_airwayStateArray isNotEqualTo [0,0]) then {
        _patient setVariable [QEGVAR(airway,AirwayObstructionVomit_State), _airwayObstruction, true];
        _patient setVariable [QEGVAR(airway,AirwayCollapse_State), _airwayCollapse, true];
    };

    if (_chestInjuryType > 0) then {
        _patient setVariable [QEGVAR(breathing,ChestInjury_State), true, true];

        switch (_chestInjuryType) do {
            case 1: {
                [_patient] call EFUNC(breathing,handlePneumothorax);
                _patient setVariable [QEGVAR(breathing,Pneumothorax_State), (_chestInjurySeverity max 1), true];
            };
            case 2: {
                _patient setVariable [QEGVAR(breathing,Pneumothorax_State), 4, true];
                [_patient] call EFUNC(breathing,handlePneumothorax);
            };
            case 3: {
                _patient setVariable [QEGVAR(breathing,Hemothorax_State), (_chestInjurySeverity max 1), true];
                [_patient] call EFUNC(breathing,handleHemothorax);
            };
            default {};
        };

        _patient setVariable [QEGVAR(breathing,Stethoscope_LungState), ([[1,0], [0,1]] select _chestInjuryTarget), true];
        [_patient] call EFUNC(breathing,updateLungState);
        
    };
}, [_patient, _airwayStateArray, _chestInjuryArray], 3] call CBA_fnc_waitAndExecute;

_patient;