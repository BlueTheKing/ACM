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

    class GVAR(Eden_FullHealFacility): Module_F {
        scope = 2;
        displayName = CSTRING(FullHealFacility_Module);
        icon = QPATHTOF(ui\Icon_Module_FullHealFacility_ca.paa);
        portrait = QPATHTOF(ui\Icon_Module_FullHealFacility_ca.paa);
        category = QGVAR(Category_Mission);
        function = QFUNC(moduleInitFullHealFacility_Eden);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        author = AUTHOR;
        class Attributes: AttributesBase {
            class InteractionDistance: Edit {
                property = QGVAR(Eden_FullHealFacility_InteractionDistance);
                displayName = ECSTRING(core,Common_Module_InteractionDistance);
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class InteractionPosition: Edit {
                property = QGVAR(Eden_FullHealFacility_InteractionPosition);
                displayName = ECSTRING(core,Common_Module_InteractionPosition);
                tooltip = ECSTRING(core,Common_Module_InteractionPosition_Tooltip);
                typeName = "STRING";
                defaultValue = "[0,0,0]";
            };
        };
    };
};