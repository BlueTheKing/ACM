class ACM_Medication {
    class Medications {
        maxDoseDeviation = 1;
        hrIncrease[] = {0, 0};
        administrationType = ACM_ROUTE_IM;
        medicationType = "Default";
        rrAdjust[] = {0,0};
        coSensitivityAdjust[] = {0,0};
        breathingEffectivenessAdjust[] = {0,0};
        maxEffectTime = 120;
        onOverDose = "";
        minEffectDose = 1; // mg
        maxEffectDose = 1; // mg
        weightEffect = 0;
        minPainReduce = 0;
        maxPainReduce = 1;

        class ACM_PO_Medication {
            painReduce = 0;
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
            minPainReduce = 0.35;
            painReduce = 0.35;
            maxPainReduce = 0.45;
        };

        class ACM_Inhalant_Medication {
            painReduce = 0;
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
            hrIncrease[] = {5, 25};
            rrAdjust[] = {1,3};
        };

        class Penthrox: ACM_Inhalant_Medication {
            minPainReduce = 0.75;
            painReduce = 0.75;
            maxPainReduce = 0.9;
            hrIncrease[] = {-1, -4};
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
            hrIncrease[] = {25, 60};
            rrAdjust[] = {6,12};
            breathingEffectivenessAdjust[] = {0.01,0.04};
            maxEffectDose = 1;
            weightEffect = 2;
        };

        class Adenosine_IV: ACM_IV_Medication {
            timeInSystem = 100;
            timeTillMaxEffect = 60;
            maxEffectTime = 25;
            hrIncrease[] = {-50, -100};
            maxEffectDose = 6;
            weightEffect = 0;
        };

        class Morphine_IV: ACM_IV_Medication {
            medicationType = "Opioid";
            minPainReduce = 0.6;
            painReduce = 0.85;
            maxPainReduce = 1;
            hrIncrease[] = {-9, -30};
            timeInSystem = 1300;
            timeTillMaxEffect = 25;
            maxEffectTime = 900;
            coSensitivityAdjust[] = {-0.05,-0.09};
            maxDose = 12;
            maxDoseDeviation = 3;
            minEffectDose = 4.15;
            maxEffectDose = 8.3;
            weightEffect = 2;
        };

        class Amiodarone_IV: ACM_IV_Medication {
            medicationType = "Amiodarone";
            hrIncrease[] = {-15, -30};
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
            hrIncrease[] = {-5, -20};
            timeInSystem = 600;
            maxEffectTime = 360;
            maxDose = 270;
            maxDoseDeviation = 50;
            maxEffectDose = 83;
        };

        class TXA_IV: ACM_IV_Medication {
            medicationType = "TXA";
            hrIncrease[] = {-1, -4};
            timeInSystem = 900;
            timeTillMaxEffect = 15;
            maxEffectTime = 600;
            viscosityChange = 10;
            maxEffectDose = 1000;
            weightEffect = 0;
        };

        class Ketamine_IV: ACM_IV_Medication {
            medicationType = "Ketamine";
            minPainReduce = 0.5;
            painReduce = 0.85;
            maxPainReduce = 1;
            hrIncrease[] = {-1, -2};
            timeInSystem = 660;
            maxEffectTime = 540;
            maxDose = 250;
            maxDoseDeviation = 50;
            minEffectDose = 8.3;
            maxEffectDose = 16.6;
        };

        class Fentanyl_IV: ACM_IV_Medication {
            medicationType = "Opioid";
            minPainReduce = 0.6;
            painReduce = 1;
            hrIncrease[] = {-5, -20};
            timeInSystem = 960;
            timeTillMaxEffect = 10;
            maxEffectTime = 840;
            coSensitivityAdjust[] = {-0.06,-0.07};
            breathingEffectivenessAdjust[] = {-0.01,-0.04};
            maxDose = 0.15;
            maxDoseDeviation = 0.05;
            minEffectDose = 0.0415; //mcg
            maxEffectDose = 0.083; //mcg
            weightEffect = 2;
        };

        class Ondansetron_IV: ACM_IV_Medication {
            hrIncrease[] = {-5, -12};
            timeInSystem = 720;
            timeTillMaxEffect = 15;
            maxEffectTime = 600;
            maxDose = 8;
            maxDoseDeviation = 8;
            viscosityChange = 20;
            maxEffectDose = 4;
            weightEffect = 0;
        };

        class CalciumChloride_IV: ACM_IV_Medication {
            hrIncrease[] = {5, 20};
            timeInSystem = 600;
            timeTillMaxEffect = 15;
            maxEffectTime = 300;
            maxDose = 1500;
            maxDoseDeviation = 100;
            viscosityChange = -10;
            maxEffectDose = 1000;
            weightEffect = 0;
        };

        class Ertapenem_IV: ACM_IV_Medication {
            medicationType = "Ertapenem";
            timeInSystem = 900;
            timeTillMaxEffect = 5;
            maxEffectTime = 600;
            maxEffectDose = 1000;
            weightEffect = 0;
        };

        class Esmolol_IV: ACM_IV_Medication {
            hrIncrease[] = {-20, -50};
            timeInSystem = 320;
            timeTillMaxEffect = 20;
            maxEffectTime = 240;
            minEffectDose = 20.75;
            maxEffectDose = 41.5;
            weightEffect = 1;
        };

        class ACM_IM_Medication {
            painReduce = 0;
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
            minPainReduce = 0.5;
            painReduce = 0.7;
            maxPainReduce = 0.95;
            hrIncrease[] = {-6, -20};
            timeInSystem = 1800;
            timeTillMaxEffect = 100;
            maxEffectTime = 1200;
            coSensitivityAdjust[] = {-0.06,-0.07};
            maxDose = 14;
            maxDoseDeviation = 3;
            minEffectDose = 5.83;
            maxEffectDose = 8.3;
            weightEffect = 2;
        };
        class Epinephrine: ACM_IM_Medication { // EpiPen
            medicationType = "Epinephrine";
            painReduce = 0;
            hrIncrease[] = {8, 20};
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
            timeTillMaxEffect = 10;
            maxEffectTime = 240;
            maxDose = 200;
            maxDoseDeviation = 50;
            maxEffectDose = 100;
            weightEffect = 0;
        };

        class Ketamine: ACM_IM_Medication {
            medicationType = "Ketamine";
            minPainReduce = 0.4;
            painReduce = 0.7;
            maxPainReduce = 0.95;
            hrIncrease[] = {-1, -2};
            rrAdjust[] = {0,0};
            timeInSystem = 900;
            timeTillMaxEffect = 20;
            maxEffectTime = 600;
            maxDose = 500;
            maxDoseDeviation = 100;
            minEffectDose = 41.5;
            maxEffectDose = 62.25;
        };

        class Fentanyl: ACM_IM_Medication {
            medicationType = "Opioid";
            minPainReduce = 0.5;
            painReduce = 0.8;
            hrIncrease[] = {-2, -10};
            timeInSystem = 1200;
            timeTillMaxEffect = 30;
            maxEffectTime = 900;
            coSensitivityAdjust[] = {-0.05,-0.06};
            breathingEffectivenessAdjust[] = {-0.01,-0.02};
            maxDose = 0.18;
            maxDoseDeviation = 0.075;
            minEffectDose = 0.0581; //mcg
            maxEffectDose = 0.083; //mcg
            weightEffect = 2;
        };

        class Ondansetron: ACM_IM_Medication {
            hrIncrease[] = {-1, -5};
            timeInSystem = 900;
            timeTillMaxEffect = 45;
            maxEffectTime = 720;
            maxDose = 8;
            maxDoseDeviation = 8;
            maxEffectDose = 4;
            weightEffect = 0;
        };

        class Ertapenem: ACM_IM_Medication {
            medicationType = "Ertapenem";
            timeInSystem = 1200;
            timeTillMaxEffect = 30;
            maxEffectTime = 900;
            maxEffectDose = 1000;
            weightEffect = 0;
        };
    };
    class MedicationType {
        class Default {};
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
        class Ertapenem {
            classnames[] = {"Ertapenem_IV", "Ertapenem"};
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
            dose = "1g/10ml";
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

        class CalciumChloride {
            concentration = 100;
            dose = "1g/10ml";
            volume = 10;
        };

        class Ertapenem {
            concentration = 100;
            dose = "1g/10ml";
            volume = 10;
        };

        class Esmolol {
            concentration = 10;
            dose = "100mg/10ml";
            volume = 10;
        };
    };
};