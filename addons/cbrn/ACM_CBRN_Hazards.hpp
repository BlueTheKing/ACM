class ACM_CBRN_Hazards {
    class Chemical {
        class CS {
            thresholds[] = {0,50};
            threshold_positiveRate[] = {1,0.5};
            threshold_negativeRate[] = {1,1};
            absorption_rate = 1;
            inhalation_rate = 0.5;
            elimination_rate = -0.5;
            thresholdFunction = QFUNC(effectCS);
        };

        class Chlorine {
            thresholds[] = {0,25};
        };

        class Sarin {
            thresholds[] = {0,25,50,75};
        };

        class Lewisite {
            thresholds[] = {0};
        };
    };
};