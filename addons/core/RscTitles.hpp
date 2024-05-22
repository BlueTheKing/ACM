class RscPicture;
class RscStructuredText;

class RscTitles {
    class ACEGVAR(dogtags,singleTag) {
        class controls {
            class nickname: RscStructuredText {
                class Attributes {
                    font = "RobotoCondensed";
                    color = "#636363";
                    align = "left";
                    valign = "middle";
                    shadow = 0;
                    shadowColor = "#636363";
                    size = "0.80";
                };
            };
        };
    };
    class ACEGVAR(dogtags,doubleTag): ACEGVAR(dogtags,singleTag) {
        class controls: controls {
            class nickname: nickname {
                class Attributes {
                    font = "RobotoCondensed";
                    color = "#636363";
                    align = "left";
                    valign = "middle";
                    shadow = 0;
                    shadowColor = "#636363";
                    size = "0.80";
                };
            };
        };
    };
};
