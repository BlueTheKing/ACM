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
                    exceptions[] = {"isNotInside","isNotSitting"};
                    icon = QPATHTOF(ui\Icon_Gasmask_ca.paa);
                    class ACM_Action_PutOnGasMask {
                        displayName = CSTRING(GasMask_PutOn);
                        condition = QUOTE([_player] call FUNC(canPutOnGasMask));
                        statement = QUOTE([_player] call FUNC(putOnGasMask));
                        showDisabled = 0;
                        exceptions[] = {"isNotInside","isNotSitting"};
                    };
                    class ACM_Action_TakeOffGasMask: ACM_Action_PutOnGasMask {
                        displayName = CSTRING(GasMask_TakeOff);
                        condition = QUOTE([_player] call FUNC(canTakeOffGasMask));
                        statement = QUOTE([_player] call FUNC(takeOffGasMask));
                    };
                    class ACM_Action_ReplaceGasMaskFilter: ACM_Action_PutOnGasMask {
                        displayName = CSTRING(GasMask_ReplaceFilter);
                        condition = QUOTE([_player] call FUNC(canReplaceFilter));
                        statement = QUOTE([_player] call FUNC(replaceFilter));
                    };
                };
                class ACM_Action_ChemicalDetector {
                    displayName = CSTRING(ChemicalDetector);
                    condition = QUOTE((_player getSlotItemName 610) == 'ChemicalDetector_01_watch_F');
                    exceptions[] = {"isNotInside","isNotSitting"};
                    icon = "";
                    class ACM_Action_TurnOnDetector {
                        displayName = CSTRING(ChemicalDetector_TurnOn);
                        condition = QUOTE(!(_player getVariable [ARR_2(QQGVAR(Detector_State),false)]));
                        statement = QUOTE([ARR_2(_player,true)] call FUNC(detector_toggle));
                        showDisabled = 0;
                        exceptions[] = {"isNotInside","isNotSitting"};
                    };
                    class ACM_Action_TurnOffDetector: ACM_Action_TurnOnDetector {
                        displayName = CSTRING(ChemicalDetector_TurnOff);
                        condition = QUOTE(_player getVariable [ARR_2(QQGVAR(Detector_State),false)]);
                        statement = QUOTE([ARR_2(_player,false)] call FUNC(detector_toggle));
                    };
                    class ACM_Action_EnableDetectorAlarm: ACM_Action_TurnOnDetector {
                        displayName = CSTRING(ChemicalDetector_EnableAlarm);
                        condition = QUOTE(!(_player getVariable [ARR_2(QQGVAR(Detector_Alarm_State),false)]));
                        statement = QUOTE([ARR_2(_player,true)] call FUNC(detector_setAlarm));
                    };
                    class ACM_Action_DisableDetectorAlarm: ACM_Action_TurnOnDetector {
                        displayName = CSTRING(ChemicalDetector_DisableAlarm);
                        condition = QUOTE(_player getVariable [ARR_2(QQGVAR(Detector_Alarm_State),false)]);
                        statement = QUOTE([ARR_2(_player,false)] call FUNC(detector_setAlarm));
                    };
                    class ACM_Action_ResetDetector: ACM_Action_TurnOnDetector {
                        displayName = CSTRING(ChemicalDetector_Reset);
                        condition = QUOTE(_player getVariable [ARR_2(QQGVAR(Detector_State),false)]);
                        statement = QUOTE([_player] call FUNC(detector_reset));
                    };
                };
            };
        };
    };
};