/*
Author: Wurzel0701
    Sorts a given array from worst to best weapon

Arguments:
    <STRING> The name of the array which needs to be sorted
    <STRING> The type of weapon this array contains

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <ARRAY> allCivilianVests
    <ARRAY> allArmoredVests

Example:
    [] call A3A_fnc_sortVests;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params
[
    ["_weaponsArrayName", "", [""]],
    ["_weaponsType", "", [""]]
];

private _weaponIndex = 1;
private _weaponsData = [];

{
    private _weaponName = _x;
    //diag_log format ["Checking weapon %1 now", _x];
    //Get the weapon config file
    private _weaponConfig = configFile >> "CfgWeapons" >> _weaponName;

    //Get the needed variables for calculation
    private _timeBetweenShots = getNumber (_weaponConfig >> "reloadTime");
    private _initSpeed = getNumber (_weaponConfig >> "initSpeed");
    private _dispersion = getNumber (_weaponConfig >> "dispersion");
    private _dispersionX = getNumber (_weaponConfig >> "aiDispersionCoefX");
    private _dispersionY = getNumber (_weaponConfig >> "aiDispersionCoefY");
    private _maxRange = getNumber (_weaponConfig >> "maxZeroing");
    private _weight = getNumber (_weaponConfig >> "WeaponSlotsInfo" >> "mass");
    private _muzzles = getArray (_weaponConfig >> "muzzles");

    //Get the used magazine and the related config
    private _weaponMag = (getArray (_weaponConfig >> "magazines")) select 0;
    //Filtering out weapons without mags, cause these most likely are not wanted anyways
    if !(isNil "_weaponMag") then
    {
        private _magConfig = configFile >> "CfgMagazines" >> _weaponMag;

        //diag_log format ["Mag is %1, config found %2", _weaponMag, !(isNil "_magConfig")];


        //Get the needed variables for calculation
        private _initSpeedMag = getNumber (_magConfig >> "initSpeed");
        private _ammoCount = getNumber (_magConfig >> "count");

        //Get the used ammo and the related config
        private _weaponAmmo = getText (_magConfig >> "ammo");
        private _ammoConfig = configFile >> "CfgAmmo" >> _weaponAmmo;

        //Get the needed variables for calculation
        private _caliber = getNumber (_ammoConfig >> "caliber");
        private _hit = getNumber (_ammoConfig >> "hit");

        private _isLockOn = (_ammoConfig >> "weaponLockSystem") call BIS_fnc_getCfgData;
        _isLockOn = _isLockOn isEqualType "" || {_isLockOn != 0};

        //Calculating damage per minute score
        private _DPM = _caliber * _hit * (_ammoCount / (_timeBetweenShots * _ammoCount + 2));
        if("EGLM" in _muzzles) then
        {
            _DPM = _DPM + 15;
        };
        if("GL_3GL_F" in _muzzles) then
        {
            _DPM = _DPM + 50;
        };
        if(_isLockOn) then
        {
            _DPM = _DPM * 2;
        };
        if(_DPM != 0) then
        {
            _DPM = _DPM / 25;
        };

        //Get the initial velocity (thanks for that one arma)
        if(isNil "_initSpeedMag") then {_initSpeedMag = 1;};
        if(_initSpeed < 0) then
        {
            _initSpeed = _initSpeedMag * (-1) * _initSpeed;
        };
        if(_initSpeed == 0) then
        {
            _initSpeed = _initSpeedMag;
        };
        private _initSpeedRating = _initSpeed / 900;

        _dispersion = _dispersion * ((_dispersionX + _dispersionY)/2);
        //Get score by comparision with norminal value
        if(_dispersion != 0) then
        {
            _dispersion = ((0.000009 - (_dispersion * _dispersion)) max 0) / 0.00000225;
        };
        if(_isLockOn) then
        {
            _dispersion = 5;
        };

        //Get score by comparision with norminal value
        if(_maxRange != 0) then
        {
            _maxRange = _maxRange / 800;
        };

        //Get score in comparison to Katiba standard weight
        private _weightRating = ((200 - _weight) max 0) / 100;

        //[3, format ["Weapon data: %1", [_weaponName, _DPM, _initSpeedRating, _dispersion, _maxRange, _weightRating]], "HakonStuffDontWorkHere"] call A3A_fnc_log;
        _weaponsData pushBack [_weaponName, _DPM, _initSpeedRating, _dispersion, _maxRange, _weightRating];
    }
    else
    {
        diag_log format ["Weapon %1 has been filtered out as it has no magazine", _weaponName];
    };
} forEach (missionNamespace getVariable _weaponsArrayName);

private _fnc_calculateWeaponScore =
{
    params ["_weaponsArray", "_DPMFactor", "_velocityFactor", "_dispersionFactor", "_rangeFactor", "_weightFactor"];

    private _score = (_weaponsArray select 1) * _DPMFactor +
                     (_weaponsArray select 2) * _velocityFactor +
                     (_weaponsArray select 3) * _dispersionFactor +
                     (_weaponsArray select 4) * _rangeFactor +
                     (_weaponsArray select 5) * _weightFactor;
    _score = _score / (_DPMFactor + _velocityFactor + _dispersionFactor + _rangeFactor + _weightFactor);
    //Info_2("%1 score is %2", _weaponsArray#0, _score);
    [_score, _weaponsArray select 0];
};

private _weaponsScore = [];
["Rifles", "Handguns", "MachineGuns", "MissileLaunchers", "Mortars", "RocketLaunchers", "Shotguns", "SMGs", "SniperRifles"];
switch (_weaponsType) do
{
    case ("Rifles"):
    {
        _weaponsScore = _weaponsData apply {[_x, 2, 1, 1, 1, 0.5] call _fnc_calculateWeaponScore;};
    };
    case ("Handguns"):
    {
        _weaponIndex = 0;
        _weaponsScore = _weaponsData apply {[_x, 3, 0.5, 0.5, 1, 0.5] call _fnc_calculateWeaponScore;};
    };
    case ("MachineGuns"):
    {
        _weaponsScore = _weaponsData apply {[_x, 6, 3, 0.5, 2, 0.5] call _fnc_calculateWeaponScore;};
    };
    case ("MissileLaunchers"):
    {
        _weaponIndex = 2;
        _weaponsScore = _weaponsData apply {[_x, 5, 0, 0.5, 2, 0.5] call _fnc_calculateWeaponScore;};
    };
    //This case does not seems to be used in vanilla
    case ("Mortars"):
    {
        _weaponsScore = _weaponsData apply {[_x, 1, 1, 1, 1, 1] call _fnc_calculateWeaponScore;};
    };
    case ("RocketLaunchers"):
    {
        _weaponIndex = 2;
        _weaponsScore = _weaponsData apply {[_x, 3, 1, 2, 0.5, 3] call _fnc_calculateWeaponScore;};
    };
    case ("Shotguns"):
    {
        _weaponsScore = _weaponsData apply {[_x, 1, 1, 1, 0.5, 1] call _fnc_calculateWeaponScore;};
    };
    case ("SMGs"):
    {
        _weaponsScore = _weaponsData apply {[_x, 3, 5, 1, 0.5, 3] call _fnc_calculateWeaponScore;};
    };
    case ("SniperRifles"):
    {
        _weaponsScore = _weaponsData apply {[_x, 3, 1, 3, 5, 2] call _fnc_calculateWeaponScore;};
    };
};

//Sort weapons and rewrite the array
_weaponsScore sort true;
private _sortedArray = [];
{
    _sortedArray pushBack (_x select 1);
    missionNamespace setVariable [format ["%1_data", _x select 1], [_x select 0, _weaponIndex, 0, 0, 0]];
} forEach _weaponsScore;

Info_2("Sorted %1 weapons of type %2", count _weaponsScore, _weaponsType);
missionNamespace setVariable [_weaponsArrayName, _sortedArray];
