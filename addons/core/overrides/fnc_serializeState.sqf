#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Serializes the medical state of a unit into a string.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Serialized state as JSON string <STRING>
 *
 * Example:
 * [player] call ace_medical_fnc_serializeState;
 *
 * Public: Yes
 */
params [["_unit", objNull, [objNull]]];

private _state = [] call CBA_fnc_createNamespace;

// For variables, see: EFUNC(medical_status,initUnit)
private _variableList = [
    [VAR_BLOOD_VOL, DEFAULT_BLOOD_VOLUME],
    [VAR_HEART_RATE, DEFAULT_HEART_RATE],
    [VAR_BLOOD_PRESS, [80, 120]],
    [VAR_PERIPH_RES, DEFAULT_PERIPH_RES],
    // State transition should handle this
    // [VAR_CRDC_ARRST, false],
    [VAR_SPO2, DEFAULT_SPO2],
    [VAR_HEMORRHAGE, 0],
    [VAR_PAIN, 0],
    [VAR_IN_PAIN, false],
    [VAR_PAIN_SUPP, 0],
    [VAR_OPEN_WOUNDS, createHashMap],
    [VAR_BANDAGED_WOUNDS, createHashMap],
    [VAR_STITCHED_WOUNDS, createHashMap],
    
    [VAR_FRACTURES, DEFAULT_FRACTURE_VALUES],
    // State transition should handle this
    // [VAR_UNCON, false],
    [VAR_TOURNIQUET, DEFAULT_TOURNIQUET_VALUES],
    [QACEGVAR(medical,occludedMedications), nil],
    [QACEGVAR(medical,triageLevel), 0],
    [QACEGVAR(medical,triageCard), []],
    [VAR_BODYPART_DAMAGE, DEFAULT_BODYPART_DAMAGE_VALUES],
    // Offset needs to be converted
    // [VAR_MEDICATIONS, []]
    ////////////////////////////////
    // Airway
    [QEGVAR(airway,AirwayReflex_State), true],
    [QEGVAR(airway,AirwayCollapse_State), 0],
    [QEGVAR(airway,AirwayObstructionVomit_State), 0],
    [QEGVAR(airway,AirwayObstructionVomit_GracePeriod), -1],
    [QEGVAR(airway,AirwayObstructionVomit_Count), 2],
    [QEGVAR(airway,AirwayObstructionBlood_State), 0],
    [QEGVAR(airway,RecoveryPosition_State), false],
    [QEGVAR(airway,AirwayItem_Oral), ""],
    [QEGVAR(airway,AirwayItem_Nasal), ""],
    [QEGVAR(airway,AirwayChecked_Time), nil],
    [QEGVAR(airway,SurgicalAirway_State), false],
    [QEGVAR(airway,SurgicalAirway_IncisionStitched), false],
    [QEGVAR(airway,SurgicalAirway_IncisionCount), 0],
    [QEGVAR(airway,SurgicalAirway_StrapSecure), false],
    [QEGVAR(airway,SurgicalAirway_TubeUnSecure), false],
    [QEGVAR(airway,AirwayCollapse_PFH), -1],
    [QEGVAR(airway,AirwayObstructionVomit_PFH), -1],
    [QEGVAR(airway,AirwayObstructionBlood_PFH), -1],
    // Breathing
    [QEGVAR(breathing,ChestInjury_State), false],
    [QEGVAR(breathing,Pneumothorax_State), 0],
    [QEGVAR(breathing,TensionPneumothorax_State), false],
    [QEGVAR(breathing,TensionPneumothorax_Time), nil],
    [QEGVAR(breathing,Hemothorax_State), 0],
    [QEGVAR(breathing,Hemothorax_Fluid), 0],
    [QEGVAR(breathing,ChestSeal_State), false],
    [QEGVAR(breathing,Thoracostomy_State), nil],
    [QEGVAR(breathing,Thoracostomy_UsedKit), false],
    [QEGVAR(breathing,PulseOximeter_Display), [[0,0],[0,0]]], 
    [QEGVAR(breathing,PulseOximeter_Placement), [false,false]],
    [QEGVAR(breathing,PulseOximeter_LastSync), [-1,-1]],
    [QEGVAR(breathing,Hardcore_Pneumothorax), false],
    [QEGVAR(breathing,BVM_lastBreath), nil],
    [QEGVAR(breathing,BVM_lastBreathOxygen), nil],
    [QEGVAR(breathing,RespirationRate), 18],
    [QEGVAR(breathing,Stethoscope_LungState), [0,0]],
    [QEGVAR(breathing,Pneumothorax_PFH), -1],
    [QEGVAR(breathing,Hemothorax_PFH), -1],
    // Circulation
    [QEGVAR(circulation,LozengeItem), ""],
    [QEGVAR(circulation,LozengeItem_InsertTime), -1],
    [QEGVAR(circulation,PressureCuff_Placement), [false,false]],
    [QEGVAR(circulation,ROSC_Time), nil],
    [QEGVAR(circulation,CardiacArrest_Time), nil],
    [QEGVAR(circulation,Hardcore_PostCardiacArrest), false],
    [QEGVAR(circulation,IV_Placement), ACM_IV_PLACEMENT_DEFAULT_0],
    [VAR_IV_COMPLICATIONS_PAIN, ACM_IV_PLACEMENT_DEFAULT_0],
    [VAR_IV_COMPLICATIONS_FLOW, ACM_IV_PLACEMENT_DEFAULT_0],
    [VAR_IV_COMPLICATIONS_BLOCK, ACM_IV_PLACEMENT_DEFAULT_0],
    [QEGVAR(circulation,IO_Placement), ACM_IO_PLACEMENT_DEFAULT_0],
    [QEGVAR(circulation,IV_Bags), createHashMap],
    [QEGVAR(circulation,IV_Bags_Active), false],
    [QEGVAR(circulation,IV_Bags_FreshBloodEffect), 0],
    [QEGVAR(circulation,ActiveFluidBags_IV), ACM_IV_PLACEMENT_DEFAULT_1],
    [QEGVAR(circulation,ActiveFluidBags_IO), ACM_IO_PLACEMENT_DEFAULT_1],
    [VAR_FLUIDBAG_FLOW_IV, ACM_IV_PLACEMENT_DEFAULT_1],
    [VAR_FLUIDBAG_FLOW_IO, ACM_IO_PLACEMENT_DEFAULT_1],
    [QEGVAR(circulation,Blood_Volume), 6],
    [QEGVAR(circulation,Plasma_Volume), 0],
    [QEGVAR(circulation,Saline_Volume), 0],
    [QEGVAR(circulation,Platelet_Count), 3],
    [QEGVAR(circulation,Calcium_Count), 0],
    [QEGVAR(circulation,Calcium_FirstDose), false],
    [QEGVAR(circulation,Overload_Volume), 0],
    [QEGVAR(circulation,TransfusedBlood_Volume), 0],
    [QEGVAR(circulation,HemolyticReaction_Volume), 0],
    [QEGVAR(circulation,HemolyticReaction_Severity), 0],
    [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Sinus],
    [QEGVAR(circulation,CardiacArrest_TargetRhythm), nil],
    [QEGVAR(circulation,CardiacArrest_DeteriorationTime), nil],
    [QEGVAR(circulation,CardiacArrest_ShockResistant), false],
    [QEGVAR(circulation,CardiacArrest_ResistChecked), false],
    [QEGVAR(circulation,ReversibleCardiacArrest_Time), nil],
    [QEGVAR(circulation,ReversibleCardiacArrest_State), false],
    [QEGVAR(circulation,Vasoconstriction_State), 0],
    [QEGVAR(circulation,AED_LastShock), nil],
    [QEGVAR(circulation,AED_ShockTotal), 0],
    [QEGVAR(circulation,CPR_StoppedTotal), nil],
    [QEGVAR(circulation,CPR_StoppedTime), nil],
    [QEGVAR(circulation,AmmoniaInhalant_LastUse), -1],
    [QEGVAR(circulation,CirculationState), true],
    [QEGVAR(circulation,BloodType), ACM_BLOODTYPE_O],
    [QEGVAR(circulation,CardiacArrest_PFH), -1],
    [QEGVAR(circulation,ReversibleCardiacArrest_PFH), -1],
    [QEGVAR(circulation,HemolyticReaction_PFH), -1],
    // Core
    [QEGVAR(core,KnockOut_State), false],
    [QEGVAR(core,WasTreated), false],
    [QEGVAR(core,WasWounded), false],
    // Disability
    [QEGVAR(disability,Tourniquet_Time), [0,0,0,0,0,0]],
    [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]],
    [VAR_SPLINTS, DEFAULT_SPLINT_VALUES],
    [QEGVAR(disability,Fracture_State), [0,0,0,0,0,0]],
    [QEGVAR(disability,Fracture_Prepared), [false,false,false,false,false,false]],
    [QEGVAR(disability,Fracture_Pain), [false,false,false,false,false,false]],
    [QEGVAR(disability,Fracture_ReFracture), [false,false,false,false,false,false]],
    [QEGVAR(disability,Fracture_NoEffect), [false,false,false,false,false,false]],
    [VAR_TOURNIQUET_NECROSIS, DEFAULT_TOURNIQUET_NECROSIS],
    [VAR_TOURNIQUET_NECROSIS_T, DEFAULT_TOURNIQUET_NECROSIS],
    [QEGVAR(disability,TourniquetEffects_PFH), -1],
    // Damage
    [VAR_CLOTTED_WOUNDS, createHashMap],
    [VAR_WRAPPED_WOUNDS, createHashMap],
    [VAR_INTERNAL_WOUNDS, createHashMap],
    [QEGVAR(damage,Coagulation_PFH), -1],
    [QEGVAR(damage,IBCoagulation_PFH), -1]
];

// CBRN
if (EGVAR(CBRN,enable)) then {
    _variableList append [
        [QEGVAR(CBRN,Exposed_State), false],
        [QEGVAR(CBRN,Exposed_External_State), false],
        [QEGVAR(CBRN,Contaminated_State), false],
        [QEGVAR(CBRN,BreathingAbility_State), 1],
        [QEGVAR(CBRN,BreathingAbility_Increase_State), 1],
        [QEGVAR(CBRN,EyesWashed), false],
        [QEGVAR(CBRN,Filter_State), DEFAULT_FILTER_CONDITION],
        [QEGVAR(CBRN,AirwayInflammation), 0],
        [QEGVAR(CBRN,SkinIrritation), [0,0,0,0,0,0]],
        [QEGVAR(CBRN,LungTissueDamage), 0],
        [QEGVAR(CBRN,CapillaryDamage), 0],
        [QEGVAR(CBRN,AirwaySpasm), false],
        [QEGVAR(CBRN,Chemical_Chlorine_Blindness), false],
        [QEGVAR(CBRN,Chemical_Lewisite_Blindness), false],
        [QEGVAR(CBRN,IsImmune), false],
        [QEGVAR(CBRN,Blindness_State), false]
    ];

    // Hazard Exposure
    {
        _variableList pushBack [(format ["ACM_CBRN_%1_Buildup", toLower _x]), 0];
        _variableList pushBack [(format ["ACM_CBRN_%1_Buildup_Threshold", toLower _x]), -1];
        _variableList pushBack [(format ["ACM_CBRN_%1_Exposed_State", toLower _x]), false];
        _variableList pushBack [(format ["ACM_CBRN_%1_Exposed_External_State", toLower _x]), false];
        _variableList pushBack [(format ["ACM_CBRN_%1_Contaminated_State", toLower _x]), false];
        _variableList pushBack [(format ["ACM_CBRN_%1_WasExposed", toLower _x]), false];
    } forEach EGVAR(CBRN,HazardType_Array);
};

{
    _x params ["_var"];

    _state setVariable [_var, _unit getVariable _x];
} forEach _variableList;

// Convert medications time to offset
private _medications = _unit getVariable [VAR_MEDICATIONS, []];
{
    _x set [1, _x#1 - CBA_missionTime];
} forEach _medications;
_state setVariable [VAR_MEDICATIONS, _medications];

// Medical statemachine state
private _currentState = [_unit, ACEGVAR(medical,STATE_MACHINE)] call CBA_statemachine_fnc_getCurrentState;
_state setVariable [QACEGVAR(medical,statemachineState), _currentState];

// Serialize & return
private _json = [_state] call CBA_fnc_encodeJSON;
_state call CBA_fnc_deleteNamespace;
_json
