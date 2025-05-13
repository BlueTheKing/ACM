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
            absorbant_skin = 0;
        };

        class Chlorine {
            thresholds[] = {0,25,50,70};
            threshold_positiveRate[] = {1,1,1,0.5};
            threshold_negativeRate[] = {1,0.5,0.3,0.2};
            absorption_rate = 0.35;
            inhalation_rate = 1;
            elimination_rate = -0.25;
            thresholdFunction = QFUNC(effectChlorine);
        };

        class Sarin {
            thresholds[] = {0,25,50,70};
            threshold_positiveRate[] = {1,1,1,0.5};
            threshold_negativeRate[] = {1,0.5,0.25,0.1};
            absorption_rate = 0.5;
            inhalation_rate = 1.5;
            elimination_rate = -0.15;
            thresholdFunction = QFUNC(effectSarin);
        };

        class Lewisite {
            thresholds[] = {0,25,70};
            threshold_positiveRate[] = {1,1,0.5};
            threshold_negativeRate[] = {1,0.5,0.3};
            absorption_rate = 1.5;
            inhalation_rate = 1;
            elimination_rate = -0.15;
            thresholdFunction = QFUNC(effectLewisite);
        };
    };
};