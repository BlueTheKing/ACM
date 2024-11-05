#include "script_component.hpp"

[QGVAR(handleCardiacArrest), LINKFUNC(handleCardiacArrest)] call CBA_fnc_addEventHandler;
[QGVAR(handleReversibleCardiacArrest), LINKFUNC(handleReversibleCardiacArrest)] call CBA_fnc_addEventHandler;

[QGVAR(attemptROSC), LINKFUNC(attemptROSC)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical,CPRSucceeded), {
    params ["_patient"];

    _patient setVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus, true];

    if (([_patient, "Adenosine_IV", false] call ACEFUNC(medical_status,getMedicationCount) > 0.1)) exitWith {};

    _patient setVariable [QGVAR(ROSC_Time), CBA_missionTime, true];
}] call CBA_fnc_addEventHandler;

[QGVAR(handleCPR), LINKFUNC(handleCPR)] call CBA_fnc_addEventHandler;

[QGVAR(checkCapillaryRefillLocal), LINKFUNC(checkCapillaryRefillLocal)] call CBA_fnc_addEventHandler;

[QGVAR(setIVLocal), LINKFUNC(setIVLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleIVComplication), LINKFUNC(handleIVComplication)] call CBA_fnc_addEventHandler;
[QGVAR(setAEDLocal), LINKFUNC(setAEDLocal)] call CBA_fnc_addEventHandler;
[QGVAR(setPressureCuffLocal), LINKFUNC(setPressureCuffLocal)] call CBA_fnc_addEventHandler;

[QGVAR(handleMed_AdenosineLocal), LINKFUNC(handleMed_AdenosineLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_AmiodaroneLocal), LINKFUNC(handleMed_AmiodaroneLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_AmmoniaInhalantLocal), LINKFUNC(handleMed_AmmoniaInhalantLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_NaloxoneLocal), LINKFUNC(handleMed_NaloxoneLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_TXALocal), LINKFUNC(handleMed_TXALocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_KetamineLocal), LINKFUNC(handleAnestheticEffects)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_LidocaineLocal), LINKFUNC(handleAnestheticEffects)] call CBA_fnc_addEventHandler;

[QGVAR(handleMed_CalciumChlorideLocal), LINKFUNC(handleMed_CalciumChlorideLocal)] call CBA_fnc_addEventHandler;

[QGVAR(handleHemolyticReaction), LINKFUNC(handleHemolyticReaction)] call CBA_fnc_addEventHandler;

[QGVAR(handleMedicationEffects), {
    params ["_patient", "_bodyPart", "_classname", ["_dose", 1]];

    // Handle special medication effects
    if (_classname in ["AmmoniaInhalant", "Naloxone", "TXA_IV", "Ketamine", "Ketamine_IV", "Lidocaine", "CalciumChloride_IV", "Adenosine_IV"]) then {
        private _shortClassname = (_classname splitString "_") select 0;
        [(format ["ACM_circulation_handleMed_%1Local", toLower _shortClassname]), [_patient, _bodyPart, _classname, _dose], _patient] call CBA_fnc_targetEvent;
    };
}] call CBA_fnc_addEventHandler;

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
        GVAR(Fluids_Array_Data) pushback _entry;
        GVAR(Fluids_Array) pushback format ["ACM_%1", _entry];
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