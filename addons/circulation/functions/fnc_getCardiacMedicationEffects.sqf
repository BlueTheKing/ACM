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
private _morphineIV = 0;
private _fentanyl  = 0;
private _fentanylIV = 0;
private _epinephrineIV = 0;
private _amiodaroneIV = 0;
private _lidocaineIV = 0;

//ace_medical_status_fnc_getMedicationCount
{
    _x params ["_medication", "_timeAdded", "_timeTillMaxEffect", "_maxTimeInSystem", "", "", "", "_administrationType", "_maxEffectTime", "", "", "", "_concentration"];

    if !(_medication in ["Morphine","Morphine_IV","Fentanyl","Fentanyl_IV","Epinephrine_IV","Amiodarone_IV","Lidocaine_IV"]) then {
        continue;
    };

    private _timeInSystem = CBA_missionTime - _timeAdded;

    private _getEffect = [_administrationType, _timeInSystem, _timeTillMaxEffect, _maxTimeInSystem, _maxEffectTime, _concentration] call FUNC(getMedicationEffect);

    switch (_medication) do {
        case "Morphine": {
            _morphine = _morphine + _getEffect;
        };
        case "Morphine_IV": {
            _morphineIV = _morphineIV + _getEffect;
        };
        case "Fentanyl": {
            _fentanyl = _fentanyl + _getEffect;
        };
        case "Fentanyl_IV": {
            _fentanylIV = _fentanylIV + _getEffect;
        };
        case "Epinephrine_IV": {
            _epinephrineIV = _epinephrineIV + _getEffect;
        };
        case "Amiodarone_IV": {
            _amiodaroneIV = _amiodaroneIV + _getEffect;
        };
        case "Lidocaine_IV": {
            _lidocaineIV = _lidocaineIV + _getEffect;
        };
    };
} forEach (_patient getVariable [VAR_MEDICATIONS, []]);

_morphine = (_morphine * 0.3) min 0.5;
_morphineIV = (_morphineIV * 0.6) min 0.8;
_fentanyl = (_fentanyl * 0.3) min 0.5;
_fentanylIV = (_fentanylIV * 0.6) min 0.8;
_epinephrineIV = (_epinephrineIV * 1.8) min 2;
_amiodaroneIV = _amiodaroneIV min 2;
_lidocaineIV = _lidocaineIV min 1.5;

(createHashMapFromArray [["morphine", (_morphine max _morphineIV)], ["fentanyl", (_fentanyl max _fentanylIV)], ["epinephrine", _epinephrineIV], ["amiodarone",_amiodaroneIV], ["lidocaine",_lidocaineIV]]);