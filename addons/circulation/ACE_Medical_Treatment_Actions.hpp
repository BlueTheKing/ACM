#define AMS_BLOODBAG_ENTRY(type,typeS,amount,item) \
    class TRIPLE(BloodBag,type,amount): BloodBag_O_1000 { \
        displayName = QUOTE(Transfuse Blood typeS (amountml)); \
        items[] = {QUOTE(TRIPLES(AMS_BloodBag,type,amount))}; \
    }

class ACEGVAR(medical_treatment,actions) {
    class CheckPulse;

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
        treatmentTime = 4;// TODO change
        allowedSelections[] = {"Body"};
        allowSelfTreatment = 0;
        items[] = {"AMS_AED"};
        consumeItem = 0;
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,1)] call FUNC(hasAED)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call FUNC(setAED));
    };
    class AED_RemovePads: AED_ApplyPads {
        displayName = "Remove AED Pads";
        displayNameProgress = "Removing AED Pads...";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 3;
        allowSelfTreatment = 1;
        condition = QUOTE([ARR_3(_patient,_bodyPart,1)] call FUNC(hasAED));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,0,false)] call FUNC(setAED));
    };
    class AED_ConnectPulseOximeter: AED_ApplyPads {
        displayName = "Connect AED Pulse Oximeter";
        displayNameProgress = "Connecting AED Pulse Oximeter...";
        icon = "";
        category = "examine";
        treatmentTime = 4;// TODO change
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE(!([ARR_3(_patient,_bodyPart,2)] call FUNC(hasAED)) && (_patient getVariable [ARR_2(QQGVAR(AEDMonitor_Placement_PulseOximeter),-1)]) == -1);
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call FUNC(setAED));
    };
    class AED_DisconnectPulseOximeter: AED_RemovePads {
        displayName = "Disconnect AED Pulse Oximeter";
        displayNameProgress = "Disconnecting AED Pulse Oximeter...";
        category = "examine";
        treatmentTime = 3;
        allowedSelections[] = {"LeftArm","RightArm"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,2)] call FUNC(hasAED) && (_patient getVariable [ARR_2(QQGVAR(AEDMonitor_Placement_PulseOximeter),-1)]) != -1);
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,1,false)] call FUNC(setAED));
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
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(AED_BeginCharge));
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
        items[] = {"AMS_IV_16g"};
        consumeItem = 1;
        condition = QUOTE(!([ARR_2(_patient,_bodyPart)] call FUNC(hasIV)));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,AMS_IV_16G,true)] call FUNC(setIV));
    };
    class InsertIV_14: InsertIV_16 {
        displayName = "Insert 14g IV";
        displayNameProgress = "Inserting 14g IV...";
        icon = "";
        treatmentTime = QGVAR(treatmentTimeIV_14);
        items[] = {"AMS_IV_14g"};
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,AMS_IV_14G,true)] call FUNC(setIV));
    };
    class InsertIO: InsertIV_16 {
        displayName = "Insert FAST1 IO";
        displayNameProgress = "Inserting FAST1 IO...";
        icon = "";
        medicRequired = QGVAR(allowIO);
        treatmentTime = QGVAR(treatmentTimeIO_FAST1);
        allowedSelections[] = {"Body"};
        allowSelfTreatment = QGVAR(selfIO);
        items[] = {"AMS_IO_FAST1"};
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,AMS_IO_FAST1,true)] call FUNC(setIV));
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
        condition = QUOTE([ARR_3(_patient,_bodyPart,AMS_IV_16G)] call FUNC(hasIV));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,AMS_IV_16G,false)] call FUNC(setIV));
    };
    class RemoveIV_14: RemoveIV_16 {
        displayName = "Remove 14g IV";
        displayNameProgress = "Removing 14g IV...";
        icon = "";
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_3(_patient,_bodyPart,AMS_IV_14G)] call FUNC(hasIV));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,AMS_IV_14G,false)] call FUNC(setIV));
    };
    class RemoveIO: RemoveIV_16 {
        displayName = "Remove FAST1 IO";
        displayNameProgress = "Removing FAST1 IO...";
        icon = "";
        allowedSelections[] = {"Body"};
        treatmentTime = 5;
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_3(_patient,_bodyPart,AMS_IO_FAST1)] call FUNC(hasIV));
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,AMS_IO_FAST1,false)] call FUNC(setIV));
    };

    class BasicBandage;
    class BloodIV: BasicBandage {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };

    class CPR {
        displayNameProgress = "";
        treatmentTime = 0.01;
        callbackStart = "";
        callbackProgress = "";
        callbackFailure = "";
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(beginCPR));
        condition = QACEFUNC(medical_treatment,canCPR);
    };
    /*class BloodIV_500: BloodIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class BloodIV_250: BloodIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class PlasmaIV: BloodIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class PlasmaIV_500: PlasmaIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class PlasmaIV_250: PlasmaIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class SalineIV: BloodIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class SalineIV_500: SalineIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };
    class SalineIV_250: SalineIV {
        allowedSelections[] = {"Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(hasIV));
    };*/

    class BloodBag_O_1000: BloodIV {
        displayName = "Transfuse Blood O+ (1000ml)";
        displayNameProgress = "Transfusing Blood...";
        items[] = {"AMS_BloodBag_O_1000"};
        callbackSuccess = QFUNC(transfuseBlood);
    };
    AMS_BLOODBAG_ENTRY(ON,'O-',1000);
    AMS_BLOODBAG_ENTRY(A,'A+',1000);
    AMS_BLOODBAG_ENTRY(AN,'A-',1000);
    AMS_BLOODBAG_ENTRY(B,'B+',1000);
    AMS_BLOODBAG_ENTRY(BN,'B-',1000);
    AMS_BLOODBAG_ENTRY(AB,'AB+',1000);
    AMS_BLOODBAG_ENTRY(ABN,'AB-',1000);

    AMS_BLOODBAG_ENTRY(O,'O+',500);
    AMS_BLOODBAG_ENTRY(ON,'O-',500);
    AMS_BLOODBAG_ENTRY(A,'A+',500);
    AMS_BLOODBAG_ENTRY(AN,'A-',500);
    AMS_BLOODBAG_ENTRY(B,'B+',500);
    AMS_BLOODBAG_ENTRY(BN,'B-',500);
    AMS_BLOODBAG_ENTRY(AB,'AB+',500);
    AMS_BLOODBAG_ENTRY(ABN,'AB-',500);

    AMS_BLOODBAG_ENTRY(O,'O+',250);
    AMS_BLOODBAG_ENTRY(ON,'O-',250);
    AMS_BLOODBAG_ENTRY(A,'A+',250);
    AMS_BLOODBAG_ENTRY(AN,'A-',250);
    AMS_BLOODBAG_ENTRY(B,'B+',250);
    AMS_BLOODBAG_ENTRY(BN,'B-',250);
    AMS_BLOODBAG_ENTRY(AB,'AB+',250);
    AMS_BLOODBAG_ENTRY(ABN,'AB-',250);
};
