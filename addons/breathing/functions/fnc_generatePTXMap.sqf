#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate chances for inflicting pneumothorax injury. (LOCAL)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_breathing_fnc_generatePTXMap;
 *
 * Public: No
 */

GVAR(ChestInjury_Chances) = createHashMapfromArray [
    [61,[0.25, 0, 0.5, 0.3]],
    [62,[0.5, 0.5, 1, 0.9]],
    [71,[0.25, 0, 0.5, 0.25]],
    [72,[0.5, 0.3, 1, 0.8]],
    [11,[0.25, 0, 0.5, 0.2]],
    [12,[0.5, 0.2, 2, 0.5]]
];