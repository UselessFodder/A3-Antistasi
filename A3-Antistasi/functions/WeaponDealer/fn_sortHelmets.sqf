/*
Author: Wurzel0701
    Sorts all helmets into the allHelmetsShop array from worst to best

Arguments:
    <NIL>

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <ARRAY> lootHelmet

Example:
    [] call A3A_fnc_sortMagazines;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _list = [];

{
    private _info = configFile >> "CfgWeapons" >> _x >> "ItemInfo";

    private _mass = getNumber (_info >> "mass");
    private _armor = getNumber (_info >> "HitpointsProtectionInfo" >> "Head");

    private _score = (_mass / 20) + (_armor / 4);
    _score = _score / 2;

    missionNamespace setVariable [format ["%1_data", _x], [_score, 11, 0, 0, 0]];
    _list pushBack [_score, _x];
} forEach lootHelmet;

_list sort true;
allHelmetsShop = [];
{
    allHelmetsShop pushBack (_x select 1);
} forEach _list;

[allHelmetsShop apply {getText (configFile >> "CfgWeapons" >> _x >> "displayName")}, "Helmets"] call A3A_fnc_logArray;
