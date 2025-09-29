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

// CBA reference macros
#define CBA_PREFIX cba

#define CBA_EGVAR(module,var)       TRIPLES(CBA_PREFIX,module,var)

#define CBA_FUNC(function)          TRIPLES(CBA_PREFIX,fnc,function)

#define CBAPATHTOF(component,path)  \x\cba\addons\component\path
#define QCBAPATHTOF(component,path) QUOTE(CBAPATHTOF(component,path))

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

#define GETACEGVAR(var1,var2,var3) GETMVAR(ACEGVAR(var1,var2),var3)

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
#undef VAR_BODYPART_DAMAGE
#define VAR_BODYPART_DAMAGE   QACEGVAR(medical,bodyPartDamage)
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

#undef HEAD_DAMAGE_THRESHOLD
#define HEAD_DAMAGE_THRESHOLD ACEGVAR(medical,const_headDamageThreshold)
#undef ORGAN_DAMAGE_THRESHOLD
#define ORGAN_DAMAGE_THRESHOLD ACEGVAR(medical,const_organDamageThreshold)
#undef FATAL_SUM_DAMAGE_WEIBULL_K
#define FATAL_SUM_DAMAGE_WEIBULL_K ACEGVAR(medical,const_fatalSumDamageWeibull_K)
#undef FATAL_SUM_DAMAGE_WEIBULL_L
#define FATAL_SUM_DAMAGE_WEIBULL_L ACEGVAR(medical,const_fatalSumDamageWeibull_L)
#undef HEART_HIT_CHANCE
#define HEART_HIT_CHANCE ACEGVAR(medical,const_heartHitChance)
#undef MINIMUM_BLOOD_FOR_STABLE_VITALS
#define MINIMUM_BLOOD_FOR_STABLE_VITALS ACEGVAR(medical,const_stableVitalsBloodThreshold)
#undef PENETRATION_THRESHOLD
#define PENETRATION_THRESHOLD ACEGVAR(medical,const_penetrationThreshold)
#undef BLOOD_LOSS_KNOCK_OUT_THRESHOLD
#define BLOOD_LOSS_KNOCK_OUT_THRESHOLD ACEGVAR(medical,const_bloodLossKnockOutThreshold)
#undef PAIN_FADE_TIME
#define PAIN_FADE_TIME ACEGVAR(medical,const_painFadeTime)
#undef SPONTANEOUS_WAKE_UP_INTERVAL
#define SPONTANEOUS_WAKE_UP_INTERVAL ACEGVAR(medical,const_wakeUpCheckInterval)
#undef LIMPING_DAMAGE_THRESHOLD
#define LIMPING_DAMAGE_THRESHOLD ACEGVAR(medical,const_limpingDamageThreshold)
#undef FRACTURE_DAMAGE_THRESHOLD
#define FRACTURE_DAMAGE_THRESHOLD ACEGVAR(medical,const_fractureDamageThreshold)
#undef CARDIAC_OUTPUT_MIN
#define CARDIAC_OUTPUT_MIN ACEGVAR(medical,const_minCardiacOutput)

// ACM
#define ACM_INCOMPATIBLE_ADDONS [["pir","Project Injury Reaction"],["kat_main","KAT Advanced Medical"],["MIRA_Vehicle_Medical","ACE Vehicle Medical"],["KJW_MedicalExpansion_core", "KJW's Medical Expansion"],["CBRN_scripts","Chemical Warfare PLUS"]]

#define ALL_BODY_PARTS_PRIORITY ["body", "head", "leftarm", "rightarm", "leftleg", "rightleg"]

#define GET_BODYPART_INDEX(bodypart) (ALL_BODY_PARTS find toLowerANSI bodypart)

#define SETTING_DROPDOWN_SKILL [0, 1, 2], [ACELLSTRING(Medical_Treatment,Anyone), ACELLSTRING(Medical_Treatment,Medics), ACELLSTRING(Medical_Treatment,Doctors)]
#define SETTING_DROPDOWN_LOCATION [0, 1, 2, 3, 4], [ACELSTRING(common,Anywhere), ACELSTRING(common,Vehicle), ACELSTRING(medical_treatment,MedicalFacilities), ACELSTRING(medical_treatment,VehiclesAndFacilities), ACELSTRING(common,Disabled)]

#define LYING_ANIMATION ["ainjppnemstpsnonwrfldnon", "acm_lyingstate"]

#define IN_LYING_STATE(unit) (unit getVariable [QEGVAR(core,Lying_State), false])

#define GET_BODYWEIGHT(unit) (unit getVariable [QEGVAR(core,BodyWeight), 80])

#define IDEAL_BODYWEIGHT 83

#define IN_CRITICAL_STATE(unit) (unit getVariable [QEGVAR(core,CriticalVitals_State), false])

#define ACM_WOUNDS ["ChemicalBurn"]

// Body Parts
#define BODYPART_N_HEAD     0
#define BODYPART_N_BODY     1
#define BODYPART_N_LEFTARM  2
#define BODYPART_N_RIGHTARM 3
#define BODYPART_N_LEFTLEG  4
#define BODYPART_N_RIGHTLEG 5

// Airway
#define GET_AIRWAYSTATE(unit) ([unit] call EFUNC(airway,getAirwayState))

#define IN_RECOVERYPOSITION(unit) (unit getVariable [QQEGVAR(airway,RecoveryPosition_State), false])

#define GET_AIRWAYADJUNCT_ORAL(unit)  (unit getVariable [QEGVAR(airway,AirwayItem_Oral), ""])
#define GET_AIRWAYADJUNCT_NASAL(unit) (unit getVariable [QEGVAR(airway,AirwayItem_Nasal), ""])

#define HAS_SURGICAL_AIRWAY(unit) (unit getVariable [QEGVAR(airway,SurgicalAirway_State), false])

#define GET_SURGICAL_AIRWAY_BLEEDRATE(unit) ([unit] call EFUNC(airway,getAirwayIncisionBleedRate))

// Breathing
#define ACM_BREATHING_MINDECREASE 0.1
#define ACM_BREATHING_MAXDECREASE 0.12

#define GET_BREATHINGSTATE(unit) ([unit] call EFUNC(breathing,getBreathingState))

#define GET_OXYGEN(unit) (unit getVariable [VAR_SPO2, 99])

#define GET_RESPIRATION_RATE(unit) (unit getVariable [QEGVAR(breathing,RespirationRate), 18])

#define GET_PULSEOX(unit) (unit getVariable [QEGVAR(breathing,PulseOximeter_Placement),[false,false]])
#define HAS_PULSEOX(unit,index) (GET_PULSEOX(unit) select index)

#define ACM_CYANOSIS_T_SLIGHT   91
#define ACM_CYANOSIS_T_MODERATE 82
#define ACM_CYANOSIS_T_SEVERE   67

#define ACM_OXYGEN_VISION 85

#define ACM_OXYGEN_UNCONSCIOUS 80
#define ACM_OXYGEN_HYPOXIA 67
#define ACM_OXYGEN_DEATH 55

#define ACM_TENSIONHEMOTHORAX_THRESHOLD 1.2

#define GET_HEMOTHORAX_BLEEDRATE(unit) ([unit] call EFUNC(circulation,getHemothoraxBleedingRate))

// Circulation
#define GET_CIRCULATIONSTATE(unit) (unit getVariable [QEGVAR(circulation,CirculationState), true])
#define HAS_PULSE(unit) ([unit] call EFUNC(circulation,hasPulse))
#define HAS_PULSE_P(unit) ([unit, true] call EFUNC(circulation,hasPulse))

#define ACM_ASYSTOLE_BLOODVOLUME 3.1
#define ACM_REVERSIBLE_CA_BLOODVOLUME 4.2
#define ACM_CA_BLOODVOLUME 4

#define GET_EFF_BLOOD_VOLUME(unit) (6 min ((unit getVariable [QEGVAR(circulation,Blood_Volume), 6]) + ((unit getVariable [QEGVAR(circulation,Plasma_Volume), 0]) * 0.3) - (unit getVariable [QEGVAR(circulation,Overload_Volume), 0])) max 0)
#define GET_PLATELET_COUNT(unit) (unit getVariable [QEGVAR(circulation,Platelet_Count), 3])

#define GET_MAP(systolic,diastolic) (diastolic + ((systolic - diastolic) / 3))
#define GET_MAP_PATIENT(unit) ([unit] call EFUNC(circulation,getMAP))

#define GET_VASOCONSTRICTION(unit) (unit getVariable [QEGVAR(circulation,Vasoconstriction_State), 0])

#define ACM_Rhythm_NA -5
#define ACM_Rhythm_CPR -1
#define ACM_Rhythm_Sinus 0
#define ACM_Rhythm_Asystole 1
#define ACM_Rhythm_VF 2
#define ACM_Rhythm_PVT 3
#define ACM_Rhythm_VT 4
#define ACM_Rhythm_PEA 5

#define GET_PRESSURECUFF(unit) (unit getVariable [QEGVAR(circulation,PressureCuff_Placement),[false,false]])
#define HAS_PRESSURECUFF(unit,index) (GET_PRESSURECUFF(unit) select index)

#define IS_OVERDOSED(unit) ([unit] call EFUNC(circulation,isOverdosed))

//// Access
#define ACM_IV_16G_M 1
#define ACM_IV_14G_M 2
#define ACM_IO_EZ_M 3
#define ACM_IO_FAST1_M 4

#define ACM_IV_P_SITE_DEFAULT_0 [0,0,0]
#define ACM_IV_P_SITE_DEFAULT_1 [1,1,1]
#define ACM_IV_PLACEMENT_DEFAULT_0 [ACM_IV_P_SITE_DEFAULT_0,ACM_IV_P_SITE_DEFAULT_0,ACM_IV_P_SITE_DEFAULT_0,ACM_IV_P_SITE_DEFAULT_0,ACM_IV_P_SITE_DEFAULT_0,ACM_IV_P_SITE_DEFAULT_0]
#define ACM_IV_PLACEMENT_DEFAULT_1 [ACM_IV_P_SITE_DEFAULT_1,ACM_IV_P_SITE_DEFAULT_1,ACM_IV_P_SITE_DEFAULT_1,ACM_IV_P_SITE_DEFAULT_1,ACM_IV_P_SITE_DEFAULT_1,ACM_IV_P_SITE_DEFAULT_1]
#define ACM_IO_PLACEMENT_DEFAULT_0 [0,0,0,0,0,0]
#define ACM_IO_PLACEMENT_DEFAULT_1 [1,1,1,1,1,1]

#define GET_IV(unit) (unit getVariable [QEGVAR(circulation,IV_Placement),ACM_IV_PLACEMENT_DEFAULT_0])
#define GET_IO(unit) (unit getVariable [QEGVAR(circulation,IO_Placement),ACM_IO_PLACEMENT_DEFAULT_0])

#define VAR_FLUIDBAG_FLOW_IV          QEGVAR(circulation,FluidBagsFlow_IV)
#define VAR_FLUIDBAG_FLOW_IO          QEGVAR(circulation,FluidBagsFlow_IO)

#define GET_IV_FLOW(unit)             (unit getVariable [VAR_FLUIDBAG_FLOW_IV, ACM_IV_PLACEMENT_DEFAULT_1])
#define GET_IV_FLOW_X(unit,part,site) ((GET_IV_FLOW(unit) select part) select site)

#define GET_IO_FLOW(unit)             (unit getVariable [VAR_FLUIDBAG_FLOW_IO, ACM_IO_PLACEMENT_DEFAULT_1])
#define GET_IO_FLOW_X(unit,part)      (GET_IO_FLOW(unit) select part)

//// Complications

#define ACM_IV_COMPLICATION_THRESHOLD_14_L 0
#define ACM_IV_COMPLICATION_THRESHOLD_14_H 6
#define ACM_IV_COMPLICATION_THRESHOLD_16_L 5
#define ACM_IV_COMPLICATION_THRESHOLD_16_H 10

#define ACM_IV_COMPLICATION_FLOW_THRESHOLD_14 3
#define ACM_IV_COMPLICATION_FLOW_THRESHOLD_16 8
#define ACM_IV_COMPLICATION_LEAK_THRESHOLD    8

#define ACM_IV_COMPLICATION_FLOW_SLOW 1
#define ACM_IV_COMPLICATION_FLOW_LOSS 2

#define VAR_IV_COMPLICATIONS_PAIN                    QEGVAR(circulation,IV_Complication_Placement_Pain)
#define VAR_IV_COMPLICATIONS_FLOW                    QEGVAR(circulation,IV_Complication_Placement_Flow)
#define VAR_IV_COMPLICATIONS_BLOCK                   QEGVAR(circulation,IV_Complication_Placement_Block)

#define GET_IV_COMPLICATIONS_PAIN(unit)              (unit getVariable [VAR_IV_COMPLICATIONS_PAIN,ACM_IV_PLACEMENT_DEFAULT_0])
#define GET_IV_COMPLICATIONS_FLOW(unit)              (unit getVariable [VAR_IV_COMPLICATIONS_FLOW,ACM_IV_PLACEMENT_DEFAULT_0])
#define GET_IV_COMPLICATIONS_BLOCK(unit)             (unit getVariable [VAR_IV_COMPLICATIONS_BLOCK,ACM_IV_PLACEMENT_DEFAULT_0])

#define GET_IV_COMPLICATIONS_PAIN_X(unit,part,site)  ((GET_IV_COMPLICATIONS_PAIN(unit) select part) select site)
#define GET_IV_COMPLICATIONS_FLOW_X(unit,part,site)  ((GET_IV_COMPLICATIONS_FLOW(unit) select part) select site)
#define GET_IV_COMPLICATIONS_BLOCK_X(unit,part,site) ((GET_IV_COMPLICATIONS_BLOCK(unit) select part) select site)

//// Medication
#define ACM_ROUTE_IM 0
#define ACM_ROUTE_IV 1
#define ACM_ROUTE_PO 2
#define ACM_ROUTE_INHALE 3

#define ACM_MEDICATION_VIALS EGVAR(circulation,MedicationVialList)

#define ACM_SYRINGES_10 EGVAR(circulation,SyringeList_10)
#define ACM_SYRINGES_5 EGVAR(circulation,SyringeList_5)
#define ACM_SYRINGES_3 EGVAR(circulation,SyringeList_3)
#define ACM_SYRINGES_1 EGVAR(circulation,SyringeList_13)

//// Blood
#define GET_BLOODTYPE(unit) (unit getVariable [QEGVAR(circulation,BloodType),-1])

#define ACM_BLOODTYPE_O   0
#define ACM_BLOODTYPE_ON  1
#define ACM_BLOODTYPE_A   2
#define ACM_BLOODTYPE_AN  3
#define ACM_BLOODTYPE_B   4
#define ACM_BLOODTYPE_BN  5
#define ACM_BLOODTYPE_AB  6
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

//// Transfusion
#define FLUIDS_ARRAY ['ACE_salineIV','ACE_plasmaIV','ACE_salineIV_500','ACE_plasmaIV_500','ACE_salineIV_250','ACE_plasmaIV_250']
#define FLUIDS_ARRAY_DATA ['salineIV','plasmaIV','salineIV_500','plasmaIV_500','salineIV_250','plasmaIV_250']

#define FBTK_ARRAY ['ACM_FieldBloodTransfusionKit_500','ACM_FieldBloodTransfusionKit_250']
#define FBTK_ARRAY_DATA ['FieldBloodTransfusionKit_500','FieldBloodTransfusionKit_250']

// Damage
#define VAR_WRAPPED_WOUNDS                  QEGVAR(damage,WrappedWounds)
#define GET_WRAPPED_WOUNDS(unit)            (unit getVariable [VAR_WRAPPED_WOUNDS, createHashMap])
#define VAR_CLOTTED_WOUNDS                  QEGVAR(damage,ClottedWounds)
#define GET_CLOTTED_WOUNDS(unit)            (unit getVariable [VAR_CLOTTED_WOUNDS, createHashMap])

#define VAR_INTERNAL_BLEEDING               QEGVAR(damage,InternalBleeding)
#define GET_INTERNAL_BLEEDING(unit)         (unit getVariable [VAR_INTERNAL_BLEEDING, 0])
#define IS_I_BLEEDING(unit)                 (GET_INTERNAL_BLEEDING(unit) > 0)
#define GET_INTERNAL_BLEEDRATE(unit)        ([unit] call EFUNC(circulation,getInternalBleedingRate))

#define GET_CAPILLARYDAMAGE_BLEEDRATE(unit) ([unit] call EFUNC(circulation,getCapillaryDamageBleedingRate))

#define INTERNAL_WOUND_TYPES           [10,20,30,60,70]

#define VAR_INTERNAL_WOUNDS            QEGVAR(damage,InternalWounds)
#define GET_INTERNAL_WOUNDS(unit)      (unit getVariable [VAR_INTERNAL_WOUNDS, createHashMap])

// Disability
#define DEFAULT_SPLINT_VALUES          [0,0,0,0,0,0]
#define VAR_SPLINTS                    QEGVAR(disability,SplintStatus)
#define GET_SPLINTS(unit)              (unit getVariable [VAR_SPLINTS, DEFAULT_SPLINT_VALUES])

#define DEFAULT_TOURNIQUET_NECROSIS     [0,0,0,0]
#define VAR_TOURNIQUET_NECROSIS         QEGVAR(disability,TourniquetEffects_Necrosis)
#define GET_TOURNIQUET_NECROSIS(unit)   (unit getVariable [VAR_TOURNIQUET_NECROSIS, DEFAULT_TOURNIQUET_NECROSIS])
#define VAR_TOURNIQUET_NECROSIS_T       QEGVAR(disability,TourniquetEffects_Necrosis_Threshold)
#define GET_TOURNIQUET_NECROSIS_T(unit) (unit getVariable [VAR_TOURNIQUET_NECROSIS_T, DEFAULT_TOURNIQUET_NECROSIS])

#define NECROSIS_THRESHOLD_SEVERE       0.9
#define NECROSIS_THRESHOLD_SEVERELOW    0.8
#define NECROSIS_THRESHOLD_MODERATE     0.5
#define NECROSIS_THRESHOLD_MODERATELOW  0.4
#define NECROSIS_THRESHOLD_LIGHT        0.1
#define NECROSIS_THRESHOLD_LIGHTLOW     0.05

#define ACM_FRACTURE_MILD               1
#define ACM_FRACTURE_SEVERE             2
#define ACM_FRACTURE_COMPLEX            3

#define FRACTURE_THRESHOLD_MILD         3
#define FRACTURE_THRESHOLD_SEVERE       5
#define FRACTURE_THRESHOLD_COMPLEX      7

// Evacuation
#define ALL_SIDES [west, east, resistance]

#define GET_SIDE(num) (ALL_SIDES select num)
#define GET_SIDE_NUM(side) (ALL_SIDES find side)

#define GET_REINFORCE_POINT(side) ([EGVAR(evacuation,ReinforcePoint_BLUFOR), EGVAR(evacuation,ReinforcePoint_REDFOR), EGVAR(evacuation,ReinforcePoint_GREENFOR)] select side)

#define GET_NAMESPACE_TICKETCOUNT(side) ([QEGVAR(evacuation,CasualtyTicket_Count_BLUFOR), QEGVAR(evacuation,CasualtyTicket_Count_REDFOR), QEGVAR(evacuation,CasualtyTicket_Count_GREENFOR)] select side)

// CBRN
#define QGVAR_BUILDUP(type)                        QEGVAR(CBRN,##type##_Buildup)

#define DEFAULT_FILTER_CONDITION                   600
#define GET_FILTER_CONDITION(unit)                 (unit getVariable [QEGVAR(CBRN,Filter_State), DEFAULT_FILTER_CONDITION])

#define IS_EXPOSED(unit)                           (unit getVariable [QEGVAR(CBRN,Exposed_State), false])
#define IS_EXPOSEDTO(unit,hazard)                  (unit getVariable [QEGVAR(CBRN,##hazard##_Exposed_State), false])
#define IS_EXPOSED_EXT(unit)                       (unit getVariable [QEGVAR(CBRN,Exposed_External_State), false])
#define IS_EXPOSED_EXTTO(unit,hazard)              (unit getVariable [QEGVAR(CBRN,##hazard##_Exposed_External_State), false])
#define GET_EXPOSURE_BREATHINGSTATE(unit)          (unit getVariable [QEGVAR(CBRN,BreathingAbility_State), 1])
#define GET_EXPOSURE_BREATHING_INCREASESTATE(unit) (unit getVariable [QEGVAR(CBRN,BreathingAbility_Increase_State), 1])

#define IS_CONTAMINATED(unit)                      (unit getVariable [QEGVAR(CBRN,Contaminated_State), false])
#define IS_CONTAMINATEDBY(unit,hazard)             (unit getVariable [QEGVAR(CBRN,##hazard##_Contaminated_State), false])

#define GET_AIRWAY_INFLAMMATION(unit)              (unit getVariable [QEGVAR(CBRN,AirwayInflammation), 0])

#define AIRWAY_INFLAMMATION_THRESHOLD_SEVERE       70
#define AIRWAY_INFLAMMATION_THRESHOLD_SERIOUS      40
#define AIRWAY_INFLAMMATION_THRESHOLD_MILD         15

#define GET_LUNG_TISSUEDAMAGE(unit)                (unit getVariable [QEGVAR(CBRN,LungTissueDamage), 0])

#define LUNG_TISSUEDAMAGE_THRESHOLD_MILD           20

#define GET_CAPILLARY_DAMAGE(unit)                (unit getVariable [QEGVAR(CBRN,CapillaryDamage), 0])

#define HAS_AIRWAY_SPASM(unit)                    (unit getVariable [QEGVAR(CBRN,AirwaySpasm), false])
#define HAS_AIRWAY_SPASM_UNMITIGATED(unit)        (HAS_AIRWAY_SPASM(unit) && (([_patient, 'Atropine', false] call ACEFUNC(medical_status,getMedicationCount)) + ([_patient, 'Atropine_IV', false] call ACEFUNC(medical_status,getMedicationCount)) < 3))

#define IS_BLINDED(unit)                          (unit getVariable [QEGVAR(CBRN,Blindness_State), false])

// GUI
#define COLOR_CIRCULATION              {0.2, 0.65, 0.2, 1}

#define NORMALIZE_SIZEEX               (0.55 / (getResolution select 5))
#define NORMALIZE_UISCALE              ((0.55 / (getResolution select 5)) min 1)

// Misc
#define ACM_TARGETVITALS_HR(unit) (unit getVariable [QEGVAR(core,TargetVitals_HeartRate), 77])
#define ACM_TARGETVITALS_MAXHR(unit) (unit getVariable [QEGVAR(core,TargetVitals_MaxHeartRate), 200])
#define ACM_TARGETVITALS_OXYGEN(unit) (unit getVariable [QEGVAR(core,TargetVitals_OxygenSaturation), 99])
#define ACM_TARGETVITALS_RR(unit) (unit getVariable [QEGVAR(core,TargetVitals_RespirationRate), 18])