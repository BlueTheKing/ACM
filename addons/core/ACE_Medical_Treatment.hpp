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
        maxEffectTime = 60;
        onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        class Morphine {
            painReduce = 0.7;
            hrIncreaseLow[] = {-8, -12};
            hrIncreaseNormal[] = {-8, -22};
            hrIncreaseHigh[] = {-8, -27};
            timeInSystem = 900;
            timeTillMaxEffect = 30;
            maxDose = 4;
            incompatibleMedication[] = {};
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
            rrAdjust[] = {-6,-10};
        };
        class Epinephrine {
            painReduce = 0;
            hrIncreaseLow[] = {9, 16};
            hrIncreaseNormal[] = {9, 44};
            hrIncreaseHigh[] = {9, 36};
            timeInSystem = 900;
            timeTillMaxEffect = 30;
            maxDose = 8;
            incompatibleMedication[] = {};
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
            rrAdjust[] = {4,8};
        };
        class Adenosine {
            painReduce = 0;
            hrIncreaseLow[] = {-7, -10};
            hrIncreaseNormal[] = {-15, -30};
            hrIncreaseHigh[] = {-15, -35};
            timeInSystem = 900;
            timeTillMaxEffect = 30;
            maxDose = 5;
            incompatibleMedication[] = {};
            viscosityChange = 0;
            onOverDose = QUOTE(_this call EFUNC(circulation,handleOverdose));
        };
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

        class Paracetamol: PainKillers {
            painReduce = 0.4;
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 1800;
            timeTillMaxEffect = 120;
            maxEffectTime = 600;
            viscosityChange = 0;
            administrationType = ACM_ROUTE_PO;
        };
        class AmmoniaInhalant: Paracetamol {
            painReduce = 0;
            hrIncreaseLow[] = {3, 8};
            hrIncreaseNormal[] = {3, 18};
            hrIncreaseHigh[] = {3, 12};
            timeInSystem = 40;
            timeTillMaxEffect = 3;
            maxEffectTime = 3;
            maxDose = 6;
            rrAdjust[] = {2,4};
            administrationType = ACM_ROUTE_INHALE;
        };
        class Penthrox: AmmoniaInhalant {
            painReduce = 0.65;
            hrIncreaseLow[] = {-1, -4};
            hrIncreaseNormal[] = {-1, -5};
            hrIncreaseHigh[] = {-1, -10};
            timeInSystem = 425;
            maxEffectTime = 80;
            maxDose = 4;
            rrAdjust[] = {-3,-6};
        };
        class Naloxone: AmmoniaInhalant {
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 300;
            maxEffectTime = 60;
            maxDose = 20;
            rrAdjust[] = {0,0};
        };

        class Epinephrine_Vial: Epinephrine {
            painReduce = 0;
            hrIncreaseLow[] = {25, 35};
            hrIncreaseNormal[] = {25, 55};
            hrIncreaseHigh[] = {25, 45};
            timeInSystem = 1200;
            timeTillMaxEffect = 5;
            maxEffectTime = 120;
            maxDose = 5;
            incompatibleMedication[] = {};
            rrAdjust[] = {8,13};
            administrationType = ACM_ROUTE_IV;
        };
        class Adenosine_Vial: Epinephrine_Vial {
            hrIncreaseLow[] = {-10, -15};
            hrIncreaseNormal[] = {-10, -40};
            hrIncreaseHigh[] = {-10, -30};
        };
        class Morphine_Vial: Epinephrine_Vial {
            painReduce = 0.85;
            hrIncreaseLow[] = {-9, -18};
            hrIncreaseNormal[] = {-9, -24};
            hrIncreaseHigh[] = {-9, -30};
            rrAdjust[] = {-8,-12};
        };
        class Amiodarone_Vial: Epinephrine_Vial {
            hrIncreaseLow[] = {-1, -2};
            hrIncreaseNormal[] = {-3, -5};
            hrIncreaseHigh[] = {-10, -15};
        };

        class TXA_Vial: Amiodarone_Vial {
            hrIncreaseLow[] = {-1, -1};
            hrIncreaseNormal[] = {-1, -1};
            hrIncreaseHigh[] = {-2, -4};
            viscosityChange = 5;
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
