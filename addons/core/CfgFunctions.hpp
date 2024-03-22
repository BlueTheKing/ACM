class CfgFunctions {
    class overwrite_medical_vitals {
        tag = "ace_medical_vitals";
        class ace_medical_vitals {
            class handleUnitVitals {
                file = QPATHTOF(overrides\fnc_handleUnitVitals.sqf);
            };
            class updateHeartRate {
                file = QPATHTOF(overrides\fnc_updateHeartRate.sqf);
            };
            class updateOxygen {
                file = QPATHTOF(overrides\fnc_updateOxygen.sqf);
            };
        };
    };
    class overwrite_medical_status {
        tag = "ace_medical_status";
        class ace_medical_status {
            class getBloodPressure {
                file = QPATHTOF(overrides\fnc_getBloodPressure.sqf);
            };
            class getBloodVolumeChange {
                file = QPATHTOF(overrides\fnc_getBloodVolumeChange.sqf);
            };
            class hasStableVitals {
                file = QPATHTOF(overrides\fnc_hasStableVitals.sqf);
            };
            class getBloodLoss {
                file = QPATHTOF(overrides\fnc_getBloodLoss.sqf);
            };
        };
    };
    class overwrite_medical_treatment {
        tag = "ace_medical_treatment";
        class ace_medical_treatment {
            class fullHealLocal {
                file = QPATHTOF(overrides\fnc_fullHealLocal.sqf);
            };
            class treatment {
                file = QPATHTOF(overrides\fnc_treatment.sqf);
            };
        };
    };
    class overwrite_medical_damage {
        tag = "ace_medical_damage";
        class ace_medical_damage {
            class woundsHandlerBase {
                file = QPATHTOF(overrides\fnc_woundsHandlerBase.sqf);
            };
        };
    };
    class overwrite_medical_statemachine {
        tag = "ace_medical_statemachine";
        class ace_medical_statemachine {
            /*class handleStateCardiacArrest {
                file = QPATHTOF(overrides\fnc_handleStateCardiacArrest.sqf);
            };*/
            class enteredStateCardiacArrest {
                file = QPATHTOF(overrides\fnc_enteredStateCardiacArrest.sqf);
            };/*
            class leftStateCardiacArrest {
                file = QPATHTOF(overrides\fnc_leftStateCardiacArrest.sqf);
            };*/
            class conditionCardiacArrestTimer {
                file = QPATHTOF(overrides\fnc_conditionCardiacArrestTimer.sqf);
            };
            /*class enteredStateFatalInjury {
                file = QPATHTOF(overrides\fnc_enteredStateFatalInjury.sqf);
            };*/
            /*class handleStateInjured {
                file = QPATHTOF(overrides\fnc_handleStateInjured.sqf);
            };*/
        };
    };
    /*class overwrite_CBA_statemachine { // TODO statemachine fuckery
        tag = "CBA_statemachine";
        class CBA_statemachine {
            class manualTransition {
                file = QPATHTOF(overrides\fnc_manualTransition.sqf);
            };
            class createFromConfig {
                file = QPATHTOF(overrides\fnc_createFromConfig.sqf);
            };
        };
    };*/
};