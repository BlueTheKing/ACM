#include "script_component.hpp"

[QGVAR(handleCardiacArrest), LINKFUNC(handleCardiacArrest)] call CBA_fnc_addEventHandler;
[QGVAR(handleReversibleCardiacArrest), LINKFUNC(handleReversibleCardiacArrest)] call CBA_fnc_addEventHandler;

[QGVAR(handleCPR), LINKFUNC(handleCPR)] call CBA_fnc_addEventHandler;

[QGVAR(setIVLocal), LINKFUNC(setIVLocal)] call CBA_fnc_addEventHandler;
[QGVAR(setAEDLocal), LINKFUNC(setAEDLocal)] call CBA_fnc_addEventHandler;

[QGVAR(handleMed_AmmoniumCarbonateLocal), LINKFUNC(handleMed_AmmoniumCarbonateLocal)] call CBA_fnc_addEventHandler;
[QGVAR(handleMed_NaloxoneLocal), LINKFUNC(handleMed_NaloxoneLocal)] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,medicationLocal), {
	params ["_patient", "_bodyPart", "_classname"];

	// Handle special medication effects
	if (_classname in ["AmmoniumCarbonate", "Naloxone"]) then {
    	[(format ["AMS_circulation_handleMed_%1Local", toLower _classname]), [_patient, _bodyPart], _patient] call CBA_fnc_targetEvent;
	};
}] call CBA_fnc_addEventHandler;