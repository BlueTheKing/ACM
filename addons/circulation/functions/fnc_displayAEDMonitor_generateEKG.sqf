#include "..\script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Blue
 * Generates rhythm sequence for EKG display
 *
 * Arguments:
 * 0: Rhythm Type <NUMBER>
 * 1: Rhythm Spacing <NUMBER>
 * 2: Rhythm Sequence Offset <NUMBER>
 *
 * Return Value:
 * Rhythm Array <ARRAY<NUMBER>>
 *
 * Example:
 * [0, 7, 0] call AMS_circulation_fnc_displayAEDMonitor_generateEKG;
 *
 * Public: No
 */

params ["_rhythm", "_spacing", "_arrayOffset"];

_arrayOffset = _arrayOffset + floor(_spacing/2);

private _maxLength = AED_MONITOR_WIDTH;

private _fnc_generateStepSpacingArray = {
    params ["_spacing"];

    private _stepSpacingArray = [];

    if (_spacing > 4) then {
        for "_i" from 0 to (ceil(_spacing/4)) do {
            _stepSpacingArray = _stepSpacingArray + [(random [-2, 0, 2]),(random [-2, 0, 2]),(random [-2, 0, 2]),(random [-2, 0, 2])];
        };
    } else {
        _stepSpacingArray = [(random [-2, 0, 2]),(random [-2, 0, 2]),(random [-2, 0, 2]),(random [-2, 0, 2])];
    };

    _stepSpacingArray resize _spacing;
    _stepSpacingArray;
};

private _rhythmArray = [];

switch (_rhythm) do {
    case -5: {
        private _step = [0];

        private _repeat = ceil(AED_MONITOR_WIDTH / (count _step));

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + _step;
        };
    };
    case 0: {
        private _generateNoisyRhythmStep = {
            params ["_cleanRhythmStep", "_noiseRange"];
            private _noisyRhythm = [];
            {
                _noisyRhythm pushBack (random [(_x - _noiseRange), _x, (_x + _noiseRange)]);
            } forEach _cleanRhythmStep;
            _noisyRhythm;
        };

        private _cleanRhythmStep = [0,-1,-5,0.1,2,-4,-40,25,5,2,1,-5,-7,-1,5,4,2,0.8,0,0];
        private _noiseRange = 3;
        private _repeat = ceil(AED_MONITOR_WIDTH / ((count _cleanRhythmStep) + _spacing));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_spacing] call _fnc_generateStepSpacingArray) + ([_cleanRhythmStep, _noiseRange] call _generateNoisyRhythmStep);
        };
    };
};

if (_arrayOffset > 0) then {
    _rhythmArray deleteRange [0,_arrayOffset];
};

_rhythmArray resize _maxLength;
_rhythmArray;