#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"
#include "\z\ace\addons\medical_engine\script_macros_medical.hpp"

// from ace
#define DFUNC(var1)       TRIPLES(ADDON,fnc,var1)
#define DEFUNC(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)

#undef QFUNC
#undef QEFUNC
#define QFUNC(var1) QUOTE(DFUNC(var1))
#define QEFUNC(var1,var2) QUOTE(DEFUNC(var1,var2))

#define GETVAR_SYS(var1,var2) getVariable [ARR_2(QUOTE(var1),var2)]
#define GETMVAR(var1,var2) (missionNamespace GETVAR_SYS(var1,var2))

// ACE3 reference macros
#define ACE_PREFIX ace

#define ACE_ADDON(component)        DOUBLES(ACE_PREFIX,component)

#define ACEGVAR(module,var)         TRIPLES(ACE_PREFIX,module,var)
#define QACEGVAR(module,var)        QUOTE(ACEGVAR(module,var))
#define QQACEGVAR(module,var)       QUOTE(QACEGVAR(module,var))

#define ACEFUNC(module,function)    TRIPLES(DOUBLES(ACE_PREFIX,module),fnc,function)
#define QACEFUNC(module,function)   QUOTE(ACEFUNC(module,function))

#define ACELSTRING(module,string)   QUOTE(TRIPLES(STR,DOUBLES(ACE_PREFIX,module),string))
#define ACELLSTRING(module,string)  localize ACELSTRING(module,string)
#define ACECSTRING(module,string)   QUOTE(TRIPLES($STR,DOUBLES(ACE_PREFIX,module),string))

#define ACEPATHTOF(component,path) \z\ace\addons\component\path
#define QACEPATHTOF(component,path) QUOTE(ACEPATHTOF(component,path))

#define DACEFUNC(module,var1) TRIPLES(module,fnc,var1)

#undef GETVAR
#define GETVAR(var1,var2,var3) (var1 GETVAR_SYS(var2,var3))

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#include "script_debug.hpp"

// Returns a text config entry as compiled code or variable from missionNamespace
#define GET_FUNCTION(var,cfg) \
    private var = getText (cfg); \
    if (isNil var) then { \
        var = compile var; \
    } else { \
        var = missionNamespace getVariable var; \
    }

// Returns a number config entry with default value of 0
// If entry is a string, will get the variable from missionNamespace
#define GET_NUMBER_ENTRY(cfg) \
    if (isText (cfg)) then { \
        missionNamespace getVariable [getText (cfg), 0]; \
    } else { \
        getNumber (cfg); \
    }

// Macros for checking if unit is in medical vehicle or facility
// Defined mostly to make location check in canTreat more readable
#define IN_MED_VEHICLE(unit)  (unit call FUNC(isInMedicalVehicle))
#define IN_MED_FACILITY(unit) (unit call FUNC(isInMedicalFacility))

#define TREATMENT_LOCATIONS_ALL 0
#define TREATMENT_LOCATIONS_VEHICLES 1
#define TREATMENT_LOCATIONS_FACILITIES 2
#define TREATMENT_LOCATIONS_VEHICLES_AND_FACILITIES 3
#define TREATMENT_LOCATIONS_NONE 4

#define LITTER_CLEANUP_CHECK_DELAY 30
#define BODY_CLEANUP_CHECK_DELAY 20

// Animations that would be played slower than this are instead played exactly as slow as this. (= Progress bar will take longer than the slowed down animation).
#define ANIMATION_SPEED_MIN_COEFFICIENT 0.5

// Animations that would be played faster than this are instead skipped. (= Progress bar too quick for animation).
#define ANIMATION_SPEED_MAX_COEFFICIENT 2.5

#define MEDICAL_TREATMENT_ITEMS (keys (uiNamespace getVariable QGVAR(treatmentItems)))

#define FATAL_INJURIES_ALWAYS 0
#define FATAL_INJURIES_CRDC_ARRST 1
#define FATAL_INJURIES_NEVER 2

// ace_dragging
#define CARRY_ANIMATIONS ["acinpercmstpsnonwnondnon", "acinpknlmstpsnonwnondnon_acinpercmrunsnonwnondnon"]
#define MAX_DRAGGED_ITEMS 3
#define MAX_LOAD_DISTANCE_MAN 5

// ace_medical_vitals
#define BASE_OXYGEN_USE -0.25

// ACE undefs

#undef GET_BLOOD_LOSS
#define GET_BLOOD_LOSS(unit)     ([unit] call ACEFUNC(medical_status,getBloodLoss))
#undef GET_BLOOD_PRESSURE       
#define GET_BLOOD_PRESSURE(unit) ([unit] call ACEFUNC(medical_status,getBloodPressure))
#undef VAR_BLOOD_PRESS
#define VAR_BLOOD_PRESS       QACEGVAR(medical,bloodPressure)
#undef VAR_BLOOD_VOL
#define VAR_BLOOD_VOL         QACEGVAR(medical,bloodVolume)
#undef VAR_WOUND_BLEEDING
#define VAR_WOUND_BLEEDING    QACEGVAR(medical,woundBleeding)
#undef VAR_CRDC_ARRST
#define VAR_CRDC_ARRST        QACEGVAR(medical,inCardiacArrest)
#undef VAR_HEART_RATE
#define VAR_HEART_RATE        QACEGVAR(medical,heartRate)
#undef VAR_SPO2
#define VAR_SPO2              QACEGVAR(medical,spo2)
#undef VAR_OXYGEN_DEMAND
#define VAR_OXYGEN_DEMAND     QACEGVAR(medical,oxygenDemand)
#undef VAR_PAIN
#define VAR_PAIN              QACEGVAR(medical,pain)
#undef VAR_PAIN_SUPP
#define VAR_PAIN_SUPP         QACEGVAR(medical,painSuppress)
#undef VAR_PERIPH_RES
#define VAR_PERIPH_RES        QACEGVAR(medical,peripheralResistance)
#undef VAR_OPEN_WOUNDS
#define VAR_OPEN_WOUNDS       QACEGVAR(medical,openWounds)
#undef VAR_BANDAGED_WOUNDS
#define VAR_BANDAGED_WOUNDS   QACEGVAR(medical,bandagedWounds)
#undef VAR_STITCHED_WOUNDS
#define VAR_STITCHED_WOUNDS   QACEGVAR(medical,stitchedWounds)
// These variables track gradual adjustments (from medication, etc.)
#undef VAR_MEDICATIONS
#define VAR_MEDICATIONS       QACEGVAR(medical,medications)
// These variables track the current state of status values above
#undef VAR_HEMORRHAGE
#define VAR_HEMORRHAGE        QACEGVAR(medical,hemorrhage)
#undef VAR_IN_PAIN
#define VAR_IN_PAIN           QACEGVAR(medical,inPain)
#undef VAR_TOURNIQUET
#define VAR_TOURNIQUET        QACEGVAR(medical,tourniquets)
#undef VAR_FRACTURES
#define VAR_FRACTURES         QACEGVAR(medical,fractures)

#undef GET_SM_STATE
#define GET_SM_STATE(unit)    ([unit, ACEGVAR(medical,STATE_MACHINE)] call CBA_statemachine_fnc_getCurrentState)

#undef PAIN_UNCONSCIOUS
#define PAIN_UNCONSCIOUS      ACEGVAR(medical,painUnconsciousThreshold)

#undef GET_DAMAGE_THRESHOLD
#define GET_DAMAGE_THRESHOLD(unit)  (unit getVariable [QACEGVAR(medical,damageThreshold), [ACEGVAR(medical,AIDamageThreshold),ACEGVAR(medical,playerDamageThreshold)] select (isPlayer unit)])

// ACM
#define ALL_BODY_PARTS_PRIORITY ["body", "head", "leftarm", "rightarm", "leftleg", "rightleg"]

#define SETTING_DROPDOWN_SKILL [0, 1, 2], [ACELLSTRING(Medical_Treatment,Anyone), ACELLSTRING(Medical_Treatment,Medics), ACELLSTRING(Medical_Treatment,Doctors)]
#define SETTING_DROPDOWN_LOCATION [0, 1, 2, 3, 4], [ACELSTRING(common,Anywhere), ACELSTRING(common,Vehicle), ACELSTRING(medical_treatment,MedicalFacilities), ACELSTRING(medical_treatment,VehiclesAndFacilities), ACELSTRING(common,Disabled)]

#define LYING_ANIMATION ["ainjppnemstpsnonwrfldnon", "acm_lyingstate"]

#define GET_BODYWEIGHT(unit) (unit getVariable [QEGVAR(core,BodyWeight), 80])

#define IDEAL_BODYWEIGHT 83

// Airway
#define GET_AIRWAYSTATE(unit) (unit getVariable [QEGVAR(airway,AirwayState), 1])

#define IN_RECOVERYPOSITION(unit) (unit getVariable [QQEGVAR(airway,RecoveryPosition_State), false])

// Breathing
#define ACM_BREATHING_MAXDECREASE 0.12

#define GET_BREATHINGSTATE(unit) (unit getVariable [QEGVAR(breathing,BreathingState), 1])

#define GET_OXYGEN(unit) (unit getVariable [VAR_SPO2, 99])

#define GET_RESPIRATION_RATE(unit) (unit getVariable [QEGVAR(breathing,RespirationRate), 18])

#define GET_PULSEOX(unit) (unit getVariable [QEGVAR(breathing,PulseOximeter_Placement),[false,false]])
#define HAS_PULSEOX(unit,index) (GET_PULSEOX(unit) select index)

#define ACM_OXYGEN_UNCONSCIOUS 80
#define ACM_OXYGEN_HYPOXIA 67
#define ACM_OXYGEN_DEATH 55

#define ACM_TENSIONHEMOTHORAX_THRESHOLD 1.2

#define GET_HEMOTHORAX_BLEEDRATE(unit) ([unit] call EFUNC(circulation,getHemothoraxBleedingRate))

// Circulation
#define GET_CIRCULATIONSTATE(unit) (unit getVariable [QEGVAR(circulation,CirculationState), false])

#define ACM_ASYSTOLE_BLOODVOLUME 3.1
#define ACM_REVERSIBLE_CA_BLOODVOLUME 4.2
#define ACM_CA_BLOODVOLUME 4

#define GET_EFF_BLOOD_VOLUME(unit) (6 min ((unit getVariable [QEGVAR(circulation,Blood_Volume), 6]) + (unit getVariable [QEGVAR(circulation,Plasma_Volume), 0]) * 0.3))

#define ACM_IV_16G_M 1
#define ACM_IV_14G_M 2
#define ACM_IO_FAST1_M 3
#define ACM_IO_EZ_M 4

#define ACM_ROUTE_IM 0
#define ACM_ROUTE_IV 1
#define ACM_ROUTE_PO 2
#define ACM_ROUTE_INHALE 3

#define ACM_SYRINGES_IM ['ACM_Syringe_IM','ACM_Syringe_IM_Epinephrine','ACM_Syringe_IM_Morphine','ACM_Syringe_IM_Ketamine','ACM_Syringe_IM_Lidocaine']
#define ACM_SYRINGES_IV ['ACM_Syringe_IV','ACM_Syringe_IV_Epinephrine','ACM_Syringe_IV_Morphine','ACM_Syringe_IV_Ketamine','ACM_Syringe_IV_Adenosine','ACM_Syringe_IV_Amiodarone','ACM_Syringe_IV_TXA']

#define GET_IV(unit) (unit getVariable [QEGVAR(circulation,IV_Placement),[0,0,0,0,0,0]])

#define GET_PRESSURECUFF(unit) (unit getVariable [QEGVAR(circulation,PressureCuff_Placement),[false,false]])
#define HAS_PRESSURECUFF(unit,index) (GET_PRESSURECUFF(unit) select index)

#define GET_BLOODTYPE(unit) (unit getVariable [QEGVAR(circulation,BloodType),-1])

#define ACM_BLOODTYPE_O 0
#define ACM_BLOODTYPE_ON 1
#define ACM_BLOODTYPE_A 2
#define ACM_BLOODTYPE_AN 3
#define ACM_BLOODTYPE_B 4
#define ACM_BLOODTYPE_BN 5
#define ACM_BLOODTYPE_AB 6
#define ACM_BLOODTYPE_ABN 7

#define BLOODTYPE_COMPATIBLE_LIST_O [ACM_BLOODTYPE_O, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_ON [ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_A [ACM_BLOODTYPE_A, ACM_BLOODTYPE_AN, ACM_BLOODTYPE_O, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_AN [ACM_BLOODTYPE_AN, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_B [ACM_BLOODTYPE_B, ACM_BLOODTYPE_BN, ACM_BLOODTYPE_O, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_BN [ACM_BLOODTYPE_BN, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_AB [ACM_BLOODTYPE_ABN, ACM_BLOODTYPE_ABN, ACM_BLOODTYPE_A, ACM_BLOODTYPE_AN, ACM_BLOODTYPE_B, ACM_BLOODTYPE_BN, ACM_BLOODTYPE_O, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST_ABN [ACM_BLOODTYPE_ABN, ACM_BLOODTYPE_AN, ACM_BLOODTYPE_BN, ACM_BLOODTYPE_ON]
#define BLOODTYPE_COMPATIBLE_LIST [BLOODTYPE_COMPATIBLE_LIST_O,BLOODTYPE_COMPATIBLE_LIST_ON,BLOODTYPE_COMPATIBLE_LIST_A,BLOODTYPE_COMPATIBLE_LIST_AN,BLOODTYPE_COMPATIBLE_LIST_B,BLOODTYPE_COMPATIBLE_LIST_BN,BLOODTYPE_COMPATIBLE_LIST_AB,BLOODTYPE_COMPATIBLE_LIST_ABN]

// Damage
#define VAR_WRAPPED_WOUNDS             QEGVAR(damage,WrappedWounds)
#define GET_WRAPPED_WOUNDS(unit)       (unit getVariable [VAR_WRAPPED_WOUNDS, createHashMap])
#define VAR_CLOTTED_WOUNDS             QEGVAR(damage,ClottedWounds)
#define GET_CLOTTED_WOUNDS(unit)       (unit getVariable [VAR_CLOTTED_WOUNDS, createHashMap])

#define VAR_INTERNAL_BLEEDING          QEGVAR(damage,InternalBleeding)
#define GET_INTERNAL_BLEEDING(unit)    (unit getVariable [VAR_INTERNAL_BLEEDING, 0])
#define IS_I_BLEEDING(unit)            (GET_INTERNAL_BLEEDING(unit) > 0)
#define GET_INTERNAL_BLEEDRATE(unit)   ([unit] call EFUNC(circulation,getInternalBleedingRate))

#define VAR_INTERNAL_WOUNDS            QEGVAR(damage,InternalWounds)
#define GET_INTERNAL_WOUNDS(unit)      (unit getVariable [VAR_INTERNAL_WOUNDS, createHashMap])

// Disability
#define DEFAULT_SPLINT_VALUES          [0,0,0,0,0,0]
#define VAR_SPLINTS                    QEGVAR(disability,SplintStatus)
#define GET_SPLINTS(unit)              (unit getVariable [VAR_SPLINTS, DEFAULT_SPLINT_VALUES])

// Misc
#define ACM_TARGETVITALS_HR(unit) (unit getVariable [QEGVAR(core,TargetVitals_HeartRate), 77])
#define ACM_TARGETVITALS_MAXHR(unit) (unit getVariable [QEGVAR(core,TargetVitals_MaxHeartRate), 200])
#define ACM_TARGETVITALS_OXYGEN(unit) (unit getVariable [QEGVAR(core,TargetVitals_OxygenSaturation), 99])
#define ACM_TARGETVITALS_RR(unit) (unit getVariable [QEGVAR(core,TargetVitals_RespirationRate), 18])