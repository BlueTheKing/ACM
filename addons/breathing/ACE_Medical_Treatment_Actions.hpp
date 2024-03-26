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
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)));
        callbackSuccess = QFUNC(checkBreathing);
    };
    class InspectChest: CheckBreathing {
        displayName = "Inspect Chest";
        displayNameProgress = "Inspecting Chest...";
        icon = "";
        medicRequired = 0;
        treatmentTime = 6;
        allowedSelections[] = {"Body"};
        callbackSuccess = QFUNC(inspectChest);
    };
    /*class UseStethoscope: CheckBreathing {
        displayName = "Inspect With Stethoscope";
        displayNameProgress = "Inspecting With Stethoscope";
        icon = "";
        medicRequired = 0;
        treatmentTime = 0.1;
        allowedSelections[] = {"Body"};
        condition = "true";
        callbackSuccess = QFUNC(useStethoscope);
    };*/

    class ApplyChestSeal: CheckBreathing {
        displayName = "Apply Chest Seal";
        displayNameProgress = "Applying Chest Seal...";
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 5;
        allowedSelections[] = {"Body"};
        allowSelfTreatment = 0;
        items[] = {"AMS_ChestSeal"};
        consumeItem = 1;
        condition = QUOTE(!(_patient getVariable [ARR_2(QQGVAR(ChestSeal_State), false)]) && _patient getVariable [ARR_2(QQGVAR(ChestInjury_State), false)]);
        callbackSuccess = QFUNC(applyChestSeal);
    };

    class PerformNCD: ApplyChestSeal {
        displayName = "Perform Needle-Chest-Decompression";
        displayNameProgress = "Performing Needle-Chest-Decompression...";
        icon = "";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 5;
        allowSelfTreatment = 0;
        items[] = {"AMS_NCDKit"};
        consumeItem = 1;
        condition = "true";
        callbackSuccess = QFUNC(performNCD);
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
        allowSelfTreatment = 0;
        items[] = {"AMS_PulseOximeter"};
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
