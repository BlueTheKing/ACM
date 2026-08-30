class ACEGVAR(medical_treatment,actions) {
    class CheckPulse;
    class CheckBreathing: CheckPulse {
        displayName = CSTRING(CheckBreathing);
        displayNameProgress = CSTRING(CheckBreathing_Progress);
        icon = "";
        category = "airway";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 3;
        allowedSelections[] = {"Head"};
        allowSelfTreatment = 0;
        condition = QUOTE(!(alive (_patient getVariable [ARR_2(QQGVAR(BVM_Medic),objNull)])));
        callbackSuccess = QFUNC(checkBreathing);
        ACM_rollToBack = 1;
    };
    class InspectChest: CheckBreathing {
        displayName = CSTRING(InspectChest);
        displayNameProgress = CSTRING(InspectChest_Progress);
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
        displayName = CSTRING(UseStethoscope);
        displayNameProgress = "";
        icon = "";
        medicRequired = 0;
        treatmentTime = 0.001;
        allowedSelections[] = {"Body"};
        allowSelfTreatment = 0;
        items[] = {"ACM_Stethoscope"};
        consumeItem = 0;
        condition = QUOTE(!([_patient] call EFUNC(core,cprActive)));
        callbackSuccess = QFUNC(useStethoscope);
        ACM_menuIcon = "ACM_Stethoscope";
    };
    class UseBVM: UseStethoscope {
        displayName = CSTRING(UseBVM);
        icon = "";
        allowedSelections[] = {"Head"};
        items[] = {"ACM_BVM","ACM_PocketBVM"};
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(canUseBVM));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(useBVM));
        ACM_cancelRecovery = 1;
        ACM_menuIcon = "ACM_BVM";
    };
    class UseBVM_Oxygen: UseBVM {
        displayName = CSTRING(UseBVM_Oxygen);
        treatmentLocations = TREATMENT_LOCATIONS_FACILITIES;
        items[] = {"ACM_BVM"};
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(canUseBVM));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(useBVM));
        ACM_menuIcon = "ACM_BVM";
    };
    class UseBVM_VehicleOxygen: UseBVM_Oxygen {
        displayName = CSTRING(UseBVM_VehicleOxygen);
        treatmentLocations = TREATMENT_LOCATIONS_VEHICLES;
    };
    class UseBVM_PortableOxygen: UseBVM_Oxygen {
        displayName = CSTRING(UseBVM_PortableOxygen);
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        items[] = {"ACM_BVM"};
        condition = QUOTE([ARR_2(_medic,_patient)] call FUNC(canUseBVM) && ('ACM_OxygenTank_425' in ([ARR_2(_medic,2)] call ACEFUNC(common,uniqueItems))));
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,true,true)] call FUNC(useBVM));
    };

    class ApplyChestSeal: CheckBreathing {
        displayName = CSTRING(ApplyChestSeal);
        displayNameProgress = CSTRING(ApplyChestSeal_Progress);
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
        ACM_menuIcon = "ACM_ChestSeal";
    };

    class PerformNCD: ApplyChestSeal {
        displayName = CSTRING(PerformNCD);
        displayNameProgress = CSTRING(PerformNCD_Progress);
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
        ACM_menuIcon = "ACM_NCDKit";
    };

    class PerformThoracostomy: ApplyChestSeal {
        displayName = CSTRING(PerformThoracostomy);
        displayNameProgress = CSTRING(PerformThoracostomy_Progress);
        icon = "";
        treatmentLocations = QGVAR(locationThoracostomy);
        medicRequired = QGVAR(allowThoracostomy);
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACE_surgicalKit"};
        consumeItem = 0;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(ChestInjury_State),false)]) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) < 1);
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(Thoracostomy_start));
        ACM_cancelRecovery = 1;
        ACM_menuIcon = "ACE_surgicalKit";
    };

    class PerformThoracostomy_Kit: PerformThoracostomy {
        displayName = CSTRING(PerformThoracostomy_Kit);
        items[] = {"ACM_ThoracostomyKit"};
        consumeItem = 1;
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(Thoracostomy_start));
        ACM_menuIcon = "ACM_ThoracostomyKit";
    };

    class InsertChestTube: PerformThoracostomy {
        displayName = CSTRING(InsertChestTube);
        displayNameProgress = CSTRING(InsertChestTube_Progress);
        icon = "";
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACM_ChestTubeKit"};
        consumeItem = 1;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) == 1);
        callbackSuccess = QFUNC(Thoracostomy_insertChestTube);
        ACM_menuIcon = "ACM_ChestTubeKit";
    };

    class ResealChestTube: InsertChestTube {
        displayName = CSTRING(ResealChestTube);
        displayNameProgress = CSTRING(ResealChestTube_Progress);
        items[] = {};
        consumeItem = 0;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) == 3);
        callbackSuccess = QFUNC(Thoracostomy_resealChestTube);
        ACM_menuIcon = "";
    };

    class DrainFluid_ACCUVAC: PerformThoracostomy {
        displayName = CSTRING(DrainFluid_ACCUVAC);
        displayNameProgress = CSTRING(DrainFluid_Suction_Progress);
        icon = "";
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"ACM_ACCUVAC"};
        consumeItem = 0;
        condition = QUOTE(GVAR(pneumothoraxEnabled) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) in [ARR_2(2,3)]);
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(Thoracostomy_drain));
        ACM_menuIcon = "ACM_ACCUVAC";
    };
    class DrainFluid_SuctionBag: DrainFluid_ACCUVAC {
        displayName = CSTRING(DrainFluid_SuctionBag);
        icon = "";
        treatmentTime = 8;
        items[] = {"ACM_SuctionBag"};
        consumeItem = 1;
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,0)] call FUNC(Thoracostomy_drain));
        ACM_menuIcon = "ACM_SuctionBag";
    };
    class DrainFluid_HandPump: DrainFluid_ACCUVAC {
        displayName = CSTRING(DrainFluid_HandPump);
        icon = "";
        treatmentTime = 8;
        items[] = {"ACM_HandPump"};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,2)] call FUNC(Thoracostomy_drain));
        ACM_menuIcon = "ACM_HandPump";
    };

    class CloseIncision: PerformThoracostomy {
        displayName = CSTRING(CloseIncision);
        displayNameProgress = CSTRING(CloseIncision_Progress);
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        treatmentTime = 5;
        items[] = {};
        condition = QUOTE(([ARR_3(_medic,_patient,['ACE_surgicalKit'])] call ACEFUNC(medical_treatment,hasItem) || (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_UsedKit),false)])) && !([_patient] call EFUNC(core,cprActive)) && !([_patient] call EFUNC(core,bvmActive)) && (_patient getVariable [ARR_2(QQGVAR(Thoracostomy_State),0)]) > 0);
        callbackSuccess = QFUNC(Thoracostomy_close);
        ACM_menuIcon = "";
    };

    class PlacePulseOximeter: CheckPulse {
        displayName = CSTRING(PlacePulseOximeter);
        displayNameProgress = CSTRING(PlacePulseOximeter_Progress);
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
        ACM_menuIcon = "ACM_PulseOximeter";
    };
    class RemovePulseOximeter: PlacePulseOximeter {
        displayName = CSTRING(RemovePulseOximeter);
        displayNameProgress = CSTRING(RemovePulseOximeter_Progress);
        icon = "";
        medicRequired = 0;
        treatmentTime = 1;
        items[] = {};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_4(_medic,_patient,_bodyPart,false)] call FUNC(setPulseOximeter));
    };
};
