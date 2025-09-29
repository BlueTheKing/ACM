#define MAINPREFIX x
#define PREFIX ACM

#define AUTHOR "Blue"

#include "script_version.hpp"

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCH.BUILD
#define VERSION_AR  MAJOR,MINOR,PATCH,BUILD

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 2.18
#define REQUIRED_CBA_VERSION {3,18,0}
#define REQUIRED_ACE_VERSION {3,18,0}

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(ACM - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(ACM - COMPONENT)
#endif
