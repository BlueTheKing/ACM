#define ACM_MEDICALMENU_ACTION_BUTTON(name,picture) \
    class ACM_MedicalMenu_ActionButton_##name##: ACM_MedicalMenu_ActionButton_None { \
        textureNoShortcut = picture; \
    }

ACM_MEDICALMENU_ACTION_BUTTON(ACE_tourniquet,QACEPATHTOF(medical_treatment,ui\tourniquet_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_surgicalKit,QACEPATHTOF(medical_treatment,ui\surgicalKit_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_personalAidKit,QACEPATHTOF(medical_treatment,ui\surgicalKit_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_bodyBag,QACEPATHTOF(medical_treatment,ui\bodybag_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_bodyBag_blue,QACEPATHTOF(medical_treatment,ui\bodybag_blue_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_bodyBag_white,QACEPATHTOF(medical_treatment,ui\bodybag_white_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_adenosine,QACEPATHTOF(medical_treatment,ui\adenosine_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_epinephrine,QACEPATHTOF(medical_treatment,ui\epinephrine_ca.paa));

ACM_MEDICALMENU_ACTION_BUTTON(CPR,QPATHTOEF(core,ui\icon_patient_cpr.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACE_morphine,QPATHTOEF(core,ui\override\morphine_ca.paa));

ACM_MEDICALMENU_ACTION_BUTTON(ACM_OPA,QPATHTOEF(airway,ui\opa_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_IGel,QPATHTOEF(airway,ui\igel_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_NPA,QPATHTOEF(airway,ui\npa_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_SuctionBag,QPATHTOEF(airway,ui\suctionbag_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_ACCUVAC,QPATHTOEF(airway,ui\accuvac_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_CricKit,QPATHTOEF(airway,ui\crickit_ca.paa));

ACM_MEDICALMENU_ACTION_BUTTON(ACM_ChestSeal,QPATHTOEF(breathing,ui\chestseal_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_PulseOximeter,QPATHTOEF(breathing,ui\pulseoximeter_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Stethoscope,QPATHTOEF(breathing,ui\stethoscope_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_NCDKit,QPATHTOEF(breathing,ui\ncdkit_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_ChestTubeKit,QPATHTOEF(breathing,ui\chestTubeKit_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_ThoracostomyKit,QPATHTOEF(breathing,ui\thoracostomyKit_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_HandPump,QPATHTOEF(breathing,ui\handPump_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_PocketBVM,QPATHTOEF(breathing,ui\pocketbvm_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_BVM,QPATHTOEF(breathing,ui\bvm_ca.paa));

ACM_MEDICALMENU_ACTION_BUTTON(ACM_AED,QPATHTOEF(circulation,ui\AED_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_PressureCuff,QPATHTOEF(circulation,ui\pressureCuff_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_IV_16G,QPATHTOEF(circulation,ui\IV_16g_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_IV_14G,QPATHTOEF(circulation,ui\IV_14g_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_IO_FAST,QPATHTOEF(circulation,ui\IO_FAST1_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_IO_EZ,QPATHTOEF(circulation,ui\IO_EZ_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Syringe_10,QPATHTOEF(circulation,ui\syringe_10_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Syringe_5,QPATHTOEF(circulation,ui\syringe_5_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Syringe_3,QPATHTOEF(circulation,ui\syringe_3_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Syringe_1,QPATHTOEF(circulation,ui\syringe_1_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Spray_Naloxone,QPATHTOEF(circulation,ui\spray_naloxone_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Paracetamol,QPATHTOEF(circulation,ui\paracetamol_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_AmmoniaInhalant,QPATHTOEF(circulation,ui\inhalant_ammonia_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Inhaler_Penthrox,QPATHTOEF(circulation,ui\inhaler_penthrox_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Lozenge_Fentanyl,QPATHTOEF(circulation,ui\lozenge_fentanyl_ca.paa));

ACM_MEDICALMENU_ACTION_BUTTON(ACM_PressureBandage,QPATHTOEF(damage,ui\pressurebandage.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_EmergencyTraumaDressing,QPATHTOEF(damage,ui\etd.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_ElasticWrap,QACEPATHTOF(medical_treatment,ui\elasticbandage_ca.paa));

ACM_MEDICALMENU_ACTION_BUTTON(ACM_SAMSplint,QPATHTOEF(disability,ui\samSplint.paa));

ACM_MEDICALMENU_ACTION_BUTTON(ACM_ATNA_Autoinjector,QPATHTOEF(cbrn,ui\autoinjector_ATNA_ca.paa));
ACM_MEDICALMENU_ACTION_BUTTON(ACM_Midazolam_Autoinjector,QPATHTOEF(cbrn,ui\autoinjector_midazolam_ca.paa));