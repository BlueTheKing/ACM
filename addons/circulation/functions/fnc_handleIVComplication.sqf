#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle IV complication deterioration on patient. (LOCAL)
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
 * [player, ACM_IV_16G_M, "leftarm", 0] call ACM_circulation_fnc_handleIVComplication;
 *
 * Public: No
 */

params ["_patient", "_type", "_bodyPart", "_accessSite"];

if (_patient getVariable [QGVAR(IV_Complication_PFH), -1] != -1) exitWith {};

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

private _timer = 15 + (random 15);

[{
    params ["_patient", "_fnc_setIVPain", "_fnc_setIVFlow", "_timer"];

    if (_patient getVariable [QGVAR(IV_Complication_PFH), -1] != -1) exitWith {};

    private _PFH = [{
        params ["_args", "_idPFH"];
        _args params ["_patient", "_fnc_setIVPain", "_fnc_setIVFlow"];

        private _IVPlacementCondition = GET_IV(_patient) isEqualTo ACM_IV_PLACEMENT_DEFAULT_0;
        private _IVComplicationsPain = GET_IV_COMPLICATIONS_PAIN(_patient);
        private _IVComplicationsFlow = GET_IV_COMPLICATIONS_FLOW(_patient);
        private _IVComplicationsBlock = GET_IV_COMPLICATIONS_BLOCK(_patient);

        if (_IVPlacementCondition || ((_IVComplicationsPain isEqualTo ACM_IV_PLACEMENT_DEFAULT_0) && (_IVComplicationsFlow isEqualTo ACM_IV_PLACEMENT_DEFAULT_0) && (_IVComplicationsBlock isEqualTo ACM_IV_PLACEMENT_DEFAULT_0))) exitWith {
            _patient setVariable [QGVAR(IV_Complication_PFH), -1];
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        private _bodyDamage = _patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];

        {
            private _partIndex = _forEachIndex;
            private _IVPlacementOnBodyPart = GET_IV(_patient) select _partIndex;
            private _damageOnBodyPart = _x;
            
            {
                private _type = _x;

                if (_type < 1) then {
                    continue;
                };
                if ((GET_IV_FLOW_X(_patient,_partIndex,_forEachIndex)) <= 0) then {
                    continue;
                };

                private _painOnSite = ((_IVComplicationsPain select _partIndex) select _forEachIndex);
                private _flowState = GET_IV_COMPLICATIONS_FLOW_X(_patient,_partIndex,_forEachIndex);

                if (_painOnSite <= 0 && _flowState <= 0) then {
                    continue;
                };

                private _attemptFlowComplication = false;
                private _attemptLeakComplication = false;
                private _targetPain = 0;

                switch (true) do {
                    case (_damageOnBodyPart > ACM_IV_COMPLICATION_LEAK_THRESHOLD): { // Leakage
                        _attemptLeakComplication = true;
                        _targetPain = 3;
                    };
                    case ((_damageOnBodyPart > ACM_IV_COMPLICATION_FLOW_THRESHOLD_16 && _type == ACM_IV_16G_M) || (_damageOnBodyPart > ACM_IV_COMPLICATION_FLOW_THRESHOLD_14 && _type == ACM_IV_14G_M)): { // Flow impedement
                        _attemptFlowComplication = true;
                        _targetPain = 3;
                    };
                    case ((_damageOnBodyPart > ACM_IV_COMPLICATION_THRESHOLD_16_L && _type == ACM_IV_16G_M) || (_damageOnBodyPart > ACM_IV_COMPLICATION_THRESHOLD_14_L && _type == ACM_IV_14G_M)): { // Pain
                        _targetPain = 2;
                    };
                    default {};
                };
                
                if (_targetPain > _painOnSite) then {
                    [_patient, _partIndex, _forEachIndex, _targetPain min (_painOnSite + 1)] call _fnc_setIVPain;
                };

                if (_flowState >= ACM_IV_COMPLICATION_FLOW_LOSS) then {
                    continue;
                };

                if ((_attemptFlowComplication || _attemptLeakComplication) && (_flowState < 1)) then {
                    private _chance = [(linearConversion [ACM_IV_COMPLICATION_FLOW_THRESHOLD_16, (ACM_IV_COMPLICATION_FLOW_THRESHOLD_16 + 3), _damageOnBodyPart, 0.2, 1, true]), (linearConversion [ACM_IV_COMPLICATION_FLOW_THRESHOLD_14, (ACM_IV_COMPLICATION_FLOW_THRESHOLD_14 + 3), _damageOnBodyPart, 0.3, 1, true])] select (_type == ACM_IV_14G_M);

                    if (random 1 < _chance) then {
                        [_patient, _partIndex, _forEachIndex, ACM_IV_COMPLICATION_FLOW_SLOW] call _fnc_setIVFlow;
                    };
                };

                if (_attemptLeakComplication && (_flowState == ACM_IV_COMPLICATION_FLOW_SLOW)) then {
                    private _chance = linearConversion [ACM_IV_COMPLICATION_LEAK_THRESHOLD, (ACM_IV_COMPLICATION_LEAK_THRESHOLD + 5), _damageOnBodyPart, 0.3, 1, true];

                    if (random 1 < _chance) then {
                        [_patient, _partIndex, _forEachIndex, ACM_IV_COMPLICATION_FLOW_LOSS] call _fnc_setIVFlow;
                    };
                };
            } forEach _IVPlacementOnBodyPart;
        } forEach _bodyDamage;
    }, _timer, [_patient, _fnc_setIVPain, _fnc_setIVFlow]] call CBA_fnc_addPerFrameHandler;

    _patient setVariable [QGVAR(IV_Complication_PFH), _PFH];
}, [_patient, _fnc_setIVPain, _fnc_setIVFlow, _timer], _timer] call CBA_fnc_waitAndExecute;