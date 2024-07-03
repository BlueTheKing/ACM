#include "\a3\ui_f\hpp\defineCommonGrids.inc"
class RscPicture;
class RscStructuredText;

class RscTitles {
    class ACEGVAR(dogtags,singleTag) {
        class controls {
            class nickname: RscStructuredText {
                y = QUOTE(0.052 * safeZoneH + (profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),Y)',safeZoneY + 0.175 * safeZoneH)]));
                h = QUOTE(3.2 * GUI_GRID_H);
                /*class Attributes {
                    font = "RobotoCondensed";
                    color = "#EEEEEE"; //color = "#636363";
                    align = "left";
                    valign = "middle";
                    shadow = 2; //shadow = 0;
                    shadowColor = "#3f4345"; //shadowColor = "#636363";
                    size = "0.80";
                };*/
            };
        };
    };
    class ACEGVAR(dogtags,doubleTag): ACEGVAR(dogtags,singleTag) {
        class controls: controls {
            class nickname: nickname {
                y = QUOTE(0.052 * safeZoneH + (profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),Y)',safeZoneY + 0.175 * safeZoneH)]));
                h = QUOTE(3.2 * GUI_GRID_H);
            };
        };
    };
};
