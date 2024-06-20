#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return medication of interest and their effects
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Medication effect <HASHMAP<NUMBER>>
 *
 * Example:
 * [cursorTarget] call ACM_circulation_fnc_getCardiacMedicationEffects;
 *
 * Public: No
 */

params ["_patient"];

private _morphine = 0;
private _morphineVial = 0;
private _epinephrine = 0;
private _epinephrineVial = 0;
private _amiodaroneVial = 0;

//ace_medical_status_fnc_getMedicationCount
{
    _x params ["_medication", "_timeAdded", "_timeTillMaxEffect", "_maxTimeInSystem", "", "", "", "_administrationType", "_maxEffectTime", "", "", "", "_concentration"];

    private _timeInSystem = CBA_missionTime - _timeAdded;

    private _getEffect = [_administrationType, _timeInSystem, _timeTillMaxEffect, _maxTimeInSystem, _maxEffectTime, _concentration] call FUNC(getMedicationEffect);

    switch (_medication) do {
        case "Morphine": {
            _morphine = _morphine + _getEffect;
        };
        case "Morphine_IV": {
            _morphineVial = _morphineVial + _getEffect;
        };
        case "Epinephrine": {
            _epinephrine = _epinephrine + _getEffect;
        };
        case "Epinephrine_IV": {
            _epinephrineVial = _epinephrineVial + _getEffect;
        };
        case "Amiodarone_IV": {
            _amiodaroneVial = _amiodaroneVial + _getEffect;
        };
    };
} forEach (_patient getVariable [VAR_MEDICATIONS, []]);

_morphine = (_morphine * 0.3) min 0.5;
_morphineVial = (_morphineVial * 0.6) min 0.8;
_epinephrine = (_epinephrine * 1.3) min 1.6;
_epinephrineVial = (_epinephrineVial * 1.8) min 2;
_amiodaroneVial = (_amiodaroneVial * 2) min 2;

createHashMapFromArray [["morphine", (_morphine max _morphineVial)], ["epinephrine", (_epinephrine max _epinephrineVial)], ["amiodarone",_amiodaroneVial]];