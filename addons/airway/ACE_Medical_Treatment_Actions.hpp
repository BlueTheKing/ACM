class ACEGVAR(medical_treatment,actions) {
    class CheckPulse;
    class CheckAirway: CheckPulse {
        displayName = "Check Airway";
        displayNameProgress = "Checking Airway";
        icon = "";
        category = "airway";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 2.5;
        allowedSelections[] = {"Head"};
        allowSelfTreatment = 0;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)));
        callbackSuccess = QFUNC(checkAirway);
    };

    class HeadTurn: CheckAirway {
        displayName = "Perform Head Turning";
        displayNameProgress = "Head Turning";
        icon = "";
        medicRequired = 0;
        treatmentTime = 5;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem),'')] == ''));
        callbackSuccess = QFUNC(performHeadTurn);
    };

    class HeadTiltChinLift: CheckAirway {
        displayName = "Perform Head Tilt-Chin Lift";
        displayNameProgress = "Tilting Head";
        icon = "";
        medicRequired = 0;
        treatmentTime = 4;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(_patient getVariable [ARR_2(QQGVAR(HeadTilt_State),false)]) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem),'')] == ''));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(setHeadTiltChinLift));
    };
    class CancelHeadTiltChinLift: HeadTiltChinLift {
        displayName = "Cancel Head Tilt-Chin Lift";
        displayNameProgress = "";
        icon = "";
        medicRequired = 0;
        treatmentTime = 0.01;
        condition = QUOTE(_patient getVariable [ARR_2(QQGVAR(HeadTilt_State),false)] && !(IN_RECOVERYPOSITION(_patient)));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(setHeadTiltChinLift));
    };

    class RecoveryPosition: CheckAirway {
        displayName = "Establish Recovery Position";
        displayNameProgress = "Establishing Recovery Position";
        icon = "";
        medicRequired = 0;
        treatmentTime = 8;
        allowedSelections[] = {"Body"};
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem),'')] == '') && !(IN_RECOVERYPOSITION(_patient)));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(setRecoveryPosition));
    };
    class CancelRecoveryPosition: RecoveryPosition {
        displayName = "Cancel Recovery Position";
        displayNameProgress = "Cancelling Recovery Position";
        icon = "";
        medicRequired = 0;
        treatmentTime = 1;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && IN_RECOVERYPOSITION(_patient));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(setRecoveryPosition));
    };

    class UseSuctionBag: CheckAirway {
        displayName = "Use Suction Bag";
        displayNameProgress = "Using Suction Bag";
        icon = "";
        medicRequired = 0;
        treatmentTime = QUOTE([_patient] call FUNC(getSuctionTime));
        items[] = {"AMS_SuctionBag"};
        consumeItem = 1;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,0)] call FUNC(handleSuction));
    };
    class UseAccuvac: UseSuctionBag {
        displayName = "Use Accuvac";
        displayNameProgress = "Using Accuvac";
        icon = "";
        medicRequired = 0;
        treatmentTime = QUOTE([_patient] call FUNC(getSuctionTime));
        items[] = {"AMS_Accuvac"};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,1)] call FUNC(handleSuction));
    };

    class InsertGuedelTube: CheckAirway {
        displayName = "Insert Guedel Tube";
        displayNameProgress = "Inserting Guedel Tube";
        icon = "";
        medicRequired = 0;
        treatmentTime = 4;
        items[] = {"AMS_GuedelTube"};
        consumeItem = 1;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem),'')] == ''));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,'OPA')] call FUNC(insertAirwayItem));
    };
    class InsertIGel: InsertGuedelTube {
        displayName = "Insert iGel";
        displayNameProgress = "Inserting iGel";
        icon = "";
        medicRequired = 0;
        treatmentTime = 8;
        items[] = {"AMS_IGel"};
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,'SGA')] call FUNC(insertAirwayItem));
    };

    class RemoveGuedelTube: CheckAirway {
        displayName = "Remove Guedel Tube";
        displayNameProgress = "Removing Guedel Tube";
        icon = "";
        medicRequired = 0;
        treatmentTime = 2;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem),'')] == 'OPA'));
        callbackSuccess = QFUNC(removeAirwayItem);
    };
    class RemoveIGel: RemoveGuedelTube {
        displayName = "Remove iGel";
        displayNameProgress = "Removing iGel";
        icon = "";
        medicRequired = 0;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem),'')] == 'SGA'));
    };
};
