class ACM_Medication {
    maxDoseDeviation = 1;
    administrationType = ACM_ROUTE_IM;
    rrAdjust[] = {0,0};
    coSensitivityAdjust[] = {0,0};
    breathingEffectivenessAdjust[] = {0,0};
    maxEffectTime = 120;
    onOverDose = "";

    class ACM_PO_Medication {
        painReduce = 0;
        hrIncreaseLow[] = {0, 0};
        hrIncreaseNormal[] = {0, 0};
        hrIncreaseHigh[] = {0, 0};
        timeInSystem = 1200;
        timeTillMaxEffect = 120;
        maxEffectTime = 600;
        maxDose = 0;
        maxDoseDeviation = 0;
        incompatibleMedication[] = {};
        administrationType = ACM_ROUTE_PO;
        viscosityChange = 0;
    };

    class Paracetamol: ACM_PO_Medication {
        painReduce = 0.4;
    };

    class ACM_Inhalant_Medication {
        painReduce = 0;
        hrIncreaseLow[] = {0, 0};
        hrIncreaseNormal[] = {0, 0};
        hrIncreaseHigh[] = {0, 0};
        timeInSystem = 40;
        timeTillMaxEffect = 3;
        maxEffectTime = 6;
        maxDose = 0;
        maxDoseDeviation = 0;
        incompatibleMedication[] = {};
        administrationType = ACM_ROUTE_INHALE;
        viscosityChange = 0;
    };

    class AmmoniaInhalant: ACM_Inhalant_Medication {
        hrIncreaseLow[] = {3, 8};
        hrIncreaseNormal[] = {3, 18};
        hrIncreaseHigh[] = {3, 12};
        rrAdjust[] = {1,3};
    };

    class Penthrox: ACM_Inhalant_Medication {
        painReduce = 0.75;
        hrIncreaseLow[] = {-1, -2};
        hrIncreaseNormal[] = {-1, -3};
        hrIncreaseHigh[] = {-1, -4};
        timeInSystem = 425;
        maxEffectTime = 80;
        maxDose = 5;
        maxDoseDeviation = 1;
        breathingEffectivenessAdjust[] = {-0.001,-0.01};
    };

    class Naloxone: ACM_Inhalant_Medication {
        timeInSystem = 360;
        maxEffectTime = 120;
    };

    class ACM_IV_Medication {
        painReduce = 0;
        hrIncreaseLow[] = {0, 0};
        hrIncreaseNormal[] = {0, 0};
        hrIncreaseHigh[] = {0, 0};
        timeInSystem = 300;
        timeTillMaxEffect = 5;
        maxEffectTime = 90;
        maxDose = 0;
        maxDoseDeviation = 0;
        incompatibleMedication[] = {};
        administrationType = ACM_ROUTE_IV;
        viscosityChange = 0;
    };

    class Epinephrine_IV: ACM_IV_Medication {
        hrIncreaseLow[] = {25, 35};
        hrIncreaseNormal[] = {25, 55};
        hrIncreaseHigh[] = {25, 45};
        rrAdjust[] = {6,12};
        breathingEffectivenessAdjust[] = {0.01,0.04};
    };

    class Adenosine_IV: ACM_IV_Medication {
        hrIncreaseLow[] = {-10, -15};
        hrIncreaseNormal[] = {-10, -40};
        hrIncreaseHigh[] = {-10, -30};
    };

    class Morphine_IV: ACM_IV_Medication {
        painReduce = 0.85;
        hrIncreaseLow[] = {-9, -18};
        hrIncreaseNormal[] = {-9, -24};
        hrIncreaseHigh[] = {-9, -30};
        timeInSystem = 600;
        coSensitivityAdjust[] = {-0.035,-0.04};
        maxDose = 1;
        maxDoseDeviation = 0;
    };

    class Amiodarone_IV: ACM_IV_Medication {
        hrIncreaseLow[] = {-1, -2};
        hrIncreaseNormal[] = {-3, -5};
        hrIncreaseHigh[] = {-10, -15};
    };

    class TXA_IV: ACM_IV_Medication {
        hrIncreaseLow[] = {-1, -1};
        hrIncreaseNormal[] = {-1, -1};
        hrIncreaseHigh[] = {-2, -4};
        viscosityChange = 5;
    };

    class Ketamine_IV: ACM_IV_Medication {
        painReduce = 0.85;
        hrIncreaseLow[] = {-1, -2};
        hrIncreaseNormal[] = {-1, -2};
        hrIncreaseHigh[] = {-1, -2};
        maxDose = 2;
        maxDoseDeviation = 0;
    };

    class ACM_IM_Medication {
        painReduce = 0;
        hrIncreaseLow[] = {0, 0};
        hrIncreaseNormal[] = {0, 0};
        hrIncreaseHigh[] = {0, 0};
        timeInSystem = 600;
        timeTillMaxEffect = 30;
        maxEffectTime = 120;
        maxDose = 0;
        maxDoseDeviation = 0;
        incompatibleMedication[] = {};
        administrationType = ACM_ROUTE_IM;
        viscosityChange = 0;
    };

    class Morphine: ACM_IM_Medication {
        painReduce = 0.7;
        hrIncreaseLow[] = {-8, -16};
        hrIncreaseNormal[] = {-8, -18};
        hrIncreaseHigh[] = {-8, -24};
        timeInSystem = 1000;
        coSensitivityAdjust[] = {-0.03,-0.035};
        maxDose = 2;
        maxDoseDeviation = 0;
    };
    class Epinephrine: ACM_IM_Medication {
        painReduce = 0;
        hrIncreaseLow[] = {8, 16};
        hrIncreaseNormal[] = {8, 34};
        hrIncreaseHigh[] = {8, 26};
        timeInSystem = 500;
        rrAdjust[] = {4,8};
        breathingEffectivenessAdjust[] = {0,0.02};
    };

    class Adenosine: ACM_IM_Medication {
        hrIncreaseLow[] = {-7, -10};
        hrIncreaseNormal[] = {-15, -30};
        hrIncreaseHigh[] = {-15, -35};
    };

    class Lidocaine: ACM_IM_Medication {
        timeTillMaxEffect = 20;
        timeInSystem = 400;
        maxDose = 3;
        maxDoseDeviation = 1;
    };

    class Ketamine: ACM_IM_Medication {
        painReduce = 0.7;
        hrIncreaseLow[] = {-1, -1};
        hrIncreaseNormal[] = {-1, -1};
        hrIncreaseHigh[] = {-1, -1};
        rrAdjust[] = {0,0};
        maxDose = 2;
        maxDoseDeviation = 1;
    };
};