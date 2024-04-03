#define BLOODBAG_ENTRY(type,amount) \
    class TRIPLE(Blood,type,amount): DOUBLES(Blood_O,amount) { \
        bloodtype = DOUBLES(AMS_BLOODTYPE,type); \
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
        class Morphine {
            painReduce = 0.75;
            hrIncreaseLow[] = {-10, -15};
            hrIncreaseNormal[] = {-10, -25};
            hrIncreaseHigh[] = {-10, -30};
            timeInSystem = 300;
            timeTillMaxEffect = 15;
            maxDose = 4;
            incompatibleMedication[] = {};
            viscosityChange = -4;
        };
        class Epinephrine {
            painReduce = 0;
            hrIncreaseLow[] = {10, 20};
            hrIncreaseNormal[] = {10, 45};
            hrIncreaseHigh[] = {10, 35};
            timeInSystem = 180;
            timeTillMaxEffect = 10;
            maxDose = 9;
            incompatibleMedication[] = {};
        };
        class Adenosine { // Doesn't exist
            painReduce = 0;
            hrIncreaseLow[] = {-7, -10};
            hrIncreaseNormal[] = {-15, -30};
            hrIncreaseHigh[] = {-15, -35};
            timeInSystem = 120;
            timeTillMaxEffect = 15;
            maxDose = 5;
            incompatibleMedication[] = {};
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
        };

        class Paracetamol: PainKillers {
            painReduce = 0.4;
            timeTillMaxEffect = 90;
            timeInSystem = 480;
        };
        class AmmoniumCarbonate: Paracetamol {
            painReduce = 0;
            hrIncreaseLow[] = {5, 15};
            hrIncreaseNormal[] = {5, 20};
            hrIncreaseHigh[] = {5, 12};
            timeInSystem = 30;
            timeTillMaxEffect = 5;
            maxDose = 4;
            viscosityChange = 1;
        };
        class Penthrox: Paracetamol {
            painReduce = 0.7;
            hrIncreaseLow[] = {-5, -15};
            hrIncreaseNormal[] = {-5, -20};
            hrIncreaseHigh[] = {-5, -12};
            timeInSystem = 300;
            timeTillMaxEffect = 5;
            maxDose = 4;
            viscosityChange = -1;
        };
        class Naloxone: Paracetamol {
            painReduce = 0;
            hrIncreaseLow[] = {0, 0};
            hrIncreaseNormal[] = {0, 0};
            hrIncreaseHigh[] = {0, 0};
            timeInSystem = 300;
            timeTillMaxEffect = 3;
            viscosityChange = 0;
        };

        class Epinephrine_Vial: Epinephrine {
            painReduce = 0;
            hrIncreaseLow[] = {25, 35};
            hrIncreaseNormal[] = {25, 55};
            hrIncreaseHigh[] = {25, 45};
            timeInSystem = 120;
            timeTillMaxEffect = 2;
            maxDose = 5;
            incompatibleMedication[] = {};
        };
        class Adenosine_Vial: Adenosine {
            painReduce = 0;
            hrIncreaseLow[] = {-10, -15};
            hrIncreaseNormal[] = {-15, -30};
            hrIncreaseHigh[] = {-20, -40};
            timeInSystem = 120;
            timeTillMaxEffect = 2;
            maxDose = -5;
        };
        class Morphine_Vial: Morphine {
            painReduce = 0.85;
            hrIncreaseLow[] = {-10, -15};
            hrIncreaseNormal[] = {-15, -35};
            hrIncreaseHigh[] = {-15, -35};
            timeInSystem = 120;
            timeTillMaxEffect = 3;
            maxDose = 3;
            viscosityChange = -5;
        };
        class Amiodarone_Vial: Naloxone {
            hrIncreaseLow[] = {-1, -2};
            hrIncreaseNormal[] = {-3, -5};
            hrIncreaseHigh[] = {-10, -15};
            timeInSystem = 360;
            timeTillMaxEffect = 2;
            maxDose = 3;
        };

        class TXA_Vial: Naloxone {
            hrIncreaseLow[] = {-1, -1};
            hrIncreaseNormal[] = {-1, -1};
            hrIncreaseHigh[] = {-2, -4};
            timeInSystem = 360;
            timeTillMaxEffect = 3;
            maxDose = 3;
            viscosityChange = -5;
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
        class Blood_O_1000: BloodIV {
            volume = 1000;
            ratio[] = {"Plasma", 1};
            type = "Blood";
            bloodtype = AMS_BLOODTYPE_O;
        };
        BLOODBAG_ENTRY(ON,1000);
        BLOODBAG_ENTRY(A,1000);
        BLOODBAG_ENTRY(AN,1000);
        BLOODBAG_ENTRY(B,1000);
        BLOODBAG_ENTRY(BN,1000);
        BLOODBAG_ENTRY(AB,1000);
        BLOODBAG_ENTRY(ABN,1000);

        class Blood_ON_500: Blood_O_1000 {
            volume = 500;
        };
        BLOODBAG_ENTRY(ON,500);
        BLOODBAG_ENTRY(A,500);
        BLOODBAG_ENTRY(AN,500);
        BLOODBAG_ENTRY(B,500);
        BLOODBAG_ENTRY(BN,500);
        BLOODBAG_ENTRY(AB,500);
        BLOODBAG_ENTRY(ABN,500);

        class Blood_ON_250: Blood_O_1000 {
            volume = 250;
        };
        BLOODBAG_ENTRY(ON,250);
        BLOODBAG_ENTRY(A,250);
        BLOODBAG_ENTRY(AN,250);
        BLOODBAG_ENTRY(B,250);
        BLOODBAG_ENTRY(BN,250);
        BLOODBAG_ENTRY(AB,250);
        BLOODBAG_ENTRY(ABN,250);
    };
};
