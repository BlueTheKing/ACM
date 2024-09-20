#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV complications on patient.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Type <NUMBER>
 * 2: Body Part <STRING>
 * 3: Access Site <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, ACM_IV_16G_M, "leftarm", 0] call ACM_circulation_fnc_setIVComplication;
 *
 * Public: No
 */

params ["_patient", "_type", "_bodyPart", "_accessSite"];

private _fnc_setIVPain = {
    params ["_patient", "_partIndex", "_accessSite", "_amount"];

    private _painPlacement = GET_IV_COMPLICATIONS_PAIN(_patient);
    _painPlacementOnBodyPart = _painPlacement select _partIndex;
    _painPlacementOnBodyPart set [_accessSite, _amount];
    _painPlacement set [_partIndex, _painPlacementOnBodyPart];

    _patient setVariable [VAR_IV_COMPLICATIONS_PAIN, _painPlacement, true];
    [_patient, (((random 0.1) + 0.05) * _amount)] call ACEFUNC(medical,adjustPainLevel);
};

private _fnc_setIVFlow = {
    params ["_patient", "_partIndex", "_accessSite", "_amount"];

    private _flowPlacement = GET_IV_COMPLICATIONS_FLOW(_patient);
    _flowPlacementOnBodyPart = _flowPlacement select _partIndex;
    _flowPlacementOnBodyPart set [_accessSite, _amount];
    _flowPlacement set [_partIndex, _flowPlacementOnBodyPart];

    _patient setVariable [VAR_IV_COMPLICATIONS_FLOW, _flowPlacement, true];
};

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

if (_type == 0) then { // Try to remove
    {
        params ["_complicationArray", "_complicationTypeVar"];

        private _placement = _complicationArray;
        if (_placement isNotEqualTo ACM_IV_PLACEMENT_DEFAULT_0) then {
            private _placementOnPart = _placement select _partIndex;
            _placementOnPart set [_accessSite, 0];
            _placement set [_partIndex, _placementOnPart];

            _patient setVariable [_complicationTypeVar, _placement, true];
        };
        
    } forEach [[(GET_IV_COMPLICATIONS_PAIN(_patient)),VAR_IV_COMPLICATIONS_PAIN],[(GET_IV_COMPLICATIONS_FLOW(_patient)),VAR_IV_COMPLICATIONS_FLOW],[(GET_IV_COMPLICATIONS_BLOCK(_patient)),VAR_IV_COMPLICATIONS_BLOCK]];
} else {
    private _damageOnBodyPart = (_patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]]) select _partIndex;

    switch (true) do {
        case (_damageOnBodyPart > ACM_IV_COMPLICATION_LEAK_THRESHOLD): { // Leakage
            [_patient, _partIndex, _accessSite, ACM_IV_COMPLICATION_FLOW_LOSS] call _fnc_setIVFlow;
            [_patient, _partIndex, _accessSite, 2] call _fnc_setIVPain;
        };
        case ((_damageOnBodyPart > ACM_IV_COMPLICATION_FLOW_THRESHOLD_16 && _type == ACM_IV_16G_M) || (_damageOnBodyPart > ACM_IV_COMPLICATION_FLOW_THRESHOLD_14 && _type == ACM_IV_14G_M)): { // Flow impedement
            [_patient, _partIndex, _accessSite, ACM_IV_COMPLICATION_FLOW_SLOW] call _fnc_setIVFlow;
            [_patient, _partIndex, _accessSite, 2] call _fnc_setIVPain;
        };
        default { // Pain
            [_patient, _partIndex, _accessSite, 1] call _fnc_setIVPain;
        };
    };
};