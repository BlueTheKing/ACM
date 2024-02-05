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

// Airway
#define IN_RECOVERYPOSITION(unit) (unit getVariable [QQEGVAR(airway,RecoveryPosition_State), false])

// Breathing
#define GET_OXYGEN(unit) (unit getVariable [QEGVAR(breathing,OxygenSaturation),0])
#define GET_PULSEOX(unit) (unit getVariable [QEGVAR(breathing,PulseOximeter_Placement),[false,false]])
#define HAS_PULSEOX(unit,index) (GET_PULSEOX(unit) select index)

// Circulation
#define GET_IV(unit) (unit getVariable [QEGVAR(circulation,IV_Placement),[0,0,0,0,0,0]])

// Damage
#define VAR_WRAPPED_WOUNDS             QEGVAR(damage,WrappedWounds)
#define GET_WRAPPED_WOUNDS(unit)       (unit getVariable [VAR_WRAPPED_WOUNDS, createHashMap])
#define VAR_CLOTTED_WOUNDS             QEGVAR(damage,ClottedWounds)
#define GET_CLOTTED_WOUNDS(unit)       (unit getVariable [VAR_CLOTTED_WOUNDS, createHashMap])

// Disability
#define DEFAULT_SPLINT_VALUES          [0,0,0,0,0,0]
#define VAR_SPLINTS                    QEGVAR(disability,SplintStatus)
#define GET_SPLINTS(unit)              (unit getVariable [VAR_SPLINTS, DEFAULT_SPLINT_VALUES])