#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get name of body part
 *
 * Arguments:
 * 0: Body Part <STRING>
 *
 * Return Value:
 * Body Part Name <STRING>
 *
 * Example:
 * ["head"] call ACM_core_fnc_getBodyPartString;
 *
 * Public: No
 */

params ["_bodyPart"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

([
    ACELSTRING(medical_gui,Head),
    ACELSTRING(medical_gui,Torso),
    ACELSTRING(medical_gui,LeftArm),
    ACELSTRING(medical_gui,RightArm),
    ACELSTRING(medical_gui,LeftLeg),
    ACELSTRING(medical_gui,RightLeg)
] select _partIndex);