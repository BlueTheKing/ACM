class ACEGVAR(medical_treatment,actions) {
    class CheckPulse;
    class CheckAirway: CheckPulse {
        displayName = CSTRING(CheckAirway);
        displayNameProgress = CSTRING(CheckAirway_Progress);
        icon = "";
        category = "airway";
        treatmentLocations = TREATMENT_LOCATIONS_ALL;
        medicRequired = 0;
        treatmentTime = 2.5;
        allowedSelections[] = {"Head"};
        allowSelfTreatment = 0;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QFUNC(checkAirway);
        ACM_rollToBack = 1;
    };

    class HeadTurn: CheckAirway {
        displayName = CSTRING(PerformHeadTurning);
        displayNameProgress = CSTRING(PerformHeadTurning_Progress);
        icon = "";
        medicRequired = 0;
        treatmentTime = 5;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Oral),'')] == '') && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Nasal),'')] == '') && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QFUNC(performHeadTurn);
        ACM_cancelRecovery = 1;
    };

    class BeginHeadTiltChinLift: CheckAirway {
        displayName = CSTRING(PerformHeadTiltChinLift);
        displayNameProgress = "";
        icon = "";
        medicRequired = 0;
        treatmentTime = 0.001;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(_patient getVariable [ARR_2(QQGVAR(HeadTilt_State),false)]) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Oral),'')] != 'SGA'));
        callbackSuccess = QUOTE([ARR_2(_medic,_patient)] call FUNC(beginHeadTiltChinLift));
        ACM_cancelRecovery = 1;
    };

    class RecoveryPosition: CheckAirway {
        displayName = CSTRING(EstablishRecoveryPosition);
        displayNameProgress = CSTRING(EstablishRecoveryPosition_Progress);
        icon = "";
        medicRequired = 0;
        treatmentTime = QGVAR(treatmentTimeRecoveryPosition);
        allowedSelections[] = {"Body"};
        condition = QUOTE(!([_patient] call EFUNC(core,cprActive)) && !(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Oral),'')] == '') && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Nasal),'')] == '') && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])) && !(IN_RECOVERYPOSITION(_patient)) && (isNull objectParent _patient));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(setRecoveryPosition));
        ACM_rollToBack = 0;
    };
    class CancelRecoveryPosition: RecoveryPosition {
        displayName = CSTRING(CancelRecoveryPosition);
        displayNameProgress = CSTRING(CancelRecoveryPosition_Progress);
        icon = "";
        medicRequired = 0;
        treatmentTime = 1;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && IN_RECOVERYPOSITION(_patient));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(setRecoveryPosition));
        ACM_rollToBack = 1;
        ACM_cancelRecovery = 1;
    };

    class UseSuctionBag: CheckAirway {
        displayName = CSTRING(UseSuctionBag);
        displayNameProgress = CSTRING(UseSuctionBag_Progress);
        icon = "";
        medicRequired = QGVAR(allowSuctionBag);
        treatmentTime = QUOTE([_patient] call FUNC(getSuctionTime));
        items[] = {"ACM_SuctionBag"};
        consumeItem = 1;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,0)] call FUNC(handleSuction));
        ACM_cancelRecovery = 1;
    };
    class UseAccuvac: UseSuctionBag {
        displayName = CSTRING(UseACCUVAC);
        displayNameProgress = CSTRING(UseACCUVAC_Progress);
        icon = "";
        medicRequired = QGVAR(allowACCUVAC);
        treatmentTime = QUOTE([_patient] call FUNC(getSuctionTime));
        items[] = {"ACM_ACCUVAC"};
        consumeItem = 0;
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,1)] call FUNC(handleSuction));
    };

    class InsertGuedelTube: CheckAirway {
        displayName = CSTRING(InsertGuedelTube);
        displayNameProgress = CSTRING(InsertGuedelTube_Progress);
        icon = "";
        medicRequired = QGVAR(allowOPA);
        treatmentTime = QGVAR(treatmentTimeOPA);
        items[] = {"ACM_GuedelTube","ACM_GuedelTube_Used"};
        consumeItem = 1;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Oral),'')] == '') && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,'OPA')] call FUNC(insertAirwayItem));
        ACM_cancelRecovery = 1;
    };
    class InsertNPA: InsertGuedelTube {
        displayName = CSTRING(InsertNPA);
        displayNameProgress = CSTRING(InsertNPA_Progress);
        icon = "";
        medicRequired = QGVAR(allowNPA);
        treatmentTime = QGVAR(treatmentTimeNPA);
        items[] = {"ACM_NPA","ACM_NPA_Used"};
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Nasal),'')] == '') && !(alive (_patient getVariable [ARR_2(QQEGVAR(breathing,BVM_Medic),objNull)])));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,'NPA')] call FUNC(insertAirwayItem));
    };
    class InsertIGel: InsertGuedelTube {
        displayName = CSTRING(InsertIGel);
        displayNameProgress = CSTRING(InsertIGel_Progress);
        icon = "";
        medicRequired = QGVAR(allowSGA);
        treatmentTime = QGVAR(treatmentTimeSGA);
        items[] = {"ACM_IGel","ACM_IGel_Used"};
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,'SGA')] call FUNC(insertAirwayItem));
    };

    class RemoveGuedelTube: CheckAirway {
        displayName = CSTRING(RemoveGuedelTube);
        displayNameProgress = CSTRING(RemoveGuedelTube_Progress);
        icon = "";
        medicRequired = 0;
        treatmentTime = 1.5;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Oral),'')] == 'OPA'));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,false)] call FUNC(removeAirwayItem));
    };
    class RemoveNPA: RemoveGuedelTube {
        displayName = CSTRING(RemoveNPA);
        displayNameProgress = CSTRING(RemoveNPA_Progress);
        icon = "";
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Nasal),'')] == 'NPA'));
        callbackSuccess = QUOTE([ARR_3(_medic,_patient,true)] call FUNC(removeAirwayItem));
    };
    class RemoveIGel: RemoveGuedelTube {
        displayName = CSTRING(RemoveIGel);
        displayNameProgress = CSTRING(RemoveIGel_Progress);
        icon = "";
        treatmentTime = 2;
        condition = QUOTE(!(_patient call ACEFUNC(common,isAwake)) && (_patient getVariable [ARR_2(QQGVAR(AirwayItem_Oral),'')] == 'SGA'));
    };
};
