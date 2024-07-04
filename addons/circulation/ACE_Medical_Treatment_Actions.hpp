#define ACM_BLOODBAG_ENTRY(type,typeS,amount) \
    class TRIPLES(BloodBag,type,amount): BloodBag_O_1000 { \
        displayName = QUOTE(Give Blood typeS (##amount##ml)); \
        items[] = {QUOTE(TRIPLES(ACM_BloodBag,type,amount))}; \
    }

class ACEGVAR(medical_treatment,actions) {
    class Diagnose;
    class CheckPulse: Diagnose {
        displayName = "Feel Pulse";
        displayNameProgress = "";
        treatmentTime = 0.001;
        allowedSelections[] = {"Head","LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = "true";
        callbackSuccess = QFUNC(feelPulse);
    };

    class PressureCuff_Attach: CheckPulse {
        displayName = "Attach Pressure Cuff";
        displayNameProgress = "Attaching Pressure Cuff...";
        icon = "";
        category = "examine";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 4;
        allowedSelections[] = {"LeftArm","RightArm"};
        items[] = {"ACM_PressureCuff"};
        consumeItem = 1;
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,3)] call FUNC(hasAED)) && !([ARR_2(_patient,_bodyPart)] call FUNC(hasPressureCuff)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,true)] call FUNC(setPressureCuff));
        ACM_cancelRecovery = 1;
        ACM_rollToBack = 1;
    };
    class PressureCuff_Remove: PressureCuff_Attach {
        displayName = "Remove Pressure Cuff";
        displayNameProgress = "Removing Pressure Cuff...";
        icon = "";
        treatmentTime = 2;
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasPressureCuff));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call FUNC(setPressureCuff));
    };

    class AED_ViewMonitor: CheckPulse {
        displayName = "View AED Monitor";
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
    };

    class AED_ApplyPads: CheckPulse {
        displayName = "Apply AED Pads";
        displayNameProgress = "Applying AED Pads...";
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
    };
    class AED_RemovePads: AED_ApplyPads {
        displayName = "Remove AED Pads";
        displayNameProgress = "Removing AED Pads...";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 1;
        allowSelfTreatment = 1;
        condition = QUOTE([ARR_3(_patient,_bodyPart,1)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,0,false)] call FUNC(setAED));
    };
    class AED_ConnectPulseOximeter: AED_ApplyPads {
        displayName = "Connect AED Pulse Oximeter";
        displayNameProgress = "Connecting AED Pulse Oximeter...";
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
        displayName = "Disconnect AED Pulse Oximeter";
        displayNameProgress = "Disconnecting AED Pulse Oximeter...";
        category = "examine";
        treatmentTime = 1;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,2)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,1,false)] call FUNC(setAED));
        ACM_rollToBack = 0;
    };
    class AED_ConnectPressureCuff: AED_ApplyPads {
        displayName = "Connect AED Pressure Cuff";
        displayNameProgress = "Connecting AED Pressure Cuff...";
        icon = "";
        category = "examine";
        treatmentTime = 3;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE(!([ARR_3(_patient,'',3)] call FUNC(hasAED)) && !([ARR_2(_patient,_bodyPart)] call FUNC(hasPressureCuff)) && ([ARR_2(_medic,_patient)] call FUNC(canConnectAED)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call FUNC(setAED));
        ACM_cancelRecovery = 0;
    };
    class AED_DisconnectPressureCuff: AED_RemovePads {
        displayName = "Disconnect AED Pressure Cuff";
        displayNameProgress = "Disconnecting AED Pressure Cuff...";
        category = "examine";
        treatmentTime = 1;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,3)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,2,false)] call FUNC(setAED));
    };
    class AED_ConnectCapnograph: AED_ApplyPads {
        displayName = "Connect AED Capnograph";
        displayNameProgress = "Connecting AED Capnograph...";
        icon = "";
        category = "examine";
        treatmentTime = 3;
        allowedSelections[] = {"Head"};
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,4)] call FUNC(hasAED)) && ([ARR_2(_medic,_patient)] call FUNC(canConnectAED)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,3)] call FUNC(setAED));
        ACM_cancelRecovery = 0;
    };
    class AED_DisconnectCapnograph: AED_RemovePads {
        displayName = "Disconnect AED Capnograph";
        displayNameProgress = "Disconnecting AED Capnograph...";
        category = "examine";
        treatmentTime = 1;
        allowedSelections[] = {"Head"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,4)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,3,false)] call FUNC(setAED));
    };

    class AED_AnalyzeRhythm: AED_ViewMonitor {
        displayName = "Analyze Rhythm";
        category = "examine";
        allowedSelections[] = {"Body"};
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanAnalyzeRhythm));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_AnalyzeRhythm));
    };
    class AED_ManualCharge: AED_AnalyzeRhythm {
        displayName = "Charge AED";
        category = "advanced";
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanManualCharge));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(AED_BeginCharge));
    };
    class AED_Shock: AED_ManualCharge {
        displayName = "Administer Shock";
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanAdministerShock));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_AdministerShock));
    };
    class AED_CancelCharge: AED_ManualCharge {
        displayName = "Cancel Charge";
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CanCancelCharge));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_CancelCharge));
    };
    class AED_MeasureBP: AED_AnalyzeRhythm {
        displayName = "Measure Blood Pressure (AED)";
        allowedSelections[] = {"LeftArm","RightArm","Body"};
        condition = QFUNC(AED_CanMeasureBP);
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_MeasureBP));
    };

    class InsertIV_16: CheckPulse {
        displayName = "Insert 16g IV";
        displayNameProgress = "Inserting 16g IV...";
        icon = "";
        category = "advanced";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = QGVAR(allowIV);
        treatmentTime = QGVAR(treatmentTimeIV_16);
        allowedSelections[] = {"LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        allowSelfTreatment = QGVAR(selfIV);
        items[] = {"ACM_IV_16g"};
        consumeItem = 1;
        condition = QUOTE(!([ARR_2(_patient,_bodyPart)] call FUNC(hasIV)));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,ACM_IV_16G_M,true)] call FUNC(setIV));
        ACM_rollToBack = 1;
    };
    class InsertIV_14: InsertIV_16 {
        displayName = "Insert 14g IV";
        displayNameProgress = "Inserting 14g IV...";
        icon = "";
        treatmentTime = QGVAR(treatmentTimeIV_14);
        items[] = {"ACM_IV_14g"};
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,ACM_IV_14G_M,true)] call FUNC(setIV));
    };
    class InsertIO: InsertIV_16 {
        displayName = "Insert FAST1 IO";
        displayNameProgress = "Inserting FAST1 IO...";
        icon = "";
        medicRequired = QGVAR(allowIO);
        treatmentTime = QGVAR(treatmentTimeIO_FAST1);
        allowedSelections[] = {"Body"};
        allowSelfTreatment = QGVAR(selfIO);
        items[] = {"ACM_IO_FAST"};
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,ACM_IO_FAST1_M,true)] call FUNC(setIV));
        ACM_cancelRecovery = 1;
    };

    class RemoveIV_16: InsertIV_16 {
        displayName = "Remove 16g IV";
        displayNameProgress = "Removing 16g IV...";
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 4;
        allowSelfTreatment = 1;
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IV_16G_M)] call FUNC(hasIV));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,ACM_IV_16G_M,false)] call FUNC(setIV));
    };
    class RemoveIV_14: RemoveIV_16 {
        displayName = "Remove 14g IV";
        displayNameProgress = "Removing 14g IV...";
        icon = "";
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IV_14G_M)] call FUNC(hasIV));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,ACM_IV_14G_M,false)] call FUNC(setIV));
    };
    class RemoveIO: RemoveIV_16 {
        displayName = "Remove FAST1 IO";
        displayNameProgress = "Removing FAST1 IO...";
        icon = "";
        allowedSelections[] = {"Body"};
        treatmentTime = 5;
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IO_FAST1_M)] call FUNC(hasIV));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,ACM_IO_FAST1_M,false)] call FUNC(setIV));
    };

    class CPR {
        displayName = "Begin CPR";
        displayNameProgress = "";
        treatmentTime = 0.01;
        callbackStart = "";
        callbackProgress = "";
        callbackFailure = "";
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(beginCPR));
        condition = QUOTE([ARR_2(_medic,_patient)] call ACEFUNC(medical_treatment,canCPR) && ((_patient getVariable [ARR_2(QQEGVAR(airway,AirwayItem_Oral),'')] == 'SGA') || !([_patient] call EFUNC(core,bvmActive))));
        ACM_rollToBack = 1;
        ACM_cancelRecovery = 1;
    };

    class BasicBandage;
    class BloodIV: BasicBandage {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = "false";
    };
    class BloodBag_O_1000: BloodIV {
        displayName = "Give Blood O+ (1000ml)";
        displayNameProgress = "Transfusing Blood...";
        items[] = {"ACM_BloodBag_O_1000"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    ACM_BLOODBAG_ENTRY(ON,O-,1000);
    ACM_BLOODBAG_ENTRY(A,A+,1000);
    ACM_BLOODBAG_ENTRY(AN,A-,1000);
    ACM_BLOODBAG_ENTRY(B,B+,1000);
    ACM_BLOODBAG_ENTRY(BN,B-,1000);
    ACM_BLOODBAG_ENTRY(AB,AB+,1000);
    ACM_BLOODBAG_ENTRY(ABN,AB-,1000);

    ACM_BLOODBAG_ENTRY(O,O+,500);
    ACM_BLOODBAG_ENTRY(ON,O-,500);
    ACM_BLOODBAG_ENTRY(A,A+,500);
    ACM_BLOODBAG_ENTRY(AN,A-,500);
    ACM_BLOODBAG_ENTRY(B,B+,500);
    ACM_BLOODBAG_ENTRY(BN,B-,500);
    ACM_BLOODBAG_ENTRY(AB,AB+,500);
    ACM_BLOODBAG_ENTRY(ABN,AB-,500);

    ACM_BLOODBAG_ENTRY(O,O+,250);
    ACM_BLOODBAG_ENTRY(ON,O-,250);
    ACM_BLOODBAG_ENTRY(A,A+,250);
    ACM_BLOODBAG_ENTRY(AN,A-,250);
    ACM_BLOODBAG_ENTRY(B,B+,250);
    ACM_BLOODBAG_ENTRY(BN,B-,250);
    ACM_BLOODBAG_ENTRY(AB,AB+,250);
    ACM_BLOODBAG_ENTRY(ABN,AB-,250);
    class PlasmaIV: BloodIV {
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class SalineIV: BloodIV {
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
};
