#include "..\script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Blue
 * Generates rhythm sequence for Pulse Oximeter display
 *
 * Arguments:
 * 0: Rhythm Type <NUMBER>
 * 1: Rhythm Spacing <NUMBER>
 * 2: Rhythm Sequence Offset <NUMBER>
 * 3: Patient Oxygen Saturation <NUMBER>
 *
 * Return Value:
 * Rhythm Array <ARRAY<NUMBER>>
 *
 * Example:
 * [0, 7, 0, 99] call AMS_circulation_fnc_displayAEDMonitor_generatePO;
 *
 * Public: No
 */

params ["_rhythm", "_spacing", "_arrayOffset", "_saturation"];

if (_spacing != -1) then {
    _arrayOffset = _arrayOffset + floor(_spacing/2);
};

_saturation = _saturation / 99;

_arrayOffset = _arrayOffset + floor(_spacing/2);

private _maxLength = AED_MONITOR_WIDTH;

private _fnc_generateStepSpacingArray = {
    params ["_spacing"];

    private _stepSpacingArray = [];

    if (_spacing > 4) then {
        for "_i" from 0 to (ceil(_spacing/4)) do {
            _stepSpacingArray = _stepSpacingArray + [(random [0, 0, 2]),(random [0, 0, 2]),(random [0, 0, 2]),(random [0, 0, 2])];
        };
    } else {
        _stepSpacingArray = [(random [0, 0, 2]),(random [0, 0, 2]),(random [0, 0, 2]),(random [0, 0, 2])];
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
    case 0: { // TODO change
        private _generateNoisyRhythmStep = {
            params ["_cleanRhythmStep", "_noiseRange"];
            private _noisyRhythm = [];
            {
                _noisyRhythm pushBack (random [(_x - _noiseRange), _x, (_x + _noiseRange)]);
            } forEach _cleanRhythmStep;
            _noisyRhythm;
        };
        //[0,-10,-30,-40,-45,-47,-49.2,-50,-49.2,-45,-40,-38,-36,-33,-30,-20,-15,-5];
        private _cleanRhythmStep = [0, -10 * _saturation, -30 * _saturation, -40 * _saturation, -45 * _saturation, -47 * _saturation, -49.2 * _saturation, -50 * _saturation, -49.2 * _saturation, -45 * _saturation, -40 * _saturation,
        -38 * _saturation, -36 * _saturation, -33 * _saturation, -30 * _saturation, -20 * _saturation, -15 * _saturation, -5 * _saturation];

        private _noiseRange = 1;
        private _repeat = ceil(AED_MONITOR_WIDTH / ((count _cleanRhythmStep) + _spacing));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_spacing] call _fnc_generateStepSpacingArray) + ([_cleanRhythmStep, _noiseRange] call _generateNoisyRhythmStep);
        };
    };
    default {
        private _step = [0];

        private _repeat = ceil(AED_MONITOR_WIDTH / (count _step));

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + _step;
        };
    };
};

if (_arrayOffset > 0) then {
    _rhythmArray deleteRange [0,_arrayOffset];
};

_rhythmArray resize [_maxLength, 0];
_rhythmArray;