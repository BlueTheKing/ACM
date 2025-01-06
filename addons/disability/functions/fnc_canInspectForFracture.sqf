#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if patient body part can be inspected for fracture.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * Can inspect for fracture <BOOL>
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_canInspectForFracture;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _partIndex = GET_BODYPART_INDEX(_bodyPart);
private _bodyPartDamage = ((_patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]]) select _partIndex);

(GET_SPLINTS(_patient) select _partIndex) == 0 && ((((_patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]]) select _partIndex) > 0) || (_bodyPartDamage select _partIndex) >= FRACTURE_DAMAGE_THRESHOLD || _bodyPartDamage >= LIMPING_DAMAGE_THRESHOLD);