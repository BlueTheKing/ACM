#define SYRINGE_ACTION_FORMAT(action,size,med,acc) QUOTE(format [ARR_5('%1 %2 (%3ml) (%4)',localize 'STR_ACM_Circulation_##action##',localize 'STR_ACM_Circulation_Medication_##med##',size,localize 'STR_ACM_Circulation_##acc##_Short')])
#define SYRINGE_PROGRESS_FORMAT(var1,var2) QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_Syringe_##var1##',localize 'STR_ACM_Circulation_Medication_##var2##')])

#define SYRINGE_ACTION_IV(medication,size,name,progress) \
    class TRIPLES(medication,size,IV): TRIPLES(Epinephrine,size,IV) { \
        displayName = name; \
        displayNameProgress = progress; \
        icon = QPATHTOEF(circulation,ui\icon_syringe_##size##_ca.paa); \
        items[] = {QUOTE(ACM_Syringe_##size##_##medication##)}; \
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) || [ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO)); \
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'##medication##',##size##,true,true)] call EFUNC(circulation,Syringe_Inject)); \
        ACM_menuIcon = "Syringe"; \
    }

#define SYRINGE_ACTION_IM(medication,size,name,progress) \
    class TRIPLES(medication,size,IM): TRIPLES(Epinephrine,size,IM) { \
        displayName = name; \
        displayNameProgress = progress; \
        icon = QPATHTOEF(circulation,ui\icon_syringe_##size##_ca.paa); \
        items[] = {QUOTE(ACM_Syringe_##size##_##medication##)}; \
        condition = "true"; \
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'##medication##',##size##,false,true)] call EFUNC(circulation,Syringe_Inject)); \
        ACM_menuIcon = "Syringe"; \
    }

class ACEGVAR(medical_treatment,actions) {
    class BasicBandage;
    class BodyBag: BasicBandage {
        ACM_menuIcon = "ACE_bodyBag";
    };
    class BodyBagBlue: BodyBag {
        ACM_menuIcon = "ACE_bodyBag_blue";
    };
    class BodyBagWhite: BodyBag {
        ACM_menuIcon = "ACE_bodyBag_white";
    };
    class Splint: BasicBandage {
        ACM_menuIcon = "ACE_splint";
    };
    class FieldDressing;
    class Morphine: FieldDressing {
        displayName = CSTRING(MorphineAutoinjector);
        displayNameProgress = CSTRING(MorphineAutoinjector_Progress);
        ACM_menuIcon = "ACE_morphine";
    };
    class Adenosine: Morphine {
        displayName = CSTRING(AdenosineAutoinjector);
        displayNameProgress = CSTRING(AdenosineAutoinjector_Progress);
        ACM_menuIcon = "ACE_adenosine";
    };
    class Epinephrine: Morphine {
        displayName = CSTRING(EpinephrineAutoinjector);
        displayNameProgress = CSTRING(EpinephrineAutoinjector_Progress);
        ACM_menuIcon = "ACE_epinephrine";
    };
    class ATNA_Autoinjector: Morphine {
        displayName = ECSTRING(CBRN,ATNAAutoinjector);
        displayNameProgress = ECSTRING(CBRN,ATNAAutoinjector_Progress);
        medicRequired = QGVAR(allowATNAAutoinjector);
        items[] = {"ACM_Autoinjector_ATNA"};
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        litter[] = {{"ACE_MedicalLitter_atropine"}};
        ACM_menuIcon = "ACM_ATNA_Autoinjector";
    };
    class Midazolam_Autoinjector: ATNA_Autoinjector {
        displayName = ECSTRING(CBRN,MidazolamAutoinjector);
        displayNameProgress = ECSTRING(CBRN,MidazolamAutoinjector_Progress);
        medicRequired = QGVAR(allowMidazolamAutoinjector);
        items[] = {"ACM_Autoinjector_Midazolam"};
        ACM_menuIcon = "ACM_Midazolam_Autoinjector";
    };
    class CheckPulse;
    class CheckResponse: CheckPulse {
        treatmentTime = 2.5;
        ACM_menuIcon = "";
    };
    class CheckBloodPressure: CheckPulse {
        displayName = ECSTRING(circulation,CheckCapillaryRefill);
        displayNameProgress = ECSTRING(circulation,CheckCapillaryRefill_Progress);
        allowedSelections[] = {"Body", "LeftArm", "RightArm"};
        treatmentTime = 4;
        callbackSuccess = QEFUNC(circulation,checkCapillaryRefill);
        ACM_menuIcon = "";
    };
    class MeasureBloodPressure: CheckBloodPressure {
        displayName = ECSTRING(circulation,PressureCuff_Measure);
        displayNameProgress = "";
        allowedSelections[] = {"LeftArm", "RightArm"};
        treatmentTime = 0.01;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasPressureCuff));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call EFUNC(circulation,measureBP));
        ACM_menuIcon = "ACM_PressureCuff";
    };
    class MeasureBloodPressureStethoscope: MeasureBloodPressure {
        displayName = ECSTRING(circulation,PressureCuff_Measure_Stethoscope);
        items[] = {"ACM_Stethoscope"};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,true)] call EFUNC(circulation,measureBP));
        ACM_menuIcon = "ACM_Stethoscope";
    };
    class CheckDogTags: CheckResponse {
        displayName = ACECSTRING(dogtags,checkItem);
        displayNameProgress = "";
        icon = QACEPATHTOF(dogtags,data\dogtag_icon_ca.paa);
        treatmentTime = 2;
        allowSelfTreatment = 1;
        condition = QFUNC(canCheckDogtag);
        callbackSuccess = QACEFUNC(dogtags,checkDogtag);
        ACM_rollToBack = 1;
        ACM_menuIcon = "Dogtag";
    };

    class PressureBandage: BasicBandage {
        displayName = ECSTRING(damage,PressureBandage);
        displayNameProgress = ACECSTRING(medical_treatment,Bandaging);
        icon = QACEPATHTOF(medical_gui,ui\bandage.paa);
        category = "bandage";

        consumeItem = 1;
        items[] = {"ACM_PressureBandage"};

        medicRequired = 0;
        allowSelfTreatment = 1;
        allowedSelections[] = {"All"};
        treatmentLocations = TREATMENT_LOCATIONS_ALL;

        treatmentTime = QEFUNC(damage,getBandageTime);

        callbackStart = "";
        callbackProgress = "";
        callbackSuccess = QACEFUNC(medical_treatment,bandage);
        callbackFailure = "";

        animationMedic = "AinvPknlMstpSlayW[wpn]Dnon_medicOther";
        animationMedicProne = "AinvPpneMstpSlayW[wpn]Dnon_medicOther";
        animationMedicSelf = "AinvPknlMstpSlayW[wpn]Dnon_medic";
        animationMedicSelfProne = "AinvPpneMstpSlayW[wpn]Dnon_medic";
        ACM_menuIcon = "ACM_PressureBandage";
    };
    class EmergencyTraumaDressing: PressureBandage {
        displayName = ECSTRING(damage,EmergencyTraumaDressing);
        items[] = {"ACM_EmergencyTraumaDressing"};
        allowSelfTreatment = 0;
        ACM_menuIcon = "ACM_EmergencyTraumaDressing";
    };
    class ElasticWrap: PressureBandage {
        displayName = ECSTRING(damage,ElasticWrap_Bruises);
        displayNameProgress = ECSTRING(damage,ElasticWrap_Progress);
        items[] = {"ACM_ElasticWrap"};
        medicRequired = QGVAR(allowWrap);
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call EFUNC(damage,canWrap));
        treatmentTime = QEFUNC(damage,getBruiseWrapTime);
        callbackSuccess = QEFUNC(damage,wrapBruises);
        ACM_menuIcon = "ACM_ElasticWrap";
    };
    class ElasticWrapBandages: ElasticWrap {
        displayName = ECSTRING(damage,ElasticWrap_Bandages);
        condition = QUOTE([ARR_3(_medic,_patient,_bodyPart)] call EFUNC(damage,canWrap));
        treatmentTime = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call EFUNC(damage,getWrapTime));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call EFUNC(damage,wrapBodypart));
    };
    class ElasticWrapClots: ElasticWrap {
        displayName = ECSTRING(damage,ElasticWrap_Clots);
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,canWrap));
        treatmentTime = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,getWrapTime));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,wrapBodypart));
    };
    class ElasticWrapSplint: ElasticWrap {
        displayName = ECSTRING(disability,ElasticWrap_Splint);
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = QEFUNC(disability,canWrapSplint);
        treatmentTime = QEFUNC(disability,getSplintWrapTime);
        callbackSuccess = QEFUNC(disability,wrapSplint);
    };

    // Surgical Airway
    class StitchAirwayIncision: FieldDressing {
        displayName = ECSTRING(airway,SurgicalAirwayStitch);
        displayNameProgress = ACECSTRING(medical_treatment,Stitching);
        icon = QACEPATHTOF(medical_gui,ui\surgical_kit.paa);
        category = "airway";
        items[] = {"ACE_surgicalKit"};
        treatmentLocations = QACEGVAR(medical_treatment,locationSurgicalKit);
        allowSelfTreatment = 0;
        medicRequired = QACEGVAR(medical_treatment,medicSurgicalKit);
        treatmentTime = QUOTE([ARR_2(_medic,_patient)] call EFUNC(airway,getStitchAirwayIncisionTime));
        allowedSelections[] = {"Head"};
        condition = QUOTE([ARR_2(_medic,_patient)] call EFUNC(airway,canStitchAirwayIncision));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call EFUNC(airway,stitchAirwayIncision));
        callbackStart = "";
        callbackProgress = "";
        consumeItem = QACEGVAR(medical_treatment,consumeSurgicalKit);
        animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        litter[] = {{"ACE_MedicalLitter_gloves"}};
        ACM_rollToBack = 1;
        ACM_menuIcon = "ACE_surgicalKit";
    };
    class StitchAirwayIncision_Suture: StitchAirwayIncision {
        displayName = ECSTRING(airway,SurgicalAirwayStitch_Suture);
        displayNameProgress = ECSTRING(damage,SurgicalKit_Suture_Progress);
        treatmentTime = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(airway,getStitchAirwayIncisionTime));
        condition = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(airway,canStitchAirwayIncision));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call EFUNC(airway,stitchAirwayIncision));
    };
    class SurgicalAirway_SecureStrap: StitchAirwayIncision {
        displayName = ECSTRING(airway,SurgicalAirwayStrap_Action);
        displayNameProgress = ECSTRING(airway,SurgicalAirwayStrap_Progress);
        icon = "";
        items[] = {};
        consumeItem = 0;
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 5;
        condition = QUOTE([ARR_2(_medic,_patient)] call EFUNC(airway,canSecureSurgicalAirway));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call EFUNC(airway,secureSurgicalAirway));
        animationMedic = "";
        litter[] = {};
        ACM_menuIcon = "";
    };

    // Disability
    class InspectForFracture: CheckPulse {
        displayName = ECSTRING(disability,InspectForFracture);
        displayNameProgress = ECSTRING(disability,InspectForFracture_Progress);
        icon = "";
        medicRequired = QEGVAR(disability,allowInspectForFracture);
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 6;
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        animationMedic = "";
        condition = QEFUNC(disability,canInspectForFracture);
        callbackSuccess = QEFUNC(disability,inspectForFracture);
        ACM_menuIcon = "Fracture";
    };
    class FractureRealignment: Splint {
        displayName = ECSTRING(disability,FractureRealignment);
        displayNameProgress = ECSTRING(disability,FractureRealignment_Progress);
        icon = "";
        medicRequired = QEGVAR(disability,allowFractureRealignment);
        consumeItem = 0;
        items[] = {};
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 3;
        callbackSuccess = QEFUNC(disability,performFractureRealignment);
        condition = QEFUNC(disability,canPerformFractureRealignment);
        litter[] = {};
        ACM_rollToBack = 1;
        ACM_menuIcon = "Fracture";
    };
    class ApplySAMSplint: Splint {
        displayName = ECSTRING(disability,ApplySAMSplint);
        displayNameProgress = ECSTRING(disability,ApplySAMSplint_Progress);
        items[] = {"ACM_SAMSplint"};
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = QEFUNC(disability,canApplySplint);
        treatmentTime = QEGVAR(disability,treatmentTimeSAMSplint);
        callbackSuccess = QEFUNC(disability,splint);
        ACM_menuIcon = "ACM_SAMSplint";
    };
    class RemoveSAMSplint: Splint {
        displayName = ECSTRING(disability,RemoveSAMSplint);
        displayNameProgress = ECSTRING(disability,RemoveSAMSplint_Progress);
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {};
        condition = QEFUNC(disability,canRemoveSplint);
        treatmentTime = 3;
        callbackSuccess = QEFUNC(disability,removeSplint);
        litter[] = {};
        ACM_menuIcon = "ACM_SAMSplint";
    };
    class SurgicalKit: FieldDressing {
        ACM_menuIcon = "ACE_surgicalKit";
        callbackFailure = QUOTE([ARR_2(_medic,_patient)] call EFUNC(damage,surgicalKitCancel));
    };
    class SurgicalKit_Suture: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Suture);
        displayNameProgress = ECSTRING(damage,SurgicalKit_Suture_Progress);
        treatmentTime = QUOTE([ARR_4(_patient,_bodyPart,0,true)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_5(_medic,_patient,_bodyPart,0,true)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_5(_args,_elapsedTime,_totalTime,0,true)] call EFUNC(damage,surgicalKitProgress));
        callbackStart = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(damage,surgicalKitStart));
        callbackFailure = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(damage,surgicalKitCancel));
    };
    class StitchWrappedWounds: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Wrapped);
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,1)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,1)] call EFUNC(damage,surgicalKitProgress));
        callbackFailure = QUOTE([ARR_2(_medic,_patient)] call EFUNC(damage,surgicalKitCancel));
    };
    class StitchWrappedWounds_Suture: SurgicalKit_Suture {
        displayName = ECSTRING(damage,SurgicalKit_Wrapped_Suture);
        treatmentTime = QUOTE([ARR_4(_patient,_bodyPart,1,true)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_5(_medic,_patient,_bodyPart,1,true)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_5(_args,_elapsedTime,_totalTime,1,true)] call EFUNC(damage,surgicalKitProgress));
        callbackFailure = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(damage,surgicalKitCancel));
    };
    class StitchClottedWounds: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Clotted);
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,2)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,2)] call EFUNC(damage,surgicalKitProgress));
        callbackFailure = QUOTE([ARR_2(_medic,_patient)] call EFUNC(damage,surgicalKitCancel));
    };
    class StitchClottedWounds_Suture: SurgicalKit_Suture {
        displayName = ECSTRING(damage,SurgicalKit_Clotted_Suture);
        treatmentTime = QUOTE([ARR_4(_patient,_bodyPart,2,true)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_5(_medic,_patient,_bodyPart,2,true)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_5(_args,_elapsedTime,_totalTime,2,true)] call EFUNC(damage,surgicalKitProgress));
        callbackFailure = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(damage,surgicalKitCancel));
    };

    class ApplyTourniquet: BasicBandage {
        sounds[] = {{QPATHTOF(sound\tourniquet_apply.wav),10,1,30}};
        ACM_menuIcon = "ACE_tourniquet";
    };
    class RemoveTourniquet: ApplyTourniquet {
        treatmentTime = QGVAR(treatmentTimeTakeOffTourniquet);
        sounds[] = {{QPATHTOF(sound\tourniquet_remove.wav),10,1,30}};
    };

    // Transfusion Menu
    class OpenTransfusionMenu: CheckPulse {
        displayName = ECSTRING(circulation,OpenTransfusionMenu);
        displayNameProgress = "";
        icon = "";
        category = "advanced";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        allowedSelections[] = {"All"};
        allowSelfTreatment = 1;
        items[] = {};
        consumeItem = 0;
        animationMedic = "";
        condition = QUOTE([ARR_4(_patient,_bodyPart,0,-1)] call EFUNC(circulation,hasIV) || [ARR_3(_patient,_bodyPart,0)] call EFUNC(circulation,hasIO));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,_bodyPart)] call EFUNC(circulation,openTransfusionMenu));
        ACM_menuIcon = "TransfusionMenu";
    };

    // IV Catheter Examination
    class InspectIV_Upper: CheckPulse {
        displayName = ECSTRING(circulation,InspectIV_Upper);
        displayNameProgress = ECSTRING(circulation,InspectIV_Progress);
        icon = "";
        category = "examine";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = QEGVAR(circulation,allowIV);
        treatmentTime = 4;
        allowedSelections[] = {"LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        allowSelfTreatment = 1;
        condition = QUOTE(([ARR_4(_patient,_bodyPart,0,0)] call EFUNC(circulation,hasIV)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call EFUNC(circulation,inspectIV));
        ACM_menuIcon = "";
    };
    class InspectIV_Middle: InspectIV_Upper {
        displayName = ECSTRING(circulation,InspectIV_Middle);
        condition = QUOTE(([ARR_4(_patient,_bodyPart,0,1)] call EFUNC(circulation,hasIV)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(circulation,inspectIV));
    };
    class InspectIV_Lower: InspectIV_Upper {
        displayName = ECSTRING(circulation,InspectIV_Lower);
        condition = QUOTE(([ARR_4(_patient,_bodyPart,0,2)] call EFUNC(circulation,hasIV)));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call EFUNC(circulation,inspectIV));
    };

    // IV/IO
    class InsertIV_16_Upper: CheckPulse {
        displayName = ECSTRING(circulation,InsertIV_16_Upper);
        displayNameProgress = ECSTRING(circulation,InsertIV_16_Progress);
        icon = "";
        category = "advanced";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = QEGVAR(circulation,allowIV);
        treatmentTime = QEGVAR(circulation,treatmentTimeIV_16);
        allowedSelections[] = {"LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        allowSelfTreatment = QEGVAR(circulation,selfIV);
        items[] = {"ACM_IV_16g"};
        consumeItem = 1;
        condition = QUOTE([ARR_4(_patient,_bodyPart,0,0)] call EFUNC(circulation,canInsertIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,true,true,0)] call EFUNC(circulation,setIV));
        ACM_rollToBack = 1;
        ACM_menuIcon = "ACM_IV_16g";
    };
    class RemoveIV_16_Upper: InsertIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIV_16_Upper);
        displayNameProgress = ECSTRING(circulation,RemoveIV_16_Progress);
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 3;
        allowSelfTreatment = 1;
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_16G_M,0)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,false,true,0)] call EFUNC(circulation,setIV));
    };
    class InsertIV_16_Middle: InsertIV_16_Upper {
        displayName = ECSTRING(circulation,InsertIV_16_Middle);
        condition = QUOTE([ARR_4(_patient,_bodyPart,0,1)] call EFUNC(circulation,canInsertIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,true,true,1)] call EFUNC(circulation,setIV));
    };
    class RemoveIV_16_Middle: RemoveIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIV_16_Middle);
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_16G_M,1)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,false,true,1)] call EFUNC(circulation,setIV));
    };
    class InsertIV_16_Lower: InsertIV_16_Upper {
        displayName = ECSTRING(circulation,InsertIV_16_Lower);
        condition = QUOTE([ARR_4(_patient,_bodyPart,0,2)] call EFUNC(circulation,canInsertIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,true,true,2)] call EFUNC(circulation,setIV));
    };
    class RemoveIV_16_Lower: RemoveIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIV_16_Lower);
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_16G_M,2)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,false,true,2)] call EFUNC(circulation,setIV));
    };
    class InsertIV_14_Upper: InsertIV_16_Upper {
        displayName = ECSTRING(circulation,InsertIV_14_Upper);
        displayNameProgress = ECSTRING(circulation,InsertIV_14_Progress);
        icon = "";
        treatmentTime = QEGVAR(circulation,treatmentTimeIV_14);
        items[] = {"ACM_IV_14g"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,true,true,0)] call EFUNC(circulation,setIV));
        ACM_menuIcon = "ACM_IV_14g";
    };
    class RemoveIV_14_Upper: RemoveIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIV_14_Upper);
        displayNameProgress = ECSTRING(circulation,RemoveIV_14_Progress);
        icon = "";
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_14G_M,0)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,false,true,0)] call EFUNC(circulation,setIV));
        ACM_menuIcon = "ACM_IV_14g";
    };
    class InsertIV_14_Middle: InsertIV_14_Upper {
        displayName = ECSTRING(circulation,InsertIV_14_Middle);
        condition = QUOTE([ARR_4(_patient,_bodyPart,0,1)] call EFUNC(circulation,canInsertIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,true,true,1)] call EFUNC(circulation,setIV));
    };
    class RemoveIV_14_Middle: RemoveIV_14_Upper {
        displayName = ECSTRING(circulation,RemoveIV_14_Middle);
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_14G_M,1)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,false,true,1)] call EFUNC(circulation,setIV));
    };
    class InsertIV_14_Lower: InsertIV_14_Upper {
        displayName = ECSTRING(circulation,InsertIV_14_Lower);
        condition = QUOTE([ARR_4(_patient,_bodyPart,0,2)] call EFUNC(circulation,canInsertIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,true,true,2)] call EFUNC(circulation,setIV));
    };
    class RemoveIV_14_Lower: RemoveIV_14_Upper {
        displayName = ECSTRING(circulation,RemoveIV_14_Lower);
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_14G_M,2)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,false,true,2)] call EFUNC(circulation,setIV));
    };
    class InsertIO_FAST1: InsertIV_16_Upper {
        displayName = ECSTRING(circulation,InsertIO_FAST1);
        displayNameProgress = ECSTRING(circulation,InsertIO_FAST1_Progress);
        icon = "";
        medicRequired = QEGVAR(circulation,allowIO);
        treatmentTime = QEGVAR(circulation,treatmentTimeIO_FAST1);
        allowedSelections[] = {"Body"};
        allowSelfTreatment = QEGVAR(circulation,selfIO);
        items[] = {"ACM_IO_FAST"};
        condition = QUOTE(!([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO)));
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,ACM_IO_FAST1_M,true,false)] call EFUNC(circulation,setIV));
        ACM_cancelRecovery = 1;
        ACM_menuIcon = "ACM_IO_FAST";
    };
    class RemoveIO_FAST1: RemoveIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIO_FAST1);
        displayNameProgress = ECSTRING(circulation,RemoveIO_FAST1_Progress);
        icon = "";
        allowedSelections[] = {"Body"};
        treatmentTime = 3.5;
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IO_FAST1_M)] call EFUNC(circulation,hasIO));
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,ACM_IO_FAST1_M,false,false)] call EFUNC(circulation,setIV));
        ACM_menuIcon = "ACM_IO_FAST";
    };
    class InsertIO_EZ: InsertIO_FAST1 {
        displayName = ECSTRING(circulation,InsertIO_EZ);
        displayNameProgress = ECSTRING(circulation,InsertIO_EZ_Progress);
        icon = "";
        treatmentTime = QEGVAR(circulation,treatmentTimeIO_EZ);
        allowedSelections[] = {"LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        items[] = {"ACM_IO_EZ"};
        condition = QUOTE(!([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO)));
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,ACM_IO_EZ_M,true,false)] call EFUNC(circulation,setIV));
        ACM_cancelRecovery = 0;
        sounds[] = {{QPATHTOEF(circulation,sound\io_drill.wav),10,1,30}};
        ACM_menuIcon = "ACM_IO_EZ";
    };
    class RemoveIO_EZ: RemoveIO_FAST1 {
        displayName = ECSTRING(circulation,RemoveIO_EZ);
        displayNameProgress = ECSTRING(circulation,RemoveIO_EZ_Progress);
        icon = "";
        allowedSelections[] = {"LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IO_EZ_M)] call EFUNC(circulation,hasIO));
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,ACM_IO_EZ_M,false,false)] call EFUNC(circulation,setIV));
        ACM_menuIcon = "ACM_IO_EZ";
    };

    // Medication

    class Paracetamol: Morphine {
        displayName = ECSTRING(circulation,UseParacetamol);
        displayNameProgress = ECSTRING(circulation,UseParacetamol_Progress);
        //icon = QACEPATHTOF(medical_gui,ui\auto_injector.paa);
        allowedSelections[] = {"Head"};
        items[] = {"ACM_Paracetamol_SinglePack","ACM_Paracetamol_DoublePack","ACM_Paracetamol"};
        medicRequired = 0;
        treatmentTime = 4;
        condition = QUOTE([_patient] call ACEFUNC(common,isAwake) && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        //animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        sounds[] = {{QPATHTOEF(circulation,sound\paracetamol.wav),10,1,30}};
        litter[] = {};
        ACM_menuIcon = "ACM_Paracetamol";
    };
    class Penthrox: Paracetamol {
        displayName = ECSTRING(circulation,UsePenthroxInhaler);
        displayNameProgress = ECSTRING(circulation,UsePenthroxInhaler_Progress);
        items[] = {"ACM_Inhaler_Penthrox"};
        treatmentTime = 4;
        animationMedic = "";
        sounds[] = {};
        ACM_menuIcon = "ACM_Inhaler_Penthrox";
    };
    class AmmoniaInhalant: Paracetamol {
        displayName = ECSTRING(circulation,UseAmmoniaInhalant);
        displayNameProgress = ECSTRING(circulation,UseAmmoniaInhalant_Progress);
        items[] = {"ACM_AmmoniaInhalant"};
        medicRequired = QEGVAR(circulation,allowAmmoniaInhalant);
        treatmentTime = 3;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        ACM_rollToBack = 1;
        ACM_menuIcon = "ACM_AmmoniaInhalant";
    };
    class Naloxone: Paracetamol {
        displayName = ECSTRING(circulation,UseNaloxoneSpray);
        displayNameProgress = ECSTRING(circulation,UseNaloxoneSpray_Progress);
        items[] = {"ACM_Spray_Naloxone"};
        treatmentTime = 4;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        ACM_rollToBack = 1;
        sounds[] = {};
        ACM_menuIcon = "ACM_Spray_Naloxone";
    };
    class FentanylLozenge: Paracetamol {
        displayName = ECSTRING(circulation,GiveFentanylLozenge);
        displayNameProgress = ECSTRING(circulation,GiveFentanylLozenge_Progress);
        items[] = {"ACM_Lozenge_Fentanyl"};
        medicRequired = QEGVAR(circulation,allowFentanylLozenge);
        allowSelfTreatment = 0;
        treatmentTime = 4;
        condition = QUOTE(_patient call ACEFUNC(common,isAwake) && ((_patient getVariable [ARR_2(QQEGVAR(circulation,LozengeItem),'')]) == '') && ((_patient getVariable [ARR_2(QQGVAR(Lying_State),false)]) || (_patient getVariable [ARR_2(QQGVAR(Sitting_State),false)])) && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,'Fentanyl')] call EFUNC(circulation,setLozenge));
        ACM_rollToBack = 1;
        sounds[] = {};
        ACM_menuIcon = "ACM_Lozenge_Fentanyl";
    };
    class RemoveFentanylLozenge: FentanylLozenge {
        displayName = ECSTRING(circulation,RemoveFentanylLozenge);
        displayNameProgress = ECSTRING(circulation,RemoveFentanylLozenge_Progress);
        items[] = {};
        consumeItem = 0;
        medicRequired = 0;
        allowSelfTreatment = 1;
        treatmentTime = 2;
        condition = QUOTE((_patient getVariable [ARR_2(QQEGVAR(circulation,LozengeItem),'')]) == 'Fentanyl');
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call EFUNC(circulation,setLozenge));
    };

    class ShakeAwake: CheckResponse {
        displayName = ECSTRING(disability,ShakeAwake);
        displayNameProgress = ECSTRING(disability,ShakeAwake_Progress);
        category = "medication";
        medicRequired = 0;
        allowedSelections[] = {"Body","LeftArm","RightArm"};
        treatmentTime = 1.5;
        condition = QUOTE(!([_patient] call ACEFUNC(common,isAwake)));
        callbackSuccess = QEFUNC(disability,shakeAwake);
        ACM_menuIcon = "";
    };
    class SlapAwake: ShakeAwake {
        displayName = ECSTRING(disability,SlapAwake);
        displayNameProgress = ECSTRING(disability,SlapAwake_Progress);
        allowedSelections[] = {"Head"};
        treatmentTime = 3;
        condition = QUOTE(!([_patient] call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QEFUNC(disability,slapAwake);
        animationMedic = "AinvPknlMstpSnonWnonDr_medic3";
        ACM_rollToBack = 1;
        ACM_ignoreAnimCoef = 1;
        ACM_menuIcon = "";
    };

    class UseSyringe_10: OpenTransfusionMenu {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',10)]));
        displayNameProgress = "";
        category = "medication";
        medicRequired = QEGVAR(circulation,allowSyringe);
        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        treatmentTime = 0.01;
        condition = QUOTE('ACM_Syringe_10' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,10)] call EFUNC(circulation,Syringe_Draw));
        ACM_menuIcon = "ACM_Syringe_10";
    };
    class UseSyringe_5: UseSyringe_10 {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',5)]));
        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
        condition = QUOTE('ACM_Syringe_5' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,5)] call EFUNC(circulation,Syringe_Draw));
        ACM_menuIcon = "ACM_Syringe_5";
    };
    class UseSyringe_3: UseSyringe_10 {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',3)]));
        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
        condition = QUOTE('ACM_Syringe_3' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,3)] call EFUNC(circulation,Syringe_Draw));
        ACM_menuIcon = "ACM_Syringe_3";
    };
    class UseSyringe_1: UseSyringe_10 {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',1)]));
        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
        condition = QUOTE('ACM_Syringe_1' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(circulation,Syringe_Draw));
        ACM_menuIcon = "ACM_Syringe_1";
    };

    // IV
    class Epinephrine_10_IV: Morphine {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Epinephrine,Intravenous));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Epinephrine));
        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_10_Epinephrine"};
        consumeItem = 0;
        medicRequired = QEGVAR(circulation,allowSyringe);
        treatmentTime = 2;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) || [ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',10,true,true)] call EFUNC(circulation,Syringe_Inject));
        //animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        sounds[] = {};
        litter[] = {};
        ACM_menuIcon = "ACM_Syringe_10";
    };
    class Epinephrine_5_IV: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Epinephrine,Intravenous));
        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
        items[] = {"ACM_Syringe_5_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',5,true,true)] call EFUNC(circulation,Syringe_Inject));
        ACM_menuIcon = "ACM_Syringe_5";
    };
    class Epinephrine_3_IV: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Epinephrine,Intravenous));
        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
        items[] = {"ACM_Syringe_3_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',3,true,true)] call EFUNC(circulation,Syringe_Inject));
        ACM_menuIcon = "ACM_Syringe_3";
    };
    class Epinephrine_1_IV: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Epinephrine,Intravenous));
        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
        items[] = {"ACM_Syringe_1_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',1,true,true)] call EFUNC(circulation,Syringe_Inject));
        ACM_menuIcon = "ACM_Syringe_1";
    };
    SYRINGE_ACTION_IV(Amiodarone,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    SYRINGE_ACTION_IV(Amiodarone,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    SYRINGE_ACTION_IV(Amiodarone,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    SYRINGE_ACTION_IV(Amiodarone,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));

    SYRINGE_ACTION_IV(Atropine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Atropine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Atropine)));
    SYRINGE_ACTION_IV(Atropine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Atropine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Atropine)));
    SYRINGE_ACTION_IV(Atropine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Atropine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Atropine)));
    SYRINGE_ACTION_IV(Atropine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Atropine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Atropine)));

    SYRINGE_ACTION_IV(Morphine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Morphine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Morphine)));
    SYRINGE_ACTION_IV(Morphine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Morphine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Morphine)));
    SYRINGE_ACTION_IV(Morphine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Morphine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Morphine)));
    SYRINGE_ACTION_IV(Morphine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Morphine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Morphine)));

    SYRINGE_ACTION_IV(Ketamine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Ketamine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ketamine)));
    SYRINGE_ACTION_IV(Ketamine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Ketamine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ketamine)));
    SYRINGE_ACTION_IV(Ketamine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Ketamine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ketamine)));
    SYRINGE_ACTION_IV(Ketamine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Ketamine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ketamine)));

    SYRINGE_ACTION_IV(Fentanyl,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Fentanyl,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Fentanyl)));
    SYRINGE_ACTION_IV(Fentanyl,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Fentanyl,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Fentanyl)));
    SYRINGE_ACTION_IV(Fentanyl,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Fentanyl,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Fentanyl)));
    SYRINGE_ACTION_IV(Fentanyl,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Fentanyl,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Fentanyl)));

    SYRINGE_ACTION_IV(TXA,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,TXA,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,TXA)));
    SYRINGE_ACTION_IV(TXA,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,TXA,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,TXA)));
    SYRINGE_ACTION_IV(TXA,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,TXA,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,TXA)));
    SYRINGE_ACTION_IV(TXA,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,TXA,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,TXA)));

    SYRINGE_ACTION_IV(Adenosine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Adenosine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Adenosine)));
    SYRINGE_ACTION_IV(Adenosine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Adenosine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Adenosine)));
    SYRINGE_ACTION_IV(Adenosine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Adenosine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Adenosine)));
    SYRINGE_ACTION_IV(Adenosine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Adenosine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Adenosine)));

    SYRINGE_ACTION_IV(Lidocaine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Lidocaine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Lidocaine)));
    SYRINGE_ACTION_IV(Lidocaine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Lidocaine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Lidocaine)));
    SYRINGE_ACTION_IV(Lidocaine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Lidocaine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Lidocaine)));
    SYRINGE_ACTION_IV(Lidocaine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Lidocaine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Lidocaine)));

    SYRINGE_ACTION_IV(Ondansetron,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Ondansetron,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ondansetron)));
    SYRINGE_ACTION_IV(Ondansetron,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Ondansetron,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ondansetron)));
    SYRINGE_ACTION_IV(Ondansetron,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Ondansetron,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ondansetron)));
    SYRINGE_ACTION_IV(Ondansetron,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Ondansetron,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ondansetron)));

    SYRINGE_ACTION_IV(CalciumChloride,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,CalciumChloride,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,CalciumChloride)));
    SYRINGE_ACTION_IV(CalciumChloride,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,CalciumChloride,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,CalciumChloride)));
    SYRINGE_ACTION_IV(CalciumChloride,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,CalciumChloride,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,CalciumChloride)));
    SYRINGE_ACTION_IV(CalciumChloride,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,CalciumChloride,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,CalciumChloride)));

    SYRINGE_ACTION_IV(Ertapenem,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Ertapenem,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ertapenem)));
    SYRINGE_ACTION_IV(Ertapenem,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Ertapenem,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ertapenem)));
    SYRINGE_ACTION_IV(Ertapenem,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Ertapenem,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ertapenem)));
    SYRINGE_ACTION_IV(Ertapenem,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Ertapenem,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ertapenem)));

    SYRINGE_ACTION_IV(Esmolol,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Esmolol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Esmolol)));
    SYRINGE_ACTION_IV(Esmolol,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Esmolol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Esmolol)));
    SYRINGE_ACTION_IV(Esmolol,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Esmolol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Esmolol)));
    SYRINGE_ACTION_IV(Esmolol,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Esmolol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Esmolol)));

    SYRINGE_ACTION_IV(Dimercaprol,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Dimercaprol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Dimercaprol)));
    SYRINGE_ACTION_IV(Dimercaprol,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Dimercaprol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Dimercaprol)));
    SYRINGE_ACTION_IV(Dimercaprol,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Dimercaprol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Dimercaprol)));
    SYRINGE_ACTION_IV(Dimercaprol,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Dimercaprol,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Dimercaprol)));

    // IM
    class Epinephrine_10_IM: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Epinephrine,Intramuscular));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Epinephrine));
        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_10_Epinephrine"};
        condition = "true";
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',10,false,true)] call EFUNC(circulation,Syringe_Inject));
        sounds[] = {};
        litter[] = {};
    };
    class Epinephrine_5_IM: Epinephrine_10_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Epinephrine,Intramuscular));
        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
        items[] = {"ACM_Syringe_5_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',5,false,true)] call EFUNC(circulation,Syringe_Inject));
        ACM_menuIcon = "ACM_Syringe_5";
    };
    class Epinephrine_3_IM: Epinephrine_10_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Epinephrine,Intramuscular));
        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
        items[] = {"ACM_Syringe_3_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',3,false,true)] call EFUNC(circulation,Syringe_Inject));
        ACM_menuIcon = "ACM_Syringe_3";
    };
    class Epinephrine_1_IM: Epinephrine_10_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Epinephrine,Intramuscular));
        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
        items[] = {"ACM_Syringe_1_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',1,false,true)] call EFUNC(circulation,Syringe_Inject));
        ACM_menuIcon = "ACM_Syringe_1";
    };
    
    SYRINGE_ACTION_IM(Morphine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Morphine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Morphine)));
    SYRINGE_ACTION_IM(Morphine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Morphine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Morphine)));
    SYRINGE_ACTION_IM(Morphine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Morphine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Morphine)));
    SYRINGE_ACTION_IM(Morphine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Morphine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Morphine)));

    SYRINGE_ACTION_IM(Ketamine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Ketamine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ketamine)));
    SYRINGE_ACTION_IM(Ketamine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Ketamine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ketamine)));
    SYRINGE_ACTION_IM(Ketamine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Ketamine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ketamine)));
    SYRINGE_ACTION_IM(Ketamine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Ketamine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ketamine)));

    SYRINGE_ACTION_IM(TXA,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,TXA,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,TXA)));
    SYRINGE_ACTION_IM(TXA,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,TXA,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,TXA)));
    SYRINGE_ACTION_IM(TXA,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,TXA,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,TXA)));
    SYRINGE_ACTION_IM(TXA,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,TXA,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,TXA)));

    SYRINGE_ACTION_IM(Fentanyl,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Fentanyl,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Fentanyl)));
    SYRINGE_ACTION_IM(Fentanyl,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Fentanyl,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Fentanyl)));
    SYRINGE_ACTION_IM(Fentanyl,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Fentanyl,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Fentanyl)));
    SYRINGE_ACTION_IM(Fentanyl,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Fentanyl,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Fentanyl)));

    SYRINGE_ACTION_IM(Lidocaine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Lidocaine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Lidocaine)));
    SYRINGE_ACTION_IM(Lidocaine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Lidocaine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Lidocaine)));
    SYRINGE_ACTION_IM(Lidocaine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Lidocaine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Lidocaine)));
    SYRINGE_ACTION_IM(Lidocaine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Lidocaine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Lidocaine)));

    SYRINGE_ACTION_IM(Amiodarone,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Amiodarone,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Amiodarone)));
    SYRINGE_ACTION_IM(Amiodarone,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Amiodarone,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Amiodarone)));
    SYRINGE_ACTION_IM(Amiodarone,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Amiodarone,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Amiodarone)));
    SYRINGE_ACTION_IM(Amiodarone,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Amiodarone,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Amiodarone)));

    SYRINGE_ACTION_IM(Atropine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Atropine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Atropine)));
    SYRINGE_ACTION_IM(Atropine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Atropine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Atropine)));
    SYRINGE_ACTION_IM(Atropine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Atropine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Atropine)));
    SYRINGE_ACTION_IM(Atropine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Atropine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Atropine)));

    SYRINGE_ACTION_IM(Adenosine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));
    SYRINGE_ACTION_IM(Adenosine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));
    SYRINGE_ACTION_IM(Adenosine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));
    SYRINGE_ACTION_IM(Adenosine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));

    SYRINGE_ACTION_IM(Ondansetron,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
    SYRINGE_ACTION_IM(Ondansetron,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
    SYRINGE_ACTION_IM(Ondansetron,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
    SYRINGE_ACTION_IM(Ondansetron,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));

    SYRINGE_ACTION_IM(CalciumChloride,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,CalciumChloride,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,CalciumChloride)));
    SYRINGE_ACTION_IM(CalciumChloride,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,CalciumChloride,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,CalciumChloride)));
    SYRINGE_ACTION_IM(CalciumChloride,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,CalciumChloride,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,CalciumChloride)));
    SYRINGE_ACTION_IM(CalciumChloride,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,CalciumChloride,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,CalciumChloride)));

    SYRINGE_ACTION_IM(Ertapenem,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Ertapenem,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ertapenem)));
    SYRINGE_ACTION_IM(Ertapenem,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Ertapenem,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ertapenem)));
    SYRINGE_ACTION_IM(Ertapenem,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Ertapenem,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ertapenem)));
    SYRINGE_ACTION_IM(Ertapenem,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Ertapenem,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ertapenem)));

    SYRINGE_ACTION_IM(Esmolol,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Esmolol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Esmolol)));
    SYRINGE_ACTION_IM(Esmolol,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Esmolol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Esmolol)));
    SYRINGE_ACTION_IM(Esmolol,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Esmolol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Esmolol)));
    SYRINGE_ACTION_IM(Esmolol,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Esmolol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Esmolol)));

    SYRINGE_ACTION_IM(Dimercaprol,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Dimercaprol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Dimercaprol)));
    SYRINGE_ACTION_IM(Dimercaprol,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Dimercaprol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Dimercaprol)));
    SYRINGE_ACTION_IM(Dimercaprol,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Dimercaprol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Dimercaprol)));
    SYRINGE_ACTION_IM(Dimercaprol,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Dimercaprol,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Dimercaprol)));

    // CBRN
    class WashEyes: CheckPulse {
        displayName = ECSTRING(CBRN,WashEyes);
        displayNameProgress = ECSTRING(CBRN,WashEyes_Progress);
        icon = "";
        category = "medication";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 3;
        allowedSelections[] = {"Head"};
        allowSelfTreatment = 1;
        items[] = {"ACE_WaterBottle","ACE_WaterBottle_Half","ACE_Canteen","ACE_Canteen_Half"};
        consumeItem = 1;
        condition = QUOTE(_patient call EFUNC(CBRN,canWashEyes));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,_usedItem)] call EFUNC(CBRN,washEyes));
        animationMedicSelf = "";
        ACM_rollToBack = 1;
        ACM_menuIcon = "";
    };
};