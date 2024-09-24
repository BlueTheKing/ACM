#include "..\script_component.hpp"
/*
 * Author: Blue
 * Add patient ACE actions to vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [vehicle] call ACM_core_fnc_addVehiclePatientActions;
 *
 * Public: No
 */

params ["_vehicle"];

private _type = (typeOf _vehicle);

private _vehicleSeats = fullCrew [_vehicle, ""];

private _actions = [];

{
    private _unit = _x select 0;

    private _triageLevel = _unit getVariable [QACEGVAR(medical,triageLevel), 0];

    if (_unit getVariable [QGVAR(WasWounded), false]) then {
        private _iconColor = [[1,1,1,1],[TRIAGE_COLOR_MINIMAL],[TRIAGE_COLOR_DELAYED],[TRIAGE_COLOR_IMMEDIATE],[TRIAGE_COLOR_DECEASED]] select _triageLevel;
        private _icon = switch (true) do {
            case !(alive _unit): { // Dead
                if ([_unit] call FUNC(cprActive)) then {
                    _iconColor = [0, 0.6, 1, 1];
                    QPATHTOF(ui\icon_patient_cpr.paa);
                } else {
                    _iconColor = [1,1,1,1];
                    QPATHTOF(ui\icon_patient_dead.paa);
                };
            };
            case (IS_BLEEDING(_unit)): { // Bleeding
                private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);
                private _bleedRate = GET_BLOOD_LOSS(_unit);
                private _bleedRateKO = BLOOD_LOSS_KNOCK_OUT_THRESHOLD_DEFAULT * (_cardiacOutput max 0.05);

                _iconColor = [1, (linearConversion [(_bleedRateKO * BLEED_RATE_SLOW), (_bleedRateKO * BLEED_RATE_SEVERE), _bleedRate, 1, 0, true]), 0, 1];
                QPATHTOF(ui\icon_patient_bleeding.paa);
            };
            case ([_unit] call FUNC(cprActive)): { // CPR
                _iconColor = [0, 0.6, 1, 1];
                QPATHTOF(ui\icon_patient_cpr.paa);
            };
            case ([_unit] call FUNC(bvmActive)): { // BVM
                _iconColor = [0, 0.6, 1, 1];
                QPATHTOF(ui\icon_patient_bvm.paa);
            };
            case (GET_OXYGEN(_unit) < 90): { // Cyanotic
                private _oxygenState = GET_OXYGEN(_unit);
                _iconColor = [(linearConversion [90, 55, _oxygenState, 0, 0.5, true]), (linearConversion [90, 55, _oxygenState, 0.6, 0.13, true]), (linearConversion [90, 55, _oxygenState, 1, 0.75, true]), 1];
                if (GET_RESPIRATION_RATE(_unit) < 1) then {
                    QPATHTOF(ui\icon_patient_respiratoryarrest_cyanosis.paa); // Not Breathing
                } else {
                    QPATHTOF(ui\icon_patient_cyanosis.paa);
                };
            };
            case (GET_RESPIRATION_RATE(_unit) < 1): { // Not Breathing
                _iconColor = [0, 0.6, 1, 1];
                QPATHTOF(ui\icon_patient_respiratoryarrest.paa);
            };
            case (GET_BLOOD_VOLUME(_unit) < 4.2): { // Mega Bloodloss
                _iconColor = [1, (linearConversion [4.3, 3.6, GET_BLOOD_VOLUME(_unit), 0.5, 0, true]), 0, 1];
                QPATHTOF(ui\icon_patient_severebloodloss.paa);
            };
            case (GET_BLOOD_VOLUME(_unit) < 5.4): { // Bloodloss
                _iconColor = [1, (linearConversion [5.4, 4.3, GET_BLOOD_VOLUME(_unit), 1, 0.5, true]), 0, 1];
                QPATHTOF(ui\icon_patient_bloodloss.paa);
            };
            case (IS_UNCONSCIOUS(_unit)): { // Unconscious
                QPATHTOF(ui\icon_patient_unconscious.paa);
            };
            case (!(IS_UNCONSCIOUS(_unit)) && IS_IN_PAIN(_unit)): { // In Pain
                QPATHTOF(ui\icon_patient_pain.paa);
            };
            default {
                "";
            };
        };

        private _triageText = ["",LELSTRING(GUI,Triage_Priority1_Short), LELSTRING(GUI,Triage_Priority2_Short), LELSTRING(GUI,Triage_Priority3_Short), LELSTRING(GUI,Triage_Priority4_Short)] select _triageLevel;
        private _patientName = [_unit, true] call ACEFUNC(common,getName);
        private _actionText = [_patientName, (format ["%1 [%2]", _patientName, _triageText])] select (_triageLevel > 0);

        _actions pushBack [[format ["ACM_PatientActions_%1", _unit],
        _actionText,
        [_icon, (_iconColor call BIS_fnc_colorRGBtoHTML)],
        {
            params ["_vehicle", "_medic", "_args"];
            _args params ["_patient"];

            [_patient] call ACEFUNC(medical_gui,openMenu);
        },
        {true},
        {
            params ["_vehicle", "_medic", "_args"];
            _args params ["_patient"];

            private _actions = [];
            
            _actions pushBack [
                [
                "ACM_PatientActions_ViewMonitor",
                LELSTRING(circulation,ViewMonitor),
                "", // TODO icon
                {
                    params ["", "", "_args"];
                    _args params ["_patient", "_medic"];

                    [_medic, _patient] call EFUNC(circulation,displayAEDMonitor);
                },
                {
                    params ["", "", "_args"];
                    _args params ["_patient", "_medic"];

                    [_patient] call EFUNC(circulation,hasAED);
                },
                {},
                [_patient, _medic]
                ] call ACEFUNC(interact_menu,createAction),
                [],
                (_this select 1)
            ];

            _actions pushBack [
                [
                "ACM_PatientActions_OpenTransfusionMenu",
                LELSTRING(circulation,OpenTransfusionMenu),
                "", // TODO icon
                {
                    params ["", "", "_args"];
                    _args params ["_patient", "_medic"];

                    private _targetBodyPart = "";

                    if ([_patient] call EFUNC(circulation,hasIV)) then {
                        {
                            if (_x isNotEqualTo ACM_IV_P_SITE_DEFAULT_0) exitWith {
                                _targetBodyPart = ALL_BODY_PARTS select _forEachIndex;
                            };
                        } forEach GET_IV(_patient);
                    } else {
                        {
                            if (_x > 0) exitWith {
                                _targetBodyPart = ALL_BODY_PARTS select _forEachIndex;
                            };
                        } forEach GET_IO(_patient);
                    };

                    [_medic,_patient,_targetBodyPart] call EFUNC(circulation,openTransfusionMenu);
                },
                {
                    params ["", "", "_args"];
                    _args params ["_patient", "_medic"];

                    ([_patient] call EFUNC(circulation,hasIV) || [_patient] call EFUNC(circulation,hasIO));
                },
                {},
                [_patient, _medic]
                ] call ACEFUNC(interact_menu,createAction),
                [],
                (_this select 1)
            ];

            _actions pushBack [
                [
                "ACM_PatientActions_Unload",
                ACELLSTRING(medical_treatment,Unload),
                "", // TODO icon
                {
                    params ["", "", "_args"];
                    _args params ["_patient", "_medic"];

                    [_medic, _patient] call ACEFUNC(medical_treatment,unloadUnit);
                },
                {
                    params ["", "", "_args"];
                    _args params ["_patient", "_medic"];

                    true;
                },
                {},
                [_patient, _medic]
                ] call ACEFUNC(interact_menu,createAction),
                [],
                (_this select 1)
            ];

            _actions;
        },
        [_unit]
        ] call ACEFUNC(interact_menu,createAction),[], (_this select 1)];
    };
} forEach (_vehicleSeats);

_actions;
