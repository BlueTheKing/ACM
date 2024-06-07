#include "..\script_component.hpp"
#include "..\UseBVM_defines.hpp"
/*
 * Author: Blue
 * Use BVM on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject] call ACM_breathing_fnc_useBVM;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[[_medic, _patient], { // On Start
    params ["_medic", "_patient"];

    "ACM_UseBVM" cutRsc ["RscUseBVM", "PLAIN", 0, false];

    _patient setVariable [QGVAR(BVM_Medic), _medic, true];

    GVAR(BVMTarget) = _patient;
    GVAR(BVMActive) = false;
    GVAR(CPRActive) = false;

    GVAR(BVM_BreathCount) = 0;

    GVAR(BVMTarget_Intubated) = !((_patient getVariable [QEGVAR(airway,AirwayItem), ""]) in ["", "OPA"]);

    GVAR(BVMCancel_MouseID) = [0xF0, [false, false, false], {
        GVAR(BVMTarget) setVariable [QGVAR(BVM_provider), objNull, true];
        GVAR(BVMTarget) setVariable [QGVAR(BVM_Medic), objNull, true];
        EGVAR(core,ContinuousAction_Active) = false;
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

    GVAR(BVMToggle_MouseID) = [0xF1, [false, false, false], {
        if (GVAR(BVMTarget) getVariable [QGVAR(BVM_provider), objNull] isEqualTo objNull) then {
            if !((GVAR(BVMTarget) getVariable [QEGVAR(airway,AirwayItem), ""]) in ["", "OPA"]) then {
                GVAR(BVMTarget) setVariable [QGVAR(BVM_provider), ACE_player, true];
            } else {
                if !([GVAR(BVMTarget)] call EFUNC(core,cprActive)) then {
                    GVAR(BVMTarget) setVariable [QGVAR(BVM_provider), ACE_player, true];
                };
            };
        } else {
            GVAR(BVMTarget) setVariable [QGVAR(BVM_provider), objNull, true];
        };
    }, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

    private _display = uiNamespace getVariable ["ACM_UseBVM", displayNull];
    private _ctrlTopText = _display displayCtrl IDC_USEBVM_TOPTEXT; 
    private _ctrlText = _display displayCtrl IDC_USEBVM_TEXT;

    if !(GVAR(BVMTarget_Intubated)) then {
        if ([_patient] call EFUNC(core,cprActive)) then {
            ["Stop using BVM", "", ""] call ACEFUNC(interaction,showMouseHint);
            GVAR(CPRActive) = true;
            _ctrlTopText ctrlSetText "Using BVM (Assisting CPR)...";
        } else {
            ["Stop using BVM", "Pause Rescue Breaths", ""] call ACEFUNC(interaction,showMouseHint);
            _patient setVariable [QGVAR(BVM_provider), _medic, true];
            GVAR(BVMActive) = true;
        };
    } else {
        ["Stop using BVM", "Pause Rescue Breaths", ""] call ACEFUNC(interaction,showMouseHint);
        _patient setVariable [QGVAR(BVM_provider), _medic, true];
        GVAR(BVMActive) = true;
        if ([_patient] call EFUNC(core,cprActive)) then {
            _ctrlTopText ctrlSetText "Using BVM (Assisting CPR)...";
        };
    };

    _medic setVariable [QGVAR(isUsingBVM), ([_patient] call EFUNC(core,bvmActive)), true];
    
    _ctrlText ctrlSetText ([_patient, false, true] call ACEFUNC(common,getName));

    GVAR(BVM_NextBreath) = (CBA_missionTime + 1);
    GVAR(BVM_BreathCount) = 0;

    if (GVAR(BVMActive)) then {
        [_patient, "activity", "%1 started BVM rescue breaths", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
    };
}, { // On cancel
    params ["_medic", "_patient"];

    [GVAR(BVMCancel_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;
    [GVAR(BVMToggle_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;

    ["", "", ""] call ACEFUNC(interaction,showMouseHint);

    if ((_patient getVariable [QGVAR(BVM_provider), objNull]) isNotEqualTo objNull) then {
        _patient setVariable [QGVAR(BVM_provider), objNull, true];
    };

    _patient setVariable [QGVAR(BVM_Medic), objNull, true];

    _medic setVariable [QGVAR(isUsingBVM), false, true];

    GVAR(BVMTarget) = objNull;

    "ACM_UseBVM" cutText ["","PLAIN", 0, false];

    [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);

    [_patient, "activity", "%1 stopped BVM rescue breaths (x%2)", [[_medic, false, true] call ACEFUNC(common,getName), GVAR(BVM_BreathCount)]] call ACEFUNC(medical_treatment,addToLog);

    ["Stopped using BVM", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
}, { // PerFrame
    params ["_medic", "_patient"];

    private _updateMouseHint = false;
    
    if ([_patient] call EFUNC(core,cprActive) != GVAR(CPRActive) || [_patient] call EFUNC(core,bvmActive) != GVAR(BVMActive)) then {
        _updateMouseHint = true;
    };

    if (_updateMouseHint) then {
        if (GVAR(BVMTarget_Intubated)) then { // Intubated
            GVAR(CPRActive) = [_patient] call EFUNC(core,cprActive);

            if ([_patient] call EFUNC(core,cprActive)) then {
                _ctrlTopText ctrlSetText "Using BVM (Assisting CPR)...";
            } else {
                _ctrlTopText ctrlSetText "Using BVM...";
            };

            if ([_patient] call EFUNC(core,bvmActive)) then { // Active BVM
                ["Continued Rescue Breaths", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                ["Stop using BVM", "Pause Rescue Breaths", ""] call ACEFUNC(interaction,showMouseHint);
                GVAR(BVMActive) = true;
            } else { // Paused BVM
                ["Paused Rescue Breaths", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                ["Stop using BVM", "Continue Rescue Breaths", ""] call ACEFUNC(interaction,showMouseHint);
                GVAR(BVMActive) = false;
            };
        } else {
            if ([_patient] call EFUNC(core,cprActive)) then {
                ["Stop using BVM", "", ""] call ACEFUNC(interaction,showMouseHint);
                GVAR(CPRActive) = true;
                GVAR(BVMActive) = [_patient] call EFUNC(core,bvmActive);
            } else {
                GVAR(CPRActive) = false;
                if ([_patient] call EFUNC(core,bvmActive)) then { // Active BVM
                    ["Continued Rescue Breaths", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    ["Stop using BVM", "Pause Rescue Breaths", ""] call ACEFUNC(interaction,showMouseHint);
                    GVAR(BVMActive) = true;
                } else { // Paused BVM
                    ["Paused Rescue Breaths", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    ["Stop using BVM", "Continue Rescue Breaths", ""] call ACEFUNC(interaction,showMouseHint);
                    GVAR(BVMActive) = false;
                };
            };
        };
        _medic setVariable [QGVAR(isUsingBVM), ([_patient] call EFUNC(core,bvmActive)), true];
    };

    if (alive (_patient getVariable [QGVAR(BVM_provider), objNull])) then {
        if (GVAR(BVM_NextBreath) < CBA_missionTime) then {
            GVAR(BVM_NextBreath) = CBA_missionTime + 6;
            playSound3D [QPATHTO_R(sound\bvm_squeeze.wav), _patient, false, getPosASL _patient, 12, 1, 12]; // 1.227s
            GVAR(BVM_BreathCount) = GVAR(BVM_BreathCount) + 1;
            if (GVAR(BVM_BreathCount) > 1) then {
                _patient setVariable [QGVAR(BVM_lastBreath), CBA_missionTime, true];
            };
        };
    };

}] call EFUNC(core,beginContinuousAction);