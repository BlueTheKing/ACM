#include "..\script_component.hpp"
/*
 * Author: SzwedzikPL
 * Checks the unit's dog tag.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject] call ace_dogtags_fnc_checkDogtag
 *
 * Public: No
 */

params ["_player", "_target"];

// Animation
_player call ACEFUNC(common,goKneeling);

// Sound
private _position = _target modelToWorldWorld (_target selectionPosition "neck");

playSound3D [
    selectRandom RUSTLING_SOUNDS,
    objNull,
    false,
    _position,
    1,
    1,
    50
];

// Display dog tag
private _doubleTags = (_target getVariable [QACEGVAR(dogtags,dogtagTaken), objNull]) != _target;
private _dogtagData = _target call ACEFUNC(dogtags,getDogtagData);

[ACELINKFUNC(dogtags,showDogtag), [_dogtagData, _doubleTags], DOGTAG_SHOW_DELAY] call CBA_fnc_waitAndExecute;

if (!(IS_UNCONSCIOUS(_target)) && alive _target) then {
    [QACEGVAR(common,displayTextStructured), [(format [LLSTRING(DogTags_InspectingDogtags), [_player, false, true] call ACEFUNC(common,getName)]), 2, _target], _target] call CBA_fnc_targetEvent;
};