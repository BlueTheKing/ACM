class CfgFunctions {
    class overwrite_interact_menu {
        tag = "ace_interact_menu";
        class ace_interact_menu {
            class compileMenuSelfAction { // Lying state exception
                file = QPATHTOF(overrides\fnc_compileMenuSelfAction.sqf); //ace/addons/interact_menu/functions/fnc_compileMenuSelfAction.sqf
            };
            class keyDown { // Lying state exception
                file = QPATHTOF(overrides\fnc_keyDown.sqf); //ace/addons/interact_menu/functions/fnc_keyDown.sqf
            };
        };
    };
    class overwrite_medical {
        tag = "ace_medical";
        class ace_medical {
            class deserializeState { // Serialize/Deserialize
                file = QPATHTOF(overrides\fnc_deserializeState.sqf); //ace/addons/medical/functions/fnc_deserializeState.sqf
            };
            class serializeState { // Serialize/Deserialize
                file = QPATHTOF(overrides\fnc_serializeState.sqf); //ace/addons/medical/functions/fnc_serializeState.sqf
            };
        };
    };
    class overwrite_medical_vitals {
        tag = "ace_medical_vitals";
        class ace_medical_vitals {
            class handleUnitVitals { // Core
                file = QPATHTOF(overrides\fnc_handleUnitVitals.sqf); //ace/addons/medical_vitals/functions/fnc_handleUnitVitals.sqf
            };
            class updateHeartRate { // Circulation
                file = QPATHTOF(overrides\fnc_updateHeartRate.sqf); //ace/addons/medical_vitals/functions/fnc_updateHeartRate.sqf
            };
            class updateOxygen { // Breathing
                file = QPATHTOF(overrides\fnc_updateOxygen.sqf); //ace/addons/medical_vitals/functions/fnc_updateOxygen.sqf
            };
        };
    };
    class overwrite_medical_status {
        tag = "ace_medical_status";
        class ace_medical_status {
            class getBloodPressure { // Circulation
                file = QPATHTOF(overrides\fnc_getBloodPressure.sqf); //ace/addons/medical_status/functions/fnc_getBloodPressure.sqf
            };
            class getBloodVolumeChange { // Circulation
                file = QPATHTOF(overrides\fnc_getBloodVolumeChange.sqf); //ace/addons/medical_status/functions/fnc_getBloodVolumeChange.sqf
            };
            class hasStableVitals { // Add oxygen saturation as vital
                file = QPATHTOF(overrides\fnc_hasStableVitals.sqf); //ace/addons/medical_status/functions/fnc_hasStableVitals.sqf
            };
            class getBloodLoss { // Circulation
                file = QPATHTOF(overrides\fnc_getBloodLoss.sqf); //ace/addons/medical_status/functions/fnc_getBloodLoss.sqf
            };
            class updateWoundBloodLoss { // Internal bleeding
                file = QPATHTOF(overrides\fnc_updateWoundBloodLoss.sqf); //ace/addons/medical_status/functions/fnc_updateWoundBloodLoss.sqf
            };
            class addMedicationAdjustment { // Administration route, respiration rate adjust
                file = QPATHTOF(overrides\fnc_addMedicationAdjustment.sqf); //ace/addons/medical_status/functions/fnc_addMedicationAdjustment.sqf
            };
            class getMedicationCount { // Administration route, respiration rate adjust
                file = QPATHTOF(overrides\fnc_getMedicationCount.sqf); //ace/addons/medical_status/functions/fnc_getMedicationCount.sqf
            };
            class setCardiacArrestState { // Fix weird heart rate on ROSC
                file = QPATHTOF(overrides\fnc_setCardiacArrestState.sqf); //ace/addons/medical_status/functions/fnc_setCardiacArrestState.sqf
            };
        };
    };
    class overwrite_medical_treatment {
        tag = "ace_medical_treatment";
        class ace_medical_treatment {
            class treatment { // Add fixes and patient animations
                file = QPATHTOF(overrides\fnc_treatment.sqf); //ace/addons/medical_treatment/functions/fnc_treatment.sqf
            };
            class ivBagLocal { // Circulation
                file = QPATHTOF(overrides\fnc_ivBagLocal.sqf); //ace/addons/medical_treatment/functions/fnc_ivBagLocal.sqf
            };
            class ivBag { // Circulation
                file = QPATHTOF(overrides\fnc_ivBag.sqf); //ace/addons/medical_treatment/functions/fnc_ivBag.sqf
            };
            class medication { // Fix magazine names in triage card
                file = QPATHTOF(overrides\fnc_medication.sqf); //ace/addons/medical_treatment/functions/fnc_medication.sqf
            };
            class medicationLocal { // Respiration rate adjust
                file = QPATHTOF(overrides\fnc_medicationLocal.sqf); //ace/addons/medical_treatment/functions/fnc_medicationLocal.sqf
            };
            class onMedicationUsage { // Overdose changes
                file = QPATHTOF(overrides\fnc_onMedicationUsage.sqf); //ace/addons/medical_treatment/functions/fnc_onMedicationUsage.sqf
            };
            class checkPulseLocal { // CPR rate
                file = QPATHTOF(overrides\fnc_checkPulseLocal.sqf); //ace/addons/medical_treatment/functions/fnc_checkPulseLocal.sqf
            };
            class tourniquetRemove { // Tourniquet time
                file = QPATHTOF(overrides\fnc_tourniquetRemove.sqf); //ace/addons/medical_treatment/functions/fnc_tourniquetRemove.sqf
            };
            class loadUnit { // Allow loading conscious patients
                file = QPATHTOF(overrides\fnc_loadUnit.sqf); //ace/addons/medical_treatment/functions/fnc_loadUnit.sqf
            };
            class getTriageStatus { // Deceased -> Expectant
                file = QPATHTOF(overrides\fnc_getTriageStatus.sqf); //ace/addons/medical_treatment/functions/fnc_getTriageStatus.sqf
            };
            class handleBandageOpening { // Bandage reopening chance with platelets
                file = QPATHTOF(overrides\fnc_handleBandageOpening.sqf); //ace/addons/medical_treatment/functions/fnc_handleBandageOpening.sqf
            };
            class placeInBodyBag { // Return medical items on body bag use
                file = QPATHTOF(overrides\fnc_placeInBodyBag.sqf); //ace/addons/medical_treatment/functions/fnc_placeInBodyBag.sqf
            };
        };
    };
    class overwrite_medical_damage {
        tag = "ace_medical_damage";
        class ace_medical_damage {
            class woundsHandlerBase { // Modify wounds, coagulation functionality, chest injury
                file = QPATHTOF(overrides\fnc_woundsHandlerBase.sqf); //ace/addons/medical_damage/functions/fnc_woundsHandlerBase.sqf
            };
        };
    };
    class overwrite_medical_feedback {
        tag = "ace_medical_feedback";
        class ace_medical_feedback {
            class handleEffects { // Oxygen Effect
                file = QPATHTOF(overrides\fnc_handleEffects.sqf); //ace/addons/medical_feedback/functions/fnc_handleEffects.sqf
            };
            class effectHeartBeat { // Lower high HR threshold
                file = QPATHTOF(overrides\fnc_effectHeartBeat.sqf); //ace/addons/medical_feedback/functions/fnc_effectHeartBeat.sqf
            };
            class initEffects { // Oxygen Effect
                file = QPATHTOF(overrides\fnc_initEffects.sqf); //ace/addons/medical_feedback/functions/fnc_initEffects.sqf
            };
            class effectUnconscious { // Oxygen Effect
                file = QPATHTOF(overrides\fnc_effectUnconscious.sqf); //ace/addons/medical_feedback/functions/fnc_effectUnconscious.sqf
            };
            class playInjuredSound { // Prevent overlapping sounds
                file = QPATHTOF(overrides\fnc_playInjuredSound.sqf); //ace/addons/medical_feedback/functions/fnc_playInjuredSound.sqf
            };
        };
    };
    class overwrite_medical_statemachine {
        tag = "ace_medical_statemachine";
        class ace_medical_statemachine {
            class enteredStateCardiacArrest { // Disable cardiac arrest timer
                file = QPATHTOF(overrides\fnc_enteredStateCardiacArrest.sqf); //ace/addons/medical_statemachine/functions/fnc_enteredStateCardiacArrest.sqf
            };
            class handleStateUnconscious { // KnockOut state
                file = QPATHTOF(overrides\fnc_handleStateUnconscious.sqf); //ace/addons/medical_statemachine/functions/fnc_handleStateUnconscious.sqf
            };
            class conditionSecondChance { // Damage
                file = QPATHTOF(overrides\fnc_conditionSecondChance.sqf); //ace/addons/medical_statemachine/functions/fnc_conditionSecondChance.sqf
            };
            class conditionExecutionDeath { // Damage
                file = QPATHTOF(overrides\fnc_conditionExecutionDeath.sqf); //ace/addons/medical_statemachine/functions/fnc_conditionExecutionDeath.sqf
            };
        };
    };
    class overwrite_medical_engine {
        tag = "ace_medical_engine";
        class ace_medical_engine {
            class setUnconsciousAnim { // Force lying animation when waking up
                file = QPATHTOF(overrides\fnc_setUnconsciousAnim.sqf); //ace/addons/medical_engine/functions/fnc_setUnconsciousAnim.sqf
            };
            class applyAnimAfterRagdoll { // Lying state
                file = QPATHTOF(overrides\fnc_applyAnimAfterRagdoll.sqf); //ace/addons/medical_engine/functions/fnc_applyAnimAfterRagdoll.sqf
            };
            class updateDamageEffects { // Tourniquet effects for legs, splints/fractures
                file = QPATHTOF(overrides\fnc_updateDamageEffects.sqf); //ace/addons/medical_engine/functions/fnc_updateDamageEffects.sqf
            };
            class handleDamage { // CBRN chemical burns
                file = QPATHTOF(overrides\fnc_handleDamage.sqf); //ace/addons/medical_engine/functions/fnc_handleDamage.sqf
            };
        };
    };
    class overwrite_medical_ai {
        tag = "ace_medical_ai";
        class ace_medical_ai {
            class healingLogic { // Use new items, setting
                file = QPATHTOF(overrides\fnc_healingLogic.sqf); //ace/addons/medical_ai/functions/fnc_healingLogic.sqf
            };
            class healSelf { // Prevent treatment from lying state
                file = QPATHTOF(overrides\fnc_healSelf.sqf); //ace/addons/medical_ai/functions/fnc_healSelf.sqf
            };
            class healUnit { // Prevent treatment from lying state
                file = QPATHTOF(overrides\fnc_healUnit.sqf); //ace/addons/medical_ai/functions/fnc_healUnit.sqf
            };
            class itemCheck { // Use own item list
                file = QPATHTOF(overrides\fnc_itemCheck.sqf); //ace/addons/medical_ai/functions/fnc_itemCheck.sqf
            };
            class playTreatmentAnim { // Medic AI CPR
                file = QPATHTOF(overrides\fnc_playTreatmentAnim.sqf); //ace/addons/medical_ai/functions/fnc_playTreatmentAnim.sqf
            };
        };
    };
    class overwrite_ace_dogtags {
        tag = "ace_dogtags";
        class ace_dogtags {
            class getDogtagData { // Blood type, weight display
                file = QPATHTOF(overrides\fnc_getDogtagData.sqf); //ace/addons/dogtags/functions/fnc_getDogtagData.sqf
            };
            class showDogtag { // Blood type, weight display
                file = QPATHTOF(overrides\fnc_showDogtag.sqf); //ace/addons/dogtags/functions/fnc_showDogtag.sqf
            };
            class checkDogtag { // Dog tags being checked hint
                file = QPATHTOF(overrides\fnc_checkDogtag.sqf); //ace/addons/dogtags/functions/fnc_checkDogtag.sqf
            };
        };
    };
    class overwrite_ace_advanced_fatigue {
        tag = "ace_advanced_fatigue";
        class ace_advanced_fatigue {
            class handleEffects { // Pneumothorax
                file = QPATHTOF(overrides\fnc_handleEffects_AF.sqf); //ace/addons/advanced_fatigue/functions/fnc_handleEffects.sqf
            };
        };
    };
    class overwrite_ace_dragging {
        tag = "ace_dragging";
        class ace_dragging {
            class startCarryLocal { // Assist carry action
                file = QPATHTOF(overrides\fnc_startCarryLocal.sqf); //ace/addons/dragging/functions/fnc_startCarryLocal.sqf
            };
            class dropObject_carry { // Handle dropping animation
                file = QPATHTOF(overrides\fnc_dropObject_carry.sqf); //ace/addons/dragging/functions/fnc_dropObject_carry.sqf
            };
            class handleUnconscious { // Cancel carrying prompt, prevent dropping woken-up casualties
                file = QPATHTOF(overrides\fnc_handleUnconscious.sqf); //ace/addons/dragging/functions/fnc_handleUnconscious.sqf
            };
            class canDrag { // Lying state allow drag
                file = QPATHTOF(overrides\fnc_canDrag.sqf); //ace/addons/dragging/functions/fnc_canDrag.sqf
            };
            class canCarry { // Lying state allow carry
                file = QPATHTOF(overrides\fnc_canCarry.sqf); //ace/addons/dragging/functions/fnc_canCarry.sqf
            };
        };
    };
};