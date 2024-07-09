#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin CPR
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_beginCPR;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if !(isNull (_patient getVariable [QGVAR(CPR_Medic), objNull])) exitWith {
    ["Patient already has CPR provider", 2, _medic] call ACEFUNC(common,displayTextStructured);
};

_patient setVariable [QACEGVAR(medical,CPR_provider), _medic, true];
_patient setVariable [QGVAR(CPR_Medic), _medic, true];

_medic setVariable [QGVAR(isPerformingCPR), true, true];

GVAR(CPRTarget) = _patient;
GVAR(CPRActive) = true;
GVAR(BVMActive) = false;

GVAR(CPRCancel_EscapeID) = [0x01, [false, false, false], {
    GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
    GVAR(CPRTarget) setVariable [QGVAR(CPR_Medic), objNull, true];
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

GVAR(CPRCancel_MouseID) = [0xF0, [false, false, false], {
    GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
    GVAR(CPRTarget) setVariable [QGVAR(CPR_Medic), objNull, true];
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

GVAR(CPRToggle_MouseID) = [0xF1, [false, false, false], {
    if (GVAR(CPRTarget) getVariable [QACEGVAR(medical,CPR_provider), objNull] isEqualTo objNull) then {
        if ((GVAR(CPRTarget) getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "SGA") then {
            GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), ACE_player, true];
        } else {
            if !([GVAR(CPRTarget)] call EFUNC(core,bvmActive)) then {
                GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), ACE_player, true];
            };
        };
    } else {
        GVAR(CPRTarget) setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
    };
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

ACEGVAR(medical_gui,pendingReopen) = false; // Prevent medical menu from reopening

if (dialog) then { // If another dialog is open (medical menu) close it
    closeDialog 0;
};

private _notInVehicle = isNull objectParent _medic;
private _initialAnimation = animationState _medic;
private _startDelay = 2;
GVAR(loopCPR) = false;

if (_notInVehicle) then {
    [_medic, "AinvPknlMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon_medic", 1] call ACEFUNC(common,doAnimation);
    GVAR(loopCPR) = true;
} else {
    if (currentWeapon _medic != "") then {
        [_medic] call ACEFUNC(weaponselect,putWeaponAway);
    };
};

if (_initialAnimation in ["amovpercmstpsnonwnondnon", "amovpknlmstpsnonwnondnon_gear", "amovpknlmstpsnonwnondnon"]) then { // Wack
    _startDelay = 1.8;
};

private _CPRStartTime = CBA_missionTime + _startDelay + 0.2;

[{
    params ["_medic", "_patient", "_notInVehicle", "_CPRStartTime"];

    if (currentWeapon _medic != "") then {
        [_medic] call ACEFUNC(weaponselect,putWeaponAway);
    };
    
    ["Stop CPR", "Pause CPR", ""] call ACEFUNC(interaction,showMouseHint);
    ["Started CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    [_patient, "activity", "%1 started CPR", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

    [{
        params ["_args", "_idPFH"];
        _args params ["_medic", "_patient", "_notInVehicle", "_CPRStartTime"];

        private _patientCondition = (!(IS_UNCONSCIOUS(_patient)) && alive _patient || _patient isEqualTo objNull);
        private _medicCondition = (!(alive _medic) || IS_UNCONSCIOUS(_medic) || _medic isEqualTo objNull);
        private _vehicleCondition = !(objectParent _medic isEqualTo objectParent _patient);
        private _distanceCondition = (_patient distance2D _medic > ACEGVAR(medical_gui,maxDistance));

        if (_patientCondition || _medicCondition || !(alive (_patient getVariable [QGVAR(CPR_Medic), objNull])) || dialog || {(!_notInVehicle && _vehicleCondition) || {(_notInVehicle && _distanceCondition)}}) exitWith { // Stop CPR
            [_idPFH] call CBA_fnc_removePerFrameHandler;
            [] call ACEFUNC(interaction,hideMouseHint);
            [GVAR(CPRCancel_EscapeID), "keydown"] call CBA_fnc_removeKeyHandler;
            [GVAR(CPRCancel_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;
            [GVAR(CPRToggle_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;

            if (_notInVehicle) then {
                [_medic, "AinvPknlMstpSnonWnonDnon_medicEnd", 2] call ACEFUNC(common,doAnimation);
            };

            private _CPRTime = CBA_missionTime - _CPRStartTime; 
            private _time = [_CPRTime, "MM:SS"] call BIS_fnc_secondsToString;

            [_patient, "activity", "%1 stopped CPR (%2)", [[_medic, false, true] call ACEFUNC(common,getName), _time]] call ACEFUNC(medical_treatment,addToLog);

            _patient setVariable [QGVAR(CPR_StoppedTotal), _CPRTime, true];
            _patient setVariable [QGVAR(CPR_StoppedTime), CBA_missionTime, true];

            if !(_patient getVariable [QACEGVAR(medical,CPR_provider), objNull] isEqualTo objNull) then {
                _patient setVariable [QACEGVAR(medical,CPR_provider), objNull, true];
            };

            _patient setVariable [QGVAR(CPR_Medic), objNull, true];
            _medic setVariable [QGVAR(isPerformingCPR), false, true];

            closeDialog 0;

            ["Stopped CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
            GVAR(CPRActive) = false;

            [QEGVAR(core,openMedicalMenu), GVAR(CPRTarget)] call CBA_fnc_localEvent;

            GVAR(CPRTarget) = objNull;
        };

        private _updateMouseHint = false;

        if ([_patient] call EFUNC(core,cprActive) != GVAR(CPRActive) || [_patient] call EFUNC(core,bvmActive) != GVAR(BVMActive)) then {
            _updateMouseHint = true;
        };

        if (_updateMouseHint) then {
            if ((_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "SGA") then { // Intubated
                GVAR(BVMActive) = [_patient] call EFUNC(core,bvmActive);
                if ([_patient] call EFUNC(core,cprActive)) then {
                    ["Continued CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    ["Stop CPR", "Pause CPR", ""] call ACEFUNC(interaction,showMouseHint);
                    GVAR(CPRActive) = true;
                    GVAR(loopCPR) = true;
                } else {
                    if (_notInVehicle) then {
                        [QACEGVAR(common,switchMove), [_medic, "ACM_CPR_Stop"]] call CBA_fnc_globalEvent;
                    };
                    ["Paused CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    ["Stop CPR", "Continue CPR", ""] call ACEFUNC(interaction,showMouseHint);
                    GVAR(CPRActive) = false;
                    GVAR(loopCPR) = false;
                };
            } else {
                if ([_patient] call EFUNC(core,bvmActive)) then {
                    ["Stop CPR", "", ""] call ACEFUNC(interaction,showMouseHint);
                    GVAR(BVMActive) = true;
                    GVAR(CPRActive) = [_patient] call EFUNC(core,cprActive);
                    GVAR(loopCPR) = GVAR(CPRActive);
                } else {
                    GVAR(BVMActive) = false;
                    if ([_patient] call EFUNC(core,cprActive)) then {
                        ["Continued CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                        ["Stop CPR", "Pause CPR", ""] call ACEFUNC(interaction,showMouseHint);
                        GVAR(CPRActive) = true;
                        GVAR(loopCPR) = true;
                    } else {
                        if (_notInVehicle) then {
                            [QACEGVAR(common,switchMove), [_medic, "ACM_CPR_Stop"]] call CBA_fnc_globalEvent;
                        };
                        ["Paused CPR", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                        ["Stop CPR", "Continue CPR", ""] call ACEFUNC(interaction,showMouseHint);
                        GVAR(CPRActive) = false;
                        GVAR(loopCPR) = false;
                    };
                };
            };
            _medic setVariable [QGVAR(isPerformingCPR), GVAR(CPRActive), true];
        };

        if (_notInVehicle && GVAR(loopCPR)) then {
            [QACEGVAR(common,switchMove), [_medic, "ACM_CPR"]] call CBA_fnc_globalEvent;
            GVAR(loopCPR) = false;

            [{
                params ["_patient"];

                !([_patient] call EFUNC(core,cprActive));
            }, {}, [_patient], 9, {
                if !([_patient] call EFUNC(core,cprActive)) exitWith {};
                GVAR(loopCPR) = true;
            }] call CBA_fnc_waitUntilAndExecute;
        };
    }, 0, [_medic, _patient, _notInVehicle, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

    [QGVAR(handleCPR), [_patient, _CPRStartTime], _patient] call CBA_fnc_targetEvent;
}, [_medic, _patient, _notInVehicle, _CPRStartTime], _startDelay] call CBA_fnc_waitAndExecute;