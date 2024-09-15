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

    if (_unit getVariable [QGVAR(WasWounded), false]) then {
        private _iconColor = "";
        private _icon = switch (true) do {
            case !(alive _unit): { // Dead
                QPATHTOF(ui\icon_patient_dead.paa);
            };
            case (IS_BLEEDING(_unit)): { // Bleeding
                QPATHTOF(ui\icon_patient_bleeding.paa);
            };
            case (GET_BLOOD_VOLUME(_unit) < 4.3): { // Mega Bloodloss
                _iconColor = [(linearConversion [4.3, 3.6, GET_BLOOD_VOLUME(_unit), 0.5, 1, true]), 1.16, 0.1, 1];
                QPATHTOF(ui\icon_patient_severebloodloss.paa);
            };
            case ([_unit] call FUNC(cprActive)): { //CPR
                QPATHTOF(ui\icon_patient_cpr.paa);
            };
            case (GET_OXYGEN(_unit) < 90): { // Cyanotic
                _iconColor = [0.16, (linearConversion [90, 55, GET_OXYGEN(_unit), 0.47, 0.13, true]), 1, 1];
                if (GET_RESPIRATION_RATE(_unit) < 1) then {
                    QPATHTOF(ui\icon_patient_respiratoryarrest.paa); // Not Breathing
                } else {
                    QPATHTOF(ui\icon_patient_cyanosis.paa);
                };
            };
            case (GET_RESPIRATION_RATE(_unit) < 1): { // Not Breathing
                QPATHTOF(ui\icon_patient_respiratoryarrest.paa);
            };
            case (GET_BLOOD_VOLUME(_unit) < 5.4): { // Bloodloss
                QPATHTOF(ui\icon_patient_bloodloss.paa);
            };
            case (IS_IN_PAIN(_unit)): { // In Pain
                QPATHTOF(ui\icon_patient_pain.paa);
            };
            default {
                "";
            };
        };

        private _actionText = [[_unit, true] call ACEFUNC(common,getName), (format ["%1 [%2]", [_unit, true] call ACEFUNC(common,getName), ([_unit] call ACEFUNC(medical_treatment,getTriageStatus) select 0)])
        ] select (_unit getVariable [QACEGVAR(medical,triageLevel), -1] > 0);

        _actions pushBack [[format ["ACM_PatientActions_%1", _unit],
        _actionText,
        _icon,
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
