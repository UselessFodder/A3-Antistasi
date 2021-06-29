/*
Author: Wurzel0701
    Sorts all explosives into the allExplosiveShop array from worst to best

Arguments:
    <NIL>

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <ARRAY> lootExplosive

Example:
    [] call A3A_fnc_sortExplosives;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _list = [];

{
    private _magConfig = configFile >> "CfgMagazines" >> _x;
    private _mass = getNumber (_magConfig >> "mass");

    //Get the used ammo and the related config
    private _weaponAmmo = getText (_magConfig >> "ammo");
    private _ammoConfig = configFile >> "CfgAmmo" >> _weaponAmmo;

    //Get the needed variables for calculation
    private _hit = getNumber (_ammoConfig >> "hit");
    private _range = getNumber (_ammoConfig >> "indirectHitRange");

    private _score = (_hit / 1000) + (_range / 5) + ((40 - _mass) max 0)/20;
    _score = _score / 3;

    missionNamespace setVariable [format ["%1_data", _x], [_score, 3, 0, 0, 0]];
    _list pushBack [_score, _x];
} forEach lootExplosive;

_list sort true;
allExplosiveShop = [];
{
    allExplosiveShop pushBack (_x select 1);
} forEach _list;

[allExplosiveShop apply {getText (configFile >> "CfgMagazines" >> _x >> "displayName")}, "Explosives"] call A3A_fnc_logArray;
