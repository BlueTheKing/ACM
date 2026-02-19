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
private _ctrlOPA = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_OPA;
private _ctrlNPA = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_NPA;
private _ctrlIGel = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_IGEL;
private _ctrlSurgicalAirway = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_SURGICAL_AIRWAY_0;
private _ctrlSurgicalAirwayStrapped = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_SURGICAL_AIRWAY_1;

if (_target getVariable [QEGVAR(airway,SurgicalAirway_State), false]) then {
    if (_target getVariable [QEGVAR(airway,SurgicalAirway_StrapSecure), false]) then {
        _ctrlSurgicalAirway ctrlShow false;
        _ctrlSurgicalAirwayStrapped ctrlShow true;
    } else {
        _ctrlSurgicalAirway ctrlShow true;
        _ctrlSurgicalAirwayStrapped ctrlShow false;
    };
} else {
    _ctrlSurgicalAirway ctrlShow false;
    _ctrlSurgicalAirwayStrapped ctrlShow false;
};

private _airwayItemOral = _target getVariable [QEGVAR(airway,AirwayItem_Oral), ""];
private _airwayItemNPA = _target getVariable [QEGVAR(airway,AirwayItem_Nasal), ""];

if (_airwayItemOral isNotEqualTo "") then {
    if (_airwayItemOral isEqualTo "SGA") then {
        _ctrlOPA ctrlShow false;
        _ctrlIGel ctrlShow true;
    } else {
        _ctrlOPA ctrlShow true;
        _ctrlIGel ctrlShow false;
    };
} else {
    _ctrlOPA ctrlShow false;
    _ctrlIGel ctrlShow false;
};

if (_airwayItemNPA isEqualTo "NPA") then {
    _ctrlNPA ctrlShow true;
} else {
    _ctrlNPA ctrlShow false;
};

private _ctrlLozenge = _ctrlGroup controlsGroupCtrl IDC_BODY_HEAD_LOZENGE;
private _lozengeItem = _target getVariable [QEGVAR(circulation,LozengeItem), ""];

if (_lozengeItem isNotEqualTo "") then {
    _ctrlLozenge ctrlShow true;
} else {
    _ctrlLozenge ctrlShow false;
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
private _ctrlIVLeftArmUpper = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_UPPER_IV;
private _ctrlIVLeftArmMiddle = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_MIDDLE_IV;
private _ctrlIVLeftArmLower = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_LOWER_IV;
private _ctrlIVRightArmUpper = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_UPPER_IV;
private _ctrlIVRightArmMiddle = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_MIDDLE_IV;
private _ctrlIVRightArmLower = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_LOWER_IV;

private _ctrlIVLeftLegUpper = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTLEG_UPPER_IV;
private _ctrlIVLeftLegMiddle = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTLEG_MIDDLE_IV;
private _ctrlIVLeftLegLower = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTLEG_LOWER_IV;
private _ctrlIVRightLegUpper = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTLEG_UPPER_IV;
private _ctrlIVRightLegMiddle = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTLEG_MIDDLE_IV;
private _ctrlIVRightLegLower = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTLEG_LOWER_IV;

private _IVArray = GET_IV(_target);

{
    _x params ["_xUpper", "_xMiddle", "_xLower"];

    (_IVArray select (_forEachIndex + 2)) params ["_IVUpper", "_IVMiddle", "_IVLower"];

    _xUpper ctrlShow (_IVUpper > 0);
    _xMiddle ctrlShow (_IVMiddle > 0);
    _xLower ctrlShow (_IVLower > 0);
} forEach [[_ctrlIVLeftArmUpper, _ctrlIVLeftArmMiddle, _ctrlIVLeftArmLower], [_ctrlIVRightArmUpper, _ctrlIVRightArmMiddle, _ctrlIVRightArmLower], [_ctrlIVLeftLegUpper, _ctrlIVLeftLegMiddle, _ctrlIVLeftLegLower], [_ctrlIVRightLegUpper, _ctrlIVRightLegMiddle, _ctrlIVRightLegLower]];

private _ctrlIOLeftArm = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTARM_IO;
private _ctrlIORightArm = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTARM_IO;
private _ctrlIOLeftLeg = _ctrlGroup controlsGroupCtrl IDC_BODY_LEFTLEG_IO;
private _ctrlIORightLeg = _ctrlGroup controlsGroupCtrl IDC_BODY_RIGHTLEG_IO;
private _ctrlIOTorso = _ctrlGroup controlsGroupCtrl IDC_BODY_TORSO_IO;

private _IOArray = GET_IO(_target);

{
    _x ctrlShow ((_IOArray select (_forEachIndex + 1)) > 0);
} forEach [_ctrlIOTorso, _ctrlIOLeftArm, _ctrlIORightArm, _ctrlIOLeftLeg, _ctrlIORightLeg];

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
    if (_airwayItemOral isEqualTo "" && !(HAS_SURGICAL_AIRWAY(_target))) then {
        _ctrlAEDCapnograph ctrlShow true;
    } else {
        _ctrlAEDCapnograph ctrlShow false;
    };
} else {
    _ctrlAEDCapnograph ctrlShow false;
};