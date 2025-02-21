class CfgVehicles {
    class Module_F;

    class GVAR(moduleBase): Module_F {
        curatorCanAttach = 1;
        category = QGVAR(CBRN);
        displayName = "Module";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;
        author = AUTHOR;
    };

    class GVAR(moduleCreateHazardZone): GVAR(moduleBase) {
        displayName = CSTRING(Module_CreateHazardZone);
        icon = QPATHTOF(ui\Icon_ChemicalHazard_ca.paa);
        curatorInfoType = QGVAR(RscCreateHazardZone);
    };
    class GVAR(moduleCreateChemicalDevice): GVAR(moduleBase) {
        displayName = CSTRING(Module_CreateChemicalDevice);
        icon = QPATHTOF(ui\Icon_ChemicalHazard_ca.paa);
        curatorInfoType = QGVAR(RscCreateChemicalDevice);
    };

    class ACE_LogicDummy;
    class ACM_HazardObject: ACE_LogicDummy {
        author = AUTHOR;
        displayName = "Hazard Origin";
        scopeCurator = 1;
        scopeArsenal = 0;
        model = QCBAPATHTOF(ai,InvisibleTarget.p3d);
        icon = QPATHTOF(ui\Icon_ChemicalHazard_ca.paa);
    };

    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {
                class ACM_Action_GasMask {
                    displayName = CSTRING(GasMask);
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    icon = QPATHTOF(ui\Icon_Gasmask_ca.paa);
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