#include "script_component.hpp"

[QGVAR(splintLocal), LINKFUNC(splintLocal)] call CBA_fnc_addEventHandler;
[QGVAR(wrapSplintLocal), LINKFUNC(wrapSplintLocal)] call CBA_fnc_addEventHandler;
[QGVAR(removeSplintLocal), LINKFUNC(removeSplintLocal)] call CBA_fnc_addEventHandler;

[QGVAR(shakeAwakeLocal), LINKFUNC(shakeAwakeLocal)] call CBA_fnc_addEventHandler;
[QGVAR(slapAwakeLocal), LINKFUNC(slapAwakeLocal)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,tourniquetLocal), LINKFUNC(setTourniquetTime)] call CBA_fnc_addEventHandler;
[QACEGVAR(medical_treatment,tourniquetLocal), LINKFUNC(handleTourniquetEffects)] call CBA_fnc_addEventHandler;

["multiplier", {
    (GET_TOURNIQUET_NECROSIS(ACE_player)) params ["_leftArm", "_rightArm"];
    1 + ((_leftArm + _rightArm) * 2)
}, QUOTE(ADDON)] call ACEFUNC(common,addSwayFactor);