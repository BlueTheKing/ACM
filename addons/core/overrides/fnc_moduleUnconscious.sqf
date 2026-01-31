#include "..\script_component.hpp"
/*
 * Author: kymckay
 * Flips the unconscious state of the unit the module is placed on.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC, [bob, kevin], true] call ace_zeus_fnc_moduleUnconscious
 *
 * Public: No
 */

params ["_logic"];

if !(local _logic) exitWith {};

if (isNil QACEFUNC(medical,setUnconscious)) then {
    [ACELSTRING(zeus,RequiresAddon)] call ACEFUNC(zeus,showMessage);
} else {
    private _mouseOver = GETMVAR(bis_fnc_curatorObjectPlaced_mouseOver,[""]);

    if ((_mouseOver select 0) != "OBJECT") then {
        [ACELSTRING(zeus,NothingSelected)] call ACEFUNC(zeus,showMessage);
    } else {
        private _unit = effectiveCommander (_mouseOver select 1);

        if !(_unit isKindOf "CAManBase") then {
            [ACELSTRING(zeus,OnlyInfantry)] call ACEFUNC(zeus,showMessage);
        } else {
            if !(alive _unit) then {
                [ACELSTRING(zeus,OnlyAlive)] call ACEFUNC(zeus,showMessage);
            } else {
                private _unconscious = GETVAR(_unit,ACE_isUnconscious,false);
                if !(_unconscious) then {
                    _unit setVariable [QACEGVAR(medical_statemachine,AIUnconsciousness), true, true];
                };
                // Function handles locality for me
                [_unit, !_unconscious, 10e10] call ACEFUNC(medical,setUnconscious);
            };
        };
    };
};

deleteVehicle _logic;
