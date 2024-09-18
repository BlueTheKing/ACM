#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Calculates the blood volume change and decreases the IVs given to the unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Time since last update <NUMBER>
 * 2: Global Sync Values (fluid bags) <BOOL>
 *
 * Return Value:
 * Blood volume <NUMBER>
 *
 * Example:
 * [player, 1, true] call ace_medical_status_fnc_getBloodVolumeChange
 *
 * Public: No
 */

params ["_unit", "_deltaT", "_syncValues"];

private _bloodVolume = _unit getVariable [QEGVAR(circulation,Blood_Volume), 6];
private _plasmaVolume = _unit getVariable [QEGVAR(circulation,Plasma_Volume), 0];
private _salineVolume = _unit getVariable [QEGVAR(circulation,Saline_Volume), 0];

private _plateletCount = _unit getVariable [QEGVAR(circulation,Platelet_Count), 3];
private _plateletCountChange = 0;

private _bloodVolumeChange = 0;
private _plasmaVolumeChange = 0;
private _salineVolumeChange = 0;

private _activeVolumes = 0;

private _bloodLoss = -_deltaT * GET_BLOOD_LOSS(_unit);
private _internalBleeding = -_deltaT * GET_INTERNAL_BLEEDRATE(_unit);

private _TXAEffect = ([_unit, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount));

private _internalBleedingSeverity = 0;

if (GET_INTERNAL_BLEEDING(_unit) > 0.3 || (_plateletCount < 0.1 && _TXAEffect < 0.1)) then {
    _internalBleedingSeverity = 1;
};

private _HTXState = _unit getVariable [QEGVAR(breathing,Hemothorax_State), 0];
private _hemothoraxBleeding = 0;

if (_HTXState > 0) then {
    _hemothoraxBleeding = -_deltaT * GET_HEMOTHORAX_BLEEDRATE(_unit);
    private _thoraxBlood = _unit getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0];
    _thoraxBlood = _thoraxBlood - _hemothoraxBleeding;
    _unit setVariable [QEGVAR(breathing,Hemothorax_Fluid), (_thoraxBlood min 1.5), _syncValues];
};

if (_bloodVolume > 0) then {
    _activeVolumes = _activeVolumes + 1;
};

if (_plasmaVolume > 0) then {
    _activeVolumes = _activeVolumes + 1;
};

if (_salineVolume > 0) then {
    _activeVolumes = _activeVolumes + 1;
};

if (_bloodVolume > 0) then {
    _bloodVolumeChange = (_bloodLoss + _internalBleeding * _internalBleedingSeverity + _hemothoraxBleeding) / _activeVolumes;
};

if (_plasmaVolume > 0) then {
    _plasmaVolumeChange = (_bloodLoss + _internalBleeding * _internalBleedingSeverity + _hemothoraxBleeding) / _activeVolumes;
};

if (_salineVolume > 0) then {
    _salineVolumeChange = (_bloodLoss + _internalBleeding * _internalBleedingSeverity + _hemothoraxBleeding) / _activeVolumes;
};

if (_plateletCount > 0.1) then {
    _plateletCountChange = (_internalBleeding * 0.5) + (_bloodLoss * 0.5) + (_hemothoraxBleeding * 0.5);
    if (_TXAEffect > 0.1) then {
        _plateletCountChange = _plateletCountChange / 2;
    };
};

private _transfusionPain = 0;

if (_unit getVariable [QEGVAR(circulation,IV_Bags_Active), false]) then {
    private _IVFlowMultiplier = 1;
    private _IOFlowMultiplier = 1;

    private _activeBagTypesIV = _unit getVariable [QEGVAR(circulation,ActiveFluidBags_IV), ACM_IV_PLACEMENT_DEFAULT_1];
    private _activeBagTypesIO = _unit getVariable [QEGVAR(circulation,ActiveFluidBags_IO), ACM_IO_PLACEMENT_DEFAULT_1];

    if (IN_CRDC_ARRST(_unit)) then {
        _IVFlowMultiplier = EGVAR(circulation,cardiacArrestBleedRate);
        _IOFlowMultiplier = 0.9;
        if (alive (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull])) then {
            _IVFlowMultiplier = 0.9;
            _IOFlowMultiplier = 1;
        };
    };

    private _fluidBags = _unit getVariable [QEGVAR(circulation,IV_Bags), createHashMap];

    private _updateCountBodyPartArray = [];

    {
        private _targetBodyPart = _x;
        private _partIndex = GET_BODYPART_INDEX(_targetBodyPart);

        private _fluidBagsBodyPart = _y;

        _fluidBagsBodyPart = _fluidBagsBodyPart apply {
            _x params ["_type", "_bagVolumeRemaining", "_accessType", "_accessSite", "_iv", ["_bloodType", -1], "_originalVolume"];

            if ((!(HAS_TOURNIQUET_APPLIED_ON(_unit,_partIndex)) || (!_iv && (_partIndex in [2,3]))) && (([(GET_IO_FLOW_X(_unit,_partIndex)),(GET_IV_FLOW_X(_unit,_partIndex,_accessSite))] select _iv) > 0)) then {
                private _fluidFlowRate = 1;
                private _fluidPassRatio = 1;
    
                switch (_type) do {
                    case "Blood": {
                        _fluidFlowRate = 0.8;
                    };
                    case "Saline": {
                        _fluidFlowRate = 1.2;
                    };
                    default {};
                };
    
                private _activeBagTypesBodyPart = [(_activeBagTypesIO select _partIndex),((_activeBagTypesIV select _partIndex) select _accessSite)] select _iv;
                private _bagChange = ((_deltaT * ACEGVAR(medical,ivFlowRate) * ([_unit, _partIndex, _iv, _accessSite] call EFUNC(circulation,getIVFlowRate))) * ([_IOFlowMultiplier, _IVFlowMultiplier] select _iv) * _fluidFlowRate) min _bagVolumeRemaining; // absolute value of the change in miliLiters
                
                if (_iv && EGVAR(circulation,IVComplications)) then {
                    _bagChange = [(_bagChange), (_bagChange * 0.9), (_bagChange * 0.85)] select (GET_IV_COMPLICATIONS_FLOW_X(_unit,_partIndex,_accessSite));
                    _fluidPassRatio = [1,1,0.8] select (GET_IV_COMPLICATIONS_FLOW_X(_unit,_partIndex,_accessSite));
                };
                
                if (_bagVolumeRemaining > 1) then {
                    _bagChange = _bagChange / _activeBagTypesBodyPart;
                };
    
                _bagVolumeRemaining = _bagVolumeRemaining - _bagChange;
    
                switch (_type) do {
                    case "Plasma": {
                        _plasmaVolumeChange = _plasmaVolumeChange + (_bagChange / 1000);
                        _plasmaVolumeChange = _plasmaVolumeChange * _fluidPassRatio;
                        _plateletCountChange = _plateletCountChange + (_bagChange / 1000);
                        _plateletCountChange = _plateletCountChange * _fluidPassRatio;
                    };
                    case "Saline": {
                        _salineVolumeChange = _salineVolumeChange + (_bagChange / 1000);
                        _salineVolumeChange = _salineVolumeChange * _fluidPassRatio;
                    };
                    default {
                        if ([GET_BLOODTYPE(_unit), _bloodType] call EFUNC(circulation,isBloodTypeCompatible)) then {
                            _bloodVolumeChange = _bloodVolumeChange + (_bagChange / 1000);
                            _bloodVolumeChange = _bloodVolumeChange * _fluidPassRatio;
                            _plateletCountChange = _plateletCountChange + (_bagChange / 500);
                            _plateletCountChange = _plateletCountChange * _fluidPassRatio;
                        } else {
                            _bloodVolumeChange = _bloodVolumeChange - (_bagChange / 1000);
                            _bloodVolumeChange = _bloodVolumeChange * _fluidPassRatio;
                            _plateletCountChange = _plateletCountChange - (_bagChange / 4000);
                            _plateletCountChange = _plateletCountChange * _fluidPassRatio;
    
                            _plasmaVolumeChange = _plasmaVolumeChange + (_bagChange / 4000);
                            _plasmaVolumeChange = _plasmaVolumeChange * _fluidPassRatio;
                            _salineVolumeChange = _salineVolumeChange + (_bagChange / 1333.4);
                            _plasmaVolumeChange = _plasmaVolumeChange * _fluidPassRatio;
                        };
                    };
                };
                // Flow pain
                if (_accessType in [ACM_IO_FAST1_M, ACM_IO_EZ_M]) then { // IO
                    private _IOPain = _bagChange / 3.7;
                    _transfusionPain = _transfusionPain + _IOPain;
                } else { // IV complication
                    private _ivComplicationPain = GET_IV_COMPLICATIONS_PAIN_X(_unit,_partIndex,_accessSite);

                    if (_ivComplicationPain > 0) then {
                        private _flowPain = (_bagChange / 1000) * _ivComplicationPain;
                        _transfusionPain = _transfusionPain + _flowPain;
                    };
                };
            };
    
            if (_bagVolumeRemaining < 0.01) then {
                _updateCountBodyPartArray pushBack _targetBodyPart;
                []
            } else {
                [_type, _bagVolumeRemaining, _accessType, _accessSite, _iv, _bloodType, _originalVolume]
            };
        };
        _fluidBags set [_targetBodyPart, _fluidBagsBodyPart];
    } forEach _fluidBags;

    if (count _updateCountBodyPartArray > 0) then {
        _updateCountBodyPartArray arrayIntersect _updateCountBodyPartArray;
        {
            private _targetBodyPart = _x;
            private _targetFluidBagsBodyPart = _fluidBags getOrDefault [_targetBodyPart, []];

            { // remove empty bag
                if ((count _x) < 1) then {
                    _targetFluidBagsBodyPart deleteAt _forEachIndex;
                };
            } forEachReversed _targetFluidBagsBodyPart;

            if (count _targetFluidBagsBodyPart < 1) then {
                _fluidBags deleteAt _targetBodyPart;
            };
        } forEach _updateCountBodyPartArray;

        if (count _fluidBags > 0) then {
            {
                [_unit, _x] call EFUNC(circulation,updateActiveFluidBags);
            } forEach _updateCountBodyPartArray;
        };
    };

    if (count _fluidBags < 1) then {
        _unit setVariable [QEGVAR(circulation,IV_Bags), nil, true]; // no bags left - clear variable (always globally sync this)
        _unit setVariable [QEGVAR(circulation,IV_Bags_Active), false, true];
        [_unit, ""] call EFUNC(circulation,updateActiveFluidBags);
    } else {
        _unit setVariable [QEGVAR(circulation,IV_Bags), _fluidBags, _syncValues];
    };
};

if (_transfusionPain > 0) then {
    [_unit, (_transfusionPain min 0.8)] call ACEFUNC(medical_status,adjustPainLevel);
};

if (_bloodVolume < 6) then {
    if (_plasmaVolume + _plasmaVolumeChange > 0) then {
        private _leftToConvert = _plasmaVolume + _plasmaVolumeChange;
        private _conversionRate = (-_deltaT * (4 / 1000)) min _leftToConvert;
    
        _plasmaVolumeChange = _plasmaVolumeChange + _conversionRate;
        _bloodVolumeChange = _bloodVolumeChange - _conversionRate;
    };
    
    if (_salineVolume + _salineVolumeChange > 0) then {
        private _leftToConvert = _salineVolume + _salineVolumeChange;
        private _conversionRate = (-_deltaT * (1 / 1000)) min _leftToConvert;
        
        _salineVolumeChange = _salineVolumeChange + _conversionRate;
        _bloodVolumeChange = _bloodVolumeChange - _conversionRate;
    };
};

private _fluidOverload = 0; //_unit setVariable [QEGVAR(circulation,Overload_Volume), 0, _syncValues];
private _spaceRemaining = DEFAULT_BLOOD_VOLUME;
private _plasmaSpaceRemaining = DEFAULT_BLOOD_VOLUME;
private _salineSpaceRemaining = DEFAULT_BLOOD_VOLUME;

_bloodVolume = 0 max _bloodVolume + _bloodVolumeChange min DEFAULT_BLOOD_VOLUME;
_plasmaSpaceRemaining = _plasmaSpaceRemaining - _bloodVolume;
_salineSpaceRemaining = _salineSpaceRemaining - _bloodVolume;

_plasmaVolume = 0 max _plasmaVolume + _plasmaVolumeChange min DEFAULT_BLOOD_VOLUME;
_fluidOverload = ((_plasmaVolume + _plasmaVolumeChange) - _plasmaSpaceRemaining);

_plasmaVolume = 0 max (_plasmaVolume min _plasmaSpaceRemaining);
_salineSpaceRemaining = _salineSpaceRemaining - _plasmaVolume;

_salineVolume = 0 max _salineVolume + _salineVolumeChange min DEFAULT_BLOOD_VOLUME;
_fluidOverload = ((_salineVolume + _salineVolumeChange) - _salineSpaceRemaining);

_salineVolume = 0 max (_salineVolume min _salineSpaceRemaining);

_fluidOverload = _fluidOverload max 0;
//_unit setVariable [QEGVAR(circulation,Overload_Volume), _fluidOverload, _syncValues];

if (_plateletCount != 3) then {
    private _adjustSpeed = 1000 * linearConversion [3, 6, _bloodVolume, 10, 1, true]; 
    if (_TXAEffect > 0.1) then {
        _adjustSpeed / 2;
    };
    if (!(IS_BLEEDING(_unit)) && !(IS_I_BLEEDING(_unit)) && _HTXState < 1 && _plateletCount > 3) then {
        _adjustSpeed = 100;
    };
    _plateletCountChange = _plateletCountChange + ((3 - _plateletCount) / _adjustSpeed);
};

_plateletCount = 0 max (_plateletCount + _plateletCountChange) min DEFAULT_BLOOD_VOLUME;

_unit setVariable [QEGVAR(circulation,Blood_Volume), _bloodVolume, _syncValues];
_unit setVariable [QEGVAR(circulation,Plasma_Volume), _plasmaVolume, _syncValues];
_unit setVariable [QEGVAR(circulation,Saline_Volume), _salineVolume, _syncValues];

_unit setVariable [QEGVAR(circulation,Platelet_Count), _plateletCount, _syncValues];

_bloodVolume + _plasmaVolume + _salineVolume min DEFAULT_BLOOD_VOLUME; 