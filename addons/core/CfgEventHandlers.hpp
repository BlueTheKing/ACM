class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preInit));
        disableModuload = "true";
    };
};

/*class Extended_Init_EventHandlers {
    class CAManBase {
        class ADDON {
            init = QUOTE(_this call COMPILE_FILE(XEH_init));
        };
    };
};*/

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_postInit));
    };
};

class Extended_Respawn_EventHandlers {
    class CAManBase {
        class ADDON {
            respawn = QUOTE(_this call FUNC(handleRespawn));
        };
    };
};

class Extended_Init_EventHandlers {
    class CAManBase {
        class ADDON {
            init = QUOTE([ARR_2((_this select 0),false)] call FUNC(initUnit));
            exclude[] = {IGNORE_BASE_UAVPILOTS};
        };
    };
};

class Extended_InitPost_EventHandlers {
    class LandVehicle {
        class ADDON {
            init = QUOTE(_this call FUNC(addVehicleCarryLoadActions));
        };
    };

    class Air {
        class ADDON {
            init = QUOTE(_this call FUNC(addVehicleCarryLoadActions));
        };
    };

    class Ship {
        class ADDON {
            init = QUOTE(_this call FUNC(addVehicleCarryLoadActions));
        };
    };
};