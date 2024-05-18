#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update circulatory system state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_updateCirculationState;
 *
 * Public: No
 */

params ["_patient"];

private _state = true;

switch (true) do {
    case (GET_OXYGEN(_patient) < ACM_OXYGEN_HYPOXIA);
    case (_patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]);
    case ((_patient getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0]) > ACM_TENSIONHEMOTHORAX_THRESHOLD);
    case (GET_BLOOD_VOLUME(_patient) < BLOOD_VOLUME_CLASS_4_HEMORRHAGE): {
        _state = false;
    };
    default {};
};

_patient setVariable [QGVAR(CirculationState), _state, true];