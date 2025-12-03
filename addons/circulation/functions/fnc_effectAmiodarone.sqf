#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Amiodarone effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Dose <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 150] call ACM_circulation_fnc_effectAmiodarone;
 *
 * Public: No
 */

params ["_patient", ["_dose", 0]];

_patient setVariable [QGVAR(Amiodarone_LastDoseTime), CBA_missionTime, true];
_patient setVariable [QGVAR(Amiodarone_LastDoseEffect), (_dose / 150), true];

if (_patient getVariable [QGVAR(Amiodarone_PFH), -1] != -1) exitWith {};

private _initialDose = CBA_missionTime;

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_initialDose"];

    private _inCardiacArrest = IN_CRDC_ARRST(_patient);

    private _timeSinceROSC = CBA_missionTime - (_patient getVariable [QGVAR(ROSC_Time), -30]);

    private _rhythm = _patient getVariable [QGVAR(Cardiac_RhythmState), ACM_Rhythm_Sinus];
    private _effect = [_patient, "Amiodarone", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
    private _actualEffectiveness = _effect / 300;

    if ((!_inCardiacArrest && _timeSinceROSC > 30) || ((_effect < 0.05) && ((_initialDose + 180) < CBA_missionTime))) exitWith {
        _patient setVariable [QGVAR(Amiodarone_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(_rhythm in [ACM_Rhythm_VF, ACM_Rhythm_PVT]) exitWith {};

    private _baseChance = ([0.4, 0.5] select (_rhythm - 2));

    private _shockEffect = (120 / (CBA_missionTime - (_patient getVariable [QGVAR(AED_LastShock), -1]))) min 2;

    if (random 1 < (_baseChance * (_actualEffectiveness / 0.9) min 1)) then { // TODO hardcore setting
        [_patient] call FUNC(attemptROSC);
    };

}, (12 + (random 4)), [_patient, _initialDose]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Amiodarone_PFH), _PFH];