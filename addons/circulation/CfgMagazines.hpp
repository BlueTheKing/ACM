#define PREPARE_SYRINGE_IV(medication) \
    class DOUBLES(ACM_Syringe_IV,medication): ACM_Syringe_IV_Epinephrine { \
        displayName = QUOTE(IV Syringe (##medication##)); \
        descriptionShort = QUOTE(IV syringe prepared with ##medication##); \
    }
#define PREPARE_SYRINGE_IM(medication) \
    class DOUBLES(ACM_Syringe_IM,medication): ACM_Syringe_IM_Epinephrine { \
        displayName = QUOTE(IM Syringe (##medication##)); \
        descriptionShort = QUOTE(IM syringe prepared with ##medication##); \
    }

class CfgMagazines {
    class CA_Magazine;

    class ACM_Paracetamol: CA_Magazine {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\paracetamol_ca.paa);
        displayName = "Paracetamol";
        descriptionShort = "Used to combat mild to moderate pain";
        descriptionUse = "Package of pills used to combat mild to moderate pain";
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 10;
        mass = 0.3;
    };

    class ACM_AmmoniaInhalant: ACM_Paracetamol {
        picture = QPATHTOF(ui\inhalant_ammonia_ca.paa);
        displayName = "Ammonia Inhalant";
        descriptionShort = "Used to wake up patients who've fainted";
        descriptionUse = "Also known as, smelling salts, inhalant used to wake up unconscious patients by triggering the inhalation reflex";
        count = 8;
    };

    class ACM_Inhaler_Penthrox: ACM_Paracetamol {
        picture = QPATHTOF(ui\inhaler_penthrox_ca.paa);
        displayName = "Penthrox Inhaler";
        descriptionShort = "Used to rapidly manage acute pain for a short time";
        descriptionUse = "Potent inhalant medication used to manage acute pain, due to the short action time it is best used in advance of painful procedures";
        count = 8;
    };

    class ACM_Syringe_IV_Epinephrine: ACM_Paracetamol {
        scope = 1;
        picture = QPATHTOF(ui\syringe_iv_ca.paa);
        displayName = "IV Syringe (Epinephrine)";
        descriptionShort = "IV syringe prepared with Epinephrine";
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 1000;
        mass = 0.8;
    };
    PREPARE_SYRINGE_IV(Morphine);
    PREPARE_SYRINGE_IV(Ketamine);
    PREPARE_SYRINGE_IV(Adenosine);
    PREPARE_SYRINGE_IV(Amiodarone);
    //PREPARE_SYRINGE_IV(Atropine);
    //PREPARE_SYRINGE_IV(Ondansetron);
    PREPARE_SYRINGE_IV(TXA);

    class ACM_Syringe_IM_Epinephrine: ACM_Syringe_IV_Epinephrine {
        picture = QPATHTOF(ui\syringe_im_ca.paa);
        displayName = "IM Syringe (Epinephrine)";
        descriptionShort = "IM syringe prepared with Epinephrine";
        count = 500;
    };
    PREPARE_SYRINGE_IM(Morphine);
    PREPARE_SYRINGE_IM(Ketamine);
    PREPARE_SYRINGE_IM(Lidocaine);
};