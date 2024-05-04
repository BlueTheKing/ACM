class ACE_Medical_Injuries {
    class damageTypes {
        class slap {
            thresholds[] = {{0.05, 1}, {0.05, 0}};
            selectionSpecific = 1;
            class Contusion {
                weighting[] = {{0.35, 0}, {0.35, 1}};
            };
        };
    };
};
