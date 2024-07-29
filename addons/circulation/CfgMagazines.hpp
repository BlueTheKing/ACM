#define SYRINGE_FORMAT_IV(var1,var2) QUOTE(format [ARR_3(C_LLSTRING(Syringe_##var1##),C_LLSTRING(Syringe_IV_Short),C_LLSTRING(Medication_##var2##))])
#define SYRINGE_FORMAT_IM(var1,var2) QUOTE(format [ARR_3(C_LLSTRING(Syringe_##var1##),C_LLSTRING(Syringe_IM_Short),C_LLSTRING(Medication_##var2##))])

#define PREPARE_SYRINGE_IV(medication,name,desc) \
    class DOUBLES(ACM_Syringe_IV,medication): ACM_Syringe_IV_Epinephrine { \
        displayName = name; \
        descriptionShort = desc; \
    }
#define PREPARE_SYRINGE_IM(medication,name,desc) \
    class DOUBLES(ACM_Syringe_IM,medication): ACM_Syringe_IM_Epinephrine { \
        displayName = name; \
        descriptionShort = desc; \
    }

class CfgMagazines {
    class CA_Magazine;

    class ACM_Paracetamol: CA_Magazine {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\paracetamol_ca.paa);
        displayName = CSTRING(Paracetamol);
        descriptionShort = CSTRING(Paracetamol_Desc);
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 10;
        mass = 0.3;
    };

    class ACM_AmmoniaInhalant: ACM_Paracetamol {
        picture = QPATHTOF(ui\inhalant_ammonia_ca.paa);
        displayName = CSTRING(AmmoniaInhalant);
        descriptionShort = CSTRING(AmmoniaInhalant_Desc);
        count = 8;
    };

    class ACM_Inhaler_Penthrox: ACM_Paracetamol {
        picture = QPATHTOF(ui\inhaler_penthrox_ca.paa);
        displayName = CSTRING(Inhaler_Penthrox);
        descriptionShort = CSTRING(Inhaler_Penthrox_Desc);
        count = 8;
    };

    class ACM_Syringe_IV_Epinephrine: ACM_Paracetamol {
        scope = 1;
        picture = QPATHTOF(ui\syringe_iv_ca.paa);
        displayName = __EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith_Display,Epinephrine));
        descriptionShort = __EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith,Epinephrine));
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 1000;
        mass = 0.8;
    };
    PREPARE_SYRINGE_IV(Morphine,__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith_Display,Morphine)),__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith,Morphine)));
    PREPARE_SYRINGE_IV(Ketamine,__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith_Display,Ketamine)),__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith,Ketamine)));
    PREPARE_SYRINGE_IV(Adenosine,__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith_Display,Adenosine)),__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith,Adenosine)));
    PREPARE_SYRINGE_IV(Amiodarone,__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith_Display,Amiodarone)),__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith,Amiodarone)));
    //PREPARE_SYRINGE_IV(Atropine);
    //PREPARE_SYRINGE_IV(Ondansetron);
    PREPARE_SYRINGE_IV(TXA,__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith_Display,TXA)),__EVAL(call compile SYRINGE_FORMAT_IV(PreparedWith,TXA)));

    class ACM_Syringe_IM_Epinephrine: ACM_Syringe_IV_Epinephrine {
        picture = QPATHTOF(ui\syringe_im_ca.paa);
        displayName = __EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith_Display,Epinephrine));
        descriptionShort = __EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith,Epinephrine));
        count = 500;
    };
    PREPARE_SYRINGE_IM(Morphine,__EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith_Display,Morphine)),__EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith,Morphine)));
    PREPARE_SYRINGE_IM(Ketamine,__EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith_Display,Ketamine)),__EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith,Ketamine)));
    PREPARE_SYRINGE_IM(Lidocaine,__EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith_Display,Lidocaine)),__EVAL(call compile SYRINGE_FORMAT_IM(PreparedWith,Lidocaine)));
};