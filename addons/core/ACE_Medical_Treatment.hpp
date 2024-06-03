#define BLOODBAG_ENTRY(type,typeM,amount) \
    class TRIPLES(BloodBag,type,amount): DOUBLES(BloodBag_O,amount) { \
        bloodtype = typeM; \
    }

class ACE_ADDON(Medical_Treatment) {
    class Bandaging {
        class FieldDressing;

        class PressureBandage: FieldDressing {
            class Abrasion {
                effectiveness = 4;
                reopeningChance = 0.6;
                reopeningMinDelay = 800;
                reopeningMaxDelay = 1500;
            };
            class AbrasionMinor: Abrasion {};
            class AbrasionMedium: Abrasion {
                effectiveness = 3;
                reopeningChance = 0.9;
            };
            class AbrasionLarge: Abrasion {
                effectiveness = 2.5;
                reopeningChance = 1;
            };

            class Avulsion: Abrasion {
                effectiveness = 2;
                reopeningChance = 0.7;
                reopeningMinDelay = 1000;
                reopeningMaxDelay = 1600;
            };
            class AvulsionMinor: Avulsion {};
            class AvulsionMedium: Avulsion {
                effectiveness = 1.4;
            };
            class AvulsionLarge: Avulsion {
                effectiveness = 1;
            };

            class Contusion: Abrasion {
                effectiveness = 2;
                reopeningChance = 0;
                reopeningMinDelay = 0;
                reopeningMaxDelay = 0;
            };
            class ContusionMinor: Contusion {};
            class ContusionMedium: Contusion {};
            class ContusionLarge: Contusion {};

            class Crush: Abrasion {
                effectiveness = 2;
                reopeningChance = 0.6;
                reopeningMinDelay = 600;
                reopeningMaxDelay = 1000;
            };
            class CrushMinor: Crush {};
            class CrushMedium: Crush {
                effectiveness = 1.7;
                reopeningChance = 0.7;
            };
            class CrushLarge: Crush {
                effectiveness = 1.6;
                reopeningChance = 0.8;
            };

            class Cut: Abrasion {
                effectiveness = 5;
                reopeningChance = 0.6;
                reopeningMinDelay = 700;
                reopeningMaxDelay = 1000;
            };
            class CutMinor: Cut {};
            class CutMedium: Cut {
                effectiveness = 3.5;
                reopeningChance = 0.7;
            };
            class CutLarge: Cut {
                effectiveness = 2;
                reopeningChance = 0.8;
            };

            class Laceration: Abrasion {
                effectiveness = 2;
                reopeningChance = 0.65;
                reopeningMinDelay = 500;
                reopeningMaxDelay = 2000;
            };
            class LacerationMinor: Laceration {};
            class LacerationMedium: Laceration {
                effectiveness = 1.5;
                reopeningChance = 0.8;
            };
            class LacerationLarge: Laceration {
                effectiveness = 1;
                reopeningChance = 0.9;
            };

            class VelocityWound: Abrasion {
                effectiveness = 2.2;
                reopeningChance = 1;
                reopeningMinDelay = 800;
                reopeningMaxDelay = 2000;
            };
            class VelocityWoundMinor: VelocityWound {};
            class VelocityWoundMedium: VelocityWound {
                effectiveness = 1.75;
            };
            class VelocityWoundLarge: VelocityWound {
                effectiveness = 1.5;
            };

            class PunctureWound: Abrasion {
                effectiveness = 2.5;
                reopeningChance = 1;
                reopeningMinDelay = 1000;
                reopeningMaxDelay = 3000;
            };
            class PunctureWoundMinor: PunctureWound {};
            class PunctureWoundMedium: PunctureWound {
                effectiveness = 2;
            };
            class PunctureWoundLarge: PunctureWound {
                effectiveness = 1.5;
            };
        };

        class EmergencyTraumaDressing: PressureBandage {
            class Abrasion {
                effectiveness = 20;
                reopeningChance = 0.48;
                reopeningMinDelay = 800;
                reopeningMaxDelay = 1500;
            };
            class AbrasionMinor: Abrasion {};
            class AbrasionMedium: Abrasion {
                effectiveness = 15;
                reopeningChance = 0.72;
            };
            class AbrasionLarge: Abrasion {
                effectiveness = 12.5;
                reopeningChance = 0.8;
            };

            class Avulsion: Abrasion {
                effectiveness = 10;
                reopeningChance = 0.52;
                reopeningMinDelay = 1000;
                reopeningMaxDelay = 1600;
            };
            class AvulsionMinor: Avulsion {};
            class AvulsionMedium: Avulsion {
                effectiveness = 7;
            };
            class AvulsionLarge: Avulsion {
                effectiveness = 5;
            };

            class Contusion: Abrasion {
                effectiveness = 10;
                reopeningChance = 0;
                reopeningMinDelay = 0;
                reopeningMaxDelay = 0;
            };
            class ContusionMinor: Contusion {};
            class ContusionMedium: Contusion {};
            class ContusionLarge: Contusion {};

            class Crush: Abrasion {
                effectiveness = 10;
                reopeningChance = 0.48;
                reopeningMinDelay = 600;
                reopeningMaxDelay = 1000;
            };
            class CrushMinor: Crush {};
            class CrushMedium: Crush {
                effectiveness = 8.5;
                reopeningChance = 0.52;
            };
            class CrushLarge: Crush {
                effectiveness = 8;
                reopeningChance = 0.64;
            };

            class Cut: Abrasion {
                effectiveness = 25;
                reopeningChance = 0.48;
                reopeningMinDelay = 700;
                reopeningMaxDelay = 1000;
            };
            class CutMinor: Cut {};
            class CutMedium: Cut {
                effectiveness = 17.5;
                reopeningChance = 0.52;
            };
            class CutLarge: Cut {
                effectiveness = 10;
                reopeningChance = 0.64;
            };

            class Laceration: Abrasion {
                effectiveness = 10;
                reopeningChance = 0.52;
                reopeningMinDelay = 500;
                reopeningMaxDelay = 2000;
            };
            class LacerationMinor: Laceration {};
            class LacerationMedium: Laceration {
                effectiveness = 7.5;
                reopeningChance = 0.64;
            };
            class LacerationLarge: Laceration {
                effectiveness = 5;
                reopeningChance = 0.72;
            };

            class VelocityWound: Abrasion {
                effectiveness = 11;
                reopeningChance = 0.8;
                reopeningMinDelay = 800;
                reopeningMaxDelay = 2000;
            };
            class VelocityWoundMinor: VelocityWound {};
            class VelocityWoundMedium: VelocityWound {
                effectiveness = 8.75;
            };
            class VelocityWoundLarge: VelocityWound {
                effectiveness = 7.5;
            };

            class PunctureWound: Abrasion {
                effectiveness = 12.5;
                reopeningChance = 0.8;
                reopeningMinDelay = 1000;
                reopeningMaxDelay = 3000;
            };
            class PunctureWoundMinor: PunctureWound {};
            class PunctureWoundMedium: PunctureWound {
                effectiveness = 10;
            };
            class PunctureWoundLarge: PunctureWound {
                effectiveness = 7.5;
            };
        };

        class ElasticWrap: PressureBandage {
            class Abrasion {
                effectiveness = 0;
            };
            class AbrasionMinor: Abrasion {};
            class AbrasionMedium: Abrasion {};
            class AbrasionLarge: Abrasion {};

            class Avulsion: Abrasion {};
            class AvulsionMinor: Avulsion {};
            class AvulsionMedium: Avulsion {};
            class AvulsionLarge: Avulsion {};

            class Contusion {
                effectiveness = 2;
                reopeningChance = 0;
                reopeningMinDelay = 0;
                reopeningMaxDelay = 0;
            };
            class ContusionMinor: Contusion {
                effectiveness = 3;
            };
            class ContusionMedium: Contusion {};
            class ContusionLarge: Contusion {
                effectiveness = 1;
            };

            class Crush: Abrasion {};
            class CrushMinor: Crush {};
            class CrushMedium: Crush {};
            class CrushLarge: Crush {};

            class Cut: Abrasion {};
            class CutMinor: Cut {};
            class CutMedium: Cut {};
            class CutLarge: Cut {};

            class Laceration: Abrasion {};
            class LacerationMinor: Laceration {};
            class LacerationMedium: Laceration {};
            class LacerationLarge: Laceration { };

            class VelocityWound: Abrasion {};
            class VelocityWoundMinor: VelocityWound {};
            class VelocityWoundMedium: VelocityWound {};
            class VelocityWoundLarge: VelocityWound {};

            class PunctureWound: Abrasion {};
            class PunctureWoundMinor: PunctureWound {};
            class PunctureWoundMedium: PunctureWound {};
            class PunctureWoundLarge: PunctureWound {};
        };
    };

    class Medication {
        maxDoseDeviation = 1;
        administrationType = ACM_ROUTE_IM;
        rrAdjust[] = {0,0};
        coSensitivityAdjust[] = {0,0};
        breathingEffectivenessAdjust[] = {0,0};
        maxEffectTime = 120;
        onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        
        class PainKillers {
            painReduce = 0.35;
            hrIncreaseLow[] = {-5, -10};
            hrIncreaseNormal[] = {-5, -15};
            hrIncreaseHigh[] = {-5, -17};
            timeInSystem = 420;
            timeTillMaxEffect = 60;
            maxDose = 5;
            incompatibleMedication[] = {};
            viscosityChange = 5;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        };

        class ACM_PO_Medication {
            painReduce = 0;
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 1200;
            timeTillMaxEffect = 120;
            maxEffectTime = 600;
            maxDose = 5;
            incompatibleMedication[] = {};
            administrationType = ACM_ROUTE_PO;
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
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
            maxDose = 5;
            incompatibleMedication[] = {};
            administrationType = ACM_ROUTE_INHALE;
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        };

        class AmmoniaInhalant: ACM_Inhalant_Medication {
            hrIncreaseLow[] = {3, 8};
            hrIncreaseNormal[] = {3, 18};
            hrIncreaseHigh[] = {3, 12};
            rrAdjust[] = {2,4};
        };
        class Penthrox: ACM_Inhalant_Medication {
            painReduce = 0.75;
            hrIncreaseLow[] = {-1, -2};
            hrIncreaseNormal[] = {-1, -3};
            hrIncreaseHigh[] = {-1, -4};
            timeInSystem = 425;
            maxEffectTime = 80;
            breathingEffectivenessAdjust[] = {-0.001,-0.01};
        };
        class Naloxone: ACM_Inhalant_Medication {
            timeInSystem = 360;
            maxEffectTime = 120;
            maxDose = 0;
        };

        class ACM_IV_Medication {
            painReduce = 0;
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 400;
            timeTillMaxEffect = 5;
            maxEffectTime = 90;
            maxDose = 5;
            incompatibleMedication[] = {};
            administrationType = ACM_ROUTE_IV;
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        };

        class Epinephrine_IV: ACM_IV_Medication {
            hrIncreaseLow[] = {25, 35};
            hrIncreaseNormal[] = {25, 55};
            hrIncreaseHigh[] = {25, 45};
            rrAdjust[] = {7,11};
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
            coSensitivityAdjust[] = {-0.03,-0.08};
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
        };

        class ACM_IM_Medication {
            painReduce = 0;
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 700;
            timeTillMaxEffect = 30;
            maxEffectTime = 120;
            maxDose = 5;
            incompatibleMedication[] = {};
            administrationType = ACM_ROUTE_IM;
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        };

        class Morphine: ACM_IM_Medication {
            painReduce = 0.7;
            hrIncreaseLow[] = {-8, -16};
            hrIncreaseNormal[] = {-8, -18};
            hrIncreaseHigh[] = {-8, -24};
            coSensitivityAdjust[] = {-0.01,-0.05};
        };
        class Epinephrine: ACM_IM_Medication {
            painReduce = 0;
            hrIncreaseLow[] = {8, 16};
            hrIncreaseNormal[] = {8, 34};
            hrIncreaseHigh[] = {8, 26};
            rrAdjust[] = {5,8};
            breathingEffectivenessAdjust[] = {0,0.02};
        };
        class Adenosine: ACM_IM_Medication {
            hrIncreaseLow[] = {-7, -10};
            hrIncreaseNormal[] = {-15, -30};
            hrIncreaseHigh[] = {-15, -35};
        };

        class Lidocaine: Morphine {
            timeTillMaxEffect = 20;
            timeInSystem = 500;
        };

        class Ketamine: ACM_IM_Medication {
            painReduce = 0.7;
            hrIncreaseLow[] = {-1, -1};
            hrIncreaseNormal[] = {-1, -1};
            hrIncreaseHigh[] = {-1, -1};
            rrAdjust[] = {0,0};
        };
    };

    class IV {
        // volume is in millileters
        volume = 1000;
        ratio[] = {};
        type = "Blood";
        class BloodIV {
            volume = 1000;
            ratio[] = {"Plasma", 1};
        };
        class BloodIV_500: BloodIV {
            volume = 500;
        };
        class BloodIV_250: BloodIV {
            volume = 250;
        };
        class PlasmaIV: BloodIV {
            volume = 1000;
            ratio[] = {"Blood", 1};
            type = "Plasma";
        };
        class PlasmaIV_500: PlasmaIV {
            volume = 500;
        };
        class PlasmaIV_250: PlasmaIV {
            volume = 250;
        };
        class SalineIV: BloodIV {
            volume = 1000;
            type = "Saline";
            ratio[] = {};
        };
        class SalineIV_500: SalineIV {
            volume = 500;
        };
        class SalineIV_250: SalineIV {
            volume = 250;
        };

        // Blood Types
        class BloodBag_O_1000: BloodIV {
            volume = 1000;
            ratio[] = {"Plasma", 1};
            type = "Blood";
            bloodtype = ACM_BLOODTYPE_O;
        };
        BLOODBAG_ENTRY(ON,ACM_BLOODTYPE_ON,1000);
        BLOODBAG_ENTRY(A,ACM_BLOODTYPE_A,1000);
        BLOODBAG_ENTRY(AN,ACM_BLOODTYPE_AN,1000);
        BLOODBAG_ENTRY(B,ACM_BLOODTYPE_B,1000);
        BLOODBAG_ENTRY(BN,ACM_BLOODTYPE_BN,1000);
        BLOODBAG_ENTRY(AB,ACM_BLOODTYPE_AB,1000);
        BLOODBAG_ENTRY(ABN,ACM_BLOODTYPE_ABN,1000);

        class BloodBag_O_500: BloodBag_O_1000 {
            volume = 500;
        };
        BLOODBAG_ENTRY(ON,ACM_BLOODTYPE_ON,500);
        BLOODBAG_ENTRY(A,ACM_BLOODTYPE_A,500);
        BLOODBAG_ENTRY(AN,ACM_BLOODTYPE_AN,500);
        BLOODBAG_ENTRY(B,ACM_BLOODTYPE_B,500);
        BLOODBAG_ENTRY(BN,ACM_BLOODTYPE_BN,500);
        BLOODBAG_ENTRY(AB,ACM_BLOODTYPE_AB,500);
        BLOODBAG_ENTRY(ABN,ACM_BLOODTYPE_ABN,500);

        class BloodBag_O_250: BloodBag_O_1000 {
            volume = 250;
        };
        BLOODBAG_ENTRY(ON,ACM_BLOODTYPE_ON,250);
        BLOODBAG_ENTRY(A,ACM_BLOODTYPE_A,250);
        BLOODBAG_ENTRY(AN,ACM_BLOODTYPE_AN,250);
        BLOODBAG_ENTRY(B,ACM_BLOODTYPE_B,250);
        BLOODBAG_ENTRY(BN,ACM_BLOODTYPE_BN,250);
        BLOODBAG_ENTRY(AB,ACM_BLOODTYPE_AB,250);
        BLOODBAG_ENTRY(ABN,ACM_BLOODTYPE_ABN,250);
    };
};
