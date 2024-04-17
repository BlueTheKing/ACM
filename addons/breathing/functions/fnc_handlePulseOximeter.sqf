#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle placing pulse oximeter
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, 2] call ACM_breathing_fnc_handlePulseOximeter;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPartIndex"];

if ((_patient getVariable [QGVAR(PulseOximeter_PFH), -1]) != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _pulseOxStatusArray = [];

    {
        if (HAS_PULSEOX(_patient,_x)) then {
            _pulseOxStatusArray pushBack _x;
        };
        
    } forEach [0,1];

    if (count _pulseOxStatusArray < 1) exitWith {
        _patient setVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]], true];
        _patient setVariable [QGVAR(PulseOximeter_PFH), -1];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _displayArray = _patient getVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]]];

    {
        if (((_patient getVariable [QGVAR(PulseOximeter_LastSync), [-1,-1]] select _x) + 3) < CBA_missionTime) then {
            if (!(HAS_TOURNIQUET_APPLIED_ON(_patient,(_x + 2))) && !(IN_CRDC_ARRST(_patient)) && (alive _patient)) then {
                private _pr = GET_HEART_RATE(_patient);
                private _displayedSPO2 = 0;

                if (_pr < 30) then {
                    _pr = 0;
                } else {
                    _displayedSPO2 = [_patient] call FUNC(getSpO2);
                };

                _displayArray set [_x, [round(_displayedSPO2), round(_pr)]];
                _patient setVariable [QGVAR(PulseOximeter_Display), _displayArray, true]; 
            } else {
                if (((_patient getVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]]] select _x) select 0) != 0) then {
                   _displayArray set [_x, [0,0]];
                   _patient setVariable [QGVAR(PulseOximeter_Display), _displayArray, true]; 
                };
            };

            private _lastSyncArray = _patient getVariable [QGVAR(PulseOximeter_LastSync), [-1,-1]];
            _lastSyncArray set [_x, CBA_missionTime];
            _patient setVariable [QGVAR(PulseOximeter_LastSync), _lastSyncArray];
        };
    } forEach _pulseOxStatusArray;
}, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(PulseOximeter_PFH), _PFH];