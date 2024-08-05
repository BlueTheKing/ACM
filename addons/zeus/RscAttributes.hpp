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

class GVAR(RscSetBloodVolume): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad',_this,QQGVAR(RscSetBloodVolume))] call ACEFUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload',_this,QQGVAR(RscSetBloodVolume))] call ACEFUNC(zeus,zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class SetBloodVolumeTab: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(setBloodVolume));
                    idc = IDC_MODULE_SET_BLOOD_VOLUME;
                    x = 0;
                    y = 0;
                    w = QUOTE(W_PART(26));
                    h = QUOTE(H_PART(6.5));
                    class Controls {
                        class Title_BloodVolume: RscText {
                            idc = -1;
                            text = CSTRING(Module_SetBloodVolume_BloodVolume);
                            x = 0;
                            y = 0;
                            w = QUOTE(W_PART(10));
                            h = QUOTE(H_PART(1));
                            colorBackground[] = {0,0,0,0.5};
                        };
                        class Slider_BloodVolume: RscXSliderH {
                            idc = IDC_MODULE_SET_BLOOD_VOLUME_BLOODVOLUME;
                            x = QUOTE(W_PART(10.1));
                            y = 0;
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(1));
                            sliderStep = 0.1;
                            sliderRange[] = {0,6};
                            sliderPosition = 6;
                        };
                        class Title_PlasmaVolume: Title_BloodVolume {
                            text = CSTRING(Module_SetBloodVolume_PlasmaVolume);
                            y = QUOTE(H_PART(1.1));
                        };
                        class Slider_PlasmaVolume: Slider_BloodVolume {
                            idc = IDC_MODULE_SET_BLOOD_VOLUME_PLASMAVOLUME;
                            y = QUOTE(H_PART(1.1));
                            sliderPosition = 0;
                        };
                        class Title_SalineVolume: Title_BloodVolume {
                            text = CSTRING(Module_SetBloodVolume_SalineVolume);
                            y = QUOTE(H_PART(2.2));
                        };
                        class Slider_SalineVolume: Slider_BloodVolume {
                            idc = IDC_MODULE_SET_BLOOD_VOLUME_SALINEVOLUME;
                            y = QUOTE(H_PART(2.2));
                            sliderPosition = 0;
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};

class GVAR(RscInflictCardiacArrest): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad',_this,QQGVAR(RscInflictCardiacArrest))] call ACEFUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload',_this,QQGVAR(RscInflictCardiacArrest))] call ACEFUNC(zeus,zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class InflictCardiacArrestTab: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(inflictCardiacArrest));
                    idc = IDC_MODULE_INFLICT_CARDIAC_ARREST;
                    x = 0;
                    y = 0;
                    w = QUOTE(W_PART(26));
                    h = QUOTE(H_PART(6.5));
                    class Controls {
                        class Title_TargetRhythm: RscText {
                            idc = -1;
                            text = CSTRING(Module_InflictCardiacArrest_TargetRhythm);
                            x = 0;
                            y = 0;
                            w = QUOTE(W_PART(10));
                            h = QUOTE(H_PART(3));
                            colorBackground[] = {0,0,0,0.5};
                        };
                        class List_TargetRhythm: ctrlToolbox {
                            idc = IDC_MODULE_INFLICT_CARDIAC_ARREST_LIST;
                            x = QUOTE(W_PART(10.1));
                            y = 0;
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(3));
                            rows = 2;
                            columns = 2;
                            strings[] = {CSTRING(Module_InflictCardiacArrest_TargetRhythm_Sinus), CSTRING(Module_InflictCardiacArrest_TargetRhythm_Asystole), CSTRING(Module_InflictCardiacArrest_TargetRhythm_VF), CSTRING(Module_InflictCardiacArrest_TargetRhythm_PVT), CSTRING(Module_InflictCardiacArrest_TargetRhythm_Random)};
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};

class GVAR(RscInflictChestInjury): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad',_this,QQGVAR(RscInflictChestInjury))] call ACEFUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload',_this,QQGVAR(RscInflictChestInjury))] call ACEFUNC(zeus,zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class InflictChestInjuryTab: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(inflictChestInjury));
                    idc = IDC_MODULE_INFLICT_CHEST_INJURY;
                    x = 0;
                    y = 0;
                    w = QUOTE(W_PART(26));
                    h = QUOTE(H_PART(6.5));
                    class Controls {
                        class Title_InjuryType: RscText {
                            idc = -1;
                            text = CSTRING(Module_InflictChestInjury_InjuryType);
                            x = 0;
                            y = 0;
                            w = QUOTE(W_PART(10));
                            h = QUOTE(H_PART(3));
                            colorBackground[] = {0,0,0,0.5};
                        };
                        class List_InjuryType: ctrlToolbox {
                            idc = IDC_MODULE_INFLICT_CHEST_INJURY_LIST;
                            x = QUOTE(W_PART(10.1));
                            y = 0;
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(3));
                            rows = 2;
                            columns = 2;
                            strings[] = {CSTRING(Module_InflictChestInjury_Pneumothorax), CSTRING(Module_InflictChestInjury_TensionPneumothorax), CSTRING(Module_InflictChestInjury_Hemothorax), CSTRING(Module_InflictChestInjury_TensionHemothorax)};
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};

class GVAR(RscGivePain): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad',_this,QQGVAR(RscGivePain))] call ACEFUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload',_this,QQGVAR(RscGivePain))] call ACEFUNC(zeus,zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class SetBloodVolumeTab: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(givePain));
                    idc = IDC_MODULE_GIVE_PAIN;
                    x = 0;
                    y = 0;
                    w = QUOTE(W_PART(26));
                    h = QUOTE(H_PART(1.1));
                    class Controls {
                        class Title_PainAmount: RscText {
                            idc = -1;
                            text = CSTRING(Module_GivePain_PainAmount);
                            x = 0;
                            y = 0;
                            w = QUOTE(W_PART(10));
                            h = QUOTE(H_PART(1));
                            colorBackground[] = {0,0,0,0.5};
                        };
                        class Slider_PainAmount: RscXSliderH {
                            idc = IDC_MODULE_GIVE_PAIN_SLIDER;
                            x = QUOTE(W_PART(10.1));
                            y = 0;
                            w = QUOTE(W_PART(15.9));
                            h = QUOTE(H_PART(1));
                            sliderStep = 0.01;
                            sliderRange[] = {0,1};
                            sliderPosition = 0;
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};