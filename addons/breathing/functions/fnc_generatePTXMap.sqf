#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate chances for inflicting pneumothorax injury (LOCAL)
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

GVAR(ChestInjury_Chances) = createHashMapfromArray [[60,8],[61,50],[62,90],[70,5],[71,40],[72,80],[10,0],[11,10],[12,20]]; // TODO move to config?