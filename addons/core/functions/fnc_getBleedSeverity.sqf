#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return bleeding severity
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Bleeding severity <NUMBER>
 *
 * Example:
 * [player] call ACM_core_fnc_getBleedSeverity;
 *
 * Public: No
 */

params ["_patient"];

// ace_medical_gui_fnc_updateInjuryList
private _cardiacOutput = [_patient] call ACEFUNC(medical_status,getCardiacOutput);
private _bleedRate = GET_BLOOD_LOSS(_patient);
private _bleedRateKO = BLOOD_LOSS_KNOCK_OUT_THRESHOLD * (_cardiacOutput max 0.05);
// Use nonzero minimum cardiac output to prevent all bleeding showing as massive during cardiac arrest
switch (true) do {
    case (_bleedRate < _bleedRateKO * BLEED_RATE_SLOW): {
        0;
    };
    case (_bleedRate < _bleedRateKO * BLEED_RATE_MODERATE): {
        1;
    };
    case (_bleedRate < _bleedRateKO * BLEED_RATE_SEVERE): {
        2;
    };
    default {
        3;
    };
};