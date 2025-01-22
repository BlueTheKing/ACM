#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate hashmap for medication types
 *
 * Arguments:
 * 0: Maximum Value Name <STRING>
 * 1: Adjustment Value Name <STRING>
 *
 * Return Value:
 * Medication Types Hashmap <HASHMAP>
 *
 * Example:
 * ["maxPainReduce", "painReduce"] call ACM_core_fnc_generateMedicationTypeMap;
 *
 * Public: No
 */

params ["_maxValueEntry", "_valueEntry"];

private _medications = "true" configClasses (configFile >> "ACM_Medication" >> "Medications");
private _medicationTypes = "true" configClasses (configFile >> "ACM_Medication" >> "MedicationType");

private _uniqueMedicationList = [];
private _medicationTypeArray = [];

{
    private _config = _x;

    if (configName _x in ["ACM_PO_Medication","ACM_Inhalant_Medication","ACM_IM_Medication","ACM_IV_Medication"]) then {continue;};
    if (isNumber (_config >> _valueEntry)) then {
        if (getNumber (_config >> _valueEntry) <= 0) then {continue;};
    } else {
        if (isArray (_config >> _valueEntry)) then {
            if (getArray (_config >> _valueEntry) isEqualTo [0,0]) then {continue;};
        };
    };

    if !(isNumber (_config >> _maxValueEntry)) then {continue;};

    if (getText (_config >> "medicationType") == "Default") then {
        if (configName _config in _uniqueMedicationList) then {
            continue;
        } else {
            _uniqueMedicationList pushBack (configName _config);
            _medicationTypeArray pushBack [configName _config, [0, (getNumber (_config >> _maxValueEntry))]];
        };
    } else {
        private _index = _medicationTypes findIf {configName _x == getText (_config >> "medicationType")};
        private _typeConfig = _medicationTypes select _index;

        if (configName _typeConfig in _uniqueMedicationList) then {
            continue;
        } else {
            _uniqueMedicationList pushBack (configName _typeConfig);
            _medicationTypeArray pushBack [configName _typeConfig, [0, (getNumber (_config >> _maxValueEntry))]];
        };
    };
} forEach _medications;

createHashMapFromArray _medicationTypeArray;