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

#define ACTION_UNLOADANDCARRY \
    class ACM_Action_UnloadAndCarryPatient { \
        displayName = CSTRING(CarryPatient); \
        condition = QUOTE(alive _target); \
        exceptions[] = {"isNotDragging", "isNotCarrying", "isNotInside"}; \
        statement = ""; \
        insertChildren = QUOTE(call FUNC(addVehicleUnloadCarryPatientActions)); \
        icon = QACEPATHTOF(dragging,ui\icons\person_carry.paa); \
    }

#define ACTION_REFILL_OXYGEN_425 \
    class ACM_Action_Refill_PortableOxygenTank_425 { \
        displayName = ECSTRING(breathing,RefillOxygenTank); \
        condition = QUOTE([ARR_2(_player,_target)] call EFUNC(breathing,canRefillOxygenTank)); \
        exceptions[] = {"isNotInside"}; \
        statement = QUOTE([_player] call EFUNC(breathing,refillOxygenTank)); \
        icon = QPATHTOEF(breathing,ui\icon_oxygentank_ca.paa); \
    }

#define ACTION_PATIENTS \
    class ACM_Action_PatientsList { \
        displayName = CSTRING(VehiclePatients); \
        condition = QUOTE(count (fullCrew [ARR_2(_target,'')]) > 0); \
        exceptions[] = {"isNotInside"}; \
        statement = ""; \
        insertChildren = QUOTE(call FUNC(addVehiclePatientActions)); \
        icon = QPATHTOEF(main,logo_empty.paa); \
    }

class CfgVehicles {
    class ACE_medicalSupplyCrate;
    class ACM_MedicalSupplyCrate_Basic: ACE_medicalSupplyCrate {
        displayName = CSTRING(MedicalSupplyCrate_Basic_Display);
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
            ADDITEM(ACM_OPA,10);
            ADDITEM(ACM_NPA,10);
            ADDITEM(ACM_SuctionBag,5);
            // Breathing
            ADDITEM(ACM_ChestSeal,10);
            ADDITEM(ACM_PocketBVM,2);
            ADDITEM(ACM_NCDKit,5);
            // Disability
            ADDITEM(ACE_morphine,10);
            ADDITEM(ACM_SAMSplint,10);
            // Other
            ADDITEM(ACM_Spray_Naloxone,10);
        };
    };
    class ACM_MedicalSupplyCrate_Advanced: ACM_MedicalSupplyCrate_Basic {
        displayName = CSTRING(MedicalSupplyCrate_Advanced_Display);
        class TransportMagazines {
            ADDMAGAZINE(ACM_Paracetamol,8);
            ADDMAGAZINE(ACM_AmmoniaInhalant,8);
            ADDMAGAZINE(ACM_Inhaler_Penthrox,8);
            ADDMAGAZINE(ACM_OxygenTank_425,2);
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
            ADDITEM(ACM_OPA,10);
            ADDITEM(ACM_NPA,10);
            ADDITEM(ACM_SuctionBag,10);
            ADDITEM(ACM_CricKit,10);
            // Breathing
            ADDITEM(ACM_Stethoscope,4);
            ADDITEM(ACM_ChestSeal,20);
            ADDITEM(ACM_BVM,4);
            ADDITEM(ACM_NCDKit,10);
            ADDITEM(ACM_PulseOximeter,5);
            ADDITEM(ACM_ThoracostomyKit,5);
            ADDITEM(ACM_ChestTubeKit,5);
            // Circulation
            ADDITEM(ACM_AED,3);
            ADDITEM(ACM_PressureCuff,3);
            ADDITEM(ACM_IV_16g,25);
            ADDITEM(ACM_IV_14g,15);
            ADDITEM(ACM_Syringe_1,5);
            ADDITEM(ACM_Syringe_3,5);
            ADDITEM(ACM_Syringe_5,5);
            ADDITEM(ACM_Syringe_10,2);
            ADDITEM(ACM_IO_FAST,15);
            ADDITEM(ACM_IO_EZ,15);
            ADDITEM(ACM_Vial_Epinephrine,10);
            ADDITEM(ACM_Vial_Esmolol,10);
            ADDITEM(ACM_Vial_TXA,10);
            ADDITEM(ACM_Vial_Amiodarone,10);
            ADDITEM(ACM_Vial_Atropine,10);
            ADDITEM(ACM_BloodBag_ON_1000,10);
            ADDITEM(ACM_BloodBag_ON_500,10);
            ADDITEM(ACM_BloodBag_ON_250,10);
            ADDITEM(ACE_plasmaIV,10);
            ADDITEM(ACE_plasmaIV_500,10);
            ADDITEM(ACE_plasmaIV_250,10);
            ADDITEM(ACE_salineIV,10);
            ADDITEM(ACE_salineIV_500,10);
            ADDITEM(ACE_salineIV_250,10);
            ADDITEM(ACM_FieldBloodTransfusionKit_250,5);
            ADDITEM(ACM_FieldBloodTransfusionKit_500,5);
            ADDITEM(ACM_Vial_CalciumChloride,10);
            // Disability
            ADDITEM(ACE_morphine,5);
            ADDITEM(ACM_Vial_Morphine,10);
            ADDITEM(ACM_Vial_Ketamine,10);
            ADDITEM(ACM_Vial_Fentanyl,10);
            ADDITEM(ACM_Vial_Lidocaine,10);
            ADDITEM(ACM_Vial_Ondansetron,10);
            ADDITEM(ACM_Lozenge_Fentanyl,10);
            ADDITEM(ACM_SAMSplint,10);
            // Other
            ADDITEM(ACM_Spray_Naloxone,10);
            ADDITEM(ACE_personalAidKit,1);
            ADDITEM(ACE_surgicalKit,2);
            ADDITEM(ACE_bodyBag,5);
            ADDITEM(ACE_suture,60);
            ADDITEM(ACM_Vial_Ertapenem,10);
        };
    };
    class ACM_CBRN_SupplyCrate: ACE_medicalSupplyCrate {
        displayName = ECSTRING(CBRN,SupplyCrate_Display);
        author = "Blue";
        editorCategory = "EdCat_Supplies";
        editorSubcategory = QGVAR(EditorCategory);
        /*hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\supplyBox.paa)};*/
        class TransportMagazines {};
        class TransportItems {
            // Treatment
            ADDITEM(ACM_Autoinjector_ATNA,30);
            ADDITEM(ACM_Autoinjector_Midazolam,10);
            //ADDITEM(ACM_Ampule_Dimercaprol,10);
            // Other
            ADDITEM(ACM_GasMaskFilter,30);
        };
    };
    class ACM_CBRN_PPE_SupplyCrate: ACM_CBRN_SupplyCrate {
        displayName = ECSTRING(CBRN,SupplyCrate_PPE_Display);
        class TransportItems {
            ADDITEM(U_C_CBRN_Suit_01_Blue_F,10);
            ADDITEM(G_AirPurifyingRespirator_02_black_F,10);
            ADDITEM(ChemicalDetector_01_watch_F,2);
            ADDITEM(ACM_GasMaskFilter,10);
        };
    };

    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_LyingState_GetUp {
                    displayName = CSTRING(LyingState_GetUp);
                    icon = "";
                    condition = QUOTE(!(isPlayer _target) && {(_target getVariable [ARR_2(QQGVAR(Lying_State),false)]) && alive _target && !(_target getVariable [ARR_2('ACE_isUnconscious',false)]) && !(_target getVariable [ARR_2(QQEGVAR(evacuation,casualtyTicketClaimed),false)])});
                    statement = QUOTE([_target] call FUNC(getUp));
                    exceptions[] = {"isNotInside"};
                    showDisabled = 0;
                };
            };
        };
        class ACE_SelfActions {
            class ACM_Action_GetUp {
                displayName = CSTRING(LyingState_GetUp);
                icon = "";
                condition = QUOTE(_player getVariable [ARR_2(QQGVAR(Lying_State),false)]);
                statement = QUOTE([_player] call FUNC(getUp));
                exceptions[] = {"isNotInside","isNotInLyingState"};
                showDisabled = 0;
            };
            class ACM_Equipment {
                displayName = CSTRING(MedicalEquipment);
                icon = QPATHTOEF(main,logo_empty.paa);
                exceptions[] = {"isNotInside", "isNotSitting"};
                class ACM_AED_Interactions {
                    displayName = ECSTRING(circulation,AED_Short);
                    condition = QUOTE('ACM_AED' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                    statement = "";
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    showDisabled = 0;
                    //icon = QPATHTOF(ui\icon_aed_ca.paa);
                    class ACM_AED_ViewMonitor {
                        displayName = ECSTRING(circulation,ViewMonitor);
                        condition = "true";
                        statement = QUOTE([ARR_2(_player,_player)] call EFUNC(circulation,displayAEDMonitor));
                        exceptions[] = {"isNotInside", "isNotSitting"};
                        showDisabled = 0;
                    };
                };
                class ACM_Action_Syringe {
                    displayName = ECSTRING(circulation,Syringes);
                    condition = QUOTE([ARR_2(_player,0)] call EFUNC(circulation,Syringe_Find));
                    statement = "";
                    showDisabled = 0;
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
                    insertChildren = QUOTE([ARR_2(_player,true)] call EFUNC(circulation,Syringe_ChildActions));
                    class ACM_Action_Syringe_10_Empty {
                        displayName = __EVAL(call compile QUOTE(format [ARR_4('%1 (%2ml) [%3]',localize 'STR_ACM_Circulation_Syringe',10,localize 'STR_ACM_Core_Common_Empty')]));
                        condition = QUOTE('ACM_Syringe_10' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                        statement = QUOTE([ARR_4(_player,objNull,'',10)] call EFUNC(circulation,Syringe_Draw));
                        showDisabled = 0;
                        exceptions[] = {"isNotInside", "isNotSitting"};
                        icon = QPATHTOEF(circulation,ui\icon_syringe_10_ca.paa);
                    };
                    class ACM_Action_Syringe_5_Empty: ACM_Action_Syringe_10_Empty {
                        displayName = __EVAL(call compile QUOTE(format [ARR_4('%1 (%2ml) [%3]',localize 'STR_ACM_Circulation_Syringe',5,localize 'STR_ACM_Core_Common_Empty')]));
                        condition = QUOTE('ACM_Syringe_5' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                        statement = QUOTE([ARR_4(_player,objNull,'',5)] call EFUNC(circulation,Syringe_Draw));
                        icon = QPATHTOEF(circulation,ui\icon_syringe_5_ca.paa);
                    };
                    class ACM_Action_Syringe_3_Empty: ACM_Action_Syringe_10_Empty {
                        displayName = __EVAL(call compile QUOTE(format [ARR_4('%1 (%2ml) [%3]',localize 'STR_ACM_Circulation_Syringe',3,localize 'STR_ACM_Core_Common_Empty')]));
                        condition = QUOTE('ACM_Syringe_3' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                        statement = QUOTE([ARR_4(_player,objNull,'',3)] call EFUNC(circulation,Syringe_Draw));
                        icon = QPATHTOEF(circulation,ui\icon_syringe_3_ca.paa);
                    };
                    class ACM_Action_Syringe_1_Empty: ACM_Action_Syringe_10_Empty {
                        displayName = __EVAL(call compile QUOTE(format [ARR_4('%1 (%2ml) [%3]',localize 'STR_ACM_Circulation_Syringe',1,localize 'STR_ACM_Core_Common_Empty')]));
                        condition = QUOTE('ACM_Syringe_1' in ([ARR_2(_player,0)] call ACEFUNC(common,uniqueItems)));
                        statement = QUOTE([ARR_4(_player,objNull,'',1)] call EFUNC(circulation,Syringe_Draw));
                        icon = QPATHTOEF(circulation,ui\icon_syringe_1_ca.paa);
                    };
                };
                class ACM_Action_SplitMedicationPack {
                    displayName = CSTRING(SplitMedicationPack);
                    condition = "true";
                    statement = "";
                    showDisabled = 0;
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    icon = "";
                    insertChildren = QUOTE([_player] call FUNC(splitMedicationPack_childActions));
                };
            };
        };
    };

    class LandVehicle;
    class Car: LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                ACTION_UNLOADANDCARRY;
                ACTION_REFILL_OXYGEN_425;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Car_F: Car {};
    class Quadbike_01_base_F: Car_F {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Kart_01_Base_F: Car_F {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Tank: LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Motorcycle: LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Air;
    class Helicopter: Air {
        class ACE_Actions {
            class ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Plane: Air {
        class ACE_Actions {
            class ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };

    class Ship;
    class Ship_F: Ship {
        class ACE_Actions {
            class ACE_MainActions {
                ACTION_UNLOADANDCARRY;
            };
        };
        class ACE_SelfActions {
            ACTION_PATIENTS;
        };
    };
};