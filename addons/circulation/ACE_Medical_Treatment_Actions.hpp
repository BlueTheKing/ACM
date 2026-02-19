class ACEGVAR(medical_treatment,actions) {
    class Diagnose;
    class CheckPulse: Diagnose {
        displayName = CSTRING(FeelPulse);
        displayNameProgress = "";
        treatmentTime = 0.001;
        allowedSelections[] = {"Head","LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = "true";
        callbackSuccess = QFUNC(feelPulse);
    };

    class PressureCuff_Attach: CheckPulse {
        displayName = CSTRING(PressureCuff_Attach);
        displayNameProgress = CSTRING(PressureCuff_Attach_Progress);
        icon = "";
        category = "examine";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 4;
        allowedSelections[] = {"LeftArm","RightArm"};
        items[] = {"ACM_PressureCuff"};
        consumeItem = 1;
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,3)] call FUNC(hasAED)) && !([ARR_2(_patient,_bodyPart)] call FUNC(hasPressureCuff)) && !([ARR_4(_patient,_bodyPart,0,0)] call FUNC(hasIV)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,true)] call FUNC(setPressureCuff));
        ACM_cancelRecovery = 1;
        ACM_rollToBack = 1;
        ACM_menuIcon = "ACM_PressureCuff";
    };
    class PressureCuff_Remove: PressureCuff_Attach {
        displayName = CSTRING(PressureCuff_Remove);
        displayNameProgress = CSTRING(PressureCuff_Remove_Progress);
        icon = "";
        treatmentTime = 2;
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasPressureCuff));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call FUNC(setPressureCuff));
    };

    class AED_ViewMonitor: CheckPulse {
        displayName = CSTRING(AED_ViewMonitor);
        displayNameProgress = "";
        icon = "";
        category = "examine";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = QGVAR(allowAED);
        treatmentTime = 0.01;
        allowedSelections[] = {"All"};
        allowSelfTreatment = 0;
        condition = QUOTE(([ARR_2(_patient,_bodyPart)] call FUNC(hasAED)));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(displayAEDMonitor));
        ACM_menuIcon = "ACM_AED";
    };

    class AED_ApplyPads: CheckPulse {
        displayName = CSTRING(AED_ApplyPads);
        displayNameProgress = CSTRING(AED_ApplyPads);
        icon = "";
        category = "advanced";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = QGVAR(allowAED);
        treatmentTime = QFUNC(getApplyPadsTime);
        allowedSelections[] = {"Body"};
        allowSelfTreatment = 0;
        consumeItem = 0;
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,1)] call FUNC(hasAED)) && ([ARR_2(_medic,_patient)] call FUNC(canConnectAED)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call FUNC(setAED));
        ACM_cancelRecovery = 1;
        ACM_rollToBack = 1;
        ACM_menuIcon = "ACM_AED";
    };
    class AED_RemovePads: AED_ApplyPads {
        displayName = CSTRING(AED_RemovePads);
        displayNameProgress = CSTRING(AED_RemovePads_Progress);
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 1;
        allowSelfTreatment = 1;
        condition = QUOTE([ARR_3(_patient,_bodyPart,1)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,0,false)] call FUNC(setAED));
        ACM_cancelRecovery = 0;
    };
    class AED_ConnectPulseOximeter: AED_ApplyPads {
        displayName = CSTRING(AED_ConnectPulseOximeter);
        displayNameProgress = CSTRING(AED_ConnectPulseOximeter_Progress);
        icon = "";
        category = "examine";
        treatmentTime = 2;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE(!([ARR_3(_patient,'',2)] call FUNC(hasAED)) && ([ARR_2(_medic,_patient)] call FUNC(canConnectAED)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call FUNC(setAED));
        ACM_cancelRecovery = 0;
        ACM_rollToBack = 0;
    };
    class AED_DisconnectPulseOximeter: AED_RemovePads {
        displayName = CSTRING(AED_DisconnectPulseOximeter);
        displayNameProgress = CSTRING(AED_DisconnectPulseOximeter_Progress);
        category = "examine";
        treatmentTime = 1;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,2)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,1,false)] call FUNC(setAED));
        ACM_rollToBack = 0;
    };
    class AED_ConnectPressureCuff: AED_ApplyPads {
        displayName = CSTRING(AED_ConnectPressureCuff);
        displayNameProgress = CSTRING(AED_ConnectPressureCuff_Progress);
        icon = "";
        category = "examine";
        treatmentTime = 3;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE(!([ARR_3(_patient,'',3)] call FUNC(hasAED)) && !([ARR_2(_patient,_bodyPart)] call FUNC(hasPressureCuff)) && ([ARR_2(_medic,_patient)] call FUNC(canConnectAED)) && !([ARR_4(_patient,_bodyPart,0,0)] call FUNC(hasIV)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call FUNC(setAED));
        ACM_cancelRecovery = 0;
    };
    class AED_DisconnectPressureCuff: AED_RemovePads {
        displayName = CSTRING(AED_DisconnectPressureCuff);
        displayNameProgress = CSTRING(AED_DisconnectPressureCuff_Progress);
        category = "examine";
        treatmentTime = 1;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,3)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,2,false)] call FUNC(setAED));
    };
    class AED_ConnectCapnograph: AED_ApplyPads {
        displayName = CSTRING(AED_ConnectCapnograph);
        displayNameProgress = CSTRING(AED_ConnectCapnograph_Progress);
        icon = "";
        category = "examine";
        treatmentTime = 3;
        allowedSelections[] = {"Head"};
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,4)] call FUNC(hasAED)) && ([ARR_2(_medic,_patient)] call FUNC(canConnectAED)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,3)] call FUNC(setAED));
        ACM_cancelRecovery = 0;
    };
    class AED_DisconnectCapnograph: AED_RemovePads {
        displayName = CSTRING(AED_DisconnectCapnograph);
        displayNameProgress = CSTRING(AED_DisconnectCapnograph_Progress);
        category = "examine";
        treatmentTime = 1;
        allowedSelections[] = {"Head"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,4)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,3,false)] call FUNC(setAED));
    };

    class AED_AnalyzeRhythm: AED_ViewMonitor {
        displayName = CSTRING(AED_AnalyzeRhythm);
        category = "examine";
        allowedSelections[] = {"Body"};
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanAnalyzeRhythm));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_AnalyzeRhythm));
    };
    class AED_ManualCharge: AED_AnalyzeRhythm {
        displayName = CSTRING(AED_ManualCharge);
        category = "advanced";
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanManualCharge));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(AED_BeginCharge));
    };
    class AED_Shock: AED_ManualCharge {
        displayName = CSTRING(AED_Shock);
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanAdministerShock));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_AdministerShock));
    };
    class AED_CancelCharge: AED_ManualCharge {
        displayName = CSTRING(AED_CancelCharge);
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanCancelCharge));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CancelCharge));
    };
    class AED_MeasureBP: AED_AnalyzeRhythm {
        displayName = CSTRING(AED_MeasureBP);
        allowedSelections[] = {"LeftArm","RightArm","Body"};
        condition = QFUNC(AED_CanMeasureBP);
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_MeasureBP));
    };

    class CPR {
        displayName = CSTRING(BeginCPR);
        displayNameProgress = "";
        treatmentTime = 0.01;
        callbackStart = "";
        callbackProgress = "";
        callbackFailure = "";
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(beginCPR));
        condition = QUOTE([ARR_2(_medic,_patient)] call ACEFUNC(medical_treatment,canCPR) && ((_patient getVariable [ARR_2(QQEGVAR(airway,AirwayItem_Oral),'')] == 'SGA') || !([_patient] call EFUNC(core,bvmActive))));
        ACM_rollToBack = 1;
        ACM_cancelRecovery = 1;
        ACM_menuIcon = "CPR";
    };

    class BasicBandage;
    class BloodIV: BasicBandage {
        condition = "false";
    };
    class PlasmaIV: BloodIV {
        condition = "false";
    };
    class SalineIV: BloodIV {
        condition = "false";
    };
};
