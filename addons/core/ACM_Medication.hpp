class ACM_Medication {
    class Medication {
        class Ammonia {
            vitalsFunction = QEFUNC(circulation,effectVitalsAmmonia);
            effectFunction = QEFUNC(circulation,effectAmmonia);
            eliminatePhase = 30;
            minimumConcentration = 25;
            class Inhale {
                absorbPhase = 3;
                maintainPhase = 15;
            };
        };
        class Adenosine {
            vitalsFunction = QEFUNC(circulation,effectVitalsAdenosine);
            effectFunction = QEFUNC(circulation,effectAdenosine);
            eliminatePhase = 45;
            minimumConcentration = 4;
            class IV {
                absorbPhase = 10;
                maintainPhase = 45;
            };
            class Vial {
                dose = 12;
                volume = 4;
                doseString = "12mg/4ml";
            };
        };
        class Amiodarone {
            vitalsFunction = QEFUNC(circulation,effectVitalsAmiodarone);
            effectFunction = QEFUNC(circulation,effectAmiodarone);
            eliminatePhase = 900;
            minimumConcentration = 150;
            class IV {
                absorbPhase = 10;
                maintainPhase = 720;
            };
            class Vial {
                dose = 150;
                volume = 3;
                doseString = "150mg/3ml";
            };
        };
        class Atropine {
            vitalsFunction = QEFUNC(circulation,effectVitalsAtropine);
            effectFunction = QEFUNC(circulation,effectAtropine);
            eliminatePhase = 600;
            minimumConcentration = 0.1;
            class IV {
                absorbPhase = 3;
                maintainPhase = 1200;
            };
            class IM {
                maximumConcentration = 10;
                absorbPhase = 30;
                maintainPhase = 1500;
            };
            class Vial {
                dose = 1;
                volume = 1;
                doseString = "1mg/1ml";
            };
        };
        class CalciumChloride {
            vitalsFunction = QEFUNC(circulation,effectVitalsCalciumChloride);
            effectFunction = QEFUNC(circulation,effectCalciumChloride);
            eliminatePhase = 600;
            minimumConcentration = 700;
            class IV {
                absorbPhase = 10;
                maintainPhase = 600;
            };
            class Vial {
                dose = 1000;
                volume = 10;
                doseString = "1g/10ml";
            };
        };
        class Epinephrine {
            vitalsFunction = QEFUNC(circulation,effectVitalsEpinephrine);
            eliminatePhase = 300;
            minimumConcentration = 0.25;
            class IV {
                absorbPhase = 3;
                maintainPhase = 300;
            };
            class IM {
                availability = 0.9;
                absorbPhase = 30;
                maintainPhase = 420;
            };
            class Vial {
                dose = 1;
                volume = 1;
                doseString = "1mg/1ml";
            };
        };
        class Ertapenem {
            //vitalsFunction = QEFUNC(circulation,effectVitalsErtapenem);
            eliminatePhase = 600;
            //minimumConcentration = 900;
            class IV {
                absorbPhase = 3;
                maintainPhase = 1200;
            };
            class IM {
                absorbPhase = 30;
                maintainPhase = 1800;
            };
            class Vial {
                dose = 1000;
                volume = 3.2;
                doseString = "1g/3.2ml";
            };
        };
        class Esmolol {
            vitalsFunction = QEFUNC(circulation,effectVitalsEsmolol);
            eliminatePhase = 120;
            minimumConcentration = 18;
            class IV {
                absorbPhase = 3;
                maintainPhase = 480;
            };
            class Vial {
                dose = 100;
                volume = 10;
                doseString = "100mg/10ml";
            };
        };
        class Fentanyl {
            vitalsFunction = QEFUNC(circulation,effectVitalsFentanyl);
            effectFunction = QEFUNC(circulation,effectFentanyl);
            isOpioid = 1;
            isMicroDose = 1;
            eliminatePhase = 600;
            minimumConcentration = 30; // mcg
            class IV {
                absorbPhase = 3;
                maintainPhase = 900;
            };
            class IM {
                availability = 0.7;
                absorbPhase = 45;
                maintainPhase = 1200;
            };
            class BUCC {
                absorbPhase = 90;
                maintainPhase = 1800;
            };
            class Vial {
                dose = 100; // mcg
                volume = 2;
                doseString = "100mcg/2ml";
            };
        };
        class Ketamine {
            vitalsFunction = QEFUNC(circulation,effectVitalsKetamine);
            effectFunction = QEFUNC(circulation,effectKetamine);
            eliminatePhase = 300;
            minimumConcentration = 7;
            class IV {
                absorbPhase = 15;
                maintainPhase = 600;
            };
            class IM {
                availability = 0.9;
                absorbPhase = 60;
                maintainPhase = 900;
            };
            class Vial {
                dose = 500;
                volume = 10;
                doseString = "500mg/10ml";
            };
        };
        class Lidocaine {
            vitalsFunction = QEFUNC(circulation,effectVitalsLidocaine);
            effectFunction = QEFUNC(circulation,effectLidocaine);
            eliminatePhase = 300;
            minimumConcentration = 30;
            class IV {
                absorbPhase = 3;
                maintainPhase = 600;
            };
            class IM {
                absorbPhase = 15;
                maintainPhase = 900;
            };
            class Vial {
                dose = 100;
                volume = 5;
                doseString = "100mg/5ml";
            };
        };
        class Methoxyflurane {
            vitalsFunction = QEFUNC(circulation,effectVitalsMethoxyflurane);
            eliminatePhase = 30;
            minimumConcentration = 0.5;
            class Inhale {
                absorbPhase = 3;
                maintainPhase = 60;
            };
        };
        class Midazolam {
            //vitalsFunction = QEFUNC(circulation,effectVitalsMidazolam);
            eliminatePhase = 300;
            minimumConcentration = 0.25;
            class IV {
                absorbPhase = 3;
                maintainPhase = 600;
            };
            class IM {
                availability = 0.9;
                absorbPhase = 30;
                maintainPhase = 900;
            };
            class Vial {
                dose = 50;
                volume = 10;
                doseString = "50mg/10ml";
            };
        };
        class Morphine {
            vitalsFunction = QEFUNC(circulation,effectVitalsMorphine);
            effectFunction = QEFUNC(circulation,effectMorphine);
            isOpioid = 1;
            eliminatePhase = 1200;
            minimumConcentration = 2;
            class IV {
                absorbPhase = 45;
                maintainPhase = 1200;
            };
            class IM {
                availability = 0.7;
                absorbPhase = 120;
                maintainPhase = 2100;
            };
            class Vial {
                dose = 10;
                volume = 2;
                doseString = "10mg/2ml";
            };
        };
        class Naloxone {
            //vitalsFunction = QEFUNC(circulation,effectVitalsNaloxone);
            eliminatePhase = 300;
            //minimumConcentration = 1;
            class IV {
                absorbPhase = 3;
                maintainPhase = 960;
            };
            class IM {
                availability = 0.9;
                absorbPhase = 30;
                maintainPhase = 1200;
            };
            class Inhale {
                availability = 0.5;
                absorbPhase = 15;
                maintainPhase = 600;
            };
            class Vial {
                dose = 4;
                volume = 10;
                doseString = "4mg/10ml";
            };
        };
        class Ondansetron {
            vitalsFunction = QEFUNC(circulation,effectVitalsOndansetron);
            eliminatePhase = 300;
            minimumConcentration = 3.5;
            class IV {
                absorbPhase = 15;
                maintainPhase = 840;
            };
            class IM {
                absorbPhase = 45;
                maintainPhase = 1440;
            };
            class Vial {
                dose = 4;
                volume = 2;
                doseString = "4mg/2ml";
            };
        };
        class Paracetamol {
            vitalsFunction = QEFUNC(circulation,effectVitalsParacetamol);
            effectFunction = QEFUNC(circulation,effectParacetamol);
            eliminatePhase = 3600;
            minimumConcentration = 300;
            class PO {
                absorbPhase = 300;
                maintainPhase = 2400;
            };
        };
        class TXA {
            vitalsFunction = QEFUNC(circulation,effectVitalsTXA);
            effectFunction = QEFUNC(circulation,effectTXA);
            eliminatePhase = 300;
            minimumConcentration = 900;
            class IV {
                absorbPhase = 10;
                maintainPhase = 900;
            };
            class IM {
                availability = 0.55;
                absorbPhase = 90;
                maintainPhase = 1200;
            };
            class Vial {
                dose = 1000;
                volume = 10;
                doseString = "1g/10ml";
            };
        };
    };
};