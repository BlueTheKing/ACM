#define PUSH_SYRINGE_IV(medication) \
    class DOUBLES(medication,IV): Epinephrine_IV { \
        displayName = QUOTE(Push ##medication## (IV)); \
        displayNameProgress = QUOTE(Pushing ##medication##...); \
        items[] = {QUOTE(ACM_Syringe_IV_##medication##)}; \
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'##medication##',true,true)] call EFUNC(circulation,Syringe_Inject)); \
    }

#define DRAW_PUSH_SYRINGE_IV(medication) \
    class TRIPLES(medication,Draw,IV): Epinephrine_Draw_IV { \
        displayName = QUOTE(Draw And Push ##medication## (IV)); \
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) && [ARR_2(_medic,'ACM_Syringe_IV')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_##medication##')] call ACEFUNC(common,hasItem)); \
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,true,'##medication##')] call EFUNC(circulation,Syringe_Draw)); \
    }

#define INJECT_SYRINGE_IM(medication) \
    class DOUBLES(medication,IM): Epinephrine_IM { \
        displayName = QUOTE(Inject ##medication## (IM)); \
        displayNameProgress = QUOTE(Injecting ##medication##...); \
        items[] = {QUOTE(ACM_Syringe_IM_##medication##)}; \
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'##medication##',true,false)] call EFUNC(circulation,Syringe_Inject)); \
    }

#define DRAW_INJECT_SYRINGE_IM(medication) \
    class TRIPLES(medication,Draw,IM): Epinephrine_Draw_IM { \
        displayName = QUOTE(Draw And Inject ##medication## (IM)); \
        condition = QUOTE([ARR_2(_medic,'ACM_Syringe_IM')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_##medication##')] call ACEFUNC(common,hasItem)); \
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,false,'##medication##')] call EFUNC(circulation,Syringe_Draw)); \
    }

class ACEGVAR(medical_treatment,actions) {
    class BasicBandage;
    class Splint;
    class FieldDressing;
    class Morphine: FieldDressing {
        displayName = "Use Morphine Autoinjector";
        displayNameProgress = "Using Morphine Autoinjector...";
    };
    class Adenosine: Morphine {
        displayName = "Use Adenosine Autoinjector";
        displayNameProgress = "Using Adenosine Autoinjector...";
    };
    class Epinephrine: Morphine {
        displayName = "Use Epinephrine Autoinjector";
        displayNameProgress = "Using Epinephrine Autoinjector...";
    };
    class SurgicalKit;
    class CheckPulse;
    class CheckResponse: CheckPulse {
        treatmentTime = 2.5;
    };
    class CheckBloodPressure: CheckPulse {
        displayName = "Check Capillary Refill Time";
        displayNameProgress = "Checking Capillary Refill Time...";
        allowedSelections[] = {"Body", "LeftArm", "RightArm"};
        treatmentTime = 2.5;
        callbackSuccess = QEFUNC(circulation,checkCapillaryRefill);
    };
    class MeasureBloodPressure: CheckBloodPressure {
        displayName = "Measure Blood Pressure";
        displayNameProgress = "";
        allowedSelections[] = {"LeftArm", "RightArm"};
        treatmentTime = 0.01;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasPressureCuff));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call EFUNC(circulation,measureBP));
    };
    class MeasureBloodPressureStethoscope: MeasureBloodPressure {
        displayName = "Measure Blood Pressure (Stethoscope)";
        items[] = {"ACM_Stethoscope"};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,true)] call EFUNC(circulation,measureBP));
    };
    class CheckDogTags: CheckResponse {
        displayName = ACECSTRING(dogtags,checkItem);
        displayNameProgress = "";
        icon = QACEPATHTOF(dogtags,data\dogtag_icon_ca.paa);
        treatmentTime = 0.01;
        allowSelfTreatment = 1;
        condition = QFUNC(canCheckDogtag);
        callbackSuccess = QACEFUNC(dogtags,checkDogtag);
        ACM_rollToBack = 1;
    };

    class PressureBandage: BasicBandage {
        displayName = "Pressure Bandage";
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
        displayName = "Emergency Trauma Dressing";
        items[] = {"ACM_EmergencyTraumaDressing"};
        allowSelfTreatment = 0;
    };
    class ElasticWrap: PressureBandage {
        displayName = "Wrap Bruises";
        displayNameProgress = "Wrapping...";
        items[] = {"ACM_ElasticWrap"};
        medicRequired = 1;
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,2)] call EFUNC(damage,canWrap));
        treatmentTime = QEFUNC(damage,getBruiseWrapTime);
        callbackSuccess = QEFUNC(damage,wrapBruises);
    };
    class ElasticWrapBandages: ElasticWrap {
        displayName = "Wrap Bandaged Wounds";
        condition = QUOTE([ARR_3(_medic,_patient,_bodyPart)] call EFUNC(damage,canWrap));
        treatmentTime = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call EFUNC(damage,getWrapTime));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,0)] call EFUNC(damage,wrapBodypart));
    };
    class ElasticWrapClots: ElasticWrap {
        displayName = "Wrap Clotted Wounds";
        condition = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,canWrap));
        treatmentTime = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,getWrapTime));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,1)] call EFUNC(damage,wrapBodypart));
    };
    class ElasticWrapSplint: ElasticWrap {
        displayName = "Wrap SAM Splint";
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = QEFUNC(disability,canWrapSplint);
        treatmentTime = QEFUNC(disability,getSplintWrapTime);
        callbackSuccess = QEFUNC(disability,wrapSplint);
    };
    class ApplySAMSplint: Splint {
        displayName = "Apply SAM Splint";
        displayNameProgress = "Applying SAM Splint...";
        items[] = {"ACM_SAMSplint"};
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        condition = QACEFUNC(medical_treatment,canSplint);
        treatmentTime = QGVAR(treatmentTimeSAMSplint);
        callbackSuccess = QEFUNC(disability,splint);
    };
    class RemoveSAMSplint: Splint {
        displayName = "Remove SAM Splint";
        displayNameProgress = "Removing SAM Splint...";
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {};
        condition = QEFUNC(disability,canRemoveSplint);
        treatmentTime = 3;
        callbackSuccess = QEFUNC(disability,removeSplint);
        litter[] = {};
    };
    /*class ChitosanInjector: Morphine {
        displayName = CSTRING(ChitosanInjector_Display);
        displayNameProgress = CSTRING(ChitosanInjector_Progress);
        icon = QACEPATHTOF(medical_gui,ui\auto_injector.paa);
        category = "bandage";
        allowedSelections[] = {"All"};
        items[] = {"ACM_chitosanInjector"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call FUNC(isBodyPartBleeding));
        callbackSuccess = QFUNC(applyChitosanInjector);
        litter[] = {};
    };*/
    class StitchWrappedWounds: SurgicalKit {
        displayName = "Use Surgical Kit (Wrapped)";
        treatmentTime = QUOTE([ARR_3(_patient,_bodyPart,1)] call EFUNC(damage,getStitchTime));
        condition = QUOTE([ARR_3(_medic,_patient,_bodyPart)] call EFUNC(damage,canStitch));
        callbackProgress = QUOTE([ARR_4(_args,_elapsedTime,_totalTime,1)] call EFUNC(damage,surgicalKitProgress));
    };
    class StitchClottedWounds: SurgicalKit {
        displayName = "Use Surgical Kit (Clotted)";
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

    // Medication

    class Paracetamol: Morphine {
        displayName = "Use Paracetamol";
        displayNameProgress = "Using Paracetamol...";
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
        displayName = "Use Penthrox Inhaler";
        displayNameProgress = "Using Penthrox Inhaler...";
        items[] = {"ACM_Inhaler_Penthrox"};
        treatmentTime = 5;
        animationMedic = "";
        sounds[] = {};
    };
    class AmmoniaInhalant: Paracetamol {
        displayName = "Use Ammonia Inhalant";
        displayNameProgress = "Using Ammonia Inhalant...";
        items[] = {"ACM_AmmoniaInhalant"};
        treatmentTime = 4;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        ACM_rollToBack = 1;
    };
    class Naloxone: Paracetamol {
        displayName = "Use Naloxone Spray";
        displayNameProgress = "Using Naloxone Spray...";
        items[] = {"ACM_Spray_Naloxone"};
        treatmentTime = 4;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        ACM_rollToBack = 1;
        sounds[] = {};
    };

    class ShakeAwake: CheckResponse {
        displayName = "Attempt To Shake Awake";
        displayNameProgress = "Shaking Patient...";
        category = "medication";
        medicRequired = 0;
        allowedSelections[] = {"Body","LeftArm","RightArm"};
        treatmentTime = 1.5;
        condition = QUOTE(!([_patient] call ACEFUNC(common,isAwake)));
        callbackSuccess = QEFUNC(disability,shakeAwake);
    };
    class SlapAwake: ShakeAwake {
        displayName = "Attempt To Slap Awake";
        displayNameProgress = "Slapping Patient...";
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
        displayName = "Push Epinephrine (IV)";
        displayNameProgress = "Pushing Epinephrine...";
        //icon = QACEPATHTOF(medical_gui,ui\auto_injector.paa);
        allowedSelections[] = {"Body","LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_IV_Epinephrine"};
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV));
        treatmentTime = 2;
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'Epinephrine',true,true)] call EFUNC(circulation,Syringe_Inject));
        //animationMedic = "AinvPknlMstpSnonWnonDnon_medic1";
        sounds[] = {};
        litter[] = {};
    };
    PUSH_SYRINGE_IV(Amiodarone);
    PUSH_SYRINGE_IV(Morphine);
    PUSH_SYRINGE_IV(Ketamine);
    PUSH_SYRINGE_IV(TXA);
    //PUSH_SYRINGE_IV(Atropine);
    //PUSH_SYRINGE_IV(Ondansetron);
    PUSH_SYRINGE_IV(Adenosine);
    class Epinephrine_Draw_IV: Epinephrine_IV {
        displayName = "Draw And Push Epinephrine (IV)";
        displayNameProgress = "";
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_2(_patient,_bodyPart)] call EFUNC(circulation,hasIV) && [ARR_2(_medic,'ACM_Syringe_IV')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_Epinephrine')] call ACEFUNC(common,hasItem));
        treatmentTime = 0.01;
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,true,'Epinephrine')] call EFUNC(circulation,Syringe_Draw));
    };
    DRAW_PUSH_SYRINGE_IV(Amiodarone);
    DRAW_PUSH_SYRINGE_IV(Morphine);
    DRAW_PUSH_SYRINGE_IV(Ketamine);
    DRAW_PUSH_SYRINGE_IV(TXA);
    //DRAW_PUSH_SYRINGE_IV(Atropine);
    //DRAW_PUSH_SYRINGE_IV(Ondansetron);
    DRAW_PUSH_SYRINGE_IV(Adenosine);
    
    // IM
    class Epinephrine_IM: Epinephrine_IV {
        displayName = "Inject Epinephrine (IM)";
        displayNameProgress = "Injecting Epinephrine...";
        allowedSelections[] = {"LeftArm","RightArm","LeftLeg","RightLeg"};
        items[] = {"ACM_Syringe_IM_Epinephrine"};
        condition = QUOTE(true);
        treatmentTime = 3;
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'Epinephrine',true,false)] call EFUNC(circulation,Syringe_Inject));
    };
    INJECT_SYRINGE_IM(Morphine);
    INJECT_SYRINGE_IM(Ketamine);
    class Lidocaine_IM: Epinephrine_IM {
        displayName = "Inject Lidocaine (IM)";
        displayNameProgress = "Injecting Lidocaine...";
        allowedSelections[] = {"Body"};
        items[] = {"ACM_Syringe_IM_Lidocaine"};
        callbackSuccess = QUOTE([ARR_6(_medic,_patient,_bodyPart,'Lidocaine',true,false)] call EFUNC(circulation,Syringe_Inject));
    };

    class Epinephrine_Draw_IM: Epinephrine_IM {
        displayName = "Draw And Inject Epinephrine (IM)";
        displayNameProgress = "";
        items[] = {};
        consumeItem = 0;
        condition = QUOTE([ARR_2(_medic,'ACM_Syringe_IM')] call ACEFUNC(common,hasItem) && [ARR_2(_medic,'ACM_Vial_Epinephrine')] call ACEFUNC(common,hasItem));
        treatmentTime = 0.01;
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,false,'Epinephrine')] call EFUNC(circulation,Syringe_Draw));
    };
    DRAW_INJECT_SYRINGE_IM(Morphine);
    DRAW_INJECT_SYRINGE_IM(Ketamine);
    class Lidocaine_Draw_IM: Epinephrine_Draw_IM {
        displayName = "Draw And Inject Lidocaine (IM)";
        allowedSelections[] = {"Body"};
        items[] = {"ACM_Vial_Lidocaine"};
        callbackSuccess = QUOTE([ARR_5(_medic,_patient,_bodyPart,false,'Lidocaine')] call EFUNC(circulation,Syringe_Draw));
    };
};