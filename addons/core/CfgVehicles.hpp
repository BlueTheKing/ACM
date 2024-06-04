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

#define ACTION_SYRINGE_IM_DISCARD(medication) \
    class DOUBLES(ACM_Action_Syringe_IM,medication) { \
        displayName = QUOTE(IM Syringe (##medication##)); \
        condition = QUOTE('ACM_Syringe_IM_##medication##' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems))); \
        statement = ""; \
        showDisabled = 0; \
        class TRIPLES(ACM_Action_Syringe_IM,medication,Discard) { \
            displayName = QUOTE(Discard Contents); \
            condition = "true"; \
            statement = QUOTE([ARR_2(_player,'##medication##')] call EFUNC(circulation,Syringe_Discard)); \
            showDisabled = 0; \
        }; \
    }

#define ACTION_SYRINGE_IM_PREPARE(medication) \
    class DOUBLES(ACM_Action_Syringe_IM_Empty_Prepare,medication) { \
        displayName = QUOTE(Draw ##medication##); \
        condition = QUOTE('ACM_Vial_##medication##' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems))); \
        statement = QUOTE([ARR_2(_player,'##medication##')] call EFUNC(circulation,Syringe_Prepare)); \
        showDisabled = 0; \
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
            ADDITEM(ACM_AED,3);
            ADDITEM(ACM_PressureCuff,3);
            ADDITEM(ACM_IV_16g,25);
            ADDITEM(ACM_IV_14g,15);
            ADDITEM(ACM_Syringe_IM,5);
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
            ADDITEM(ACM_Vial_Ketamine,10);
            ADDITEM(ACM_Vial_Lidocaine,10);
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

    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACM_Equipment {
                displayName = "Medical Equipment";
                icon = QPATHTOEF(main,logo_empty.paa);
                class ACM_AED_Interactions {
                    displayName = "AED";
                    condition = QUOTE('ACM_AED' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                    //icon = QPATHTOF(ui\icon_aed_ca.paa);
                    class ACM_AED_ViewMonitor {
                        displayName = "View Monitor";
                        condition = "true";
                        statement = QUOTE([ARR_2(_player,_player)] call EFUNC(circulation,displayAEDMonitor));
                        showDisabled = 0;
                    };
                };
                class ACM_Action_Syringe_IM {
                    displayName = "IM Syringes";
                    condition = QUOTE([_player] call EFUNC(circulation,Syringe_Find));
                    statement = "";
                    showDisabled = 0;
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    icon = QPATHTOEF(circulation,ui\icon_syringe_im_ca.paa);
                    class ACM_Action_Syringe_IM_Empty {
                        displayName = "IM Syringe (Empty)";
                        condition = QUOTE('ACM_Syringe_IM' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                        statement = "";
                        showDisabled = 0;
                        exceptions[] = {"isNotInside", "isNotSitting"};
                        icon = "";
                        ACTION_SYRINGE_IM_PREPARE(Epinephrine);
                        ACTION_SYRINGE_IM_PREPARE(Morphine);
                        ACTION_SYRINGE_IM_PREPARE(Ketamine);
                        ACTION_SYRINGE_IM_PREPARE(Lidocaine);
                    };
                    ACTION_SYRINGE_IM_DISCARD(Epinephrine);
                    ACTION_SYRINGE_IM_DISCARD(Morphine);
                    ACTION_SYRINGE_IM_DISCARD(Ketamine);
                    ACTION_SYRINGE_IM_DISCARD(Lidocaine);
                };
            };
        };
    };

    class LandVehicle;
    class Car: LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Car_F: Car {};
    class Quadbike_01_base_F: Car_F {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Kart_01_Base_F: Car_F {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Tank: LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Motorcycle: LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Air;
    class Helicopter: Air {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Plane: Air {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };

    class Ship;
    class Ship_F: Ship {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_UnloadAndCarryPatient {
                    displayName = "Carry Patient";
                    condition = QUOTE(alive _target);
                    exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"};
                    statement = "";
                    insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions));
                    icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa);
                };
            };
        };
    };
};