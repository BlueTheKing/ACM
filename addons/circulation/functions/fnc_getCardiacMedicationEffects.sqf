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
 * [cursorTarget] call AMS_circulation_fnc_getCardiacMedicationEffects;
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
    _x params ["_medication", "_timeAdded", "_timeTillMaxEffect", "_maxTimeInSystem"];

    private _getEffect = (((_timeInSystem / _timeTillMaxEffect) ^ 2) min 1) * (_maxTimeInSystem - _timeInSystem) / _maxTimeInSystem;

    switch (_medication) do {
        case "Morphine": {
            _morphine = _morphine + _getEffect;
        };
        case "MorphineVial": {
            _morphineVial = _morphineVial + _getEffect;
        };
        case "Epinephrine": {
            _epinephrine = _epinephrine + _getEffect;
        };;
        case "EpinephrineVial": {
            _epinephrineVial = _epinephrineVial + _getEffect;
        };
        case "Amiodarone": {
            _amiodaroneVial = _amiodaroneVial + _getEffect;
        };
    };
} forEach (_patient getVariable [VAR_MEDICATIONS, []]);

_morphine = (_morphine * 0.3) min 0.5;
_morphineVial = (_morphineVial * 0.6) min 0.8;
_epinephrine = (_epinephrine * 1.3) min 1.6;
_epinephrineVial = (_epinephrineVial * 1.5) min 1.8;
_amiodaroneVial = (_amiodaroneVial * 2) min 2;

createHashMapFromArray [["morphine", (_morphine max _morphineVial)], ["epinephrine", (_epinephrine max _epinephrineVial)], ["amiodarone",_amiodaroneVial]];