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
    }

#define SYRINGE_ACTION_IM(medication,size,name,progress) \
    class TRIPLES(medication,size,IM): TRIPLES(Epinephrine,size,IM) { \
        displayName = name; \
        displayNameProgress = progress; \
        icon = QPATHTOEF(circulation,ui\icon_syringe_##size##_ca.paa); \
        items[] = {QUOTE(ACM_Syringe_##size##_##medication##)}; \
        condition = "true"; \
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'##medication##',##size##,false,true)] call EFUNC(circulation,Syringe_Inject)); \
    }

class ACEGVAR(medical_treatment,actions) {
    class BasicBandage;
    class Splint;
    class FieldDressing;
    class Morphine: FieldDressing {
        displayName = CSTRING(MorphineAutoinjector);
        displayNameProgress = CSTRING(MorphineAutoinjector_Progress);
    };
    class Adenosine: Morphine {
        displayName = CSTRING(AdenosineAutoinjector);
        displayNameProgress = CSTRING(AdenosineAutoinjector_Progress);
    };
    class Epinephrine: Morphine {
        displayName = CSTRING(EpinephrineAutoinjector);
        displayNameProgress = CSTRING(EpinephrineAutoinjector_Progress);
    };
    class CheckPulse;
    class CheckResponse: CheckPulse {
        treatmentTime = 2.5;
    };
    class CheckBloodPressure: CheckPulse {
        displayName = ECSTRING(circulation,CheckCapillaryRefill);
        displayNameProgress = ECSTRING(circulation,CheckCapillaryRefill_Progress);
        allowedSelections[] = {"Body", "LeftArm", "RightArm"};
        treatmentTime = 2.5;
        callbackSuccess = QEFUNC(circulation,checkCapillaryRefill);
    };
    class MeasureBloodPressure: CheckBloodPressure {
        displayName = ECSTRING(circulation,PressureCuff_Measure);
        displayNameProgress = "";
        allowedSelections[] = {"LeftArm", "RightArm"};
        treatmentTime = 0.01;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasPressureCuff));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call EFUNC(circulation,measureBP));
    };
    class MeasureBloodPressureStethoscope: MeasureBloodPressure {
        displayName = ECSTRING(circulation,PressureCuff_Measure_Stethoscope);
        items[] = {"ACM_Stethoscope"};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,true)] call EFUNC(circulation,measureBP));
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
    };
    class EmergencyTraumaDressing: PressureBandage {
        displayName = ECSTRING(damage,EmergencyTraumaDressing);
        items[] = {"ACM_EmergencyTraumaDressing"};
        allowSelfTreatment = 0;
    };
    class ElasticWrap: PressureBandage {
        displayName = ECSTRING(damage,ElasticWrap_Bruises);
        displayNameProgress = ECSTRING(damage,ElasticWrap_Progress);
        items[] = {"ACM_ElasticWrap"};
        medicRequired = QGVAR(allowWrap);
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call EFUNC(damage,canWrap));
        treatmentTime = QEFUNC(damage,getBruiseWrapTime);
        callbackSuccess = QEFUNC(damage,wrapBruises);
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
    class ApplySAMSplint: Splint {
        displayName = ECSTRING(disability,ApplySAMSplint);
        displayNameProgress = ECSTRING(disability,ApplySAMSplint_Progress);
        items[] = {"ACM_SAMSplint"};
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = QACEFUNC(medical_treatment,canSplint);
        treatmentTime = QGVAR(treatmentTimeSAMSplint);
        callbackSuccess = QEFUNC(disability,splint);
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
    };
    class SurgicalKit;
    class SurgicalKit_Suture: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Suture);
        displayNameProgress = ECSTRING(damage,SurgicalKit_Suture_Progress);
        treatmentTime = QUOTE([ARR_4(_patient,_bodyPart,0,true)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_5(_medic,_patient,_bodyPart,0,true)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_5(_args,_elapsedTime,_totalTime,0,true)] call EFUNC(damage,surgicalKitProgress));
        callbackStart = QUOTE([ARR_3(_medic,_patient,true)] call EFUNC(damage,surgicalKitStart));
    };
    class StitchWrappedWounds: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Wrapped);
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,1)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,1)] call EFUNC(damage,surgicalKitProgress));
    };
    class StitchWrappedWounds_Suture: SurgicalKit_Suture {
        displayName = ECSTRING(damage,SurgicalKit_Wrapped_Suture);
        treatmentTime = QUOTE([ARR_4(_patient,_bodyPart,1,true)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_5(_medic,_patient,_bodyPart,1,true)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_5(_args,_elapsedTime,_totalTime,1,true)] call EFUNC(damage,surgicalKitProgress));
    };
    class StitchClottedWounds: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Clotted);
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,2)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,2)] call EFUNC(damage,surgicalKitProgress));
    };
    class StitchClottedWounds_Suture: SurgicalKit_Suture {
        displayName = ECSTRING(damage,SurgicalKit_Clotted_Suture);
        treatmentTime = QUOTE([ARR_4(_patient,_bodyPart,2,true)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_5(_medic,_patient,_bodyPart,2,true)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_5(_args,_elapsedTime,_totalTime,2,true)] call EFUNC(damage,surgicalKitProgress));
    };

    class ApplyTourniquet: BasicBandage {
        sounds[] = {{QPATHTOF(sound\tourniquet_apply.wav),10,1,30}};
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
        condition = QUOTE(!([ARR_4(_patient,_bodyPart,0,0)] call EFUNC(circulation,hasIV)));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,true,true,0)] call EFUNC(circulation,setIV));
        ACM_rollToBack = 1;
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
        condition = QUOTE(!([ARR_4(_patient,_bodyPart,0,1)] call EFUNC(circulation,hasIV)));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,true,true,1)] call EFUNC(circulation,setIV));
    };
    class RemoveIV_16_Middle: RemoveIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIV_16_Middle);
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_16G_M,1)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_16G_M,false,true,1)] call EFUNC(circulation,setIV));
    };
    class InsertIV_16_Lower: InsertIV_16_Upper {
        displayName = ECSTRING(circulation,InsertIV_16_Lower);
        condition = QUOTE(!([ARR_4(_patient,_bodyPart,0,2)] call EFUNC(circulation,hasIV)));
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
    };
    class RemoveIV_14_Upper: RemoveIV_16_Upper {
        displayName = ECSTRING(circulation,RemoveIV_14_Upper);
        displayNameProgress = ECSTRING(circulation,RemoveIV_14_Progress);
        icon = "";
        allowSelfTreatment = 0;
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_14G_M,0)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,false,true,0)] call EFUNC(circulation,setIV));
    };
    class InsertIV_14_Middle: InsertIV_14_Upper {
        displayName = ECSTRING(circulation,InsertIV_14_Middle);
        condition = QUOTE(!([ARR_4(_patient,_bodyPart,0,1)] call EFUNC(circulation,hasIV)));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,true,true,1)] call EFUNC(circulation,setIV));
    };
    class RemoveIV_14_Middle: RemoveIV_14_Upper {
        displayName = ECSTRING(circulation,RemoveIV_14_Middle);
        condition = QUOTE([ARR_4(_patient,_bodyPart,ACM_IV_14G_M,1)] call EFUNC(circulation,hasIV));
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,ACM_IV_14G_M,false,true,1)] call EFUNC(circulation,setIV));
    };
    class InsertIV_14_Lower: InsertIV_14_Upper {
        displayName = ECSTRING(circulation,InsertIV_14_Lower);
        condition = QUOTE(!([ARR_4(_patient,_bodyPart,0,2)] call EFUNC(circulation,hasIV)));
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
    };
    class RemoveIO_EZ: RemoveIO_FAST1 {
        displayName = ECSTRING(circulation,RemoveIO_EZ);
        displayNameProgress = ECSTRING(circulation,RemoveIO_EZ_Progress);
        icon = "";
        allowedSelections[] = {"LeftArm", "RightArm", "LeftLeg", "RightLeg"};
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IO_EZ_M)] call EFUNC(circulation,hasIO));
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,ACM_IO_EZ_M,false,false)] call EFUNC(circulation,setIV));
    };

    // Medication

    class Paracetamol: Morphine {
        displayName = ECSTRING(circulation,UseParacetamol);
        displayNameProgress = ECSTRING(circulation,UseParacetamol_Progress);
        //icon = QACEPATHTOF(medical_gui,ui\auto_injector.paa);
        allowedSelections[] = {"Head"};
        items[] = {"ACM_Paracetamol"};
        condition = QUOTE([_patient] call ACEFUNC(common,isAwake) && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        treatmentTime = 5;
        //animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        sounds[] = {{QPATHTOEF(circulation,sound\paracetamol.wav),10,1,30}};
        litter[] = {};
    };
    class Penthrox: Paracetamol {
        displayName = ECSTRING(circulation,UsePenthroxInhaler);
        displayNameProgress = ECSTRING(circulation,UsePenthroxInhaler_Progress);
        items[] = {"ACM_Inhaler_Penthrox"};
        treatmentTime = 5;
        animationMedic = "";
        sounds[] = {};
    };
    class AmmoniaInhalant: Paracetamol {
        displayName = ECSTRING(circulation,UseAmmoniaInhalant);
        displayNameProgress = ECSTRING(circulation,UseAmmoniaInhalant_Progress);
        items[] = {"ACM_AmmoniaInhalant"};
        treatmentTime = 3;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        ACM_rollToBack = 1;
    };
    class Naloxone: Paracetamol {
        displayName = ECSTRING(circulation,UseNaloxoneSpray);
        displayNameProgress = ECSTRING(circulation,UseNaloxoneSpray_Progress);
        items[] = {"ACM_Spray_Naloxone"};
        treatmentTime = 4;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        ACM_rollToBack = 1;
        sounds[] = {};
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
    };

    class UseSyringe_10: OpenTransfusionMenu {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',10)]));
        displayNameProgress = "";
        category = "medication";
        medicRequired = 0;
        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        treatmentTime = 0.01;
        condition = QUOTE('ACM_Syringe_10' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,10)] call EFUNC(circulation,Syringe_Draw));
    };
    class UseSyringe_5: UseSyringe_10 {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',5)]));
        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
        condition = QUOTE('ACM_Syringe_5' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,5)] call EFUNC(circulation,Syringe_Draw));
    };
    class UseSyringe_3: UseSyringe_10 {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',3)]));
        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
        condition = QUOTE('ACM_Syringe_3' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,3)] call EFUNC(circulation,Syringe_Draw));
    };
    class UseSyringe_1: UseSyringe_10 {
        displayName = __EVAL(call compile QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_UseSyringe',1)]));
        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
        condition = QUOTE('ACM_Syringe_1' in (items _medic));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(circulation,Syringe_Draw));
    };

    // IV
    class Epinephrine_10_IV: Morphine {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Epinephrine,Intravenous));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Epinephrine));
        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_10_Epinephrine"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) || [ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO));
        treatmentTime = 2;
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',10,true,true)] call EFUNC(circulation,Syringe_Inject));
        //animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        sounds[] = {};
        litter[] = {};
    };
    class Epinephrine_5_IV: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Epinephrine,Intravenous));
        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
        items[] = {"ACM_Syringe_5_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',5,true,true)] call EFUNC(circulation,Syringe_Inject));
    };
    class Epinephrine_3_IV: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Epinephrine,Intravenous));
        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
        items[] = {"ACM_Syringe_3_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',3,true,true)] call EFUNC(circulation,Syringe_Inject));
    };
    class Epinephrine_1_IV: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Epinephrine,Intravenous));
        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
        items[] = {"ACM_Syringe_1_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',1,true,true)] call EFUNC(circulation,Syringe_Inject));
    };
    SYRINGE_ACTION_IV(Amiodarone,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,10,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    SYRINGE_ACTION_IV(Amiodarone,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,5,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    SYRINGE_ACTION_IV(Amiodarone,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,3,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    SYRINGE_ACTION_IV(Amiodarone,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,1,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));

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

    // IM
    class Epinephrine_10_IM: Epinephrine_10_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Epinephrine,Intramuscular));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Epinephrine));
        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_10_Epinephrine"};
        condition = "true";
        treatmentTime = 2;
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',10,false,true)] call EFUNC(circulation,Syringe_Inject));
        sounds[] = {};
        litter[] = {};
    };
    class Epinephrine_5_IM: Epinephrine_10_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Epinephrine,Intramuscular));
        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
        items[] = {"ACM_Syringe_5_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',5,false,true)] call EFUNC(circulation,Syringe_Inject));
    };
    class Epinephrine_3_IM: Epinephrine_10_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Epinephrine,Intramuscular));
        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
        items[] = {"ACM_Syringe_3_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',3,false,true)] call EFUNC(circulation,Syringe_Inject));
    };
    class Epinephrine_1_IM: Epinephrine_10_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Epinephrine,Intramuscular));
        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
        items[] = {"ACM_Syringe_1_Epinephrine"};
        callbackSuccess = QUOTE([ARR_7(_medic,_patient,_bodyPart,'Epinephrine',1,false,true)] call EFUNC(circulation,Syringe_Inject));
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

    SYRINGE_ACTION_IM(Adenosine,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));
    SYRINGE_ACTION_IM(Adenosine,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));
    SYRINGE_ACTION_IM(Adenosine,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));
    SYRINGE_ACTION_IM(Adenosine,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Adenosine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Adenosine)));

    SYRINGE_ACTION_IM(Ondansetron,10,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,10,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
    SYRINGE_ACTION_IM(Ondansetron,5,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,5,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
    SYRINGE_ACTION_IM(Ondansetron,3,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,3,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
    SYRINGE_ACTION_IM(Ondansetron,1,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,1,Ondansetron,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ondansetron)));
};