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

    if (isServer) then {
        /*[QGVAR(transferCurator), {
            params ["_unit", "_originalUnit"];

            private _curatorLogic = getAssignedCuratorLogic _originalUnit;

            unassignCurator _curatorLogic;

            [{
                params ["_curatorLogic"];

                isNull getAssignedCuratorUnit _curatorLogic;
            }, {
                params ["_curatorLogic", "_unit"];

                _unit assignCurator _curatorLogic;
            }, [_curatorLogic, _unit]] call CBA_fnc_waitUntilAndExecute;
        }] call CBA_fnc_addEventHandler;*/

        [QGVAR(createCurator), {
            params ["_unit"];
            
            if !(isPlayer _unit) exitWith {};

            private _unitID = getPlayerUID _unit;
            private _group = createGroup [sideLogic, true];
            private _module = _group createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];

            _module setVariable ["owner", _unitID, true];
            _module setVariable ["Addons", 3, true];
            _module setVariable ["BIS_fnc_initModules_disableAutoActivation", false];

            _module setCuratorCoef ["place", 0];
            _module setCuratorCoef ["delete", 0];
        }] call CBA_fnc_addEventHandler;
    };

    [QGVAR(createReinforcementAndSwitch), {
        params ["_originalUnit"];

        if !(hasInterface) exitWith {};

        private _unit = (createGroup GVAR(playerFaction)) createUnit [(typeOf _originalUnit), (getPosATL GVAR(ReinforcePoint)), [], 0, "FORM"];

        [_unit, ([_originalUnit] call CBA_fnc_getLoadout)] call CBA_fnc_setLoadout;

        [{
            params ["_unit", "_originalUnit"];

            private _saved = (ACE_player getVariable ["ENH_savedLoadout", -1] isNotEqualTo -1);

            selectPlayer _unit;

            removeGoggles _unit;
            _unit addGoggles (goggles _originalUnit);

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

                private _persistentVariableArray = _originalUnit getVariable ["ACM_PersistentVariables", []];

                if (count _persistentVariableArray > 0) then {
                    {
                        _x params ["_variableName", "_variableValue"];

                        _unit setVariable [_variableName, _variableValue, true];
                    } forEach _persistentVariableArray;
                };

                private _persistentFunctionArray = _originalUnit getVariable ["ACM_PersistentFunctions", []];

                if (count _persistentFunctionArray > 0) then {
                    {
                        _x params ["_functionName", ["_functionArguments", []]];

                        _functionArguments call _functionName;
                    } forEach _persistentFunctionArray;
                };

                if !(isNull (getAssignedCuratorLogic _originalUnit)) then {
                    [QGVAR(createCurator), _unit] call CBA_fnc_serverEvent;
                };

                ["ACM_casualtyEvacuated", [_unit, _originalUnit], _unit] call CBA_fnc_targetEvent;
            }, [_unit, _originalUnit], 1] call CBA_fnc_waitAndExecute;
        }, [_unit, _originalUnit], 1] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addEventHandler;
}] call CBA_fnc_addEventHandler;