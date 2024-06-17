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
