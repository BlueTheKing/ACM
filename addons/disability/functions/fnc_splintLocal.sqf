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
 * [player, cursorObject, "LeftLeg", "ApplySAMSplint"] call ace_medical_treatment_fnc_splintLocal; // ACM_disability_fnc_splintLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname"];
TRACE_3("splintLocal",_medic,_patient,_bodyPart);

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

private _fractureArray = _patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]];

private _preparedArray = _patient getVariable [QGVAR(Fracture_Prepared), [false,false,false,false,false,false]];

if ((_preparedArray select _partIndex) && ((_fractureArray select _partIndex) < ACM_FRACTURE_COMPLEX) || !(GVAR(enableFractureSeverity))) then {
    private _fractures = GET_FRACTURES(_patient);
    _fractures set [_partIndex, -1];
    _patient setVariable [VAR_FRACTURES, _fractures, true];
};

if (_classname isEqualTo "ApplySAMSplint" && ACEGVAR(medical,fractures) > 1) then {
    private _splints = GET_SPLINTS(_patient);
    _splints set [_partIndex, 1];
    _patient setVariable [VAR_SPLINTS, _splints, true];

    // Splint falls off after a while
    private _fallOffTime = GVAR(splintFallOffTime);
    [{
        params ["_patient", "", "_partIndex"];

        (GET_SPLINTS(_patient) select _partIndex != 1) || !(alive _patient);
    }, {}, [_patient, _bodyPart, _partIndex], (random [_fallOffTime, (_fallOffTime + 30), (_fallOffTime + 60)]), {
        params ["_patient", "_bodyPart"];

        if ((GET_SPLINTS(_patient) select GET_BODYPART_INDEX(_bodyPart)) == 1 && alive _patient) then {
            [QGVAR(removeSplintLocal), [objNull, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;
            [LLSTRING(Splint_FellOff), 1.5, _patient] call ACEFUNC(common,displayTextStructured);
        };
    }] call CBA_fnc_waitUntilAndExecute;
};

// Check if we fixed limping from this treatment
[_patient] call ACEFUNC(medical_engine,updateDamageEffects);