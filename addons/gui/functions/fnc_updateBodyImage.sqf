#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update medical menu GUI body image.
 *
 * Arguments:
 * 0: Body image controls group <CONTROL>
 * 1: Target <OBJECT>
 * 2: Body part <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL, _target, 0] call ACM_GUI_fnc_updateBodyImage;
 *
 * Public: No
 */

params ["_ctrlGroup", "_target", "_selectionN"];

// Airway
private _ctrlGuedelTube = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_GUEDELTUBE;
private _ctrlNPA = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_NPA;
private _ctrlIGel = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_IGEL;

private _airwayItemOral = _target getVariable [QEGVAR(airway,AirwayItem_Oral), ""];
private _airwayItemNPA = _target getVariable [QEGVAR(airway,AirwayItem_Nasal), ""];

if !(_airwayItemOral isEqualTo "") then {
    if (_airwayItemOral isEqualTo "SGA") then {
        _ctrlGuedelTube ctrlShow false;
        _ctrlIGel ctrlShow true;
    } else {
        _ctrlGuedelTube ctrlShow true;
        _ctrlIGel ctrlShow false;
    };
} else {
    _ctrlGuedelTube ctrlShow false;
    _ctrlIGel ctrlShow false;
};

if (_airwayItemNPA isEqualTo "NPA") then {
    _ctrlNPA ctrlShow true;
} else {
    _ctrlNPA ctrlShow false;
};

// Breathing
private _ctrlPulseOximeterRight = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_PULSEOX;
private _ctrlPulseOximeterLeft = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_PULSEOX;
private _ctrlChestSeal = _ctrlGroup controlsGroupCtrl IDC_BODY_TORSO_CHESTSEAL;
private _ctrlChestInjury = _ctrlGroup controlsGroupCtrl IDC_BODY_TORSO_PNEUMOTHORAX;

if (_target getVariable [QEGVAR(breathing,ChestSeal_State), false]) then {
    _ctrlChestSeal ctrlShow true;
} else {
    _ctrlChestSeal ctrlShow false;
};

if (HAS_PULSEOX(_target,0)) then {
    _ctrlPulseOximeterLeft ctrlShow true;
} else {
    _ctrlPulseOximeterLeft ctrlShow false;
};

if (HAS_PULSEOX(_target,1)) then {
    _ctrlPulseOximeterRight ctrlShow true;
} else {
    _ctrlPulseOximeterRight ctrlShow false;
};

// Circulation
private _ctrlIVLeftArm = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_IV;
private _ctrlIVRightArm = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_IV;
private _ctrlIVLeftLeg = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTLEG_IV;
private _ctrlIVRightLeg = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTLEG_IV;
private _ctrlIO = _ctrlGroup controlsGroupCtrl IDC_BODY_TORSO_IO;

private _IVArray = GET_IV(_target);

{
    switch (_IVArray select (_forEachIndex + 2)) do {
        case 0: {
            _x ctrlShow false;
        };
        default {
            _x ctrlShow true;
        };
    };
} forEach [_ctrlIVLeftArm, _ctrlIVRightArm, _ctrlIVLeftLeg, _ctrlIVRightLeg];

if ((_IVArray select 1) > 0) then {
    _ctrlIO ctrlShow true;
} else {
    _ctrlIO ctrlShow false;
};

private _ctrlPressureCuffRight = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_PRESSURECUFF;
private _ctrlPressureCuffLeft = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_PRESSURECUFF;

if ((_target getVariable [QEGVAR(circulation,PressureCuff_Placement), -1]) isNotEqualTo [false,false]) then {
    if (HAS_PRESSURECUFF(_target,0)) then {
        _ctrlPressureCuffLeft ctrlShow true;
    } else {
        _ctrlPressureCuffLeft ctrlShow false;
    };

    if (HAS_PRESSURECUFF(_target,1)) then {
        _ctrlPressureCuffRight ctrlShow true;
    } else {
        _ctrlPressureCuffRight ctrlShow false;
    };
} else {
    _ctrlPressureCuffRight ctrlShow false;
    _ctrlPressureCuffLeft ctrlShow false;
};

private _ctrlAEDPads = _ctrlGroup controlsGroupCtrl IDC_BODY_TORSO_AED_PADS;
private _ctrlAEDPulseOximeterRight = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_AED_PULSEOX;
private _ctrlAEDPulseOximeterLeft = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_AED_PULSEOX;
private _ctrlAEDPressureCuffRight = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_AED_PRESSURECUFF;
private _ctrlAEDPressureCuffLeft = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_AED_PRESSURECUFF;
private _ctrlAEDCapnograph = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_AED_CAPNOGRAPH;

if (_target getVariable [QEGVAR(circulation,AED_Placement_Pads), false]) then {
    _ctrlAEDPads ctrlShow true;
} else {
    _ctrlAEDPads ctrlShow false;
};

if ((_target getVariable [QEGVAR(circulation,AED_Placement_PulseOximeter), -1]) != -1) then {
    if (_target getVariable [QEGVAR(circulation,AED_Placement_PulseOximeter), -1] == 2) then {
        _ctrlAEDPulseOximeterRight ctrlShow false;
        _ctrlAEDPulseOximeterLeft ctrlShow true;
    } else {
        _ctrlAEDPulseOximeterRight ctrlShow true;
        _ctrlAEDPulseOximeterLeft ctrlShow false;
    };
} else {
    _ctrlAEDPulseOximeterRight ctrlShow false;
    _ctrlAEDPulseOximeterLeft ctrlShow false;
};

if ((_target getVariable [QEGVAR(circulation,AED_Placement_PressureCuff), -1]) != -1) then {
    if (_target getVariable [QEGVAR(circulation,AED_Placement_PressureCuff), -1] == 2) then {
        _ctrlAEDPressureCuffRight ctrlShow false;
        _ctrlAEDPressureCuffLeft ctrlShow true;
    } else {
        _ctrlAEDPressureCuffRight ctrlShow true;
        _ctrlAEDPressureCuffLeft ctrlShow false;
    };
} else {
    _ctrlAEDPressureCuffRight ctrlShow false;
    _ctrlAEDPressureCuffLeft ctrlShow false;
};

if (_target getVariable [QEGVAR(circulation,AED_Placement_Capnograph), false]) then {
    if (_airwayItemOral isEqualTo "") then {
        _ctrlAEDCapnograph ctrlShow true;
    } else {
        _ctrlAEDCapnograph ctrlShow false;
    };
} else {
    _ctrlAEDCapnograph ctrlShow false;
};