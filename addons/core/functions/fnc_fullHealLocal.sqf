#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle full heal.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_fullHealLocal;
 *
 * Public: No
 */

params ["_patient"];

[_patient] call FUNC(resetVariables);
[_patient] call EFUNC(airway,resetVariables);
[_patient] call EFUNC(breathing,resetVariables);
[_patient] call EFUNC(circulation,resetVariables);
[_patient] call EFUNC(damage,resetVariables);
[_patient] call EFUNC(disability,resetVariables);