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
 * [player, cursorTarget, false] call ACM_circulation_fnc_AED_BeginCharge;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_manual", false]];

if (_manual) then {
    _patient setVariable [QGVAR(AED_InUse), true, true];
};

playSound3D [QPATHTO_R(sound\aed_charging.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 4.002s

_patient setVariable [QGVAR(AED_Charged), false, true];

private _fnc_chargedPFH = {
    params ["_patient"];

    [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        if !(_patient getVariable [QGVAR(AED_Charged), false]) exitWith {
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        playSound3D [QPATHTO_R(sound\aed_alarm.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.528s
    }, 0.528, [_patient]] call CBA_fnc_addPerFrameHandler;

    [{
        params ["_patient"];

        !(_patient getVariable [QGVAR(AED_Charged), false]) || !([_patient, "", 1] call FUNC(hasAED));
    }, {}, [_patient], 30, 
    { // Cancel shock if not administered within 30s
        params ["_patient"];

        if ([_patient, "", 1] call FUNC(hasAED) && (_patient getVariable [QGVAR(AED_Charged), false])) then {
            _patient setVariable [QGVAR(AED_Charged), false, true];
            _patient setVariable [QGVAR(AED_InUse), false, true];
            _medic setVariable [QGVAR(AED_Medic_InUse), false, true];
            playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.624s
        };
    }] call CBA_fnc_waitUntilAndExecute;
};

[{
    params ["_patient", "_medic", "_manual", "_fnc_chargedPFH"];

    if (_manual) then {
        _patient setVariable [QGVAR(AED_Charged), true, true];
        [_patient] call _fnc_chargedPFH;
    } else {
        playSound3D [QPATHTO_R(sound\aed_standclear_pushtoshock.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 2.557s

        [{
            params ["_patient", "_medic", "_fnc_chargedPFH"];

            _patient setVariable [QGVAR(AED_Charged), true, true];

            [_patient] call _fnc_chargedPFH;
        }, [_patient, _medic, _fnc_chargedPFH], 2.5] call CBA_fnc_waitAndExecute;
    };
}, [_patient, _medic, _manual, _fnc_chargedPFH], 4.1] call CBA_fnc_waitAndExecute;



