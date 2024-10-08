#define COMPONENT circulation
#define COMPONENT_BEAUTIFIED Circulation
#include "\x\ACM\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_CIRCULATION
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_CIRCULATION
    #define DEBUG_SETTINGS DEBUG_SETTINGS_CIRCULATION
#endif

#include "\x\ACM\addons\main\script_macros.hpp"

#define C_LLSTRING(string) localize 'STR_ACM_Circulation_##string##'
#define ICON_SYRINGE(size) QPATHTOF(ui\icon_syringe_##size##_ca.paa)