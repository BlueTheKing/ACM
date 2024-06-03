class CfgVehicles {
    class Module_F;

    class GVAR(moduleBase): Module_F {
        curatorCanAttach = 1;
        category = QGVAR(Modules);
        displayName = "Module";
        icon = QACEPATHTOF(zeus,ui\Icon_Module_Zeus_Heal_ca.paa);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;
    };

    class GVAR(unCardiacArrest): GVAR(moduleBase) {
        displayName = "Un-Cardiac Arrest";
        function = QFUNC(unCardiacArrest);
    };
    class GVAR(forceWakeUp): GVAR(moduleBase) {
        displayName = "Force Wake-up";
        function = QFUNC(forceWakeUp);
        icon = QACEPATHTOF(zeus,ui\Icon_Module_Zeus_Heal_ca.paa);
    };
    class GVAR(setBloodVolume): GVAR(moduleBase) {
        displayName = "Set Blood Volume";
        icon = QPATHTOF(ui\Icon_Module_BloodVolume_ca.paa);
        curatorInfoType = QGVAR(RscSetBloodVolume);
    };
    class GVAR(inflictChestInjury): GVAR(moduleBase) {
        displayName = "Inflict Chest Injury";
        icon = QPATHTOF(ui\Icon_Module_ChestInjury_ca.paa);
        curatorInfoType = QGVAR(RscInflictChestInjury);
    };
    class GVAR(givePain): GVAR(moduleBase) {
        displayName = "Give Pain";
        icon = QPATHTOF(ui\Icon_Module_GivePain_ca.paa);
        curatorInfoType = QGVAR(RscGivePain);
    };
};
