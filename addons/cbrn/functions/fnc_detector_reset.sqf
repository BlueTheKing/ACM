#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset detector hightest threat.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_detector_reset;
 *
 * Public: No
 */

params ["_unit"];

_unit setVariable [QGVAR(Detector_Exposure_Severity), 0];

[LLSTRING(ChemicalDetector_WasReset), 2, _unit] call ACEFUNC(common,displayTextStructured);