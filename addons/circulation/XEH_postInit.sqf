#include "script_component.hpp"

[QGVAR(handleCardiacArrest), LINKFUNC(handleCardiacArrest)] call CBA_fnc_addEventHandler;
[QGVAR(handleReversibleCardiacArrest), LINKFUNC(handleReversibleCardiacArrest)] call CBA_fnc_addEventHandler;

[QGVAR(attemptROSC), LINKFUNC(attemptROSC)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical,CPRSucceeded), {
    params ["_patient"];

    _patient setVariable [QGVAR(CardiacArrest_RhythmState), 0, true];
    _patient setVariable [QGVAR(ROSC_Time), CBA_missionTime, true];
}] call CBA_fnc_addEventHandler;

[QGVAR(handleCPR), LINKFUNC(handleCPR)] call CBA_fnc_addEventHandler;

[QGVAR(checkCapillaryRefillLocal), LINKFUNC(checkCapillaryRefillLocal)] call CBA_fnc_addEventHandler;

[QGVAR(setIVLocal), LINKFUNC(setIVLocal)] call CBA_fnc_addEventHandler;
[QGVAR(setAEDLocal), LINKFUNC(setAEDLocal)] call CBA_fnc_addEventHandler;
[QGVAR(setPressureCuffLocal), LINKFUNC(setPressureCuffLocal)] call CBA_fnc_addEventHandler;

[QGVAR(handleMed_AmmoniaInhalantLocal), LINKFUNC(handleMed_AmmoniaInhalantLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_NaloxoneLocal), LINKFUNC(handleMed_NaloxoneLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_txaLocal), LINKFUNC(handleMed_TXALocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_ketamineLocal), LINKFUNC(handleAnestheticEffects)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_lidocaineLocal), LINKFUNC(handleAnestheticEffects)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,medicationLocal), {
    params ["_patient", "_bodyPart", "_classname", ["_dose", 1]];

    // Handle special medication effects
    if (_classname in ["AmmoniaInhalant", "Naloxone", "TXA_IV", "Ketamine", "Ketamine_IV", "Lidocaine"]) then {
        private _shortClassname = (_classname splitString "_") select 0;
        [(format ["ACM_circulation_handleMed_%1Local", toLower _shortClassname]), [_patient, _bodyPart, _classname], _patient] call CBA_fnc_targetEvent;
    };
}] call CBA_fnc_addEventHandler;

call FUNC(generateBloodTypeList);

["isNotPerformingCPR", {!((_this select 0) getVariable [QGVAR(isPerformingCPR), false])}] call ACEFUNC(common,addCanInteractWithCondition);

if (GVAR(Hardcore_PostCardiacArrest)) then {
    [QGVAR(Hardcore_PostCardiacArrest), {
        ([1, 1.4] select (_this getVariable [QGVAR(Hardcore_PostCardiacArrest), false]));
    }] call ACEFUNC(advanced_fatigue,addDutyFactor);
};