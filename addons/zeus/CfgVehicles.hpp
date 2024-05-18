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
    class GVAR(patientState): GVAR(moduleBase) {
        displayName = "Set Patient State";
        icon = QACEPATHTOF(zeus,ui\Icon_Module_Zeus_Heal_ca.paa);
        curatorInfoType = QGVAR(RscPatientState);
    };
};
