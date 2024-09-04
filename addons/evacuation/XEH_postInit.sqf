#include "script_component.hpp"

if !(GVAR(enabled)) exitWith {};

if !(isMultiplayer) exitWith {};

GVAR(CasualtyGroup) = createGroup [civilian, false];

if (isServer) then {
    if (GVAR(ticketCountRespawn) > ([GVAR(playerFaction), 0] call BIS_fnc_respawnTickets)) then {
        private _missingTickets = GVAR(ticketCountRespawn) - ([GVAR(playerFaction), 0] call BIS_fnc_respawnTickets);
        [GVAR(playerFaction), _missingTickets] call BIS_fnc_respawnTickets;
    };

    missionNamespace setVariable [QGVAR(CasualtyTicket_Count), GVAR(ticketCountCasualty), true];
};

[QACEGVAR(medical,death), {
    params ["_unit"];

    if !(_unit getVariable [QGVAR(playerSpawned), false]) exitWith {};

    if (_unit getVariable [QGVAR(casualtyTicketClaimed), false]) then {
        [_unit] call FUNC(returnCasualtyTicket);
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(createReinforcmentAndSwitch), {
    params ["_originalUnit"];

    if !(hasInterface) exitWith {};

    private _unit = (createGroup GVAR(playerFaction)) createUnit [(typeOf _originalUnit), (getPosATL GVAR(ReinforcePoint)), [], 0, "FORM"];

    [_unit, ([_originalUnit] call CBA_fnc_getLoadout)] call CBA_fnc_setLoadout;

    [{
        params ["_unit"];

        selectPlayer _unit;
    }, [_unit], 1] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;