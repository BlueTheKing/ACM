class ACM_CBRN_Hazards {
    class Chemical {
        class CS {
            thresholds[] = {0,50,100};
            absorption_rate = 0;
            inhalation_rate = 0.5;
            elimination_rate = -0.5;
        };

        class Chlorine {
            thresholds[] = {0,25,100};
        };

        class Sarin {
            thresholds[] = {0,25,50,75,100};
        };

        class Lewisite {
            thresholds[] = {0};
        };
    };
};