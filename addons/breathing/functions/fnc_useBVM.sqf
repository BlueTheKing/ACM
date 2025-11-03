#include "..\script_component.hpp"
#include "..\UseBVM_defines.hpp"
/*
 * Author: Blue
 * Use BVM on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Use Oxygen <BOOL>
 * 3: Using Portable Oxygen <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, false, false] call ACM_breathing_fnc_useBVM;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_useOxygen", false], ["_portableOxygen", false]];

if !(isNull (_patient getVariable [QGVAR(BVM_Medic), objNull])) exitWith {
    [LLSTRING(BVM_Already), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
};

GVAR(BVMCancel_MouseID) = [0xF0, [false, false, false], {
        GVAR(BVMTarget) setVariable [QGVAR(BVM_provider), objNull, true];
        GVAR(BVMTarget) setVariable [QGVAR(BVM_Medic), objNull, true];
        EGVAR(core,ContinuousAction_Active) = false;
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

GVAR(BVMToggle_MouseID) = [0xF1, [false, false, false], {
    if (GVAR(BVMTarget) getVariable [QGVAR(BVM_provider), objNull] isEqualTo objNull) then {
        if ((GVAR(BVMTarget) getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "SGA") then {
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

GVAR(BVMSwap_MouseID) = [0xF2, [false, false, false], {
    if (isNull (GVAR(BVMTarget) getVariable [QGVAR(BVM_provider), objNull]) && isNull (GVAR(BVMTarget) getVariable [QEGVAR(circulation,CPR_Medic), objNull])) then {
        GVAR(SwapToCPR) = true;
        EGVAR(core,ContinuousAction_Active) = false;
    };
}, "keydown", "", false, 0] call CBA_fnc_addKeyHandler;

[[_medic, _patient, "head", [_useOxygen, _portableOxygen]], { // On Start
    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["_useOxygen", "_portableOxygen"];

    "ACM_UseBVM" cutRsc ["RscUseBVM", "PLAIN", 0, false];

    _patient setVariable [QGVAR(BVM_Medic), _medic, true];

    GVAR(BVMTarget) = _patient;
    GVAR(BVMActive) = false;
    GVAR(CPRActive) = false;

    GVAR(SwapToCPR) = false;

    GVAR(BVM_OxygenActive) = _useOxygen;
    GVAR(BVM_PortableOxygen) = _portableOxygen;

    _patient setVariable [QGVAR(BVM_ConnectedOxygen), _useOxygen, true];

    GVAR(BVM_BreathCount) = 0;

    GVAR(BVMTarget_Intubated) = ((_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "SGA");

    private _display = uiNamespace getVariable ["ACM_UseBVM", displayNull];
    private _ctrlTopText = _display displayCtrl IDC_USEBVM_TOPTEXT; 
    private _ctrlText = _display displayCtrl IDC_USEBVM_TEXT;

    private _assisting = false;

    if !(GVAR(BVMTarget_Intubated)) then {
        if ([_patient] call EFUNC(core,cprActive)) then {
            [LLSTRING(BVM_Stop), "", ""] call ACEFUNC(interaction,showMouseHint);
            GVAR(CPRActive) = true;
            _assisting = true;
        } else {
            [LLSTRING(BVM_Stop), LLSTRING(BVM_Pause), ""] call ACEFUNC(interaction,showMouseHint);
            _patient setVariable [QGVAR(BVM_provider), _medic, true];
            GVAR(BVMActive) = true;
        };
    } else {
        [LLSTRING(BVM_Stop), LLSTRING(BVM_Pause), ""] call ACEFUNC(interaction,showMouseHint);
        _patient setVariable [QGVAR(BVM_provider), _medic, true];
        GVAR(BVMActive) = true;
        if ([_patient] call EFUNC(core,cprActive)) then {
            _assisting = true;
        };
    };

    if (_assisting) then {
        if !(GVAR(BVM_OxygenActive)) then {
            _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM_Assist);
        } else {
            _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM_AssistOxygen);
        };
    } else {
        if (GVAR(BVM_OxygenActive)) then {
            _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM_Oxygen);
        } else {
            _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM);
        };
    };

    _medic setVariable [QGVAR(isUsingBVM), ([_patient] call EFUNC(core,bvmActive)), true];
    
    _ctrlText ctrlSetText ([_patient, false, true] call ACEFUNC(common,getName));

    GVAR(BVM_NextBreath) = (CBA_missionTime + 2);
    GVAR(BVM_BreathCount) = 0;

    if (GVAR(BVMActive)) then {
        [_patient, "activity", LSTRING(BVM_ActionLog_Start), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
    };

    if (EGVAR(circulation,SwapToBVM)) then {
        EGVAR(circulation,SwapToBVM) = false;
    } else {
        [LLSTRING(BVM_Started), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    };
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["_useOxygen", "_portableOxygen"];

    [GVAR(BVMCancel_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;
    [GVAR(BVMToggle_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;
    [GVAR(BVMSwap_MouseID), "keydown"] call CBA_fnc_removeKeyHandler;

    [] call ACEFUNC(interaction,hideMouseHint);

    if ((_patient getVariable [QGVAR(BVM_provider), objNull]) isNotEqualTo objNull) then {
        _patient setVariable [QGVAR(BVM_provider), objNull, true];
    };

    _patient setVariable [QGVAR(BVM_Medic), objNull, true];

    _medic setVariable [QGVAR(isUsingBVM), false, true];

    _patient setVariable [QGVAR(BVM_ConnectedOxygen), false, true];

    "ACM_UseBVM" cutText ["","PLAIN", 0, false];

    [_patient, "activity", LLSTRING(BVM_ActionLog_Stop), [[_medic, false, true] call ACEFUNC(common,getName), GVAR(BVM_BreathCount)]] call ACEFUNC(medical_treatment,addToLog);

    closeDialog 0;

    if (GVAR(SwapToCPR)) then {
        EGVAR(core,ContinuousAction_ForceOpenMenu) = false;
        [{
            params ["_medic", "_patient"];

            [LLSTRING(BVM_SwappedToCPR), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

            [_medic, _patient] call EFUNC(circulation,beginCPR);
        }, [_medic, _patient], 0.1] call CBA_fnc_waitAndExecute;
    } else {
        [LLSTRING(BVM_Stopped), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        [QEGVAR(core,openMedicalMenu), GVAR(BVMTarget)] call CBA_fnc_localEvent;
    };

    GVAR(BVMTarget) = objNull;
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart", "_extraArgs"];
    _extraArgs params ["_useOxygen", "_portableOxygen"];

    private _updateMouseHint = false;
    private _updateText = false;
    
    if ([_patient] call EFUNC(core,cprActive) != GVAR(CPRActive) || [_patient] call EFUNC(core,bvmActive) != GVAR(BVMActive)) then {
        _updateMouseHint = true;
        _updateText = true;
    };

    if ((_patient getVariable [QGVAR(BVM_ConnectedOxygen), false]) != GVAR(BVM_OxygenActive)) then {
        GVAR(BVM_OxygenActive) = (_patient getVariable [QGVAR(BVM_ConnectedOxygen), false]);
        _updateText = true;
    };

    if (_updateMouseHint) then {
        if (GVAR(BVMTarget_Intubated)) then { // Intubated
            GVAR(CPRActive) = [_patient] call EFUNC(core,cprActive);

            if ([_patient] call EFUNC(core,bvmActive)) then { // Active BVM
                [LLSTRING(BVM_Continued), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                [LLSTRING(BVM_Stop), LLSTRING(BVM_Pause), ""] call ACEFUNC(interaction,showMouseHint);
                GVAR(BVMActive) = true;
            } else { // Paused BVM
                [LLSTRING(BVM_Paused), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                [LLSTRING(BVM_Stop), LLSTRING(BVM_Continue), (["", LLSTRING(BVM_SwapToCPR)] select (isNull (_patient getVariable [QGVAR(CPR_Medic), objNull])))] call ACEFUNC(interaction,showMouseHint);
                GVAR(BVMActive) = false;
            };
        } else {
            if ([_patient] call EFUNC(core,cprActive)) then {
                [LLSTRING(BVM_Stop), "", ""] call ACEFUNC(interaction,showMouseHint);
                GVAR(CPRActive) = true;
                GVAR(BVMActive) = [_patient] call EFUNC(core,bvmActive);
            } else {
                GVAR(CPRActive) = false;
                if ([_patient] call EFUNC(core,bvmActive)) then { // Active BVM
                    [LLSTRING(BVM_Continued), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    [LLSTRING(BVM_Stop), LLSTRING(BVM_Pause), ""] call ACEFUNC(interaction,showMouseHint);
                    GVAR(BVMActive) = true;
                } else { // Paused BVM
                    [LLSTRING(BVM_Paused), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    [LLSTRING(BVM_Stop), LLSTRING(BVM_Continue), (["", LLSTRING(BVM_SwapToCPR)] select (isNull (_patient getVariable [QGVAR(CPR_Medic), objNull])))] call ACEFUNC(interaction,showMouseHint);
                    GVAR(BVMActive) = false;
                };
            };
        };
        _medic setVariable [QGVAR(isUsingBVM), ([_patient] call EFUNC(core,bvmActive)), true];
    };

    if (_updateText) then {
        private _display = uiNamespace getVariable ["ACM_UseBVM", displayNull];
        private _ctrlTopText = _display displayCtrl IDC_USEBVM_TOPTEXT;
        
        if ([_patient] call EFUNC(core,cprActive)) then {
            if !(_patient getVariable [QGVAR(BVM_ConnectedOxygen), false]) then {
                _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM_Assist);
            } else {
                _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM_AssistOxygen);
            };
        } else {
            if !(_patient getVariable [QGVAR(BVM_ConnectedOxygen), false]) then {
                _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM);
            } else {
                _ctrlTopText ctrlSetText LLSTRING(BVM_UsingBVM_Oxygen);
            };
        };
    };

    if (alive (_patient getVariable [QGVAR(BVM_provider), objNull])) then {
        if !([_medic, _patient, true] call FUNC(canUseBVM)) exitWith {
            EGVAR(core,ContinuousAction_Active) = false;
        };

        if (GVAR(BVM_NextBreath) < CBA_missionTime) then {
            GVAR(BVM_NextBreath) = CBA_missionTime + 6;
            playSound3D [QPATHTO_R(sound\bvm_squeeze.wav), _patient, false, getPosASL _patient, 12, 1, 12]; // 1.227s
            GVAR(BVM_BreathCount) = GVAR(BVM_BreathCount) + 1;
            if (GVAR(BVM_BreathCount) > 1 && (GET_AIRWAYSTATE(_patient) > 0)) then {
                _patient setVariable [QGVAR(BVM_lastBreath), CBA_missionTime, true];
                if (_patient getVariable [QGVAR(BVM_ConnectedOxygen), false]) then {
                    _patient setVariable [QGVAR(BVM_lastBreathOxygen), CBA_missionTime, true];
                };
            };

            if (GVAR(BVM_PortableOxygen)) then {
                private _success = [_medic] call FUNC(useOxygenTankReserve);
                if !(_success) then {
                    [LLSTRING(BVM_UsingBVM_OxygenTankDepleted), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
                    _patient setVariable [QGVAR(BVM_ConnectedOxygen), false, true];
                    GVAR(BVM_PortableOxygen) = false;
                };
            };
        };
    };
}] call EFUNC(core,beginContinuousAction);