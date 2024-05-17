class CfgVehicles {
    class Module_F;

    class GVAR(unCardiacArrest): Module_F {
        curatorCanAttach = 1;
        category = QGVAR(Modules);
        displayName = "Un-Cardiac Arrest";
        function = QFUNC(unCardiacArrest);
        icon = QACEPATHTOF(zeus,ui\Icon_Module_Zeus_Heal_ca.paa);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;
    };
    class GVAR(forceWakeUp): Module_F {
        displayName = "Force Wake-up";
        function = QFUNC(forceWakeUp);
        icon = QACEPATHTOF(zeus,ui\Icon_Module_Zeus_Heal_ca.paa);
    };
};
