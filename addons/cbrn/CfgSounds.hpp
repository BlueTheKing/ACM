class CfgSounds {
    class ACM_CBRN_Cough_1 {
        name = "ACM_CBRN_Cough_1";
        sound[] = {QPATHTO_R(sound\cough1.wav), "db+16", 1};
        titles[] = {};
    };
    class ACM_CBRN_Cough_2: ACM_CBRN_Cough_1 {
        name = "ACM_CBRN_Cough_2";
        sound[] = {QPATHTO_R(sound\cough2.wav), "db+16", 1};
    };
    class ACM_CBRN_Cough_3: ACM_CBRN_Cough_1 {
        name = "ACM_CBRN_Cough_3";
        sound[] = {QPATHTO_R(sound\cough3.wav), "db+16", 1};
    };
    class ACM_CBRN_Cough_4: ACM_CBRN_Cough_1 {
        name = "ACM_CBRN_Cough_4";
        sound[] = {QPATHTO_R(sound\cough3.wav), "db+16", 1};
    };
    class ACM_CBRN_Inhale_1: ACM_CBRN_Cough_1 {
        name = "ACM_CBRN_Inhale_1";
        sound[] = {QPATHTO_R(sound\inhale1.wav), "db+16", 1};
    };
    class ACM_CBRN_Inhale_2: ACM_CBRN_Cough_1 {
        name = "ACM_CBRN_Inhale_2";
        sound[] = {QPATHTO_R(sound\inhale2.wav), "db+16", 1};
    };
};
