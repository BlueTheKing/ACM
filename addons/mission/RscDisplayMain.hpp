class RscControlsGroupNoScrollbars;
class RscStandardDisplay;
class RscDisplayMain: RscStandardDisplay {
    class controls {
        class GroupSingleplayer: RscControlsGroupNoScrollbars {
            class Controls;
        };
        class GroupTutorials: GroupSingleplayer {
            h = "(6 *   1.5) *  (pixelH * pixelGrid * 2)";

            class Controls: Controls {
                class Bootcamp;
                class Arsenal;
                class GVAR(mission): Arsenal {
                    idc = -1;
                    text = "ACM Testing Zone";
                    tooltip = "#1 Malpractice Simulator™";
                    y = "(4 *   1.5) *  (pixelH * pixelGrid * 2) +  (pixelH)";
                    onbuttonclick = QUOTE(playMission [ARR_2('','PATHTOF(ACM_TestZone.VR)')]);
                    animTextureNormal = QPATHTOF(ui\buttonMainMenu_ca.paa);
                    animTextureDisabled = QPATHTOF(ui\buttonMainMenu_ca.paa);
                    animTextureOver = QPATHTOF(ui\buttonMainMenuHover_ca.paa);
                    animTextureFocused = QPATHTOF(ui\buttonMainMenuHover_ca.paa);
                    animTexturePressed = QPATHTOF(ui\buttonMainMenu_ca.paa);
                    animTextureDefault = QPATHTOF(ui\buttonMainMenu_ca.paa);
                };
                class FieldManual: Bootcamp {
                    y = "(5 *   1.5) *  (pixelH * pixelGrid * 2) +  (pixelH)";
                };
                class CommunityGuides: Bootcamp {
                    y = "(6 *   1.5) *  (pixelH * pixelGrid * 2) +  (pixelH)";
                };
            };
        };
    };
};
