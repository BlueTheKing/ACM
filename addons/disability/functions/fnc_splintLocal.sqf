#include "..\script_component.hpp"
/*
 * Author: PabstMirror
 * Local callback for applying a splint to a patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Action Classname <STRING>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player, cursorObject, "LeftLeg"] call ace_medical_treatment_fnc_splintLocal; // ACM_disability_fnc_splintLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname"];
TRACE_3("splintLocal",_medic,_patient,_bodyPart);

private _partIndex = ALL_BODY_PARTS find toLower _bodyPart;

private _fractures = GET_FRACTURES(_patient);
_fractures set [_partIndex, -1];
_patient setVariable [VAR_FRACTURES, _fractures, true];

if (_classname isEqualTo "ApplySAMSplint" && ACEGVAR(medical,fractures) > 1) then {
    private _splints = GET_SPLINTS(_patient);
    _splints set [_partIndex, 1];
    _patient setVariable [VAR_SPLINTS, _splints, true];

    // Splint falls off after a while
    private _fallOffTime = EGVAR(core,splintFallOffTime);
    [{
        params ["_patient", "_bodyPart"];

        GET_SPLINTS(_patient) select (ALL_BODY_PARTS find toLower _bodyPart) != 1;
    }, {}, [_patient, _bodyPart], (random [_fallOffTime, (_fallOffTime + 30), (_fallOffTime + 60)]), {
        params ["_patient", "_bodyPart"];
        
        [QGVAR(removeSplintLocal), [objNull, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;
        [QACEGVAR(common,displayTextStructured), ["Splint has fallen off", 1.5, _medic], _medic] call CBA_fnc_targetEvent;
    }] call CBA_fnc_waitUntilAndExecute;
};

// Check if we fixed limping from this treatment
[_patient] call ACEFUNC(medical_engine,updateDamageEffects);