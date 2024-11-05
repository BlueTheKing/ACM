#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset circulation variables to default values
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

if (hasInterface) then {
    _patient setVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false];
    _patient setVariable [QGVAR(AnestheticEffect_PFH), -1];
};

_patient setVariable [QGVAR(ROSC_Time), nil, true];
_patient setVariable [QGVAR(CardiacArrest_Time), nil, true];

_patient setVariable [QGVAR(Hardcore_PostCardiacArrest), false, true];

_patient setVariable [QGVAR(IV_Placement), ACM_IV_PLACEMENT_DEFAULT_0, true];

_patient setVariable [VAR_IV_COMPLICATIONS_PAIN, ACM_IV_PLACEMENT_DEFAULT_0, true];
_patient setVariable [VAR_IV_COMPLICATIONS_FLOW, ACM_IV_PLACEMENT_DEFAULT_0, true];
_patient setVariable [VAR_IV_COMPLICATIONS_BLOCK, ACM_IV_PLACEMENT_DEFAULT_0, true];

_patient setVariable [QGVAR(IO_Placement), ACM_IO_PLACEMENT_DEFAULT_0, true];

_patient setVariable [QGVAR(IV_Bags), createHashMap, true];
_patient setVariable [QGVAR(IV_Bags_Active), false, true];
_patient setVariable [QGVAR(IV_Bags_FreshBloodEffect), 0, true];

_patient setVariable [QGVAR(ActiveFluidBags_IV), ACM_IV_PLACEMENT_DEFAULT_1, true];
_patient setVariable [QGVAR(ActiveFluidBags_IO), ACM_IO_PLACEMENT_DEFAULT_1, true];

_patient setVariable [VAR_FLUIDBAG_FLOW_IV, ACM_IV_PLACEMENT_DEFAULT_1, true];
_patient setVariable [VAR_FLUIDBAG_FLOW_IO, ACM_IO_PLACEMENT_DEFAULT_1, true];

_patient setVariable [QGVAR(Blood_Volume), 6, true];
_patient setVariable [QGVAR(Plasma_Volume), 0, true];
_patient setVariable [QGVAR(Saline_Volume), 0, true];

_patient setVariable [QGVAR(Platelet_Count), 3, true];
_patient setVariable [QGVAR(Calcium_Count), 0, true];
_patient setVariable [QGVAR(Calcium_FirstDose), false, true];

_patient setVariable [QGVAR(Overload_Volume), 0, true];
_patient setVariable [QGVAR(TransfusedBlood_Volume), 0, true];

_patient setVariable [QGVAR(HemolyticReaction_Volume), 0, true];
_patient setVariable [QGVAR(HemolyticReaction_Severity), 0, true];

_patient setVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus, true];
_patient setVariable [QGVAR(CardiacArrest_TargetRhythm), nil];
_patient setVariable [QGVAR(CardiacArrest_DeteriorationTime), nil];

_patient setVariable [QGVAR(CardiacArrest_ShockResistant), false, true];
_patient setVariable [QGVAR(CardiacArrest_ResistChecked), false, true];

_patient setVariable [QGVAR(ReversibleCardiacArrest_Time), nil];
_patient setVariable [QGVAR(ReversibleCardiacArrest_State), false, true];

// AED
_patient setVariable [QGVAR(AED_PFH), -1];
_patient setVariable [QGVAR(AED_StartTime), -1, true];
_patient setVariable [QGVAR(AED_Provider), nil, true];
_patient setVariable [QGVAR(AED_InUse), false, true];

_patient setVariable [QGVAR(AED_EKGDisplay), [], true];
_patient setVariable [QGVAR(AED_EKGRefreshDisplay), [], true];
_patient setVariable [QGVAR(AED_PODisplay), [], true];
_patient setVariable [QGVAR(AED_PORefreshDisplay), [], true];
_patient setVariable [QGVAR(AED_CODisplay), [], true];
_patient setVariable [QGVAR(AED_CORefreshDisplay), [], true];

_patient setVariable [QGVAR(AED_Placement_Pads), false, true];
_patient setVariable [QGVAR(AED_Pads_LastSync), CBA_missionTime];
_patient setVariable [QGVAR(AED_Pads_Display), 0, true];
_patient setVariable [QGVAR(AED_LastShock), nil, true];
_patient setVariable [QGVAR(AED_ShockTotal), 0, true];

_patient setVariable [QGVAR(AED_Placement_PulseOximeter), -1, true];
_patient setVariable [QGVAR(AED_PulseOximeter_LastSync), CBA_missionTime];
_patient setVariable [QGVAR(AED_PulseOximeter_Display), 0, true];

_patient setVariable [QGVAR(AED_Placement_Capnograph), false, true];
_patient setVariable [QGVAR(AED_Capnograph_LastSync), CBA_missionTime];
_patient setVariable [QGVAR(AED_CO2_Display), 0, true];
_patient setVariable [QGVAR(AED_RR_Display), 0, true];

_patient setVariable [QGVAR(AED_Placement_PressureCuff), -1, true];
_patient setVariable [QGVAR(AED_NIBP_Display), [0,0], true];

_patient setVariable [QGVAR(CPR_StoppedTotal), nil, true];
_patient setVariable [QGVAR(CPR_StoppedTime), nil, true];
_patient setVariable [QGVAR(CPR_CorpulsStop), false, true];

_patient setVariable [QGVAR(CPR_Medic), objNull, true];
_patient setVariable [QGVAR(isPerformingCPR), false, true];

_patient setVariable [QGVAR(AmmoniaInhalant_LastUse), -1, true];

[_patient] call FUNC(updateCirculationState);
[_patient] call FUNC(generateBloodType);