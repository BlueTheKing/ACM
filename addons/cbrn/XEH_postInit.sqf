#include "script_component.hpp"

[QGVAR(initHazardZone), LINKFUNC(initHazardZone)] call CBA_fnc_addEventHandler;
[QGVAR(initHazardUnit), LINKFUNC(initHazardUnit)] call CBA_fnc_addEventHandler;

if (true) then { // TODO setting
    GVAR(HazardType_List) = createHashMap;

    private _hazardCategoryArray = "true" configClasses (configFile >> "ACM_CBRN_Hazards");

    {
        private _hazardTypeArray = [];
        
        {
            _hazardTypeArray pushBack (configName _x);
        } forEach ("true" configClasses _x);

        GVAR(HazardType_List) set [configName _x, _hazardTypeArray];
    } forEach _hazardCategoryArray;
};