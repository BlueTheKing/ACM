#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get fresh blood entry.
 *
 * Arguments:
 * 0: ID <NUMBER>
 *
 * Return Value:
 * 0: Fresh Blood Entry <ARRAY>
 *   0: Donor <OBJECT>
 *   1: Volume <NUMBER>
 *   2: Blood Type <NUMBER>
 *   3: Collection Time <NUMBER>
 *
 * Example:
 * [1] call ACM_circulation_fnc_getFreshBloodEntry;
 *
 * Public: No
 */

params ["_id"];

private _freshBloodlist = (missionNamespace getVariable [QGVAR(FreshBloodList), createHashMap]);

_freshBloodlist get _id;