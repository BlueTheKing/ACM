#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_initUnit;
 *
 * Public: No
 */

params ["_patient"];

[_patient] call EFUNC(airway,initUnit);
//[_patient] call EFUNC(circulation,initUnit);

[{
    params ["_patient"];

    [_patient] call FUNC(generateTargetVitals);
}, [_patient], 0.5] call CBA_fnc_waitAndExecute;