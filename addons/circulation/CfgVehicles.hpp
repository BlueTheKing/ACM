class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_Head {
                class CheckBloodPressure {};
            };
        };
        class ACE_SelfActions {
            class Medical {
                class ACE_Head {
                    class CheckBloodPressure {};
                };
            };
            class ACE_Equipment {
                class AMS_AED_Interactions {
                    displayName = "AED";
                    condition = QUOTE('AMS_AED' in (items _player));
                    //icon = QPATHTOF(ui\icon_aed_ca.paa);
                    class AMS_AED_ViewMonitor {
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
