class CfgFunctions {
    class overwrite_medical_gui {
        tag = "ace_medical_gui";
        class ace_medical_gui {
            class updateInjuryList {
                file = QPATHTOF(overrides\fnc_updateInjuryList.sqf);
            };
            class onMenuOpen {
                file = QPATHTOF(overrides\fnc_onMenuOpen.sqf);
            };
            class updateBodyImage {
                file = QPATHTOF(overrides\fnc_updateBodyImage.sqf);
            };
        };
    };
};