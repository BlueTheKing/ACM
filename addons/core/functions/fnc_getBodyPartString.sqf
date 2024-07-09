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
    ACELLSTRING(medical_gui,Head),
    ACELLSTRING(medical_gui,Torso),
    ACELLSTRING(medical_gui,LeftArm),
    ACELLSTRING(medical_gui,RightArm),
    ACELLSTRING(medical_gui,LeftLeg),
    ACELLSTRING(medical_gui,RightLeg)
] select _partIndex);