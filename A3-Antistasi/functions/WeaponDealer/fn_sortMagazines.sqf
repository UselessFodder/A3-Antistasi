/*
Author: Wurzel0701
    Sorts all magazines into the allAmmunitionShop array from worst to best

Arguments:
    <NIL>

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <ARRAY> allMagShotgun
    <ARRAY> allMagBullet
    <ARRAY> allMagRocket
    <ARRAY> allMagMissile
    <ARRAY> allAmmunitionShop

Example:
    [] call A3A_fnc_sortMagazines;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _list = [];

{
    private _magConfig = configFile >> "CfgMagazines" >> _x;
    private _ammoCount = getNumber (_magConfig >> "count");

    //Get the used ammo and the related config
    private _weaponAmmo = getText (_magConfig >> "ammo");
    private _ammoConfig = configFile >> "CfgAmmo" >> _weaponAmmo;

    //Get the needed variables for calculation
    private _caliber = getNumber (_ammoConfig >> "caliber");
    private _hit = getNumber (_ammoConfig >> "hit");

    private _damage = _caliber * _hit;
    private _ammoOffset = abs (_ammoCount - 30);
    private _offsetPercentage = 1 + (_ammoOffset / 20);

    private _score = 2 * (_damage / 10) + _offsetPercentage;
    _score = _score / 3;

    _list pushBack [_score, _x];
} forEach allMagBullet + allMagShotgun;

{
    private _mass = getNumber (configFile >> "CfgMagazines" >> _x >> "mass");

    //Get the used ammo and the related config
    private _weaponAmmo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
    private _ammoConfig = configFile >> "CfgAmmo" >> _weaponAmmo;

    //Get the needed variables for calculation
    private _caliber = getNumber (_ammoConfig >> "caliber");
    private _hit = getNumber (_ammoConfig >> "hit");

    private _damage = _caliber * _hit;
    private _score = (_damage / 100) + (_mass /50);

    _list pushBack [_score, _x];
} forEach allMagRocket;

{
    private _mass = getNumber (configFile >> "CfgMagazines" >> _x >> "mass");

    //Get the used ammo and the related config
    private _weaponAmmo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
    private _ammoConfig = configFile >> "CfgAmmo" >> _weaponAmmo;

    //Get the needed variables for calculation
    private _caliber = getNumber (_ammoConfig >> "caliber");
    private _hit = getNumber (_ammoConfig >> "hit");

    private _damage = _caliber * _hit;
    private _score = ((_damage / 100) + (_mass /50)) * 2;

    _list pushBack [_score, _x];
} forEach allMagMissile;

_list sort true;
allAmmunitionShop = [];
{
    missionNamespace setVariable [format ["%1_data", (_x select 1)], [(_x select 0), 4, 0, 0, 0]];
    allAmmunitionShop pushBack (_x select 1);
} forEach _list;

[allAmmunitionShop apply {getText (configFile >> "CfgMagazines" >> _x >> "displayName")}, "Ammo"] call A3A_fnc_logArray;
