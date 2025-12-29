#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get name of body part.
 *
 * Arguments:
 * 0: Body Part <STRING>
 * 1: Localize String? <BOOL>
 *
 * Return Value:
 * Body Part Name <STRING>
 *
 * Example:
 * ["head", true] call ACM_core_fnc_getBodyPartString;
 *
 * Public: No
 */

params ["_bodyPart", ["_localize", true]];

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

private _string = ([
    ACELSTRING(medical_gui,Head),
    ACELSTRING(medical_gui,Torso),
    ACELSTRING(medical_gui,LeftArm),
    ACELSTRING(medical_gui,RightArm),
    ACELSTRING(medical_gui,LeftLeg),
    ACELSTRING(medical_gui,RightLeg)
] select _partIndex);

([_string, localize _string] select _localize);