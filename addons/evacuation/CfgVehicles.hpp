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

    class GVAR(EvacuationPoint): Module_F {
        scope = 2;
        displayName = CSTRING(Module_EvacuationPoint);
        icon = QPATHTOF(ui\Icon_Evacuation_ca.paa);
        portrait = QPATHTOF(ui\Icon_Evacuation_ca.paa);
        category = QGVAR(Category_Evacuation);
        function = QFUNC(moduleCreateEvacuationPoint);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        author = AUTHOR;
        class Attributes: AttributesBase {
            class Side: Combo {
                property = QGVAR(Eden_EvacuationPoint_Side);
                displayName = CSTRING(Module_PlayerFaction);
                typeName = "NUMBER";
                defaultValue = 0;
                class values {
                    class Side_BLUFOR {
                        name = "BLUFOR";
                        value = 0;
                    };
                    class Side_REDFOR {
                        name = "REDFOR";
                        value = 1;
                    };
                    class Side_GREENFOR {
                        name = "GREENFOR";
                        value = 2;
                    };
                };
            };
            class InteractionDistance: Edit {
                property = QGVAR(Eden_EvacuationPoint_InteractionDistance);
                displayName = ECSTRING(core,Common_Module_InteractionDistance);
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class InteractionPosition: Edit {
                property = QGVAR(Eden_EvacuationPoint_InteractionPosition);
                displayName = ECSTRING(core,Common_Module_InteractionPosition);
                tooltip = ECSTRING(core,Common_Module_InteractionPosition_Tooltip);
                typeName = "STRING";
                defaultValue = "[0,0,0]";
            };
        };
    };

    class GVAR(ReinforcePoint): Module_F {
        scope = 2;
        displayName = CSTRING(Module_ReinforcePoint);
        icon = QPATHTOF(ui\Icon_Evacuation_ca.paa);
        portrait = QPATHTOF(ui\Icon_Evacuation_ca.paa);
        category = QGVAR(Category_Evacuation);
        function = QFUNC(moduleCreateReinforcePoint);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        author = AUTHOR;
        class Attributes: AttributesBase {
            class Side: Combo {
                property = QGVAR(Eden_ReinforcePoint_Side);
                displayName = CSTRING(Module_PlayerFaction);
                typeName = "NUMBER";
                defaultValue = 0;
                class values {
                    class Side_BLUFOR {
                        name = "BLUFOR";
                        value = 0;
                    };
                    class Side_REDFOR {
                        name = "REDFOR";
                        value = 1;
                    };
                    class Side_GREENFOR {
                        name = "GREENFOR";
                        value = 2;
                    };
                };
            };
        };
    };

    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_ConvertCasualty {
                    displayName = CSTRING(ConvertCasualty);
                    icon = "";
                    condition = QUOTE([ARR_2(_player,_target)] call FUNC(canConvert));
                    statement = QUOTE([ARR_2(_player,_target)] call FUNC(convertCasualtyAction));
                    exceptions[] = {"isNotInside"};
                    showDisabled = 0;
                };
            };
        };
    };
};