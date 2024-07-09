class ACM_Medication {
    class Medications {
        maxDoseDeviation = 1;
        administrationType = ACM_ROUTE_IM;
        medicationType = "Default";
        rrAdjust[] = {0,0};
        coSensitivityAdjust[] = {0,0};
        breathingEffectivenessAdjust[] = {0,0};
        maxEffectTime = 120;
        onOverDose = "";
        maxEffectDose = 1; // mg
        weightEffect = 0;
        maxPainReduce = 1;

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
            medicationType = "Default";
            maxPainReduce = 1;
            viscosityChange = 0;
            weightEffect = 1;
        };

        class Paracetamol: ACM_PO_Medication {
            painReduce = 0.4;
            maxPainReduce = 0.5;
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
            medicationType = "Default";
            maxPainReduce = 1;
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
            maxPainReduce = 0.9;
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
            medicationType = "Default";
            maxPainReduce = 1;
            viscosityChange = 0;
            weightEffect = 1;
        };

        class Epinephrine_IV: ACM_IV_Medication {
            medicationType = "Epinephrine";
            hrIncreaseLow[] = {25, 35};
            hrIncreaseNormal[] = {25, 55};
            hrIncreaseHigh[] = {25, 45};
            rrAdjust[] = {6,12};
            breathingEffectivenessAdjust[] = {0.01,0.04};
            maxEffectDose = 1;
        };

        class Adenosine_IV: ACM_IV_Medication {
            medicationType = "Adenosine";
            hrIncreaseLow[] = {-10, -15};
            hrIncreaseNormal[] = {-10, -40};
            hrIncreaseHigh[] = {-10, -30};
            maxEffectDose = 6;
        };

        class Morphine_IV: ACM_IV_Medication {
            medicationType = "Opioid";
            painReduce = 0.85;
            maxPainReduce = 1;
            hrIncreaseLow[] = {-9, -18};
            hrIncreaseNormal[] = {-9, -24};
            hrIncreaseHigh[] = {-9, -30};
            timeInSystem = 600;
            coSensitivityAdjust[] = {-0.035,-0.04};
            maxDose = 1;
            maxDoseDeviation = 0;
            maxEffectDose = 5;
        };

        class Amiodarone_IV: ACM_IV_Medication {
            medicationType = "Amiodarone";
            hrIncreaseLow[] = {-1, -2};
            hrIncreaseNormal[] = {-3, -5};
            hrIncreaseHigh[] = {-10, -15};
            maxEffectDose = 150;
        };

        class TXA_IV: ACM_IV_Medication {
            medicationType = "TXA";
            hrIncreaseLow[] = {-1, -1};
            hrIncreaseNormal[] = {-1, -1};
            hrIncreaseHigh[] = {-2, -4};
            timeInSystem = 600;
            maxEffectTime = 300;
            viscosityChange = 5;
            weightEffect = 0;
        };

        class Ketamine_IV: ACM_IV_Medication {
            medicationType = "Ketamine";
            painReduce = 0.85;
            maxPainReduce = 1;
            hrIncreaseLow[] = {-1, -2};
            hrIncreaseNormal[] = {-1, -2};
            hrIncreaseHigh[] = {-1, -2};
            maxDose = 2;
            maxDoseDeviation = 0;
            maxEffectDose = 20;
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
            medicationType = "Default";
            maxPainReduce = 1;
            viscosityChange = 0;
            weightEffect = 1;
        };

        class Morphine: ACM_IM_Medication {
            medicationType = "Opioid";
            painReduce = 0.7;
            maxPainReduce = 0.95;
            hrIncreaseLow[] = {-8, -16};
            hrIncreaseNormal[] = {-8, -18};
            hrIncreaseHigh[] = {-8, -24};
            timeInSystem = 1000;
            coSensitivityAdjust[] = {-0.03,-0.035};
            maxDose = 2;
            maxDoseDeviation = 0;
            maxEffectDose = 10;
        };
        class Epinephrine: ACM_IM_Medication { // EpiPen
            medicationType = "Epinephrine";
            painReduce = 0;
            hrIncreaseLow[] = {8, 16};
            hrIncreaseNormal[] = {8, 34};
            hrIncreaseHigh[] = {8, 26};
            timeInSystem = 500;
            rrAdjust[] = {3,6};
            breathingEffectivenessAdjust[] = {0,0.01};
            maxEffectDose = 1;
        };

        class Adenosine: ACM_IM_Medication { // Doesn't exist
            medicationType = "Adenosine";
            hrIncreaseLow[] = {-7, -10};
            hrIncreaseNormal[] = {-15, -30};
            hrIncreaseHigh[] = {-15, -35};
        };

        class Lidocaine: ACM_IM_Medication {
            timeTillMaxEffect = 20;
            timeInSystem = 400;
            maxDose = 3;
            maxDoseDeviation = 1;
            maxEffectDose = 70;
        };

        class Ketamine: ACM_IM_Medication {
            medicationType = "Ketamine";
            painReduce = 0.7;
            maxPainReduce = 0.95;
            hrIncreaseLow[] = {-1, -1};
            hrIncreaseNormal[] = {-1, -1};
            hrIncreaseHigh[] = {-1, -1};
            rrAdjust[] = {0,0};
            maxDose = 2;
            maxDoseDeviation = 1;
            maxEffectDose = 50;
        };
    };
    class MedicationType {
        class Default {};
        class Adenosine {
            classnames[] = {"Adenosine_IV", "Adenosine"};
        };
        class Epinephrine {
            classnames[] = {"Epinephrine_IV", "Epinephrine"};
        };
        class Opioid {
            classnames[] = {"Morphine_IV", "Morphine"};
        };
        class Ketamine {
            classnames[] = {"Ketamine_IV", "Ketamine"};
        };
        class TXA {
            classnames[] = {"TXA_IV"};
        };
        class Amiodarone {
            classnames[] = {"Amiodarone_IV"};
        };
    };
    class Concentration {
        class Naloxone {
            concentration = 4;
            dose = "4mg/0.1ml";
            volume = 0.1;
        };

        class Amiodarone {
            concentration = 50;
            dose = "150mg/3ml";
            volume = 3;
        };

        class TXA {
            concentration = 100;
            dose = "1000mg/10ml";
            volume = 10;
        };

        class Morphine {
            concentration = 5;
            dose = "10mg/2ml";
            volume = 2;
        };

        class Epinephrine {
            concentration = 1;
            dose = "1mg/1ml";
            volume = 1;
        };

        class Adenosine {
            concentration = 3;
            dose = "12mg/4ml";
            volume = 4;
        };

        class Lidocaine {
            concentration = 20;
            dose = "100mg/5ml";
            volume = 5;
        };

        class Ketamine {
            concentration = 50;
            dose = "500mg/10ml";
            volume = 10;
        };
    };
};