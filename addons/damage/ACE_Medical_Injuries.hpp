class ACE_Medical_Injuries {
    class wounds {
        class ThermalBurn;
        class ChemicalBurn: ThermalBurn { // CBRN
            pain = 0.8;
        };
    };

    class damageTypes {
        class slap {
            thresholds[] = {{0.05, 1}, {0.05, 0}};
            selectionSpecific = 1;
            class Contusion {
                weighting[] = {{0.35, 0}, {0.35, 1}};
            };
        };
        class incision {
            thresholds[] = {{0.1, 1}, {0.1, 0}};
            selectionSpecific = 1;
            class Cut {
                weighting[] = {{0.1, 1}, {0.1, 0}};
            };
        };
        class lewisiteburn { // CBRN
            thresholds[] = {{0, 1}};
            selectionSpecific = 0;
            noBlood = 1;
            class ChemicalBurn {
                weighting[] = {{0, 1}};
            };
        };
    };
};
