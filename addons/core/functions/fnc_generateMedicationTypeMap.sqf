#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate hashmap for medication types
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_core_fnc_generateMedicationTypeMap;
 *
 * Public: No
 */

private _medications = "true" configClasses (configFile >> "ACM_Medication" >> "Medications");
private _medicationTypes = "true" configClasses (configFile >> "ACM_Medication" >> "MedicationType");

private _uniqueMedicationList = [];

private _medicationTypeArray = [];

{
    private _config = _x;

    if (configName _x in ["ACM_PO_Medication","ACM_Inhalant_Medication","ACM_IM_Medication","ACM_IV_Medication"]) then {continue;};
    if (getNumber (_config >> "painReduce") <= 0) then {continue;};

    if (getText (_config >> "medicationType") == "Default") then {
        if (configName _config in _uniqueMedicationList) then {
            continue;
        } else {
            _uniqueMedicationList pushBack (configName _config);
            _medicationTypeArray pushBack [configName _config, [[configName _config], 0, (getNumber (_config >> "maxPainReduce"))]];
        };
    } else {
        private _index = _medicationTypes findIf {configName _x == getText (_config >> "medicationType")};
        private _typeConfig = _medicationTypes select _index;

        if (configName _typeConfig in _uniqueMedicationList) then {
            continue;
        } else {
            _uniqueMedicationList pushBack (configName _typeConfig);
            _medicationTypeArray pushBack [configName _typeConfig, [getArray (_typeConfig >> "classnames"), 0, (getNumber (_config >> "maxPainReduce"))]];
        };
    };
} forEach _medications;

GVAR(MedicationTypes) = createHashMapFromArray _medicationTypeArray;