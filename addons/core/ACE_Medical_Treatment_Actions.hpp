#define SYRINGE_ACTION_FORMAT(var1,var2,var3) QUOTE(format [ARR_3(localize 'STR_ACM_Circulation_Syringe_##var1##',localize 'STR_ACM_Circulation_Medication_##var2##','STR_ACM_Circulation_##var3##_Short')])
#define SYRINGE_PROGRESS_FORMAT(var1,var2) QUOTE(format [ARR_2(localize 'STR_ACM_Circulation_Syringe_##var1##',localize 'STR_ACM_Circulation_Medication_##var2##')])

#define PUSH_SYRINGE_IV(medication,name,progress) \
    class DOUBLES(medication,IV): Epinephrine_IV { \
        displayName = name; \
        displayNameProgress = progress; \
        items[] = {QUOTE(ACM_Syringe_IV_##medication##)}; \
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'##medication##',true,true)] call EFUNC(circulation,Syringe_Inject)); \
    }

#define DRAW_PUSH_SYRINGE_IV(medication,name) \
    class TRIPLES(medication,Draw,IV): Epinephrine_Draw_IV { \
        displayName = name; \
        condition = QUOTE(([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) || [ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO)) && [ARR_2(_medic,'ACM_Syringe_IV')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_##medication##')] call ACEFUNC(common,hasItem)); \
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,true,'##medication##')] call EFUNC(circulation,Syringe_Draw)); \
    }

#define INJECT_SYRINGE_IM(medication,name,progress) \
    class DOUBLES(medication,IM): Epinephrine_IM { \
        displayName = name; \
        displayNameProgress = progress; \
        items[] = {QUOTE(ACM_Syringe_IM_##medication##)}; \
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'##medication##',true,false)] call EFUNC(circulation,Syringe_Inject)); \
    }

#define DRAW_INJECT_SYRINGE_IM(medication,name) \
    class TRIPLES(medication,Draw,IM): Epinephrine_Draw_IM { \
        displayName = name; \
        condition = QUOTE([ARR_2(_medic,'ACM_Syringe_IM')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_##medication##')] call ACEFUNC(common,hasItem)); \
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,false,'##medication##')] call EFUNC(circulation,Syringe_Draw)); \
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
    class SurgicalKit;
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
        medicRequired = 1;
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
    class StitchWrappedWounds: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Wrapped);
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,1)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_3(_medic,_patient,_bodyPart)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,1)] call EFUNC(damage,surgicalKitProgress));
    };
    class StitchClottedWounds: SurgicalKit {
        displayName = ECSTRING(damage,SurgicalKit_Clotted);
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,2)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,2)] call EFUNC(damage,surgicalKitProgress));
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
        condition = QUOTE([ARR_3(_patient,_bodyPart,ACM_IV_14G_M)] call EFUNC(circulation,hasIV));
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
        treatmentTime = 4;
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
    
    // IV
    class Epinephrine_IV: Morphine {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Push,Epinephrine,Intravenous));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Epinephrine));
        //icon = QACEPATHTOF(medical_gui,ui\auto_injector.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_IV_Epinephrine"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) || [ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO));
        treatmentTime = 2;
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'Epinephrine',true,true)] call EFUNC(circulation,Syringe_Inject));
        //animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        sounds[] = {};
        litter[] = {};
    };
    PUSH_SYRINGE_IV(Amiodarone,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,Amiodarone,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Amiodarone)));
    PUSH_SYRINGE_IV(Morphine,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,Morphine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Morphine)));
    PUSH_SYRINGE_IV(Ketamine,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,Ketamine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Ketamine)));
    PUSH_SYRINGE_IV(TXA,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,TXA,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,TXA)));
    //PUSH_SYRINGE_IV(Atropine);
    //PUSH_SYRINGE_IV(Ondansetron);
    PUSH_SYRINGE_IV(Adenosine,__EVAL(call compile SYRINGE_ACTION_FORMAT(Push,Adenosine,Intravenous)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Pushing,Adenosine)));
    class Epinephrine_Draw_IV: Epinephrine_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(DrawPush,Epinephrine,Intravenous));
        displayNameProgress = "";
        items[] = {};
        consumeItem = 0;
        condition = QUOTE(([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) || [ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIO)) && [ARR_2(_medic,'ACM_Syringe_IV')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_Epinephrine')] call ACEFUNC(common,hasItem));
        treatmentTime = 0.01;
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,true,'Epinephrine')] call EFUNC(circulation,Syringe_Draw));
    };
    DRAW_PUSH_SYRINGE_IV(Amiodarone,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawPush,Amiodarone,Intravenous)));
    DRAW_PUSH_SYRINGE_IV(Morphine,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawPush,Morphine,Intravenous)));
    DRAW_PUSH_SYRINGE_IV(Ketamine,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawPush,Ketamine,Intravenous)));
    DRAW_PUSH_SYRINGE_IV(TXA,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawPush,TXA,Intravenous)));
    //DRAW_PUSH_SYRINGE_IV(Atropine);
    //DRAW_PUSH_SYRINGE_IV(Ondansetron);
    DRAW_PUSH_SYRINGE_IV(Adenosine,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawPush,Adenosine,Intravenous)));
    
    // IM
    class Epinephrine_IM: Epinephrine_IV {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,Epinephrine,Intramuscular));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Epinephrine));
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_IM_Epinephrine"};
        condition = QUOTE(true);
        treatmentTime = 3;
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'Epinephrine',true,false)] call EFUNC(circulation,Syringe_Inject));
    };
    INJECT_SYRINGE_IM(Morphine,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,Morphine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Morphine)));
    INJECT_SYRINGE_IM(Ketamine,__EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,Ketamine,Intramuscular)),__EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Ketamine)));
    class Lidocaine_IM: Epinephrine_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(Inject,Lidocaine,Intramuscular));
        displayNameProgress = __EVAL(call compile SYRINGE_PROGRESS_FORMAT(Injecting,Lidocaine));
        allowedSelections[] = {"Body"};
        items[] = {"ACM_Syringe_IM_Lidocaine"};
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'Lidocaine',true,false)] call EFUNC(circulation,Syringe_Inject));
    };

    class Epinephrine_Draw_IM: Epinephrine_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(DrawInject,Epinephrine,Intramuscular));
        displayNameProgress = "";
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_2(_medic,'ACM_Syringe_IM')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_Epinephrine')] call ACEFUNC(common,hasItem));
        treatmentTime = 0.01;
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,false,'Epinephrine')] call EFUNC(circulation,Syringe_Draw));
    };
    DRAW_INJECT_SYRINGE_IM(Morphine,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawInject,Morphine,Intramuscular)));
    DRAW_INJECT_SYRINGE_IM(Ketamine,__EVAL(call compile SYRINGE_ACTION_FORMAT(DrawInject,Ketamine,Intramuscular)));
    class Lidocaine_Draw_IM: Epinephrine_Draw_IM {
        displayName = __EVAL(call compile SYRINGE_ACTION_FORMAT(DrawInject,Lidocaine,Intramuscular));
        allowedSelections[] = {"Body"};
        items[] = {"ACM_Vial_Lidocaine"};
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,false,'Lidocaine')] call EFUNC(circulation,Syringe_Draw));
    };
};