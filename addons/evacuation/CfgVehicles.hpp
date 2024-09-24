class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_MainActions {
                class ACM_ConvertCasualty {
                    displayName = CSTRING(ConvertCasualty);
                    icon = "";
                    condition = QUOTE([ARR_2(_player,_target)] call FUNC(canConvert));
                    statement = QUOTE([ARR_2(_player,_target)] call FUNC(convertCasualtyAction));
                    exceptions[] = {"isNotInside"};
                    showDisabled = 0;
                };
            };
        };
    };
};