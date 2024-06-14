class CfgMagazines {
    class CA_Magazine;

    class ACM_OxygenTank_425: CA_Magazine {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\oxygenTank_ca.paa);
        displayName = "Portable Oxygen Tank (425L)";
        descriptionShort = "Used with BVM to provide supplementary oxygen to patients";
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 283;
        mass = 20;
    };
};