#include "script_component.hpp"

if !(isMultiplayer) exitWith {};

["CBA_settingsInitialized", {
    if !(GVAR(enable)) exitWith {};

    GVAR(CasualtyGroup) = createGroup [civilian, false];

    if (isServer) then {
        if ((round GVAR(ticketCountRespawn)) > ([GVAR(playerFaction), 0] call BIS_fnc_respawnTickets)) then {
            private _missingTickets = (round GVAR(ticketCountRespawn)) - ([GVAR(playerFaction), 0] call BIS_fnc_respawnTickets);
            [GVAR(playerFaction), _missingTickets] call BIS_fnc_respawnTickets;
        };

        missionNamespace setVariable [QGVAR(CasualtyTicket_Count), (round GVAR(ticketCountCasualty)), true];
    };

    [QACEGVAR(medical,death), {
        params ["_unit"];

        if (_unit getVariable [QGVAR(casualtyTicketClaimed), false]) then {
            [true] call FUNC(setCasualtyTicket);
            [GVAR(playerFaction), -(round GVAR(convertedCasualtyDeathPenalty))] call BIS_fnc_respawnTickets;
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(createReinforcementAndSwitch), {
        params ["_originalUnit"];

        if !(hasInterface) exitWith {};

        private _unit = (createGroup GVAR(playerFaction)) createUnit [(typeOf _originalUnit), (getPosATL GVAR(ReinforcePoint)), [], 0, "FORM"];

        [_unit, ([_originalUnit] call CBA_fnc_getLoadout)] call CBA_fnc_setLoadout;

        [{
            params ["_unit", "_originalUnit"];

            private _saved = (ACE_player getVariable ["ENH_savedLoadout", -1] isNotEqualTo -1);

            selectPlayer _unit;

            if (_saved) then { // Prevent restore loadout from breaking
                _unit setVariable ["ENH_savedLoadout", getUnitLoadout _unit];
            };

            _originalUnit setVariable [QGVAR(TreatmentText_Providers), []];

            if (GVAR(clearCasualtyLoadout)) then {
                removeAllWeapons _originalUnit;
            };

            [{
                params ["_unit", "_originalUnit"];

                // ace_common_fnc_setName
                _originalUnit setVariable ["ACE_Name", ([name _unit, true] call ACEFUNC(common,sanitizeString)), true];
                _originalUnit setVariable ["ACE_NameRaw", ([name _unit, false] call ACEFUNC(common,sanitizeString)), true];

                private _engineerLevel = _originalUnit getVariable ["ACE_isEngineer", _originalUnit getUnitTrait "engineer"];
                _unit setVariable ["ACE_isEngineer", ([0,1,2] select _engineerLevel), true];

                private _medicLevel = _originalUnit getVariable [QACEGVAR(medical,medicClass), parseNumber (_originalUnit getUnitTrait "medic")];
                _unit setVariable [QACEGVAR(medical,medicClass), _medicLevel, true];

                ["ACM_casualtyEvacuated", [_unit, _originalUnit], _unit] call CBA_fnc_targetEvent;
            }, [_unit, _originalUnit], 1] call CBA_fnc_waitAndExecute;
        }, [_unit, _originalUnit], 1] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addEventHandler;
}] call CBA_fnc_addEventHandler;