#define COMPONENT zeus
#define COMPONENT_BEAUTIFIED Zeus
#include "\x\ACM\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_ZEUS
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_ZEUS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_ZEUS
#endif

#include "\x\ACM\addons\main\script_macros.hpp"

// UI grid
#define SIZEX ((safeZoneW / safeZoneH) min 1.2)
#define SIZEY (SIZEX / 1.2)
#define W_PART(num) (num * (SIZEX / 40))
#define H_PART(num) (num * (SIZEY / 25))
#define X_PART(num) (W_PART(num) + (safeZoneX + (safeZoneW - SIZEX) / 2))
#define Y_PART(num) (H_PART(num) + (safeZoneY + (safeZoneH - SIZEY) / 2))

#define IDC_MODULE_SET_BLOOD_VOLUME 90000
#define IDC_MODULE_SET_BLOOD_VOLUME_BLOODVOLUME 90001
#define IDC_MODULE_SET_BLOOD_VOLUME_PLASMAVOLUME 90002
#define IDC_MODULE_SET_BLOOD_VOLUME_SALINEVOLUME 90003

#define IDC_MODULE_INFLICT_CHEST_INJURY 90004
#define IDC_MODULE_INFLICT_CHEST_INJURY_LIST 90005

#define IDC_MODULE_GIVE_PAIN 90006
#define IDC_MODULE_GIVE_PAIN_SLIDER 90007