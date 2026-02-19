#include "..\script_component.hpp"
/*
 * Author: mharis001
 * Updates injury list for given body part for the target.
 *
 * Arguments:
 * 0: Injury list <CONTROL>
 * 1: Target <OBJECT>
 * 2: Body part, -1 to only show overall health info <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrlInjuries, _target, 0] call ace_medical_gui_fnc_updateInjuryList
 *
 * Public: No
 */

params ["_ctrl", "_target", "_selectionN"];

private _entries = [];
private _nonissueColor = [1, 1, 1, 0.33];

private _airwayColor = [0.19, 0.91, 0.93, 1];
private _breathingColor = [0.3, 0.8, 0.8, 1];
private _circulationColor = [0.2, 0.6, 0.2, 1];

private _addListSpacer = false;

// Indicate if unit is bleeding at all
if (IS_BLEEDING(_target)) then {
    switch (ACEGVAR(medical_gui,showBleeding)) do {
        case 1: {
        //  Just show whether the unit is bleeding at all
            _entries pushBack [localize ACELSTRING(medical_gui,Status_Bleeding), [1, 0, 0, 1]];
        };
        case 2: {
            // Give a qualitative description of the rate of bleeding
            _entries pushBack (switch ([_target] call EFUNC(core,getBleedSeverity)) do {
                case 1: {[localize ACELSTRING(medical_gui,Bleed_Rate2), [1, 0.67, 0, 1]]};
                case 2: {[localize ACELSTRING(medical_gui,Bleed_Rate3), [1, 0.33, 0, 1]]};
                case 3: {[localize ACELSTRING(medical_gui,Bleed_Rate4), [1, 0, 0, 1]]};
                default {[localize ACELSTRING(medical_gui,Bleed_Rate1), [1, 1, 0, 1]]};
            });
        };
    };
} else {
    if (GVAR(showInactiveStatuses)) then {_entries pushBack [LLSTRING(NoExternalBleeding), _nonissueColor];};
};

if (ACEGVAR(medical_gui,showBloodlossEntry)) then {
    // Give a qualitative description of the blood volume lost
    switch (GET_HEMORRHAGE(_target)) do {
        case 0: {
           if (GVAR(showInactiveStatuses)) then {_entries pushBack [localize ACELSTRING(medical_gui,Lost_Blood0), _nonissueColor];};
        };
        case 1: {
            _addListSpacer = true;
            _entries pushBack [localize ACELSTRING(medical_gui,Lost_Blood1), [1, 1, 0, 1]];
        };
        case 2: {
            _addListSpacer = true;
            _entries pushBack [localize ACELSTRING(medical_gui,Lost_Blood2), [1, 0.67, 0, 1]];
        };
        case 3: {
            _addListSpacer = true;
            _entries pushBack [localize ACELSTRING(medical_gui,Lost_Blood3), [1, 0.33, 0, 1]];
        };
        case 4: {
            _addListSpacer = true;
            _entries pushBack [localize ACELSTRING(medical_gui,Lost_Blood4), [1, 0, 0, 1]];
        };
    };
};

// Show total connected IV bags
private _totalBags = 0;
private _salineBags = 0;
private _bloodBags = 0;
private _freshBloodBags = 0;
private _plasmaBags = 0;
private _FBTKBags = 0;
{
    private _IVBagsBodyPart = (_target getVariable [QEGVAR(circulation,IV_Bags), createHashMap]) getOrDefault [_x, []];

    {
        _x params ["_type"];

        switch (_type) do {
            case "Saline": {
                _salineBags = _salineBags + 1;
            };
            case "Blood": {
                _bloodBags = _bloodBags + 1;
            };
            case "Plasma": {
                _plasmaBags = _plasmaBags + 1;
            };
            case "FBTK": {
                _FBTKBags = _FBTKBags + 1;
            };
            case "FreshBlood": {
                _freshBloodBags = _freshBloodBags + 1;
            };
        };
        _totalBags = _totalBags + 1;  
    } forEach _allBagsBodyPart; 
} forEach ALL_BODY_PARTS;

if (_totalBags > 0) then {
    if (_FBTKBags > 0) then {
        _entries pushBack [format [LELSTRING(circulation,GUI_CollectingBlood), floor _FBTKBags], [1, 1, 1, 1]];
    };
    if (_freshBloodBags > 0) then {
        _entries pushBack [format [LELSTRING(circulation,GUI_TransfusingFreshBlood), floor _freshBloodBags], [1, 1, 1, 1]];
    };
    if (_bloodBags > 0) then {
        _entries pushBack [format [LELSTRING(circulation,GUI_TransfusingBlood), floor _bloodBags], [1, 1, 1, 1]];
    };
    if (_plasmaBags > 0) then {
        _entries pushBack [format [LELSTRING(circulation,GUI_TransfusingPlasma), floor _plasmaBags], [1, 1, 1, 1]];
    };
    if (_salineBags > 0) then {
        _entries pushBack [format [LELSTRING(circulation,GUI_TransfusingSaline), floor _salineBags], [1, 1, 1, 1]];
    };
} else {
    if (GVAR(showInactiveStatuses)) then {_entries pushBack [localize ACELSTRING(medical_treatment,Status_NoIv), _nonissueColor];};
};

// Indicate the amount of pain the unit is in
if (_target call ACEFUNC(common,isAwake)) then {
    private _pain = GET_PAIN_PERCEIVED(_target);
    if (_pain > 0) then {
        _addListSpacer = true;
        private _painText = "";
        if (GVAR(showExactPainAmount)) then {
            _painText = switch (true) do {
                case (_pain > PAIN_UNCONSCIOUS): {
                    ACELSTRING(medical_treatment,Status_SeverePain);
                };
                case (_pain > (PAIN_UNCONSCIOUS / 5)): {
                    ACELSTRING(medical_treatment,Status_Pain);
                };
                default {
                    ACELSTRING(medical_treatment,Status_MildPain);
                };
            };
        } else {
            _painText = ACELSTRING(medical_treatment,Status_Pain);
        };
        _entries pushBack [localize _painText, [1, 1, 1, 1]];
    } else {
        if (GVAR(showInactiveStatuses)) then {_entries pushBack [localize ACELSTRING(medical_gui,Status_NoPain), _nonissueColor];};
    };
};

// Skip the rest as they're body part specific
if (_selectionN == -1) exitWith {
    // Add all entries to injury list
    lbClear _ctrl;

    {
        _x params ["_text", "_color"];

        _ctrl lbSetColor [_ctrl lbAdd _text, _color];
    } forEach _entries;

    _ctrl lbSetCurSel -1;
};

[QACEGVAR(medical_gui,updateInjuryListGeneral), [_ctrl, _target, _selectionN, _entries]] call CBA_fnc_localEvent;

if (count _entries > 0) then {_entries pushBack ["", [1, 1, 1, 1]];};

// Add selected body part name
private _bodyPartName = [
    ACELSTRING(medical_gui,Head),
    ACELSTRING(medical_gui,Torso),
    ACELSTRING(medical_gui,LeftArm),
    ACELSTRING(medical_gui,RightArm),
    ACELSTRING(medical_gui,LeftLeg),
    ACELSTRING(medical_gui,RightLeg)
] select _selectionN;

_entries pushBack [localize _bodyPartName, [1, 1, 1, 1]];

// Recovery Position
if (_selectionN in [0,1] && _target getVariable [QEGVAR(airway,RecoveryPosition_State), false]) then {
    _entries pushBack [LELSTRING(airway,CheckAirway_RecoveryPosition), _airwayColor];
} else {
    if (_selectionN == 0 && _target getVariable [QEGVAR(airway,HeadTilt_State), false]) then {
        _entries pushBack [LELSTRING(airway,GUI_HeadTiltedChinLifted), _airwayColor];
    };
};

// CPR
if (_selectionN == 1 && (_target getVariable [QEGVAR(circulation,CPR_Medic), objNull]) isNotEqualTo objNull) then {
    private _string = LELSTRING(core,Common_Paused);
    if ([_target] call EFUNC(core,cprActive)) then {
        _string = LELSTRING(core,Common_InProgress);
    };
    _entries pushBack [format ["%1 %2 (%3)", ACELLSTRING(medical_treatment,Actions_CPR), _string, ([(_target getVariable [QEGVAR(circulation,CPR_Medic), objNull]), false, true] call ACEFUNC(common,getName))], _circulationColor];
};

// Airway Items
if (_selectionN == 0) then {
    private _airwayItemTypeOral = _target getVariable [QEGVAR(airway,AirwayItem_Oral), ""];
    private _airwayItemTypeNasal = _target getVariable [QEGVAR(airway,AirwayItem_Nasal), ""];

    if (_airwayItemTypeNasal == "NPA") then {
        _entries pushBack [LELSTRING(airway,NPA), _airwayColor];
    };

    if (_airwayItemTypeOral != "") then {
        private _airwayItem = LELSTRING(airway,OPA);

        if (_airwayItemTypeOral isEqualTo "SGA") then {
            _airwayItem = LELSTRING(airway,IGel);
        };

        _entries pushBack [_airwayItem, _airwayColor];
    };

    if ((_target getVariable [QEGVAR(airway,SurgicalAirway_State), false]) || (_target getVariable [QEGVAR(airway,SurgicalAirway_InProgress), false])) then {
        private _entry = LELSTRING(airway,SurgicalAirway);

        if (_target getVariable [QEGVAR(airway,SurgicalAirway_State), false]) then {
            if (_target getVariable [QEGVAR(airway,SurgicalAirway_StrapSecure), false]) then {
                _entry = format ["%1 [%2]", _entry, LELSTRING(airway,GUI_SurgicalAirway_Strapped)];
            };
            if (_target getVariable [QEGVAR(airway,SurgicalAirway_Incision), false] && !(_target getVariable [QEGVAR(airway,SurgicalAirway_IncisionStitched), false])) then {
                _entry = format ["%1 [%2]", _entry, LELSTRING(airway,GUI_SurgicalAirway_OpenIncision)]; 
            };
        } else {
            if (_target getVariable [QEGVAR(airway,SurgicalAirway_InProgress), false]) then {
                _entry = format ["%1 [%2]", _entry, LELSTRING(core,Common_InProgress)];
            };
        };

        _entries pushBack [_entry, _airwayColor];
    };

    private _lozengeItem = _target getVariable [QEGVAR(circulation,LozengeItem), ""];

    if (_lozengeItem != "") then {
        private _item = LELSTRING(circulation,FentanylLozenge);

        _entries pushBack [_item, _circulationColor];
    };
};

private _oxygenSaturation = GET_OXYGEN(_target);

// Cyanosis
if (_selectionN in [0,2,3] && {!(alive _target) || (_oxygenSaturation < ACM_CYANOSIS_T_SLIGHT || HAS_TOURNIQUET_APPLIED_ON(_target,_selectionN))}) then {
    private _tourniquetTime = 0;
    if !(alive _target) then {
        private _timeSinceDeath = CBA_missionTime - (_target getVariable [QEGVAR(core,TimeOfDeath), CBA_missionTime]);
        private _newOxygenSaturation = linearConversion [0, (330 - ((100 - _oxygenSaturation) * ACM_BREATHING_MAXDECREASE)), _timeSinceDeath, 99, 55, true];
        _oxygenSaturation = _oxygenSaturation min _newOxygenSaturation;
    };
    private _colorScale = linearConversion [ACM_CYANOSIS_T_SLIGHT, ACM_OXYGEN_DEATH, _oxygenSaturation, 0.47, 0.13, true];

    if (HAS_TOURNIQUET_APPLIED_ON(_target,_selectionN)) then {
        _tourniquetTime = CBA_missionTime - ((_target getVariable [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]]) select _selectionN);
        _colorScale = _colorScale min (linearConversion [1, 90, _tourniquetTime, 0.47, 0.13, true]);
    };

    if (EGVAR(breathing,showCyanosisSeverity)) then {
        private _cyanosis = switch (true) do {
            case (_oxygenSaturation < ACM_CYANOSIS_T_SEVERE || _tourniquetTime > 120): {LELSTRING(breathing,GUI_Severe)};
            case (_oxygenSaturation < ACM_CYANOSIS_T_MODERATE || _tourniquetTime > 60): {LELSTRING(breathing,GUI_Moderate)};
            default {LELSTRING(breathing,GUI_Slight)};
        };

        _entries pushBack [format ["%1 %2", _cyanosis, LELSTRING(breathing,GUI_Cyanosis)], [0.16, _colorScale, 1, 1]];
    } else {
        _entries pushBack [LELSTRING(breathing,GUI_NoticableCyanosis), [0.16, _colorScale, 1, 1]];
    };
};

if (EGVAR(CBRN,enable)) then {
    private _skinIrritation = (_target getVariable [QEGVAR(CBRN,SkinIrritation), [0,0,0,0,0,0]]) select _selectionN;
    
    if (_skinIrritation > 5) then {
        private _colorMultiplier = linearConversion [5, 85, _skinIrritation, 1, 0.7, true];
        private _severity = switch (true) do {
            case (_skinIrritation < 25): {LELSTRING(CBRN,GUI_Slight)};
            case (_skinIrritation < 65): {LELSTRING(CBRN,GUI_Moderate)};
            default {LELSTRING(CBRN,GUI_Severe)};
        };

        _entries pushBack [format ["%1 %2", _severity, LELSTRING(CBRN,GUI_SkinIrritation)], [(0.8 * _colorMultiplier), (0.7 * _colorMultiplier), (0.1 * _colorMultiplier), 1]];
    };
};

if (_selectionN == 0 && ((CBA_missionTime - (_target getVariable [QEGVAR(breathing,TensionPneumothorax_Time), CBA_missionTime])) > 300)) then {
    _entries pushBack [LELSTRING(breathing,GUI_TrachealDeviation), [0.5, 0.1, 0.9, 1]];
};

// BVM
if (_selectionN == 0 && (_target getVariable [QEGVAR(breathing,BVM_Medic), objNull]) isNotEqualTo objNull) then {
    private _string = LELSTRING(core,Common_Paused);
    if (alive (_target getVariable [QEGVAR(breathing,BVM_provider), objNull])) then {
        _string = LELSTRING(core,Common_Active);
    };
    _entries pushBack [format ["%1 %2 (%3)", LELSTRING(breathing,BVM_Short), _string, ([(_target getVariable [QEGVAR(breathing,BVM_Medic), objNull]), false, true] call ACEFUNC(common,getName))], _breathingColor];
};

private _selectionBodyPart = ALL_BODY_PARTS select _selectionN;

// IO
private _bodyPartIO = GET_IO(_target) select _selectionN;

if (_bodyPartIO > 0) then {
    private _IOText = switch (_bodyPartIO) do {
        case ACM_IO_EZ_M: {LELSTRING(circulation,IO_EZ)};
        case ACM_IO_FAST1_M: {LELSTRING(circulation,IO_FAST1)};
    };

    private _connectedBag = [_target, _selectionBodyPart, false] call FUNC(getBodyPartIVBags);

    private _IOEntry = "";
    if (_connectedBag != "") then {
        _IOEntry = format ["%1 [%2]", _IOText, _connectedBag];
    } else {
        _IOEntry = _IOText;
    };
    _entries pushBack [_IOEntry, _circulationColor];
};

// IV
private _bodyPartIV = GET_IV(_target) select _selectionN;

if (_bodyPartIV isNotEqualTo [0,0,0]) then {
    {
        if (_x > 0) then {
            private _IVText = switch (_x) do {
                case ACM_IV_16G_M: {LELSTRING(circulation,IV_16g)};
                case ACM_IV_14G_M: {LELSTRING(circulation,IV_14g)};
            };
            _IVText = format ["%1 (%2)", _IVText, ([LELSTRING(circulation,IV_Upper), LELSTRING(circulation,IV_Middle), LELSTRING(circulation,IV_Lower)] select _forEachIndex)];
    
            private _connectedBag = [_target, _selectionBodyPart, true, _forEachIndex, _x] call FUNC(getBodyPartIVBags);
    
            private _IVEntry = "";
    
            if (_connectedBag != "") then {
                _IVEntry = format ["%1 [%2]", _IVText, _connectedBag];
            } else {
                _IVEntry = _IVText;
            };
    
            _entries pushBack [_IVEntry, _circulationColor];
        };
    } forEach _bodyPartIV;
};

// AED
private _allowOnArm = (_target getVariable [QEGVAR(circulation,AED_Placement_PulseOximeter), -1] == (_selectionN max 0)) || (_target getVariable [QEGVAR(circulation,AED_Placement_PressureCuff), -1] == (_selectionN max 0));
private _allowOnHead = _target getVariable [QEGVAR(circulation,AED_Placement_Capnograph), false];
if ((_selectionN == 1 || (_selectionN in [2,3] && _allowOnArm) || (_selectionN == 0 && _allowOnHead)) && [_target] call EFUNC(circulation,hasAED)) then {
    private _padsStatus = _target getVariable [QEGVAR(circulation,AED_Placement_Pads), false];
    private _pulseOximeterStatus = (_target getVariable [QEGVAR(circulation,AED_Placement_PulseOximeter), -1] != -1);

    private _entry = LELSTRING(circulation,AED_Short);

    private _displayedHR = _target getVariable [QEGVAR(circulation,AED_Pads_Display), 0];

    if (_displayedHR < 1) then {
        _displayedHR = "--";
    };

    if (_padsStatus) then {
        _entry = _entry + (format [" [%1: %2", LELSTRING(circulation,AED_Monitor_HR), _displayedHR]);
    } else {
        _entry = _entry + (format [" [%1: %2", LELSTRING(circulation,AED_Monitor_PR), _displayedHR]);
    };

    if (_pulseOximeterStatus) then {
        private _displayedSPO2 = _target getVariable [QEGVAR(circulation,AED_PulseOximeter_Display), 0];

        if (_displayedSPO2 < 1) then {
            _displayedSPO2 = "--";
        };

        _entry = _entry + (format [" %1: %2", LELSTRING(circulation,AED_Monitor_SpO2), _displayedSPO2]);
    } else {
        _entry = _entry + (format [" %1: --", LELSTRING(circulation,AED_Monitor_SpO2)]);
    };

    private _measuredBP = _target getVariable [QEGVAR(circulation,AED_NIBP_Display), [0,0]];

    private _displayedBP = _measuredBP;

    if ((_measuredBP select 1) < 1) then {
        _displayedBP = ["--","--"];
    };

    _entry = _entry + (format [" %1: %2/%3", LELSTRING(circulation,AED_Monitor_BP), (_displayedBP select 0), (_displayedBP select 1)]);

    private _measuredEtCO2 = _target getVariable [QEGVAR(circulation,AED_CO2_Display), 0];
    private _measuredRR = _target getVariable [QEGVAR(circulation,AED_RR_Display), 0];

    if (_measuredEtCO2 > 0 && _measuredRR > 0) then {
        _entry = _entry + format [" %1: %2 %3: %4", LELSTRING(circulation,AED_Monitor_RR), _measuredRR, LELSTRING(circulation,AED_Monitor_CO2), _measuredEtCO2];
    } else {
        _entry = _entry + format [" %1: -- %2: --", LELSTRING(circulation,AED_Monitor_RR), LELSTRING(circulation,AED_Monitor_CO2)];
    };

    _entries pushBack [format ["%1]",_entry], [0.18, 0.6, 0.96, 1]];
};

// Pulse Oximeter
if (_selectionN in [2,3] && {HAS_PULSEOX(_target,(_selectionN - 2))}) then {
    private _pr = (_target getVariable [QEGVAR(breathing,PulseOximeter_Display), [[0,0],[0,0]]] select (_selectionN - 2)) select 1;
    private _spO2 = (_target getVariable [QEGVAR(breathing,PulseOximeter_Display), [[0,0],[0,0]]] select (_selectionN - 2)) select 0; 
    
    if (_spO2 < 1 || _pr < 1) then {
        _pr = "--";
        _spO2 = "--";
    };

    _entries pushBack [format ["%1 [%2: %3 %4: %5]", LELSTRING(breathing,PulseOximeter), LELSTRING(circulation,AED_Monitor_PR), _pr, LELSTRING(circulation,AED_Monitor_SpO2), _spo2], _breathingColor];
};

// Damage taken tooltip
if (ACEGVAR(medical_gui,showDamageEntry)) then {
    private _bodyPartDamage = GET_BODYPART_DAMAGE(_target) select _selectionN;
    if (_bodyPartDamage > 0) then {
        private _damageThreshold = GET_DAMAGE_THRESHOLD(_target);

        if (EGVAR(damage,enable)) then {
            switch (true) do {
                case (_selectionN > 3): { // legs: index 4 & 5
                    _damageThreshold = LIMPING_DAMAGE_THRESHOLD * 4;
                };
                case (_selectionN > 1): { // arms: index 2 & 3
                    _damageThreshold = FRACTURE_DAMAGE_THRESHOLD * 4;
                };
                case (_selectionN == 0): { // head: index 0
                    _damageThreshold = [EGVAR(damage,headTraumaDeathThresholdAI), EGVAR(damage,headTraumaDeathThreshold)] select (isPlayer _target);
                };
                default { // torso: index 1
                    _damageThreshold = [EGVAR(damage,bodyTraumaDeathThresholdAI), EGVAR(damage,bodyTraumaDeathThreshold)] select (isPlayer _target);
                };
            };
        } else {
            switch (true) do {
                case (_selectionN > 3): { // legs: index 4 & 5
                    if (ACEGVAR(medical,limbDamageThreshold) != 0 && {[false, !isPlayer _target, true] select ACEGVAR(medical,useLimbDamage)}) then { // Just indicate how close to the limping threshold we are
                        _damageThreshold = _damageThreshold * ACEGVAR(medical,limbDamageThreshold);
                    } else {
                        _damageThreshold = FRACTURE_DAMAGE_THRESHOLD * 4;
                    };
                };
                case (_selectionN > 1): { // arms: index 2 & 3
                    if (ACEGVAR(medical,limbDamageThreshold) != 0 && {[false, !isPlayer _target, true] select ACEGVAR(medical,useLimbDamage)}) then { // Just indicate how close to the fracture threshold we are
                        _damageThreshold = _damageThreshold * ACEGVAR(medical,limbDamageThreshold);
                    } else {
                        _damageThreshold = FRACTURE_DAMAGE_THRESHOLD * 4;
                    };
                };
                case (_selectionN == 0): { // head: index 0
                    _damageThreshold = _damageThreshold * 1.25;
                };
                default { // torso: index 1
                    _damageThreshold = _damageThreshold * 1.5;
                };
            };
        };

        // _bodyPartDamage here should indicate how close unit is to guaranteed death via sum of trauma, so use the same multipliers used in medical_damage/functions/fnc_determineIfFatal.sqf
        _bodyPartDamage = (_bodyPartDamage / (_damageThreshold max 0.01)) min 1;
        switch (true) do {
            case (_bodyPartDamage isEqualTo 1): {
                _entries pushBack [localize ACELSTRING(medical_gui,traumaSustained4), [_bodyPartDamage] call ACEFUNC(medical_gui,damageToRGBA)];
            };
            case (_bodyPartDamage >= 0.75): {
                _entries pushBack [localize ACELSTRING(medical_gui,traumaSustained3), [_bodyPartDamage] call ACEFUNC(medical_gui,damageToRGBA)];
            };
            case (_bodyPartDamage >= 0.5): {
                _entries pushBack [localize ACELSTRING(medical_gui,traumaSustained2), [_bodyPartDamage] call ACEFUNC(medical_gui,damageToRGBA)];
            };
            case (_bodyPartDamage >= 0.25): {
                _entries pushBack [localize ACELSTRING(medical_gui,traumaSustained1), [_bodyPartDamage] call ACEFUNC(medical_gui,damageToRGBA)];
            };
        };
    };
};

// Chest Seal
if (_selectionN == 1 && (_target getVariable [QEGVAR(breathing,ChestSeal_State), false])) then {
    _entries pushBack [(format ["%1 %2", LELSTRING(breathing,ChestSeal), LELSTRING(core,Common_Applied)]), [1, 0.95, 0, 1]];
};

// Standalone Pressure Cuff
if (_selectionN in [2,3] && {HAS_PRESSURECUFF(_target,(_selectionN - 2))}) then {
    _entries pushBack [LELSTRING(circulation,PressureCuff), _circulationColor];
};

// Indicate if a tourniquet is applied
if (HAS_TOURNIQUET_APPLIED_ON(_target,_selectionN)) then {
    _entries pushBack [format ["%1 [%2]",localize ACELSTRING(medical_gui,Status_Tourniquet_Applied), ((_target getVariable [QEGVAR(disability,Tourniquet_Time), [0,0,0,0,0,0]]) select _selectionN)], [0.77, 0.51, 0.08, 1]];
};

// Fractures
private _fractureState = GET_FRACTURES(_target) select _selectionN;
if (_fractureState != 0) then {
    private _splintStatus = GET_SPLINTS(_target) select _selectionN;

    if (_splintStatus != 0) then {
        switch (_splintStatus) do {
            case 2: {
                _entries pushBack [(format ["%1 %2 (%3)", LELSTRING(disability,SAMSplint), LELSTRING(core,Common_Applied), LELSTRING(disability,GUI_Wrapped)]), [0.2, 0.2, 1, 1]];
            };
            case 1: {
                _entries pushBack [(format ["%1 %2", LELSTRING(disability,SAMSplint), LELSTRING(core,Common_Applied)]), [0.2, 0.2, 1, 1]];
            };
            default {
                _entries pushBack [localize ACELSTRING(medical_gui,Status_SplintApplied), [0.2, 0.2, 1, 1]];
            };
        };
    } else {
        if (_fractureState > 0 && GVAR(showFracture)) then {
            _entries pushBack [localize ACELSTRING(medical_gui,Status_Fractured), [1, 0, 0, 1]];
        };
    };
};

// Internal bleeding indicator
private _selectionN_InternalBleeding = [_target, _selectionN] call EFUNC(damage,getBodyPartInternalBleeding);
private _HTXFluid = _target getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0];

switch (true) do {
    case (_selectionN == 1 && _HTXFluid > 0.5): {
        private _colorAdjustment = linearConversion [0.5, 1.5, _HTXFluid, 0.75, 0.45, true];
        if (_selectionN_InternalBleeding > 0.15) then {
            _colorAdjustment = _colorAdjustment max (linearConversion [0.15, 0.5, _selectionN_InternalBleeding, 0.75, 0.45, true]);
            _entries pushBack [(format ["%1 (%2)", LELSTRING(breathing,InspectChest_Bruising_Short), LELSTRING(breathing,GUI_LowerAndUpperChest)]), [_colorAdjustment, 0.1, 0.6, 1]];
        } else {
            _entries pushBack [(format ["%1 (%2)", LELSTRING(breathing,InspectChest_Bruising_Short), LELSTRING(breathing,GUI_UpperChest)]), [_colorAdjustment, 0.1, 0.6, 1]];
        };
    };
    case (_selectionN_InternalBleeding > 0.15): {
        private _colorAdjustment = linearConversion [0.15, 0.5, _selectionN_InternalBleeding, 0.75, 0.45, true];
        _entries pushBack [LELSTRING(breathing,InspectChest_Bruising_Short), [_colorAdjustment, 0.1, 0.6, 1]];
    };
    default {};
};

// Thoracostomy status
if (_selectionN == 1) then {
    switch (_target getVariable [QEGVAR(breathing,Thoracostomy_State), -1]) do {
        case 0: {_entries pushBack [(format [LELSTRING(breathing,GUI_ThoracostomyIncision_%1), LELSTRING(breathing,GUI_ThoracostomyIncision_Sealed)]), _airwayColor];};
        case 1: {_entries pushBack [(format [LELSTRING(breathing,GUI_ThoracostomyIncision_%1), LELSTRING(breathing,GUI_ThoracostomyIncision_Open)]), _airwayColor];};
        case 2: {_entries pushBack [(format [LELSTRING(breathing,GUI_ThoracostomyIncision_%1), LELSTRING(breathing,GUI_ThoracostomyIncision_ChestTube)]), _airwayColor];};
        case 3: {_entries pushBack [(format [LELSTRING(breathing,GUI_ThoracostomyIncision_%1), LELSTRING(breathing,GUI_ThoracostomyIncision_ChestTubeUnsealed)]), _airwayColor];};
        default {};
    };
};

[QACEGVAR(medical_gui,updateInjuryListPart), [_ctrl, _target, _selectionN, _entries, _bodyPartName]] call CBA_fnc_localEvent;

// Add entries for open, bandaged, and stitched wounds
private _woundEntries = [];

private _fnc_processWounds = {
    params ["_wounds", "_format", "_color"];

    {
        _x params ["_woundClassID", "_amountOf"];

        if (_amountOf > 0) then {
            private _classIndex = _woundClassID / 10;
            private _category   = _woundClassID % 10;

            private _className = ACEGVAR(medical_damage,woundClassNames) select _classIndex;
            private _suffix = ["Minor", "Medium", "Large"] select _category;

            private _woundName = localize ([(format [ACELSTRING(medical_damage,%1_%2), _className, _suffix]), (format [ELSTRING(damage,Wounds_%1_%2), _className, _suffix])] select (_className in ACM_WOUNDS));

            private _woundDescription = if (_amountOf >= 1) then {
                format ["%1x %2", ceil _amountOf, _woundName]
            } else {
                format [localize ACELSTRING(medical_gui,PartialX), _woundName]
            };

            _woundEntries pushBack [format [_format, _woundDescription], _color];
        };
    } forEach (_wounds getOrDefault [_selectionBodyPart, []]);
};

[GET_OPEN_WOUNDS(_target), "%1", [1, 1, 1, 1]] call _fnc_processWounds;
[GET_BANDAGED_WOUNDS(_target), "[B] %1", [0.88, 0.7, 0.65, 1]] call _fnc_processWounds;
[GET_STITCHED_WOUNDS(_target), "[S] %1", [0.7, 0.7, 0.7, 1]] call _fnc_processWounds;
[GET_CLOTTED_WOUNDS(_target), "[C] %1", [1, 0.5, 0.1, 1]] call _fnc_processWounds;
[GET_WRAPPED_WOUNDS(_target), "[W] %1", [0.7, 0.5, 0.1, 1]] call _fnc_processWounds;

[QACEGVAR(medical_gui,updateInjuryListWounds), [_ctrl, _target, _selectionN, _woundEntries, _bodyPartName]] call CBA_fnc_localEvent;

// Handle no wound entries
if (_woundEntries isEqualTo []) then {
    _entries pushBack [localize ACELSTRING(medical_treatment,NoInjuriesBodypart), _nonissueColor];
} else {
    _entries append _woundEntries;
};

// Add all entries to injury list
lbClear _ctrl;

{
    _x params ["_text", "_color"];

    _ctrl lbSetColor [_ctrl lbAdd _text, _color];
} forEach _entries;

_ctrl lbSetCurSel -1;
