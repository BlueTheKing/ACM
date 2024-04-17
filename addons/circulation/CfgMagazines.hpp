class CfgMagazines {
    class CA_Magazine;

    class ACM_Paracetamol: CA_Magazine {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\paracetamol_ca.paa);
        displayName = "Paracetamol";
        descriptionShort = "Used to combat mild to moderate pain";
        descriptionUse = "Package of pills used to combat mild to moderate pain";
        ACE_isMedicalItem = 1;
        ACE_asItem = 1;
        count = 10;
        mass = 0.3;
    };

    class ACM_AmmoniumCarbonate: ACM_Paracetamol {
        picture = QPATHTOF(ui\ammoniumcarbonate_ca.paa);
        displayName = "Ammonium Carbonate";
        descriptionShort = "Used to wake up patients who've fainted";
        descriptionUse = "Also known as, smelling salts, inhalant used to wake up unconscious patients by triggering the inhalation reflex";
        count = 8;
    };

    class ACM_Inhaler_Penthrox: ACM_Paracetamol {
        picture = QPATHTOF(ui\inhaler_penthrox_ca.paa);
        displayName = "Penthrox Inhaler";
        descriptionShort = "Used to rapidly manage acute pain for a short time";
        descriptionUse = "Potent inhalant medication used to manage acute pain, due to the short action time it is best used in advance of painful procedures";
        count = 8;
    };
};