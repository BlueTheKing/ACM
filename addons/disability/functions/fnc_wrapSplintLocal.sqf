#include "..\script_component.hpp"
/*
 * Author: Blue
 * Wrap splint (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_wrapSplintLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _splintStatus = GET_SPLINTS(_patient);
private _splintStatusOnPart = _splintStatus select (ALL_BODY_PARTS find toLower _bodyPart);

_splintStatus set [(ALL_BODY_PARTS find toLower _bodyPart), 2];

_patient setVariable [VAR_SPLINTS, _splintStatus, true];