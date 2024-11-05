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

GVAR(ChestInjury_Chances) = createHashMapfromArray [[60,0.08],[61,0.5],[62,0.9],[70,0.05],[71,0.4],[72,0.8],[10,0],[11,0.1],[12,0.2]];