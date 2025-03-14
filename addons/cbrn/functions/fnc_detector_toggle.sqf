#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set whether detector is enabled.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call ACM_CBRN_fnc_detector_toggle;
 *
 * Public: No
 */

params ["_unit", "_state"];

_unit setVariable [QGVAR(Detector_State), _state, true];

if (_state) then {
    [LLSTRING(ChemicalDetector_TurnedOn), 1.5, _unit] call ACEFUNC(common,displayTextStructured);
    [QGVAR(detectorPFH), [_unit], _unit] call CBA_fnc_targetEvent;
} else {
    [LLSTRING(ChemicalDetector_TurnedOff), 1.5, _unit] call ACEFUNC(common,displayTextStructured);
};