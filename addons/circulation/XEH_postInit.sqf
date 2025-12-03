#include "script_component.hpp"

[QGVAR(handleCardiacArrest), LINKFUNC(handleCardiacArrest)] call CBA_fnc_addEventHandler;
[QGVAR(handleReversibleCardiacArrest), LINKFUNC(handleReversibleCardiacArrest)] call CBA_fnc_addEventHandler;

[QGVAR(administerMedicationLocal), LINKFUNC(administerMedicationLocal)] call CBA_fnc_addEventHandler;

[QGVAR(attemptROSC), LINKFUNC(attemptROSC)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical,CPRSucceeded), {
    params ["_patient"];

    _patient setVariable [QGVAR(Cardiac_RhythmState), ACM_Rhythm_Sinus, true];

    if (([_patient, "Adenosine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration) > 1)) exitWith {};

    _patient setVariable [QGVAR(ROSC_Time), CBA_missionTime, true];
    if ([_patient] call FUNC(recentAEDShock)) then {
        _patient setVariable [QGVAR(AED_LastShock), 0, true];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(handleCPR), LINKFUNC(handleCPR)] call CBA_fnc_addEventHandler;

[QGVAR(checkCapillaryRefillLocal), LINKFUNC(checkCapillaryRefillLocal)] call CBA_fnc_addEventHandler;

[QGVAR(setIVLocal), LINKFUNC(setIVLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleIVComplication), LINKFUNC(handleIVComplication)] call CBA_fnc_addEventHandler;
[QGVAR(setAEDLocal), LINKFUNC(setAEDLocal)] call CBA_fnc_addEventHandler;
[QGVAR(setPressureCuffLocal), LINKFUNC(setPressureCuffLocal)] call CBA_fnc_addEventHandler;

[QGVAR(setLozengeLocal), LINKFUNC(setLozengeLocal)] call CBA_fnc_addEventHandler;

[QGVAR(handleHemolyticReaction), LINKFUNC(handleHemolyticReaction)] call CBA_fnc_addEventHandler;

// Medication

[QGVAR(handleNauseaEffects), LINKFUNC(handleNauseaEffects)] call CBA_fnc_addEventHandler;

private _medicationConfig = (configFile >> "ACM_Medication" >> "Medication");

private _medicationList = [];

{
    _medicationList pushBack (configName _x);
} forEach ("true" configClasses _medicationConfig);

GVAR(MedicationList) = [];
GVAR(MedicationList_MinimumThreshold) = [];
GVAR(MedicationList_VitalsFunction) = [];
GVAR(MedicationList_EffectFunction) = [];

{
    private _minimumConcentration = (getNumber (_medicationConfig >> _x >> "minimumConcentration"));
    private _vitalsFunctionConfig = (_medicationConfig >> _x >> "vitalsFunction");

    if (_minimumConcentration > -1 && isText _vitalsFunctionConfig) then {
        GVAR(MedicationList) pushBack _x;
        GVAR(MedicationList_MinimumThreshold) pushBack (getNumber (_medicationConfig >> _x >> "minimumConcentration"));    
        GVAR(MedicationList_VitalsFunction) pushBack (getText _vitalsFunctionConfig);
        
        private _effectFunctionConfig = (_medicationConfig >> _x >> "effectFunction");

        if (isText _effectFunctionConfig) then {
            GVAR(MedicationList_EffectFunction) pushBack (getText _effectFunctionConfig);
        } else {
            GVAR(MedicationList_EffectFunction) pushBack "";
        };
    };
} forEach _medicationList;

call FUNC(generateBloodTypeList);

["isNotPerformingCPR", {!((_this select 0) getVariable [QGVAR(isPerformingCPR), false])}] call ACEFUNC(common,addCanInteractWithCondition);

if (GVAR(Hardcore_PostCardiacArrest)) then {
    [QGVAR(Hardcore_PostCardiacArrest), {
        ([1, 1.4] select (_this getVariable [QGVAR(Hardcore_PostCardiacArrest), false]));
    }] call ACEFUNC(advanced_fatigue,addDutyFactor);
};

GVAR(Fluids_Array) = FLUIDS_ARRAY;
GVAR(Fluids_Array_Data) = FLUIDS_ARRAY_DATA;

// Blood Bags
{
    private _bloodType = _x;

    {
        private _entry = format ["BloodBag_%1_%2", _bloodType, _x];
        GVAR(Fluids_Array_Data) pushBack _entry;
        GVAR(Fluids_Array) pushBack format ["ACM_%1", _entry];
    } forEach [1000,500,250];
} forEach ["O","ON","A","AN","B","BN","AB","ABN"];

GVAR(Fluids_Array) append FBTK_ARRAY; 
GVAR(Fluids_Array_Data) append FBTK_ARRAY_DATA; 

ACM_SYRINGES_10 = ['ACM_Syringe_10'];
ACM_SYRINGES_5 = ['ACM_Syringe_5'];
ACM_SYRINGES_3 = ['ACM_Syringe_3'];
ACM_SYRINGES_1 = ['ACM_Syringe_1'];

{ // Filled Syringes
    private _size = getNumber (_x >> "count");

    private _targetArray = switch (_size) do {
        case 1000: {ACM_SYRINGES_10};
        case 500: {ACM_SYRINGES_5};
        case 300: {ACM_SYRINGES_3};
        default {ACM_SYRINGES_1};
    };

    _targetArray pushBack (configName _x);
} forEach ("getNumber (_x >> 'ACM_isSyringe') > 0" configClasses (configFile >> "CfgMagazines"));

ACM_MEDICATION_VIALS = [];

{ // Medication Vials
    ACM_MEDICATION_VIALS pushBack (configName _x);
} forEach ("getNumber (_x >> 'ACM_isVial') > 0" configClasses (configFile >> "CfgWeapons"));

if (isServer) then {
    missionNamespace setVariable [QGVAR(FreshBloodList), (createHashMapFromArray [[0,[objNull,250,ACM_BLOODTYPE_ON,true,CBA_missionTime]]]), true];
};

if (hasInterface || isServer) then {
    [QGVAR(updateFreshBloodBagName), {
        params ["_size", "_id"];

        private _classname = format ["ACM_FreshBloodBag_%1_%2", _size, _id];
        private _bloodType = ([_id] call FUNC(getFreshBloodEntry)) select 2;
        private _bloodTypeString = [_bloodType, 1] call FUNC(convertBloodType);
        private _newName = format [C_LLSTRING(FreshBloodBag), (format ["%1 (%2ml) [%3]", _bloodTypeString, _size, _id])];
        [_classname, _newName] call CBA_fnc_renameInventoryItem;
    }] call CBA_fnc_addEventHandler;
};