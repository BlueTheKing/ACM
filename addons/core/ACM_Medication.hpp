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
            timeInSystem = 3000;
            timeTillMaxEffect = 240;
            maxEffectTime = 900;
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
            painReduce = 0.35;
            maxPainReduce = 0.45;
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
            timeInSystem = 420;
            maxEffectTime = 90;
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
            timeInSystem = 360;
            timeTillMaxEffect = 5;
            maxEffectTime = 240;
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
            weightEffect = 0;
        };

        class Adenosine_IV: ACM_IV_Medication {
            medicationType = "Adenosine";
            hrIncreaseLow[] = {-10, -15};
            hrIncreaseNormal[] = {-10, -40};
            hrIncreaseHigh[] = {-10, -30};
            maxEffectDose = 6;
            weightEffect = 0;
        };

        class Morphine_IV: ACM_IV_Medication {
            medicationType = "Opioid";
            painReduce = 0.85;
            maxPainReduce = 1;
            hrIncreaseLow[] = {-9, -18};
            hrIncreaseNormal[] = {-9, -24};
            hrIncreaseHigh[] = {-9, -30};
            timeInSystem = 1300;
            timeTillMaxEffect = 15;
            maxEffectTime = 900;
            coSensitivityAdjust[] = {-0.035,-0.04};
            maxDose = 10;
            maxDoseDeviation = 2;
            maxEffectDose = 6;
        };

        class Amiodarone_IV: ACM_IV_Medication {
            medicationType = "Amiodarone";
            hrIncreaseLow[] = {-5, -10};
            hrIncreaseNormal[] = {-15, -30};
            hrIncreaseHigh[] = {-20, -30};
            timeInSystem = 720;
            timeTillMaxEffect = 10;
            maxEffectTime = 480;
            maxDose = 2200;
            maxDoseDeviation = 200;
            maxEffectDose = 150;
            weightEffect = 0;
        };

        class Lidocaine_IV: ACM_IV_Medication {
            medicationType = "Lidocaine_IV";
            hrIncreaseLow[] = {-3, -5};
            hrIncreaseNormal[] = {-12, -20};
            hrIncreaseHigh[] = {-10, -20};
            timeInSystem = 600;
            maxEffectTime = 360;
            maxDose = 300;
            maxDoseDeviation = 50;
            maxEffectDose = 83;
        };

        class TXA_IV: ACM_IV_Medication {
            medicationType = "TXA";
            hrIncreaseLow[] = {-1, -1};
            hrIncreaseNormal[] = {-1, -1};
            hrIncreaseHigh[] = {-2, -4};
            timeInSystem = 900;
            timeTillMaxEffect = 15;
            maxEffectTime = 600;
            viscosityChange = 10;
            maxEffectDose = 1000;
            weightEffect = 0;
        };

        class Ketamine_IV: ACM_IV_Medication {
            medicationType = "Ketamine";
            painReduce = 0.85;
            maxPainReduce = 1;
            hrIncreaseLow[] = {-1, -2};
            hrIncreaseNormal[] = {-1, -2};
            hrIncreaseHigh[] = {-1, -2};
            timeInSystem = 660;
            maxEffectTime = 540;
            maxDose = 40;
            maxDoseDeviation = 10;
            maxEffectDose = 20.7;
        };

        class Fentanyl_IV: ACM_IV_Medication {
            medicationType = "Opioid";
            painReduce = 1;
            hrIncreaseLow[] = {-20, -26};
            hrIncreaseNormal[] = {-20, -30};
            hrIncreaseHigh[] = {-20, -40};
            timeInSystem = 960;
            timeTillMaxEffect = 10;
            maxEffectTime = 840;
            coSensitivityAdjust[] = {-0.035,-0.036};
            maxDose = 0.15;
            maxDoseDeviation = 0.05;
            maxEffectDose = 0.0415; //mcg
        };

        class Ondansetron_IV: ACM_IV_Medication {
            hrIncreaseLow[] = {-4, -8};
            hrIncreaseNormal[] = {-5, -14};
            hrIncreaseHigh[] = {-7, -18};
            timeInSystem = 720;
            timeTillMaxEffect = 15;
            maxEffectTime = 600;
            maxDose = 8;
            maxDoseDeviation = 8;
            maxEffectDose = 4;
            weightEffect = 0;
        };

        class ACM_IM_Medication {
            painReduce = 0;
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 400;
            timeTillMaxEffect = 30;
            maxEffectTime = 240;
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
            timeInSystem = 1800;
            timeTillMaxEffect = 100;
            maxEffectTime = 1200;
            coSensitivityAdjust[] = {-0.03,-0.035};
            maxDose = 14;
            maxDoseDeviation = 3;
            maxEffectDose = 10;
        };
        class Epinephrine: ACM_IM_Medication { // EpiPen
            medicationType = "Epinephrine";
            painReduce = 0;
            hrIncreaseLow[] = {5, 22};
            hrIncreaseNormal[] = {5, 20};
            hrIncreaseHigh[] = {5, 12};
            rrAdjust[] = {3,6};
            breathingEffectivenessAdjust[] = {0,0.01};
            maxEffectDose = 0.3;
            weightEffect = 0;
        };

        class Adenosine: ACM_IM_Medication { // Doesn't exist
            medicationType = "Adenosine";
        };

        class Amiodarone: ACM_IM_Medication {
            weightEffect = 0;
        };

        class Lidocaine: ACM_IM_Medication {
            timeInSystem = 600;
            timeTillMaxEffect = 20;
            maxEffectTime = 240;
            maxDose = 120;
            maxDoseDeviation = 20;
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
            timeInSystem = 900;
            timeTillMaxEffect = 20;
            maxEffectTime = 600;
            maxDose = 100;
            maxDoseDeviation = 20;
            maxEffectDose = 50;
        };

        class Fentanyl: ACM_IM_Medication {
            medicationType = "Opioid";
            painReduce = 0.8;
            hrIncreaseLow[] = {-18, -26};
            hrIncreaseNormal[] = {-18, -28};
            hrIncreaseHigh[] = {-18, -34};
            timeInSystem = 1200;
            timeTillMaxEffect = 30;
            maxEffectTime = 900;
            coSensitivityAdjust[] = {-0.035,-0.036};
            maxDose = 0.18;
            maxDoseDeviation = 0.075;
            maxEffectDose = 0.0581; //mcg
        };

        class Ondansetron: ACM_IM_Medication {
            hrIncreaseLow[] = {-1, -5};
            hrIncreaseNormal[] = {-3, -10};
            hrIncreaseHigh[] = {-5, -12};
            timeInSystem = 900;
            timeTillMaxEffect = 45;
            maxEffectTime = 720;
            maxDose = 8;
            maxDoseDeviation = 8;
            maxEffectDose = 4;
            weightEffect = 0;
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
            classnames[] = {"Morphine_IV", "Morphine", "Fentanyl_IV", "Fentanyl"};
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
        class Lidocaine {
            classnames[] = {"Lidocaine_IV"};
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

        class Fentanyl {
            concentration = 0.05;
            dose = "100mcg/2ml";
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

        class Ondansetron {
            concentration = 2;
            dose = "4mg/2ml";
            volume = 2;
        };
    };
};