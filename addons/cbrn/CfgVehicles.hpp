class CfgVehicles {
    class Module_F;

    class GVAR(moduleCreateHazardZone): Module_F {
        author = "Blue";
        displayName = "Create Hazard Zone";
        category = QGVAR(CBRN);
        function = QFUNC(moduleCreateHazardZone);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;
        curatorCanAttach = 1;
    };

    class B_TargetSoldier;
    class ACM_HazardOriginObject: B_TargetSoldier {
        author = "Blue";
        displayName = "Hazard Origin";
        scope = 1;
        scopeCurator = 1;
        scopeArsenal = 0;
        model = QCBAPATHTOF(ai,InvisibleTarget.p3d);
        icon = QPATHTOEF(core,ui\icon_patient_dead.paa);
    };
    class ACM_HazardHelperObject: ACM_HazardOriginObject {};

    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {
                class ACM_Action_GasMask {
                    displayName = CSTRING(GasMask);
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    icon = ""; // TODO
                    class ACM_Action_PutOnGasMask {
                        displayName = CSTRING(GasMask_PutOn);
                        condition = QUOTE([_player] call FUNC(canPutOnGasMask));
                        statement = QUOTE([_player] call FUNC(putOnGasMask));
                        showDisabled = 0;
                        exceptions[] = {"isNotInside", "isNotSitting"};
                    };
                    class ACM_Action_TakeOffGasMask {
                        displayName = CSTRING(GasMask_TakeOff);
                        condition = QUOTE([_player] call FUNC(canTakeOffGasMask));
                        statement = QUOTE([_player] call FUNC(takeOffGasMask));
                        showDisabled = 0;
                        exceptions[] = {"isNotInside", "isNotSitting"};
                    };
                    class ACM_Action_ReplaceGasMaskFilter {
                        displayName = CSTRING(GasMask_ReplaceFilter);
                        condition = QUOTE([_player] call FUNC(canReplaceFilter));
                        statement = QUOTE([_player] call FUNC(replaceFilter));
                        showDisabled = 0;
                        exceptions[] = {"isNotInside", "isNotSitting"};
                    };
                };
            };
        };
    };
};