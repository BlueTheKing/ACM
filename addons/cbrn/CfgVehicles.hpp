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
        scope = 2;
        scopeCurator = 2;
        scopeArsenal = 0;
        model = QCBAPATHTOF(ai,InvisibleTarget.p3d);
        //icon = ""
    };
    class ACM_HazardHelperObject: ACM_HazardOriginObject {};
};