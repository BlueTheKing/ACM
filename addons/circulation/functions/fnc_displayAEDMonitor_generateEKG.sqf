#include "..\script_component.hpp"
#include "..\Defibrillator_defines.hpp"
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
 * [Rhythm Array <ARRAY<NUMBER>>, Safe Spacing Array] <ARRAY<ARRAY>>
 *
 * Example:
 * [0, 7, 0] call ACM_circulation_fnc_displayAEDMonitor_generateEKG;
 *
 * Public: No
 */

params ["_rhythm", "_spacing", "_arrayOffset"];

if (_spacing != -1) then {
    _arrayOffset = _arrayOffset + floor(_spacing/2);
};

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

private _generateNoisyRhythmStep = {
    params ["_cleanRhythmStep", "_noiseRange"];

    private _noisyRhythm = [];
    {
        _noisyRhythm pushBack (random [(_x - _noiseRange), _x, (_x + _noiseRange)]);
    } forEach _cleanRhythmStep;
    _noisyRhythm;
};

private _generateSafeSpacing = {
    params ["_count", ["_safe", false]];

    private _array = [];

    for "_i" from 1 to _count do {
        _array pushBack _safe;
    };

    _array;
};

private _rhythmArray = [];
private _safeSpacingArray = [];

switch (_rhythm) do {
    case -1: { // CPR
        private _cleanRhythmStep = [0,-5,-10,-20,-40 + (random 5),-45 + (random 5),-45 + (random 5),-45 + (random 5),-45 + (random 5),-45 + (random 5),-45 + (random 5),-40 + (random 5),-20,-10,-5]; // 15
        private _noiseRange = 8;
        private _repeat = ceil(AED_MONITOR_WIDTH / ((count _cleanRhythmStep) + _spacing));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_spacing] call _fnc_generateStepSpacingArray) + ([_cleanRhythmStep, _noiseRange] call _generateNoisyRhythmStep);
            _safeSpacingArray = _safeSpacingArray + ([_spacing, true] call _generateSafeSpacing) + ([15] call _generateSafeSpacing);
        };
    };
    case 5; // PEA
    case 0: { // Sinus
        private _cleanRhythmStep = [0,-1,-5,2,-4,-40,25,5,0,-5,-7,-1,5,4,0.8]; // 15
        private _noiseRange = 3;
        private _repeat = ceil(AED_MONITOR_WIDTH / ((count _cleanRhythmStep) + _spacing));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_spacing] call _fnc_generateStepSpacingArray) + ([_cleanRhythmStep, _noiseRange] call _generateNoisyRhythmStep);
            _safeSpacingArray = _safeSpacingArray + ([_spacing, true] call _generateSafeSpacing) + ([15] call _generateSafeSpacing);
        };
    };
    case 1: { // Asystole
        private _cleanRhythmStep = [0];
        private _noiseRange = 3;
        private _repeat = ceil(AED_MONITOR_WIDTH / (count _cleanRhythmStep));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_cleanRhythmStep, _noiseRange] call _generateNoisyRhythmStep);
        };
    };
    case 2: { // VF
        private _cleanRhythmStep = [0];
        private _noiseRange = 30;
        private _repeat = ceil(AED_MONITOR_WIDTH / (count _cleanRhythmStep));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_cleanRhythmStep, _noiseRange] call _generateNoisyRhythmStep);
        };
    };
    case 3: { // PVT
        private _cleanRhythmStep = [5,-30,-47,-49,-49,-49,-44,-39,-30]; // 9
        private _noiseRange = 3;
        private _repeat = ceil(AED_MONITOR_WIDTH / (count _cleanRhythmStep));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            private _cleanRhythmStepRandomized = _cleanRhythmStep;
            _cleanRhythmStepRandomized set [0, ((_cleanRhythmStepRandomized select 0) + (2 - (random 4)))];
            _rhythmArray = _rhythmArray + ([_cleanRhythmStepRandomized, _noiseRange] call _generateNoisyRhythmStep);
        };
    };
};

if (_arrayOffset > 0) then {
    _rhythmArray deleteRange [0,_arrayOffset];
};

if (count _safeSpacingArray < 1) then {
    _safeSpacingArray resize [_maxLength, true];
};

_rhythmArray resize [_maxLength, 0];

[_rhythmArray,_safeSpacingArray];