#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin charging AED
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Is in manual mode <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, false] call AMS_circulation_fnc_AED_BeginCharge;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_manual", false]];

//playSound3D [QPATHTO_R(sound\aed_charging.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 4.002s

_patient setVariable [QGVAR(AEDMonitor_Charged), false, true];

GVAR(loopTime) = 0;

private _fnc_chargedPFH = {
    params ["_patient"];

    [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        if !(_patient getVariable [QGVAR(AEDMonitor_Charged), false]) exitWith {
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        if ((GVAR(loopTime) + 0.53) > CBA_missionTime) exitWith {};

        GVAR(loopTime) = CBA_missionTime;
        //playSound3D [QPATHTO_R(sound\aed_chargedalarm.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 0.528s
    }, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

    [{
        params ["_patient"];

        !(_patient getVariable [QGVAR(AEDMonitor_Charged), false]);
    }, {}, [_patient], 20, 
    {
        params ["_patient"];

        _patient setVariable [QGVAR(AEDMonitor_Charged), false, true];
        //playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 0.624s

    }] call CBA_fnc_waitUntilAndExecute; // Cancel shock if not administered within 20s
};

[{
    params ["_patient", "_medic", "_fnc_chargedPFH"];

    if (_manual) then {
        _patient setVariable [QGVAR(AEDMonitor_Charged), true, true];
        [_patient] call _fnc_chargedPFH;
    } else {
        //playSound3D [QPATHTO_R(sound\aed_standclear_pushtoshock.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 2.557s

        [{
            params ["_patient", "_medic", "_fnc_chargedPFH"];

            _patient setVariable [QGVAR(AEDMonitor_Charged), true, true];

            [_patient] call _fnc_chargedPFH;
        }, [_patient, _medic, _fnc_chargedPFH], 2.5] call CBA_fnc_waitAndExecute;
    };
}, [_patient, _medic, _fnc_chargedPFH], 4.1] call CBA_fnc_waitAndExecute;



