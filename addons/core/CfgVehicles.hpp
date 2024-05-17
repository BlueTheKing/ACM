#define ADDMAGAZINE(classname,num) \
    class DOUBLES(_xx,classname) { \
		magazine = QUOTE(classname); \
		count = num; \
	}

#define ADDITEM(classname,num) \
    class DOUBLES(_xx,classname) { \
        name = QUOTE(classname); \
        count = num; \
    }

class CfgVehicles {
    class ACE_medicalSupplyCrate;
    class ACM_MedicalSupplyCrate_Basic: ACE_medicalSupplyCrate {
        displayName = "[ACM] Basic Medical Supply Crate";
        author = "Blue";
        editorCategory = "EdCat_Supplies";
        editorSubcategory = QGVAR(EditorCategory);
        /*hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\supplyBox.paa)};*/
        class TransportMagazines {
            ADDMAGAZINE(ACM_Paracetamol,4);
            ADDMAGAZINE(ACM_AmmoniaInhalant,4);
            ADDMAGAZINE(ACM_Inhaler_Penthrox,5);
        };
        class TransportItems {
            // Catastrophic Bleeding
            ADDITEM(ACM_PressureBandage,50);
            ADDITEM(ACM_EmergencyTraumaDressing,20);
            ADDITEM(ACM_ElasticWrap,40);
            ADDITEM(ACE_tourniquet,24);
            // Airway
            ADDITEM(ACM_GuedelTube,10);
            ADDITEM(ACM_SuctionBag,5);
            // Breathing
            ADDITEM(ACM_ChestSeal,10);
            ADDITEM(ACM_NCDKit,5);
            // Circulation
            ADDITEM(ACE_epinephrine,10);
            // Disability
            ADDITEM(ACE_morphine,10);
            ADDITEM(ACE_splint,10);
            ADDITEM(ACM_SAMSplint,10);
            // Other
            ADDITEM(ACM_Spray_Naloxone,10);
        };
    };
    class ACM_MedicalSupplyCrate_Advanced: ACM_MedicalSupplyCrate_Basic {
        displayName = "[ACM] Advanced Medical Supply Crate";
        class TransportMagazines {
            ADDMAGAZINE(ACM_Paracetamol,8);
            ADDMAGAZINE(ACM_AmmoniaInhalant,8);
            ADDMAGAZINE(ACM_Inhaler_Penthrox,8);
        };
        class TransportItems {
            // Catastrophic Bleeding
            ADDITEM(ACM_PressureBandage,60);
            ADDITEM(ACM_EmergencyTraumaDressing,30);
            ADDITEM(ACM_ElasticWrap,60);
            ADDITEM(ACE_tourniquet,16);
            // Airway
            ADDITEM(ACM_IGel,20);
            ADDITEM(ACM_ACCUVAC,5);
            ADDITEM(ACM_GuedelTube,10);
            ADDITEM(ACM_SuctionBag,10);
            // Breathing
            ADDITEM(ACM_ChestSeal,20);
            ADDITEM(ACM_NCDKit,10);
            ADDITEM(ACM_PulseOximeter,5);
            ADDITEM(ACM_ChestTubeKit,5);
            // Circulation
            ADDITEM(ACM_AED,4);
            ADDITEM(ACM_IV_16g,25);
            ADDITEM(ACM_IV_14g,15);
            ADDITEM(ACM_IO_FAST,20);
            ADDITEM(ACM_Vial_Epinephrine,10);
            ADDITEM(ACM_Vial_Morphine,10);
            ADDITEM(ACM_Vial_Adenosine,10);
            ADDITEM(ACM_Vial_TXA,10);
            ADDITEM(ACM_Vial_Amiodarone,10);
            ADDITEM(ACE_epinephrine,5);
            ADDITEM(ACM_BloodBag_ON_1000,10);
            ADDITEM(ACM_BloodBag_ON_500,10);
            ADDITEM(ACM_BloodBag_ON_250,10);
            ADDITEM(ACE_plasmaIV,10);
            ADDITEM(ACE_plasmaIV_500,10);
            ADDITEM(ACE_plasmaIV_250,10);
            ADDITEM(ACE_salineIV,10);
            ADDITEM(ACE_salineIV_500,10);
            ADDITEM(ACE_salineIV_250,10);
            // Disability
            ADDITEM(ACE_morphine,5);
            ADDITEM(ACE_splint,10);
            ADDITEM(ACM_SAMSplint,10);
            // Other
            ADDITEM(ACM_Spray_Naloxone,10);
            ADDITEM(ACE_personalAidKit,1);
            ADDITEM(ACE_surgicalKit,2);
            ADDITEM(ACE_bodyBag,5);
            ADDITEM(ACE_suture,60);
        };
    };
};