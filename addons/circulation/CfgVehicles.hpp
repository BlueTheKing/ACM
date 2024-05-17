class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {
                class ACM_AED_Interactions {
                    displayName = "AED";
                    condition = QUOTE('ACM_AED' in (items _player));
                    //icon = QPATHTOF(ui\icon_aed_ca.paa);
                    class ACM_AED_ViewMonitor {
                        displayName = "View Monitor";
                        condition = "true";
                        statement = QUOTE([ARR_2(_player,_player)] call FUNC(displayAEDMonitor));
                        showDisabled = 0;
                    };
                };
            };
        };
    };
};
