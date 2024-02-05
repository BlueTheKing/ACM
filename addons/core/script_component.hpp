#define COMPONENT core
#define COMPONENT_BEAUTIFIED Core
#include "\x\AMS\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_CORE
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_CORE
#endif

#include "\x\AMS\addons\main\script_macros.hpp"

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
