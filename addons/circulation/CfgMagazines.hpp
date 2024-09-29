#define SYRINGE_FORMAT_DISPLAY(med,size) QUOTE(format [ARR_4('%1 (%2ml) [%3]',C_LLSTRING(Syringe),size,C_LLSTRING(Medication_##med##))])
#define SYRINGE_FORMAT_DESC(med,amount) QUOTE(format [ARR_3(C_LLSTRING(Syringe_PreparedWith),##amount##,C_LLSTRING(Medication_##med##))])

#define PREPARE_SYRINGE(c,m,amount,med,name,desc) \
    class DOUBLES(ACM_Syringe_##amount##,med): ACM_Syringe_10_Epinephrine { \
        picture = QPATHTOF(ui\syringe_##amount##_ca.paa); \
        displayName = name; \
        descriptionShort = desc; \
        count = c; \
        mass = m; \
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

    class ACM_Syringe_10_Epinephrine: ACM_Paracetamol {
        scope = 1;
        picture = QPATHTOF(ui\syringe_10_ca.paa);
        displayName = __EVAL(call compile SYRINGE_FORMAT_DISPLAY(Epinephrine,10));
        descriptionShort = __EVAL(call compile SYRINGE_FORMAT_DESC(Epinephrine,10));
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 1000;
        mass = 0.9;
        ACM_isSyringe = 1;
    };
    PREPARE_SYRINGE(500,0.7,5,Epinephrine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Epinephrine,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Epinephrine,5)));
    PREPARE_SYRINGE(300,0.6,3,Epinephrine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Epinephrine,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Epinephrine,3)));
    PREPARE_SYRINGE(100,0.5,1,Epinephrine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Epinephrine,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Epinephrine,1)));

    PREPARE_SYRINGE(1000,0.9,10,Morphine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Morphine,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Morphine,10)));
    PREPARE_SYRINGE(500,0.7,5,Morphine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Morphine,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Morphine,5)));
    PREPARE_SYRINGE(300,0.6,3,Morphine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Morphine,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Morphine,3)));
    PREPARE_SYRINGE(100,0.5,1,Morphine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Morphine,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Morphine,1)));

    PREPARE_SYRINGE(1000,0.9,10,Ketamine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ketamine,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ketamine,10)));
    PREPARE_SYRINGE(500,0.7,5,Ketamine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ketamine,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ketamine,5)));
    PREPARE_SYRINGE(300,0.6,3,Ketamine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ketamine,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ketamine,3)));
    PREPARE_SYRINGE(100,0.5,1,Ketamine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ketamine,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ketamine,1)));

    PREPARE_SYRINGE(1000,0.9,10,Adenosine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Adenosine,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Adenosine,10)));
    PREPARE_SYRINGE(500,0.7,5,Adenosine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Adenosine,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Adenosine,5)));
    PREPARE_SYRINGE(300,0.6,3,Adenosine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Adenosine,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Adenosine,3)));
    PREPARE_SYRINGE(100,0.5,1,Adenosine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Adenosine,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Adenosine,1)));

    PREPARE_SYRINGE(1000,0.9,10,Amiodarone,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Amiodarone,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Amiodarone,10)));
    PREPARE_SYRINGE(500,0.7,5,Amiodarone,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Amiodarone,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Amiodarone,5)));
    PREPARE_SYRINGE(300,0.6,3,Amiodarone,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Amiodarone,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Amiodarone,3)));
    PREPARE_SYRINGE(100,0.5,1,Amiodarone,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Amiodarone,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Amiodarone,1)));

    PREPARE_SYRINGE(1000,0.9,10,Fentanyl,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Fentanyl,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Fentanyl,10)));
    PREPARE_SYRINGE(500,0.7,5,Fentanyl,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Fentanyl,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Fentanyl,5)));
    PREPARE_SYRINGE(300,0.6,3,Fentanyl,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Fentanyl,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Fentanyl,3)));
    PREPARE_SYRINGE(100,0.5,1,Fentanyl,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Fentanyl,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Fentanyl,1)));

    PREPARE_SYRINGE(1000,0.9,10,Ondansetron,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ondansetron,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ondansetron,10)));
    PREPARE_SYRINGE(500,0.7,5,Ondansetron,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ondansetron,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ondansetron,5)));
    PREPARE_SYRINGE(300,0.6,3,Ondansetron,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ondansetron,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ondansetron,3)));
    PREPARE_SYRINGE(100,0.5,1,Ondansetron,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Ondansetron,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Ondansetron,1)));

    PREPARE_SYRINGE(1000,0.9,10,TXA,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(TXA,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(TXA,10)));
    PREPARE_SYRINGE(500,0.7,5,TXA,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(TXA,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(TXA,5)));
    PREPARE_SYRINGE(300,0.6,3,TXA,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(TXA,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(TXA,3)));
    PREPARE_SYRINGE(100,0.5,1,TXA,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(TXA,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(TXA,1)));

    PREPARE_SYRINGE(1000,0.9,10,Lidocaine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Lidocaine,10)),__EVAL(call compile SYRINGE_FORMAT_DESC(Lidocaine,10)));
    PREPARE_SYRINGE(500,0.7,5,Lidocaine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Lidocaine,5)),__EVAL(call compile SYRINGE_FORMAT_DESC(Lidocaine,5)));
    PREPARE_SYRINGE(300,0.6,3,Lidocaine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Lidocaine,3)),__EVAL(call compile SYRINGE_FORMAT_DESC(Lidocaine,3)));
    PREPARE_SYRINGE(100,0.5,1,Lidocaine,__EVAL(call compile SYRINGE_FORMAT_DISPLAY(Lidocaine,1)),__EVAL(call compile SYRINGE_FORMAT_DESC(Lidocaine,1)));
};