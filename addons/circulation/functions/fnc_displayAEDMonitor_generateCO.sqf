#include "..\script_component.hpp"
#include "..\Defibrillator_defines.hpp"
/*
 * Author: Blue
 * Generates rhythm sequence for EtCO2 display
 *
 * Arguments:
 * 0: Rhythm Type <NUMBER>
 * 1: Rhythm Spacing <NUMBER>
 * 2: Rhythm Sequence Offset <NUMBER>
 * 3: Patient EtCO2 <NUMBER>
 * 4: Patient Respiration Rate <NUMBER>
 *
 * Return Value:
 * [Rhythm Array <ARRAY<NUMBER>>, Safe Spacing Array] <ARRAY<ARRAY>>
 *
 * Example:
 * [0, 7, 0, 35, 20] call ACM_circulation_fnc_displayAEDMonitor_generateCO;
 *
 * Public: No
 */

params ["_rhythm", "_spacing", "_arrayOffset", "_co2", "_rr"];

if (_rhythm != -5 && {_co2 < 1 || _rr < 1}) then {
    _rhythm = 1;
};

_co2 = _co2 / 50;

if (_spacing != -1) then {
    _arrayOffset = _arrayOffset + floor(_spacing/2);
};

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

private _maxHeight = (-150 * _co2);

switch (_rhythm) do {
    case -5: {
        private _step = [0];

        private _repeat = ceil(AED_MONITOR_WIDTH / (count _step));

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + _step;
        };
    };
    case -1: { // CPR
        private _breathWidth = 5;
        private _angle = 18 / _breathWidth;

        private _cleanRhythmStart = [0, -10 * _co2, -40 * _co2, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 5, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 1, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 0.01]; // 6
        private _cleanRhythmEnd = [_maxHeight + 0.1, _maxHeight + 5, _maxHeight + 40, -10 * _co2, -1 * _co2]; // 5
        private _cleanRhythmStepComplete = _cleanRhythmStart;

        for "_i" from 0 to _breathWidth do {
            private _fromMax = _breathWidth - _i;
            private _value = _maxHeight + (_fromMax/50 * (_fromMax * _angle));
            _cleanRhythmStepComplete = _cleanRhythmStepComplete + [_value];
        };

        _cleanRhythmStepComplete = _cleanRhythmStepComplete + _cleanRhythmEnd;

        private _stepLength = count _cleanRhythmStepComplete;

        private _noiseRange = 2;
        private _repeat = ceil(AED_MONITOR_WIDTH / (_stepLength + _spacing));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_spacing] call _fnc_generateStepSpacingArray) + ([_cleanRhythmStepComplete, _noiseRange] call _generateNoisyRhythmStep);
            _safeSpacingArray = _safeSpacingArray + ([_spacing, true] call _generateSafeSpacing) + ([_stepLength] call _generateSafeSpacing);
        };
    };
    case 0: { // Sinus
        private _breathWidth = 30 * (18 / _rr);
        private _angle = 18 / _breathWidth;
        _spacing = round((60 / _rr) * 12);
        
        private _cleanRhythmStart = [0, -10 * _co2, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 40, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 5, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 1, _maxHeight + (_breathWidth / 50 * (_breathWidth * _angle)) + 0.01]; // 6
        private _cleanRhythmEnd = [_maxHeight + 0.1, _maxHeight + 5, _maxHeight + 40, -10 * _co2, -1 * _co2]; // 5
        private _cleanRhythmStepComplete = _cleanRhythmStart;

        for "_i" from 0 to _breathWidth do {
            private _fromMax = _breathWidth - _i;
            private _value = _maxHeight + (_fromMax/50 * (_fromMax * _angle));
            _cleanRhythmStepComplete = _cleanRhythmStepComplete + [_value];
        };

        _cleanRhythmStepComplete = _cleanRhythmStepComplete + _cleanRhythmEnd;

        private _stepLength = count _cleanRhythmStepComplete;

        private _noiseRange = 1;
        private _repeat = ceil(AED_MONITOR_WIDTH / (_stepLength + _spacing));

        if (_arrayOffset > 0) then {
            _repeat = _repeat + 1;
        };

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_spacing] call _fnc_generateStepSpacingArray) + ([_cleanRhythmStepComplete, _noiseRange] call _generateNoisyRhythmStep);
            _safeSpacingArray = _safeSpacingArray + ([_spacing, true] call _generateSafeSpacing) + ([_stepLength] call _generateSafeSpacing);
        };
    };
    default {
        private _step = [0];
        private _noiseRange = 2;

        private _repeat = ceil(AED_MONITOR_WIDTH / (count _step));

        for "_i" from 0 to _repeat do {
            _rhythmArray = _rhythmArray + ([_step, _noiseRange] call _generateNoisyRhythmStep);
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