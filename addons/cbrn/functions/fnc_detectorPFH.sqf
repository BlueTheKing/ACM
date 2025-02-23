#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle detector PFH. (LOCAL)
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_detectorPFH;
 *
 * Public: No
 */

params ["_unit"];

if (_unit getVariable [QGVAR(Detector_PFH), -1] != -1) exitWith {};

private _detectorPFH = [{
    params ["_args", "_idPFH"];
    _args params ["_unit"];

    private _hasDetector = (_unit getSlotItemName 610) == 'ChemicalDetector_01_watch_F';
    private _isEnabled = _unit getVariable [QGVAR(Detector_State), false];

    if (!_isEnabled || !_hasDetector) exitWith {
        if !(_hasDetector) then {
            _unit setVariable [QGVAR(Detector_State), false, true];
        };

        _unit setVariable [QGVAR(Detector_PFH), -1];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (IS_CONTAMINATED(_unit)) then {
        if (_unit getVariable [QGVAR(Detector_Alarm_State), false]) then {
            playSound3D [QPATHTO_R(sound\detector_warning.wav), _unit, false, getPosASL _unit, 5, 1, 30]; // 0.805s
        };

        private _exposureSeverity = 0;

        if (IS_CONTAMINATEDBY(_unit,Chemical_CS)) then {
            _exposureSeverity = _exposureSeverity + 0.1;
        };

        if (IS_CONTAMINATEDBY(_unit,Chemical_Chlorine)) then {
            _exposureSeverity = _exposureSeverity + 0.85;
        };

        if (IS_CONTAMINATEDBY(_unit,Chemical_Sarin) || IS_CONTAMINATEDBY(_unit,Chemical_Lewisite)) then {
            _exposureSeverity = _exposureSeverity + 1;
        };

        _unit setVariable [QGVAR(Detector_Exposure_Severity), (_exposureSeverity min 1)];
    };
}, 0.8, [_unit]] call CBA_fnc_addPerFrameHandler;

_unit setVariable [QGVAR(Detector_PFH), _detectorPFH];

if (_unit getVariable [QGVAR(DetectorUI_PFH), -1] != -1) exitWith {};

"ACM_ChemicalDetector" cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false];

private _detectorUIPFH = [{
    params ["_args", "_idPFH"];
    _args params ["_unit"];

    private _isEnabled = _unit getVariable [QGVAR(Detector_State), false];

    if !(_isEnabled) exitWith {
        private _detectorUI = uiNamespace getVariable "RscWeaponChemicalDetector";

        if !(isNull _detectorUI) then {
            private _detectorCtrl = _detectorUI displayCtrl 101;
            _detectorCtrl ctrlAnimateModel ["Threat_Level_Source", 0, true];
        };

        "ACM_ChemicalDetector" cutText ["", "PLAIN"];
        _unit setVariable [QGVAR(DetectorUI_PFH), -1];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _detectorUI = uiNamespace getVariable "RscWeaponChemicalDetector";

    if !(isNull _detectorUI) then {
        private _detectorCtrl = _detectorUI displayCtrl 101;
        _detectorCtrl ctrlAnimateModel ["Threat_Level_Source", (_unit getVariable [QGVAR(Detector_Exposure_Severity), 0]), true];
    };
}, 0, [_unit]] call CBA_fnc_addPerFrameHandler;

_unit setVariable [QGVAR(DetectorUI_PFH), _detectorUIPFH];