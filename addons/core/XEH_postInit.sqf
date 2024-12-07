#include "script_component.hpp"

if (GVAR(ignoreIncompatibleAddonWarning)) then {
    INFO("Incompatible Addon Warning Disabled");
} else {
    ["CBA_settingsInitialized", {
        [] call FUNC(checkIncompatibleAddons);
    }] call CBA_fnc_addEventHandler;
};

[0, {
    if (_this getVariable [QACEGVAR(medical,isBleeding), false]) exitWith {};
    
    private _count = 0;

    ({
        _count = _count + (count _x);
    } forEach (_this getVariable [QEGVAR(circulation,IV_Bags), createHashMap]));

    -1 * _count;
}] call ACEFUNC(field_rations,addStatusModifier);

[QGVAR(openMedicalMenu), ACELINKFUNC(medical_gui,openMenu)] call CBA_fnc_addEventHandler;

["ace_cardiacArrest", LINKFUNC(onCardiacArrest)] call CBA_fnc_addEventHandler;
["ace_unconscious", LINKFUNC(onUnconscious)] call CBA_fnc_addEventHandler;

[QGVAR(handleFatalVitals), LINKFUNC(handleFatalVitals)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,fullHealLocalMod), LINKFUNC(fullHealLocal)] call CBA_fnc_addEventHandler;

[QGVAR(showTreatmentText), LINKFUNC(handleTreatmentText)] call CBA_fnc_addEventHandler;

["ace_treatmentStarted", {
    params ["_medic", "_patient", "", "_classname"];

    if (isPlayer _patient) then {
        [QGVAR(showTreatmentText), [_medic, _patient, true], _patient] call CBA_fnc_targetEvent;
    };
}] call CBA_fnc_addEventHandler;

["ace_treatmentFailed", {
    params ["_medic", "_patient", "", "_classname"];

    if (isPlayer _patient) then {
        [QGVAR(showTreatmentText), [_medic, _patient, false], _patient] call CBA_fnc_targetEvent;
    };
}] call CBA_fnc_addEventHandler;

["ace_treatmentSucceded", {
    params ["_medic", "_patient", "", "_classname"];

    if (isPlayer _patient) then {
        [QGVAR(showTreatmentText), [_medic, _patient, false], _patient] call CBA_fnc_targetEvent;
    };

    if (_patient getVariable [QGVAR(WasTreated), false]) exitWith {};

    if !(IS_UNCONSCIOUS(_patient)) exitWith {};

    if (_classname in ["CheckDogTags","SlapAwake","AmmoniaInhalant"]) exitWith {}; // Ignore these

    private _config = configFile >> QACEGVAR(medical_treatment,actions) >> _classname;

    if (isNumber (_config >> "ACM_rollToBack")) then {
        if ([false,true] select (getNumber (_config >> "ACM_rollToBack"))) then {
            _patient setVariable [QGVAR(WasTreated), true, true];
        };
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(playWakeUpSound), {
    params ["_patient"];

    _patient setVariable [QACEGVAR(medical_feedback,soundTimeoutmoan), CBA_missionTime + 10];

    private _distance = 5;
    private _targets = allPlayers inAreaArray [ASLToAGL getPosASL _patient, _distance, _distance, 0, false, _distance];
    if (_targets isEqualTo []) exitWith {};

    private _sound = selectRandom ["ACM_wakeUp_1","ACM_wakeUp_2","ACM_wakeUp_3","ACM_wakeUp_4"];

    [QACEGVAR(medical_feedback,forceSay3D), [_patient, _sound, _distance], _targets] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

[QACEGVAR(medical,death), {
    params ["_unit"];

    _unit setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Asystole, true];
    _unit setVariable [QGVAR(TimeOfDeath), CBA_missionTime, true];
}] call CBA_fnc_addEventHandler;

[QGVAR(cancelCarryingPrompt), LINKFUNC(cancelCarryingPrompt)] call CBA_fnc_addEventHandler;
[QGVAR(cancelCarryLocal), {
    params ["_carrier", "_target"];

    [format [LLSTRING(CancelCarrying_Stopped), [_target, true] call ACEFUNC(common,getName)], 1.5, _carrier] call ACEFUNC(common,displayTextStructured);
    [_carrier, _target] call ACEFUNC(dragging,dropObject_carry);
}] call CBA_fnc_addEventHandler;

[QACEGVAR(dragging,startedCarry), {
    params ["_unit", "_target"];

    if (_target isKindOf "CAManBase") then {
        [_target] call ACEFUNC(weaponselect,putWeaponAway);

        if !(IS_UNCONSCIOUS(_target)) then {
            [QGVAR(cancelCarryingPrompt), [_target, _unit], _target] call CBA_fnc_targetEvent;
        };
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(getUpPrompt), LINKFUNC(getUpPrompt)] call CBA_fnc_addEventHandler;

["isNotInLyingState", {!((_this select 0) getVariable [QGVAR(Lying_State), false])}] call ACEFUNC(common,addCanInteractWithCondition);

call FUNC(generateMedicationTypeMap);