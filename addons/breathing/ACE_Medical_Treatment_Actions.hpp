class ACEGVAR(medical_treatment,actions) {
    class CheckPulse;
    class CheckBreathing: CheckPulse {
        displayName = "Check Breathing";
        displayNameProgress = "Checking Breathing...";
        icon = "";
        category = "airway";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 3;
        allowedSelections[] = {"Head"};
        allowSelfTreatment = 0;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQGVAR(BVM_Medic),objNull)])));
        callbackSuccess = QFUNC(checkBreathing);
        ACM_rollToBack = 1;
    };
    class InspectChest: CheckBreathing {
        displayName = "Inspect Chest";
        displayNameProgress = "Inspecting Chest...";
        icon = "";
        medicRequired = QGVAR(allowInspectChest);
        treatmentTime = QGVAR(treatmentTimeInspectChest);
        allowedSelections[] = {"Body"};
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !(_patient call ACEFUNC(common,isAwake)) && !([_patient] call EFUNC(core,cprActive)) && (isNull objectParent _patient));
        callbackSuccess = QFUNC(inspectChest);
        animationMedic = "AinvPknlMstpSnonWnonDr_medic4";
        ACM_cancelRecovery = 1;
    };
    class UseStethoscope: CheckBreathing {
        displayName = "Inspect Chest With Stethoscope";
        displayNameProgress = "Inspecting Chest With Stethoscope...";
        icon = "";
        medicRequired = 0;
        treatmentTime = 0.001;
        allowedSelections[] = {"Body"};
        allowSelfTreatment = 0;
        items[] = {"ACM_Stethoscope"};
        consumeItem = 0;
        condition = QUOTE(!([_patient] call EFUNC(core,cprActive)));
        callbackSuccess = QFUNC(useStethoscope);
    };
    class UseBVM: UseStethoscope {
        displayName = "Use BVM";
        icon = "";
        allowedSelections[] = {"Head"};
        items[] = {"ACM_BVM","ACM_PocketBVM"};
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQGVAR(BVM_Medic),objNull)])));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(useBVM));
        ACM_cancelRecovery = 1;
    };
    class UseBVM_Oxygen: UseBVM {
        displayName = "Use BVM with Oxygen";
        treatmentLocations = TREATMENT_LOCATIONS_FACILITIES;
        items[] = {"ACM_BVM"};
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQGVAR(BVM_Medic),objNull)])));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(useBVM));
    };
    class UseBVM_VehicleOxygen: UseBVM_Oxygen {
        displayName = "Use BVM with Oxygen (Vehicle)";
        treatmentLocations = TREATMENT_LOCATIONS_VEHICLES;
    };
    class UseBVM_PortableOxygen: UseBVM_Oxygen {
        displayName = "Use BVM with Oxygen (Portable)";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        items[] = {"ACM_BVM"};
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQGVAR(BVM_Medic),objNull)])) && ('ACM_OxygenTank_425' in ([ARR_2(_medic,2)] call ACEFUNC(common,uniqueItems))));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,true,true)] call FUNC(useBVM));
    };

    class ApplyChestSeal: CheckBreathing {
        displayName = "Apply Chest Seal";
        displayNameProgress = "Applying Chest Seal...";
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 5;
        allowedSelections[] = {"Body"};
        allowSelfTreatment = 1;
        items[] = {"ACM_ChestSeal"};
        consumeItem = 1;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !(_patient getVariable [ARR_2(QQGVAR(ChestSeal_State),false)]) && _patient getVariable [ARR_2(QQGVAR(ChestInjury_State),false)]);
        callbackSuccess = QFUNC(applyChestSeal);
        ACM_cancelRecovery = 1;
    };

    class PerformNCD: ApplyChestSeal {
        displayName = "Perform Needle-Chest-Decompression";
        displayNameProgress = "Performing Needle-Chest-Decompression...";
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = QGVAR(allowNCD);
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACM_NCDKit"};
        consumeItem = 1;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && _patient getVariable [ARR_2(QQGVAR(ChestInjury_State),false)]);
        callbackSuccess = QFUNC(performNCD);
        ACM_cancelRecovery = 1;
    };

    class PerformThoracostomy: ApplyChestSeal {
        displayName = "Perform Thoracostomy";
        displayNameProgress = "Performing Thoracostomy...";
        icon = "";
        treatmentLocations = QGVAR(locationThoracostomy);
        medicRequired = QGVAR(allowThoracostomy);
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACE_surgicalKit"};
        consumeItem = 0;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(ChestInjury_State),false)]) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) < 1);
        callbackSuccess = QFUNC(Thoracostomy_start);
        ACM_cancelRecovery = 1;
    };

    class InsertChestTube: PerformThoracostomy {
        displayName = "Insert Chest Tube";
        displayNameProgress = "Inserting Chest Tube...";
        icon = "";
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACM_ChestTubeKit"};
        consumeItem = 1;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) == 1);
        callbackSuccess = QFUNC(Thoracostomy_insertChestTube);
    };

    class DrainFluid_ACCUVAC: PerformThoracostomy {
        displayName = "Drain Fluid (ACCUVAC)";
        displayNameProgress = "Draining Fluid...";
        icon = "";
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACM_ACCUVAC"};
        consumeItem = 0;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) == 2);
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(Thoracostomy_drain));
    };
    class DrainFluid_SuctionBag: DrainFluid_ACCUVAC {
        displayName = "Drain Fluid (Suction Bag)";
        icon = "";
        treatmentTime = 8;
        items[] = {"ACM_SuctionBag"};
        consumeItem = 1;
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,0)] call FUNC(Thoracostomy_drain));
    };

    class CloseIncision: PerformThoracostomy {
        displayName = "Close Thoracostomy Incision";
        displayNameProgress = "Closing Thoracostomy Incision...";
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 5;
        condition = QUOTE(!([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) > 0);
        callbackSuccess = QFUNC(Thoracostomy_close);
    };

    class PlacePulseOximeter: CheckPulse {
        displayName = "Place Pulse Oximeter";
        displayNameProgress = "Placing Pulse Oximeter...";
        icon = "";
        category = "examine";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 2;
        allowedSelections[] = {"LeftArm","RightArm"};
        items[] = {"ACM_PulseOximeter"};
        consumeItem = 1;
        condition = QFUNC(canPlacePulseOximeter);
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,_bodyPart)] call FUNC(setPulseOximeter));
    };
    class RemovePulseOximeter: PlacePulseOximeter {
        displayName = "Remove Pulse Oximeter";
        displayNameProgress = "Removing Pulse Oximeter...";
        icon = "";
        medicRequired = 0;
        treatmentTime = 1;
        items[] = {};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call FUNC(setPulseOximeter));
    };
};
