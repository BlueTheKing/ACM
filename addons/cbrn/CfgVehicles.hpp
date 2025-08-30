class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Default;
            class Combo;
            class Edit;
            class Checkbox;
            class ModuleDescription;
        };
    };

    class GVAR(Eden_HazardZone): Module_F {
        scope = 2;
        displayName = CSTRING(Module_HazardZone);
        icon = QPATHTOF(ui\Icon_ChemicalHazard_ca.paa);
        category = QGVAR(CBRN);
        function = QFUNC(moduleCreateHazardZone_Eden);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        author = AUTHOR;
        class AttributeValues
		{
			size3[] = {5,5,2.5};
			isRectangle = 0;
		};
        class Attributes: AttributesBase {
            class HazardType: Combo {
                property = QGVAR(Eden_HazardZone_HazardType);
                displayName = CSTRING(Module_Generic_HazardType);
                typeName = "NUMBER";
                defaultValue = 0;
                class values {
                    class Chemical_Placebo {
                        name = CSTRING(Chemical_Placebo);
                        value = 0;
                    };
                    class Chemical_CS {
                        name = CSTRING(Chemical_CS);
                        value = 1;
                    };
                    class Chemical_Chlorine {
                        name = CSTRING(Chemical_Chlorine);
                        value = 2;
                    };
                    class Chemical_Sarin {
                        name = CSTRING(Chemical_Sarin);
                        value = 3;
                    };
                    class Chemical_Lewisite {
                        name = CSTRING(Chemical_Lewisite);
                        value = 4;
                    };
                };
            };
            class ZoneRadius: Edit {
                property = QGVAR(Eden_HazardZone_ZoneRadius);
                displayName = CSTRING(Module_Generic_ZoneRadius);
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class EffectTime: Edit {
                property = QGVAR(Eden_HazardZone_EffectTime);
                displayName = CSTRING(Module_Generic_EffectTime);
                tooltip = CSTRING(Module_Generic_EffectTime_Tooltip);
                typeName = "NUMBER";
                defaultValue = 0;
            };
            class AttachToObject: Checkbox {
                property = QGVAR(Eden_HazardZone_AttachToObject);
                displayName = CSTRING(Module_Generic_AttachToObject);
                tooltip = CSTRING(Module_Generic_AttachToObject_TooltipEden);
                typeName = "BOOL";
            };
            class ShowMist: Checkbox {
                property = QGVAR(Eden_HazardZone_ShowMist);
                displayName = CSTRING(Module_Generic_ShowMist);
                tooltip = CSTRING(Module_Generic_ShowMist_Tooltip);
                typeName = "BOOL";
                defaultValue = 1;
            };
            class AffectAI: Checkbox {
                property = QGVAR(Eden_HazardZone_AffectAI);
                displayName = CSTRING(Module_Generic_AffectAI);
                typeName = "BOOL";
                defaultValue = 1;
            };
        };
    };

    class GVAR(Eden_ChemicalDevice): Module_F {
        scope = 2;
        displayName = CSTRING(Module_ChemicalDevice);
        icon = QPATHTOF(ui\Icon_ChemicalHazard_ca.paa);
        category = QGVAR(CBRN);
        function = QFUNC(moduleCreateChemicalDevice_Eden);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        author = AUTHOR;
        class AttributeValues
		{
			size3[] = {5,5,2.5};
			isRectangle = 0;
		};
        class Attributes: AttributesBase {
            class HazardType: Combo {
                property = QGVAR(Eden_ChemicalDevice_HazardType);
                displayName = CSTRING(Module_Generic_HazardType);
                typeName = "NUMBER";
                defaultValue = 0;
                class values {
                    class Chemical_Chlorine {
                        name = CSTRING(Chemical_Chlorine);
                        value = 0;
                    };
                    class Chemical_Sarin {
                        name = CSTRING(Chemical_Sarin);
                        value = 1;
                    };
                    class Chemical_Lewisite {
                        name = CSTRING(Chemical_Lewisite);
                        value = 2;
                    };
                };
            };
            class ExplosionCloudSize: Combo {
                property = QGVAR(Eden_ChemicalDevice_ExplosionCloudSize);
                displayName = CSTRING(Module_CreateChemicalDevice_CloudSize);
                typeName = "NUMBER";
                defaultValue = 0;
                class values {
                    class CloudSize_None {
                        name = CSTRING(Module_CreateChemicalDevice_CloudSize_None);
                        value = 0;
                    };
                    class CloudSize_Small {
                        name = CSTRING(Module_CreateChemicalDevice_CloudSize_Small);
                        value = 1;
                    };
                    class CloudSize_Large {
                        name = CSTRING(Module_CreateChemicalDevice_CloudSize_Large);
                        value = 2;
                    };
                };
            };
            class ZoneRadius: Edit {
                property = QGVAR(Eden_ChemicalDevice_ZoneRadius);
                displayName = CSTRING(Module_Generic_ZoneRadius);
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class PermanentHazard: Checkbox {
                property = QGVAR(Eden_ChemicalDevice_PermanentHazard);
                displayName = CSTRING(Module_CreateChemicalDevice_PermanentHazard);
                tooltip = CSTRING(Module_CreateChemicalDevice_PermanentHazard_Tooltip);
                typeName = "BOOL";
                defaultValue = 0;
            };
            class AffectAI: Checkbox {
                property = QGVAR(Eden_ChemicalDevice_AffectAI);
                displayName = CSTRING(Module_Generic_AffectAI);
                typeName = "BOOL";
                defaultValue = 1;
            };
        };
    };

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
        class ACE_Actions {
            class ACM_Action_GasMask_Other {
                displayName = CSTRING(GasMask);
                icon = QPATHTOF(ui\Icon_Gasmask_ca.paa);
                exceptions[] = {"isNotInside","isNotSitting"};
                distance = 1.75;
                selection = "head";
                class ACM_Action_PutOnGasMask_Other {
                    displayName = CSTRING(GasMask_PutOn);
                    icon = QPATHTOF(ui\Icon_Gasmask_ca.paa);
                    condition = QUOTE(!(_target call ACEFUNC(common,isAwake)) && !([_target] call FUNC(isWearingGasMask)) && {([_target] call FUNC(hasGasMask) || [_player] call FUNC(hasGasMask))});
                    statement = QUOTE([ARR_2(_target,_player)] call FUNC(putOnGasMask));
                    exceptions[] = {"isNotInside","isNotSitting"};
                    showDisabled = 0;
                };
                class ACM_Action_TakeOffGasMask_Other: ACM_Action_PutOnGasMask_Other {
                    displayName = CSTRING(GasMask_TakeOff);
                    condition = QUOTE([_target] call FUNC(canTakeOffGasMask));
                    statement = QUOTE([ARR_2(_target,_player)] call FUNC(takeOffGasMask));
                };
                class ACM_Action_ReplaceGasMaskFilter_Other: ACM_Action_PutOnGasMask_Other {
                    displayName = CSTRING(GasMask_ReplaceFilter);
                    condition = QUOTE([_target] call FUNC(isWearingGasMask) && {([_target] call FUNC(hasFilter) || [_player] call FUNC(hasFilter))});
                    statement = QUOTE([_player] call FUNC(replaceFilter));
                };
            };
        };
        class ACE_SelfActions {
            class ACE_Equipment {
                class ACM_Action_GasMask {
                    displayName = CSTRING(GasMask);
                    icon = QPATHTOF(ui\Icon_Gasmask_ca.paa);
                    exceptions[] = {"isNotInside","isNotSitting"};
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