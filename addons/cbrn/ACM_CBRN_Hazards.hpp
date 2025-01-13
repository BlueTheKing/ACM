class ACM_CBRN_Hazards {
    class Chemical {
        class CS {
            thresholds[] = {0,50,100};
            threshold_rate[] = {1,0.5};
            absorption_rate = 1;
            inhalation_rate = 0.5;
            elimination_rate = -0.5;
            thresholdFunction = QFUNC(effectCS);
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