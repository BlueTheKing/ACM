#define COMPONENT core
#define COMPONENT_BEAUTIFIED Core
#include "\x\ACM\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_CORE
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_CORE
#endif

#include "\x\ACM\addons\main\script_macros.hpp"

// CfgReplacementItems.hpp
#define TYPE_FIRST_AID_KIT 401
#define TYPE_MEDIKIT 619

#define SM_QACEFUNC(module,function) QUOTE(_this call ACEFUNC(module,function)) // statemachine stuff

#define CBA_QEGVAR(module,var)     QUOTE(TRIPLES(CBA,module,var))
#define CBA_EFUNC(module,function) TRIPLES(DOUBLES(CBA,module),fnc,function)

#define TRANSITIONS(var) (var + "_transitions")
#define EVENTTRANSITIONS(var) (var + "_eventTransitions")
#define ONSTATE(var) (var + "_onState")
#define ONSTATEENTERED(var) (var + "_onStateEntered")
#define ONSTATELEAVING(var) (var + "_onStateLeaving")
#define SM_GET_FUNCTION(var,cfg) private var = getText (cfg); \
    if (isNil var || {!((missionNamespace getVariable var) isEqualType {})}) then { \
        var = compile var; \
    } else { \
        var = missionNamespace getVariable var;\
    }


// ace_medical_feedback

#define EMPTY_SOUND {"A3\Sounds_F\dummysound.wss",1,1}
#define NAMESPACE_NULL locationNull

#define DISABLE_VANILLA_SCREAMS
#define DISABLE_VANILLA_MOANS
#define DISABLE_VANILLA_HEARTBEAT
#define DISABLE_VANILLA_BLOOD_TEXTURES
#define DISABLE_VANILLA_DAMAGE_EFFECTS

#define FX_PAIN_FADE_IN   0.3
#define FX_PAIN_FADE_OUT  0.7
#define FX_UNCON_FADE_IN  2.0
#define FX_UNCON_FADE_OUT 5.0

#define SND_HEARBEAT_FAST   (selectRandom ["ACE_heartbeat_fast_1", "ACE_heartbeat_fast_2", "ACE_heartbeat_fast_3"])
#define SND_HEARBEAT_NORMAL (selectRandom ["ACE_heartbeat_norm_1", "ACE_heartbeat_norm_2"])
#define SND_HEARBEAT_SLOW   (selectRandom ["ACE_heartbeat_slow_1", "ACE_heartbeat_slow_2"])
#define SND_FRACTURE        (selectRandom ["ACE_fracture_1", "ACE_fracture_2", "ACE_fracture_3", "ACE_fracture_4"])

#define VOL_UNCONSCIOUS 0.25

#define FX_PAIN_WHITE_FLASH 0
#define FX_PAIN_PULSATING_BLUR 1
#define FX_PAIN_CHROMATIC_ABERRATION 2
#define FX_PAIN_ONLY_BASE 3

#define FX_BLOODVOLUME_COLOR_CORRECTION 0
#define FX_BLOODVOLUME_ICON 1
#define FX_BLOODVOLUME_BOTH 2

#define ICON_BLOODVOLUME_IDX_MIN 0
#define ICON_BLOODVOLUME_IDX_MAX 6
#define ICON_BLOODVOLUME_PATH(num) format [QPATHTOF(data\bloodVolume_%1.paa), num]
#define ICON_BLOODVOLUME_COLOR_NONE [0, 0, 0, 0]
#define ICON_BLOODVOLUME_COLOR_WHITE [1, 1, 1, 1]
#define ICON_BLOODVOLUME_COLOR_ORANGE [1, 0.6, 0, 1]
#define ICON_BLOODVOLUME_COLOR_RED [0.8, 0.2, 0, 1]

#define ICON_TOURNIQUET_PATH QPATHTOF(data\tourniquet.paa)
#define ICON_SPLINT_PATH QPATHTOF(data\splint.paa)
#define ICON_FRACTURE_PATH QPATHTOF(data\fracture.paa)
