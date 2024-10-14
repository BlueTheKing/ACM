#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut, PabstMirror, johnb43
 * Applies healing to target.
 * States that contain "needs" are states in which the medic is blocked, either temporairly (HR too high/low) or until resupplied, from treating.
 * States that contain "wait" are states where the medic waits temporairly before continuing treatment.
 *
 * Arguments:
 * 0: Healer <OBJECT>
 * 1: Target <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [cursorObject, cursorObject] call ace_medical_ai_fnc_healingLogic
 *
 * Public: No
 */

params ["_healer", "_target"];
(_healer getVariable [QACEGVAR(medical_ai,currentTreatment), [-1]]) params ["_finishTime", "_treatmentTarget", "_treatmentEvent", "_treatmentArgs", "_treatmentItem"];

// Treatment in progress, check if finished and apply
if (_finishTime > 0) exitWith {
    if (CBA_missionTime >= _finishTime) then {
        TRACE_5("treatment finished",_finishTime,_treatmentTarget,_treatmentEvent,_treatmentArgs,_treatmentItem);
        _healer setVariable [QACEGVAR(medical_ai,currentTreatment), nil];

        private _usedItem = "";

        if ((ACEGVAR(medical_ai,requireItems) > 0) && {_treatmentItem != ""}) then {
            ([_healer, _treatmentItem] call ACEFUNC(medical_ai,itemCheck)) params ["_itemOk", "_itemClassname", "_treatmentClass"];
             // No item after treatment done
            if (!_itemOk) exitWith {
                _treatmentEvent = "#fail";
            };

            _healer removeItem _itemClassname;
            _usedItem = _itemClassname;

            if (_treatmentClass != "") then {
                _treatmentArgs set [2, _treatmentClass];
            };
        };
        if ((_treatmentTarget == _target) && {(_treatmentEvent select [0, 1]) != "#"}) then {
            // There is no event for tourniquet removal, so handle calling function directly
            if (_treatmentEvent == QACEGVAR(medical_ai,tourniquetRemove)) exitWith {
                _treatmentArgs call ACEFUNC(medical_treatment,tourniquetRemove);
            };

            [_treatmentEvent, _treatmentArgs, _target] call CBA_fnc_targetEvent;

            // Splints are already logged on their own
            switch (_treatmentEvent) do {
                case QEGVAR(disability,shakeAwakeLocal): {
                    [_target, "activity", LELSTRING(disability,ShakePatient_ActionLog), [[_healer, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
                };
                case QACEGVAR(medical_treatment,bandageLocal): {
                    [_target, "activity", ACELSTRING(medical_treatment,Activity_bandagedPatient), [[_healer, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
                };
                case QEGVAR(circulation,setIVLocal): {
                    _treatmentArgs params ["", "", "", "", "_iv", "_accessSite"];

                    if (_iv) then {
                        private _accessSiteHint = [LELSTRING(circulation,IV_Upper), LELSTRING(circulation,IV_Middle), LELSTRING(circulation,IV_Lower)] select _accessSite;

                        [_target, "activity", "%1 %2 %3 (%4)", [[_healer, false, true] call ACEFUNC(common,getName), (toLower LELSTRING(core,Common_Inserted)), LELSTRING(circulation,IV_16g), _accessSiteHint]] call ACEFUNC(medical_treatment,addToLog);
                    } else {
                        [_target, "activity", "%1 %2 %3", [[_healer, false, true] call ACEFUNC(common,getName), (toLower LELSTRING(core,Common_Inserted)), LELSTRING(circulation,IO_FAST1)]] call ACEFUNC(medical_treatment,addToLog);
                    };
                };
                case QACEGVAR(medical_treatment,ivBagLocal): {
                    if (_usedItem == "") then {
                        _usedItem = "ACE_salineIV";
                    };

                    [_target, _usedItem] call ACEFUNC(medical_treatment,addToTriageCard);
                    [_target, "activity", LELSTRING(circulation,GUI_BeganTransfusing), [[_healer, false, true] call ACEFUNC(common,getName), ([_classname] call EFUNC(circulation,getFluidBagString)), ([_bodyPart] call FUNC(getBodyPartString))]] call ACEFUNC(medical_treatment,addToLog);
                };
                case QEGVAR(airway,handleSuctionLocal): {
                    if (_usedItem == "") then {
                        _usedItem = "ACM_SuctionBag";
                    };

                    [_target, "activity", ACELSTRING(medical_treatment,Activity_usedItem), [[_healer, false, true] call ACEFUNC(common,getName), LELSTRING(airway,SuctionBag_Short)]] call ACEFUNC(medical_treatment,addToLog);
                };
                case QEGVAR(breathing,applyChestSealLocal): {
                    if (_usedItem == "") then {
                        _usedItem = "ACM_ChestSeal";
                    };

                    [_target, LELSTRING(breathing,ChestSeal)] call ACEFUNC(medical_treatment,addToTriageCard);
                    [_target, "activity", LELSTRING(breathing,ChestSeal_ActionLog), [[_healer, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
                };
                case QACEGVAR(medical_treatment,medicationLocal): {
                    _usedItem = switch (_treatmentItem) do {
                        case "morphine": {
                            "ACE_morphine"
                        };
                        case "naloxone": {
                            "ACM_Spray_Naloxone"
                        };
                        case "penthrox": {
                            "ACM_Inhaler_Penthrox"
                        };
                        case "paracetamol": {
                            "ACM_Paracetamol"
                        };
                    };

                    [_target, _usedItem] call ACEFUNC(medical_treatment,addToTriageCard);
                    
                    private _cfg = ["CfgWeapons", "CfgMagazines"] select (isClass (configFile >> "CfgMagazines" >> _usedItem));
                    [_target, "activity", ACELSTRING(medical_treatment,Activity_usedItem), [[_healer, false, true] call ACEFUNC(common,getName), getText (configFile >> _cfg >> _usedItem >> "displayName")]] call ACEFUNC(medical_treatment,addToLog);
                };
                case QACEGVAR(medical_treatment,tourniquetLocal): {
                    [_target, "ACE_tourniquet"] call ACEFUNC(medical_treatment,addToTriageCard);
                    [_target, "activity", ACELSTRING(medical_treatment,Activity_appliedTourniquet), [[_healer, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
                };
            };

            #ifdef DEBUG_MODE_FULL
            INFO_4("%1->%2: %3 - %4",_healer,_target,_treatmentEvent,_treatmentArgs);
            systemChat format ["Applying [%1->%2]: %3", _healer, _treatmentTarget, _treatmentEvent];
            #endif
        };
    };
};

// Bandage a limb up, then remove the tourniquet on it
private _fnc_removeTourniquet = {
    params [["_removeAllTourniquets", false]];

    // Ignore head & torso if not removing all tourniquets (= administering drugs/IVs)
    private _offset = [2, 0] select _removeAllTourniquets;

    // Bandage the least bleeding body part
    private _bodyPartBleeding = [];
    _bodyPartBleeding resize [[4, 6] select _removeAllTourniquets, -1];

    {
        // Ignore head and torso, if only looking for place to administer drugs/IVs
        private _partIndex = (ALL_BODY_PARTS find _x) - _offset;

        if (_partIndex >= 0 && {_tourniquets select _partIndex != 0}) then {
            {
                _x params ["", "_amountOf", "_bleeding"];

                // max 0, to set the baseline to 0, as body parts with no wounds are marked with -1
                _bodyPartBleeding set [_partIndex, ((_bodyPartBleeding select _partIndex) max 0) + (_amountOf * _bleeding)];
            } forEach _y;
        };
    } forEach GET_OPEN_WOUNDS(_target);

    // If there are no open wounds, check if there are tourniquets on limbs with no open wounds (stitched or fully healed),
    // as we know there have to be tourniquets at this point
    if (_bodyPartBleeding findIf {_x != -1} == -1) then {
        _bodyPartBleeding set [_tourniquets findIf {_x != 0}, 0];
    };

    // Ignore body parts that don't have open wounds (-1)
    private _minBodyPartBleeding = selectMin (_bodyPartBleeding select {_x != -1});
    private _selection = ALL_BODY_PARTS select ((_bodyPartBleeding find _minBodyPartBleeding) + _offset);

    // If not bleeding anymore, remove the tourniquet
    if (_minBodyPartBleeding == 0) exitWith {
        _treatmentEvent = QACEGVAR(medical_ai,tourniquetRemove);
        _treatmentTime = 7;
        _treatmentArgs = [_healer, _target, _selection];
    };

    // If no bandages available, wait
    // If check is done at the start of the scope, it will miss the edge case where the unit ran out of bandages just as they finished bandaging tourniqueted body part
    if !(([_healer, "@bandage"] call ACEFUNC(medical_ai,itemCheck)) # 0) exitWith {
        _treatmentEvent = "#needsBandage";
    };

    // Otherwise keep bandaging
    _treatmentEvent = QACEGVAR(medical_treatment,bandageLocal);
    _treatmentTime = 5;
    _treatmentArgs = [_target, _selection, "FieldDressing"];
    _treatmentItem = "@bandage";
};

// Find a suitable limb (no tourniquets) for adminstering drugs/IVs
private _fnc_findNoTourniquet = {
    private _bodyPart = "";

    // If all limbs have tourniquets, find the least damaged limb and try to bandage it
    if ((_tourniquets select [2]) find 0 == -1) then {
        call _fnc_removeTourniquet;
    } else {
        // Select a random non-tourniqueted limb otherwise
        private _bodyParts = ["leftarm", "rightarm", "leftleg", "rightleg"];

        while {_bodyParts isNotEqualTo []} do {
            _bodyPart = selectRandom _bodyParts;

            // If no tourniquet on, use that body part
            if (_tourniquets select (ALL_BODY_PARTS find _bodyPart) == 0) exitWith {};

            _bodyParts deleteAt (_bodyParts find _bodyPart);
        };
    };

    _bodyPart // return
};

private _tourniquets = GET_TOURNIQUETS(_target);

private _treatmentEvent = "#none";
private _treatmentArgs = [];
private _treatmentTime = 6;
private _treatmentItem = "";

if (true) then {
    if (IS_BLEEDING(_target)) exitWith {
        private _hasBandage = ([_healer, "@bandage"] call ACEFUNC(medical_ai,itemCheck)) # 0;
        private _hasTourniquet = ([_healer, "tourniquet"] call ACEFUNC(medical_ai,itemCheck)) # 0;

        // Patient is not worth treating if bloodloss can't be stopped
        if !(_hasBandage || _hasTourniquet) exitWith {
            _treatmentEvent = "#needsBandageOrTourniquet";
        };

        // Bandage the heaviest bleeding body part
        private _bodyPartBleeding = [0, 0, 0, 0, 0, 0];

        {
            private _partIndex = ALL_BODY_PARTS find _x;

            // Ignore tourniqueted limbs
            if (_tourniquets select _partIndex == 0) then {
                {
                    _x params ["", "_amountOf", "_bleeding"];
                    _bodyPartBleeding set [_partIndex, (_bodyPartBleeding select _partIndex) + (_amountOf * _bleeding)];
                } forEach _y;
            };
        } forEach GET_OPEN_WOUNDS(_target);

        private _maxBodyPartBleeding = selectMax _bodyPartBleeding;
        private _bodyPartIndex = _bodyPartBleeding find _maxBodyPartBleeding;
        private _selection = ALL_BODY_PARTS select _bodyPartIndex;

        // Apply tourniquet if moderate bleeding or no bandage is available, and if not head and torso
        if (_hasTourniquet && {_bodyPartIndex > HITPOINT_INDEX_BODY} && {!_hasBandage || {_maxBodyPartBleeding > 0.3}}) exitWith {
            _treatmentEvent = QACEGVAR(medical_treatment,tourniquetLocal);
            _treatmentTime = 7;
            _treatmentArgs = [_target, _selection];
            _treatmentItem = "tourniquet";
        };

        _treatmentEvent = QACEGVAR(medical_treatment,bandageLocal);
        _treatmentTime = 5;
        _treatmentArgs = [_target, _selection, "PressureBandage"];
        _treatmentItem = "@bandage";
    };

    private _isUnconscious = IS_UNCONSCIOUS(_target);
    private _inCardiacArrest = IN_CRDC_ARRST(_target);

    private _bloodVolume = GET_BLOOD_VOLUME(_target);
    private _needsIV = _bloodVolume < MINIMUM_BLOOD_FOR_STABLE_VITALS;

    if (_isUnconscious && !_needsIV && !_inCardiacArrest && GET_OXYGEN(_target) > ACM_CYANOSIS_T_SLIGHT) exitWith {
        _treatmentEvent = QEGVAR(disability,shakeAwakeLocal);
        _treatmentTime = 1.5;
        _treatmentArgs = [_healer, _target];
        _treatmentItem = "";
    };

    private _performAirwayType = 0;

    if (_isUnconscious && GET_AIRWAYADJUNCT_ORAL(_target) == "" && GET_AIRWAYADJUNCT_NASAL(_target) == "") then {
        private _hasAirwayAdjunct = ([_healer, "@airway"] call ACEFUNC(medical_ai,itemCheck)) # 0;

        private _airwayObstruction = (_target getVariable [QEGVAR(airway,AirwayObstructionVomit_State), 0]) + (_target getVariable [QEGVAR(airway,AirwayObstructionBlood_State), 0]);

        if (_airwayObstruction > 0) then {
            if (_airwayObstruction < 2) then {
                _performAirwayType = 2;
            } else {
                _performAirwayType = [0, 3] select (([_healer, "@suction"] call ACEFUNC(medical_ai,itemCheck)) # 0);
            };
        } else {
            _performAirwayType = [0, 1] select _hasAirwayAdjunct;
        };
    };

    if (_performAirwayType > 0) exitWith {
        switch (_performAirwayType) do {
            case 2: {
                _treatmentEvent = QEGVAR(airway,performHeadTurn);
                _treatmentTime = 5;
                _treatmentArgs = [_healer, _target];
            };
            case 3: {
                _treatmentEvent = QEGVAR(airway,handleSuctionLocal);
                _treatmentTime = 8;
                _treatmentArgs = [_target];
                _treatmentItem = "@suction";
            };
            default {
                _treatmentEvent = QEGVAR(airway,insertAirwayItem);
                _treatmentTime = 5;
                _treatmentArgs = [_healer, _target, "NPA"];
                _treatmentItem = "@airway";
            };
        };
    };

    private _hasChestInjury = _target getVariable [QEGVAR(breathing,ChestInjury_State), false];

    if (_hasChestInjury && !(_target getVariable [QEGVAR(breathing,ChestSeal_State), false])) exitWith {
        _treatmentEvent = QEGVAR(breathing,applyChestSealLocal);
        _treatmentTime = 5;
        _treatmentArgs = [_healer, _target];
        _treatmentItem = "@chestseal";
    };

    private _opioidDose = ([_target, "Morphine"] call ACEFUNC(medical_status,getMedicationCount)) + ([_target, "Morphine_IV"] call ACEFUNC(medical_status,getMedicationCount)) + ([_target, "Fentanyl"] call ACEFUNC(medical_status,getMedicationCount)) + ([_target, "Fentanyl_IV"] call ACEFUNC(medical_status,getMedicationCount));

    if (_isUnconscious && (_inCardiacArrest || _opioidDose > 2 || (GET_RESPIRATION_RATE(_target) < 12)) && ([_healer, "naloxone", _target] call ACEFUNC(medical_ai,itemCheck)) # 0) exitWith {
        if (CBA_missionTime < (_target getVariable [QACEGVAR(medical_ai,nextNaloxone), -1])) exitWith {
            _treatmentEvent = "#waitForNaloxoneToTakeEffect";
        };

        _target setVariable [QACEGVAR(medical_ai,nextNaloxone), CBA_missionTime + 60];

        _treatmentEvent = QACEGVAR(medical_treatment,medicationLocal);
        _treatmentTime = 5;
        _treatmentArgs = [_target, "head", "Naloxone"];
        _treatmentItem = "naloxone";
    };

    
    private _canGiveIV = _needsIV && {_healer call ACEFUNC(medical_treatment,isMedic)};

    private _canGiveFluid = _canGiveIV && {([_healer, "@fluid"] call ACEFUNC(medical_ai,itemCheck)) # 0}; // Has fluid
    private _hasIVAccess = [_target] call EFUNC(circulation,hasIV);
    private _hasIOAccess = [_target] call EFUNC(circulation,hasIO);
    private _hasAccess = _hasIVAccess || _hasIOAccess;

    private _canInsertIV = _canGiveIV && !_hasAccess && {([_healer, "@iv"] call ACEFUNC(medical_ai,itemCheck)) # 0 && !_inCardiacArrest};
    private _canInsertIO = _canGiveIV && !_hasAccess && {([_healer, "@io"] call ACEFUNC(medical_ai,itemCheck)) # 0 && !_canInsertIV};

    private _canTransfuse = _canGiveFluid && _hasAccess;
    
    private _doCPR = _inCardiacArrest;

    // If in cardiac arrest, first add some blood to injured if necessary, then do CPR (doing CPR when not enough blood is suboptimal if you have IVs)
    // If healer has no IVs, allow AI to do CPR to keep injured alive
    if (_doCPR && {!_canGiveIV || {_bloodVolume >= BLOOD_VOLUME_CLASS_3_HEMORRHAGE}}) exitWith {
        _treatmentEvent = QACEGVAR(medical_treatment,cprLocal);
        _treatmentArgs = [_healer, _target];
        _treatmentTime = 120;
    };

    private _bodypart = "";

    if (_canInsertIV && {
        // If all limbs are tourniqueted, bandage the one with the least amount of wounds, so that the tourniquet can be removed
        _bodyPart = call _fnc_findNoTourniquet;
        _bodyPart == "";
    }) exitWith {};

    if (_canInsertIV || _canInsertIO) exitWith {
        if (_canInsertIV) then {
            private _targetBodyPart = _bodyPart;

            _treatmentEvent = QEGVAR(circulation,setIVLocal);
            _treatmentTime = 6;
            _treatmentArgs = [_healer, _target, _targetBodyPart, ACM_IV_16G_M, true, (round (random 2))];
            _treatmentItem = "@io";
        } else {
            _treatmentEvent = QEGVAR(circulation,setIVLocal);
            _treatmentTime = 4;
            _treatmentArgs = [_healer, _target, "body", ACM_IO_FAST1_M, false, -1];
            _treatmentItem = "@io";
        };
    };

    if (_canTransfuse) then {
        // Check if patient's blood volume + remaining IV volume is enough to allow the patient to wake up
        private _totalIVVolume = 0; //in ml
        private _IVBags = _target getVariable [QEGVAR(circulation,IV_Bags), createHashMap];
        {
            private _IVBagsBodyPart = _IVBags getOrDefault [_x, []];

            {
                _x params ["", "_volumeRemaining"];

                _totalIVVolume = _totalIVVolume + _volumeRemaining;
            } forEach _IVBagsBodyPart;
        } forEach ALL_BODY_PARTS;

        // Check if the medic has to wait, which allows for a little multitasking
        if (_bloodVolume + (_totalIVVolume / 1000) >= MINIMUM_BLOOD_FOR_STABLE_VITALS) then {
            _treatmentEvent = "#waitForIV";
            _needsIV = false;
            _canTransfuse = false;
        };
    };

    if (_canTransfuse) exitWith {
        private _isIV = _hasIVAccess;
        private _targetBodyPart = 0;

        if (_isIV) then {
            {
                if (_x isNotEqualTo ACM_IV_P_SITE_DEFAULT_0) then {
                    _targetBodyPart = _forEachIndex;
                    break;
                };
            } forEach GET_IV(_target);
        } else {
            {
                if (_x > 0) then {
                    _targetBodyPart = _forEachIndex;
                    break;
                };
            } forEach GET_IO(_target);
        };

        private _targetAccessSite = -1;

        if (_isIV) then {
            {
                if (_x > 0) then {
                    _targetAccessSite = _forEachIndex;
                    break;
                };
                
            } forEach GET_IV(_target);
        };

        private _targetAccessType = [_target, _isIV, _targetBodyPart, _targetAccessSite] call EFUNC(circulation,getAccessType);
        _treatmentEvent = QACEGVAR(medical_treatment,ivBagLocal);
        _treatmentTime = 5;
        _treatmentArgs = [_target, (ALL_BODY_PARTS select _targetBodyPart), "SalineIV", _targetAccessType, _isIV, _targetAccessSite];
        _treatmentItem = "@fluid";
    };

    // Leg fractures
    private _index = (GET_FRACTURES(_target) select [4, 2]) find 1;

    if (_index != -1 && {
            // In case the unit doesn't have a splint, set state here
            _treatmentEvent = "#needsSplint";

            ([_healer, "splint"] call ACEFUNC(medical_ai,itemCheck)) # 0
    }) exitWith {
        _treatmentEvent = QACEGVAR(medical_treatment,splintLocal);
        _treatmentTime = 6;
        _treatmentArgs = [_healer, _target, ALL_BODY_PARTS select (_index + 4)];
        _treatmentItem = "splint";
    };

    // Wait until the injured has enough blood before administering drugs
    // (_needsIV && !_canGiveIV), but _canGiveIV is false here, otherwise IV would be given
    if (_needsIV || {_doCPR && {_treatmentEvent == "#waitForIV"}}) exitWith {
        // If injured is in cardiac arrest and the healer is doing nothing else, start CPR
        if (_doCPR) exitWith {
            // Medic remains in this loop until injured is given enough IVs or dies
            _treatmentEvent = QACEGVAR(medical_treatment,cprLocal);
            _treatmentArgs = [_healer, _target];
            _treatmentTime = 120;
        };

        // If the injured needs IVs, but healer can't give it to them, have healder wait
        if (_needsIV) exitWith {
            _treatmentEvent = "#needsIV";
        };
    };

    // These checks are not exitWith, so that the medic can try to bandage up tourniqueted body parts
    if ((count (_target getVariable [VAR_MEDICATIONS, []])) >= 6) then {
        _treatmentEvent = "#needsFewerMeds";
    };

    private _heartRate = GET_HEART_RATE(_target);

    // Remove all remaining tourniquets by bandaging all body parts
    if (_tourniquets isNotEqualTo DEFAULT_TOURNIQUET_VALUES) then {
        true call _fnc_removeTourniquet;
    };

    // If the healer can bandage or remove tourniquets, do that
    if (_treatmentEvent in [QACEGVAR(medical_treatment,bandageLocal), QACEGVAR(medical_ai,tourniquetRemove)]) exitWith {};

    // Otherwise, if the healer is either done or out of bandages, continue
    if (!(_treatmentEvent in ["#needsFewerMeds", "#waitForIV"]) && !_isUnconscious && {(GET_PAIN_PERCEIVED(_target) > 0.25)}) exitWith {
        private _penthroxDose = [_target, "Penthrox"] call ACEFUNC(medical_status,getMedicationCount);
        private _paracetamolDose = [_target, "Paracetamol"] call ACEFUNC(medical_status,getMedicationCount);
        
        switch (true) do {
            case (GET_PAIN_PERCEIVED(_target) > 0.5 && !_hasChestInjury && _heartRate > 60 && _opioidDose < 0.5 && {([_healer, "morphine"] call ACEFUNC(medical_ai,itemCheck)) # 0}): {
                if (CBA_missionTime < (_target getVariable [QACEGVAR(medical_ai,nextMorphine), -1])) exitWith {
                    _treatmentEvent = "#waitForMorphineToTakeEffect";
                };

                // If all limbs are tourniqueted, bandage the one with the least amount of wounds, so that the tourniquet can be removed
                _bodyPart = call _fnc_findNoTourniquet;

                if (_bodyPart == "") exitWith {};

                _target setVariable [QACEGVAR(medical_ai,nextMorphine), CBA_missionTime + 1800];

                _treatmentEvent = QACEGVAR(medical_treatment,medicationLocal);
                _treatmentTime = 4;
                _treatmentArgs = [_target, _bodyPart, "Morphine", 10];
                _treatmentItem = "morphine";
            };
            case (_penthroxDose < 2 && {([_healer, "penthrox"] call ACEFUNC(medical_ai,itemCheck)) # 0}): {
                if (CBA_missionTime < (_target getVariable [QACEGVAR(medical_ai,nextPenthrox), -1])) exitWith {
                    _treatmentEvent = "#waitForPenthroxToTakeEffect";
                };

                _target setVariable [QACEGVAR(medical_ai,nextPenthrox), CBA_missionTime + 60];

                _treatmentEvent = QACEGVAR(medical_treatment,medicationLocal);
                _treatmentTime = 5;
                _treatmentArgs = [_target, "head", "Penthrox"];
                _treatmentItem = "penthrox";
            };
            case (_paracetamolDose < 2 && {([_healer, "paracetamol"] call ACEFUNC(medical_ai,itemCheck)) # 0}): {
                if (CBA_missionTime < (_target getVariable [QACEGVAR(medical_ai,nextParacetamol), -1])) exitWith {
                    _treatmentEvent = "#waitForParacetamolToTakeEffect";
                };

                _target setVariable [QACEGVAR(medical_ai,nextParacetamol), CBA_missionTime + 120];

                _treatmentEvent = QACEGVAR(medical_treatment,medicationLocal);
                _treatmentTime = 5;
                _treatmentArgs = [_target, "head", "Paracetamol"];
                _treatmentItem = "paracetamol";
            };
        };
    };
};

_healer setVariable [QACEGVAR(medical_ai,currentTreatment), [CBA_missionTime + _treatmentTime, _target, _treatmentEvent, _treatmentArgs, _treatmentItem]];

// Play animation
if ((_treatmentEvent select [0, 1]) != "#") then {
    private _treatmentClassname = switch (_treatmentEvent) do {
        case QACEGVAR(medical_treatment,splintLocal): {"Splint"};
        case QACEGVAR(medical_treatment,cprLocal): {"CPR"};
        case QACEGVAR(medical_treatment,tourniquetLocal): {"ApplyTourniquet"};
        case QACEGVAR(medical_ai,tourniquetRemove): {"RemoveTourniquet"};
        case QEGVAR(breathing,applyChestSealLocal): {"ApplyChestSeal"};
        case QEGVAR(circulation,setIVLocal): {"InsertIV_16G"};
        case QACEGVAR(medical_treatment,ivBagLocal): {"RemoveTourniquet"};
        case QEGVAR(airway,performHeadTurn): {"HeadTurn"};
        case QEGVAR(airway,handleSuctionLocal): {"UseSuctionBag"};
        case QEGVAR(airway,insertAirwayItem): {"InsertNPA"};
        case QEGVAR(disability,shakeAwakeLocal): {"ShakeAwake"};
        default {_treatmentArgs select 2};
    };

    [_healer, _treatmentClassname, _healer == _target] call ACEFUNC(medical_ai,playTreatmentAnim);
};

#ifdef DEBUG_MODE_FULL
TRACE_4("treatment started",_treatmentTime,_target,_treatmentEvent,_treatmentArgs);
systemChat format ["Treatment [%1->%2]: %3", _healer, _target, _treatmentEvent];
#endif
