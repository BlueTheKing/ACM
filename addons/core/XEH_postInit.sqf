#include "script_component.hpp"

["ace_cardiacArrest", LINKFUNC(onCardiacArrest)] call CBA_fnc_addEventHandler;
["ace_unconscious", LINKFUNC(onUnconscious)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,fullHealLocalMod), LINKFUNC(fullHealLocal)] call CBA_fnc_addEventHandler;

["ace_treatmentSucceded", {
    params ["_medic", "_patient", "", "_classname"];

    if (IS_UNCONSCIOUS(_patient)) then {
        _patient setVariable [QGVAR(WasTreated), true, true];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(playWakeUpSound), {
    params ["_patient"];

    _patient setVariable [QACEGVAR(medical_feedback,soundTimeoutmoan), CBA_missionTime + 8];

    private _distance = 5;
    private _targets = allPlayers inAreaArray [ASLToAGL getPosASL _patient, _distance, _distance, 0, false, _distance];
    if (_targets isEqualTo []) exitWith {};

    private _sound = selectRandom ["ACM_wakeUp_1","ACM_wakeUp_2","ACM_wakeUp_3","ACM_wakeUp_4"];

    [QACEGVAR(medical_feedback,forceSay3D), [_patient, _sound, _distance], _targets] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;