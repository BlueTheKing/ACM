class RscControlsGroup;
class RscControlsGroupNoScrollbars;
class RscText;
class RscListBox;
class RscCombo;
class RscEdit;
class RscXSliderH;
class RscCheckBox;
class RscActivePicture;
class RscMapControl;
class RscPicture;
class ctrlToolbox;
class RscButton;

class RscDisplayAttributes {
    class Controls {
        class Background;
        class Title;
        class Content: RscControlsGroup {
            class Controls;
        };
        class ButtonOK;
        class ButtonCancel;
    };
};

class GVAR(RscCreateHazardZone): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad',_this,QQGVAR(RscCreateHazardZone))] call ACEFUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload',_this,QQGVAR(RscCreateHazardZone))] call ACEFUNC(zeus,zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class Tab: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(moduleCreateHazardZone));
                    idc = IDC_MODULE_CREATE_HAZARDZONE;
                    x = 0;
                    y = 0;
                    w = QUOTE(W_PART(26));
                    h = QUOTE(H_PART(8));
                    class Controls {
                        class Title_HazardType: RscText {
                            idc = -1;
                            text = CSTRING(Module_Generic_HazardType);
                            x = 0;
                            y = 0;
                            w = QUOTE(W_PART(10));
                            h = QUOTE(H_PART(1));
                            colorBackground[] = {0,0,0,0.5};
                        };
                        class List_HazardType: RscCombo {
                            idc = IDC_MODULE_CREATE_HAZARDZONE_LIST;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(0);
                            w = QUOTE(W_PART(16));
                            h = QUOTE(H_PART(1));
                            colorBackground[] = {0, 0, 0, 0.5};
                            class Items {
                                class Chemical_Placebo {
                                    text = CSTRING(Chemical_Placebo);
                                    //picture = "\a3\ui_f_curator\data\displays\rscdisplaycurator\modegroups_ca.paa";
                                    default = 1;
                                };
                                class Chemical_CS {
                                    text = CSTRING(Chemical_CS);
                                    //picture = "\a3\ui_f\data\map\diary\icons\playerwest_ca.paa";
                                };
                                class Chemical_Chlorine {
                                    text = CSTRING(Chemical_Chlorine);
                                    //picture = "\a3\ui_f\data\map\diary\icons\playereast_ca.paa";
                                };
                                class Chemical_Sarin {
                                    text = CSTRING(Chemical_Sarin);
                                    //picture = "\a3\ui_f\data\map\diary\icons\playerguer_ca.paa";
                                };
                                class Chemical_Lewisite {
                                    text = CSTRING(Chemical_Lewisite);
                                    //picture = "\a3\ui_f\data\map\diary\icons\playerciv_ca.paa";
                                };
                            };
                        };
                        class Title_Radius: Title_HazardType {
                            text = CSTRING(Module_Generic_ZoneRadius);
                            y = QUOTE(H_PART(1.1));
                            w = QUOTE(W_PART(10));
                        };
                        class Slider_Radius: RscXSliderH {
                            idc = IDC_MODULE_CREATE_HAZARDZONE_RADIUS;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(H_PART(1.1));
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(1));
                            sliderStep = 1;
                            sliderRange[] = {1,30};
                            sliderPosition = 5;
                        };
                        class Title_EffectTime: Title_HazardType {
                            text = CSTRING(Module_Generic_EffectTime);
                            y = QUOTE(H_PART(2.2));
                            w = QUOTE(W_PART(10));
                            tooltip = CSTRING(Module_Generic_EffectTime_Tooltip);
                        };
                        class Slider_EffectTime: Slider_Radius {
                            idc = IDC_MODULE_CREATE_HAZARDZONE_EFFECTTIME;
                            y = QUOTE(H_PART(2.2));
                            sliderRange[] = {0,60};
                            sliderPosition = 0;
                        };
                        class Title_Attach: Title_HazardType {
                            text = CSTRING(Module_Generic_AttachToObject);
                            y = QUOTE(H_PART(3.3));
                            w = QUOTE(W_PART(10));
                        };
                        class Checkbox_Attach: RscCheckBox {
                            idc = IDC_MODULE_CREATE_HAZARDZONE_ATTACH;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(H_PART(3.3));
                            w = QUOTE(W_PART(1));
                            h = QUOTE(H_PART(1));
                            checked = 0;
                        };
                        class Title_ShowMist: Title_HazardType {
                            text = CSTRING(Module_Generic_ShowMist);
                            y = QUOTE(H_PART(4.4));
                            w = QUOTE(W_PART(10));
                            tooltip = CSTRING(Module_Generic_ShowMist_Tooltip);
                        };
                        class Checkbox_ShowMist: Checkbox_Attach {
                            idc = IDC_MODULE_CREATE_HAZARDZONE_SHOWMIST;
                            y = QUOTE(H_PART(4.4));
                            checked = 1;
                        };
                        class Title_AffectAI: Title_HazardType {
                            text = CSTRING(Module_Generic_AffectAI);
                            y = QUOTE(H_PART(5.5));
                            w = QUOTE(W_PART(10));
                        };
                        class Checkbox_AffectAI: Checkbox_Attach {
                            idc = IDC_MODULE_CREATE_HAZARDZONE_AFFECTAI;
                            y = QUOTE(H_PART(5.5));
                            checked = 1;
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};

class GVAR(RscCreateChemicalDevice): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad',_this,QQGVAR(RscCreateChemicalDevice))] call ACEFUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload',_this,QQGVAR(RscCreateChemicalDevice))] call ACEFUNC(zeus,zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class Tab: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(moduleCreateChemicalDevice));
                    idc = IDC_MODULE_CREATE_CHEMICALDEVICE;
                    x = 0;
                    y = 0;
                    w = QUOTE(W_PART(26));
                    h = QUOTE(H_PART(6));
                    class Controls {
                        class Title_HazardType: RscText {
                            idc = -1;
                            text = CSTRING(Module_Generic_HazardType);
                            x = 0;
                            y = 0;
                            w = QUOTE(W_PART(10));
                            h = QUOTE(H_PART(1));
                            colorBackground[] = {0,0,0,0.5};
                        };
                        class List_HazardType: RscCombo {
                            idc = IDC_MODULE_CREATE_CHEMICALDEVICE_LIST;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(0);
                            w = QUOTE(W_PART(16));
                            h = QUOTE(H_PART(1));
                            colorBackground[] = {0, 0, 0, 0.5};
                            class Items {
                                class Chemical_Chlorine {
                                    text = CSTRING(Chemical_Chlorine);
                                    default = 1;
                                };
                                class Chemical_Sarin {
                                    text = CSTRING(Chemical_Sarin);
                                };
                                class Chemical_Lewisite {
                                    text = CSTRING(Chemical_Lewisite);
                                };
                            };
                        };
                        class Title_ExplosionCloud: Title_HazardType {
                            text = CSTRING(Module_CreateChemicalDevice_CloudSize);
                            y = QUOTE(H_PART(1.1));
                            w = QUOTE(W_PART(10));
                        };
                        class List_ExplosionCloud: ctrlToolbox {
                            idc = IDC_MODULE_CREATE_CHEMICALDEVICE_CLOUDSIZELIST;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(H_PART(1.1));
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(1));
                            rows = 1;
                            columns = 3;
                            strings[] = {CSTRING(Module_CreateChemicalDevice_CloudSize_None),CSTRING(Module_CreateChemicalDevice_CloudSize_Small),CSTRING(Module_CreateChemicalDevice_CloudSize_Large)};
                        };
                        class Title_Radius: Title_HazardType {
                            text = CSTRING(Module_Generic_ZoneRadius);
                            y = QUOTE(H_PART(2.2));
                            w = QUOTE(W_PART(10));
                        };
                        class Slider_Radius: RscXSliderH {
                            idc = IDC_MODULE_CREATE_CHEMICALDEVICE_RADIUS;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(H_PART(2.2));
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(1));
                            sliderStep = 1;
                            sliderRange[] = {1,15};
                            sliderPosition = 5;
                        };
                        class Title_PermanentHazard: Title_HazardType {
                            text = CSTRING(Module_CreateChemicalDevice_PermanentHazard);
                            y = QUOTE(H_PART(3.3));
                            w = QUOTE(W_PART(10));
                            tooltip = CSTRING(Module_CreateChemicalDevice_PermanentHazard_Tooltip);
                        };
                        class Checkbox_PermanentHazard: RscCheckBox {
                            idc = IDC_MODULE_CREATE_CHEMICALDEVICE_PERMANENT;
                            x = QUOTE(W_PART(10.1));
                            y = QUOTE(H_PART(3.3));
                            w = QUOTE(W_PART(1));
                            h = QUOTE(H_PART(1));
                            checked = 0;
                        };
                        class Title_AffectAI: Title_HazardType {
                            text = CSTRING(Module_Generic_AffectAI);
                            y = QUOTE(H_PART(4.4));
                            w = QUOTE(W_PART(10));
                        };
                        class Checkbox_AffectAI: Checkbox_PermanentHazard {
                            idc = IDC_MODULE_CREATE_CHEMICALDEVICE_AFFECTAI;
                            y = QUOTE(H_PART(4.4));
                            checked = 1;
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};