class CfgVehicles {
    class Bag_Base;
    class B_CivilianBackpack_01_Base_F;
    class ACM_Corpuls_CPR: B_CivilianBackpack_01_Base_F {
        author = "Miss Heda";
        scope = 2;
        displayName = "Corpuls CPR"; // IDK if you want a string here, name stays the same across diffrent languages.
        picture = QPATHTOF(ui\corpuls_cpr\corpuls_cpr_ui.paa);
        hiddenSelectionsTextures[] = {
            QPATHTOF(ui\corpuls_cpr\corpuls_cpr_model.paa)
        };
        maximumLoad = 0;
        mass = 140; // RL Corpuls weights 6.3Kg
    };
};