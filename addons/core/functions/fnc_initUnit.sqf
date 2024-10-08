#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_initUnit;
 *
 * Public: No
 */

params ["_unit"];

[_unit] call EFUNC(airway,initUnit);
[_unit] call EFUNC(circulation,initUnit);

[{
    params ["_unit"];

    [_unit] call FUNC(generateTargetVitals);
}, [_unit], 0.5] call CBA_fnc_waitAndExecute;