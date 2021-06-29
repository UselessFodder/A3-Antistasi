/*
Author: Wurzel0701
    Sorts all backpacks into the lootBackpack array from worst to best

Arguments:
    <NIL>

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <ARRAY> allCivilianVests
    <ARRAY> allArmoredVests

Example:
    [] call A3A_fnc_sortBackpacks;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _list = [];

{
    private _config = configFile >> "CfgVehicles" >> _x;

    private _mass = getNumber (_config >> "mass");
    private _cargo = getNumber (_config >> "maximumLoad");

    //Debug_3("Backpack %1 has %2 mass, %3 cargo", _x, _mass, _cargo);

    private _score = (_mass / 40) + (_cargo / 160);
    _score = _score / 2;

    //Debug_2("Backpack %1 end score is %2", _x, _score);
    missionNamespace setVariable [format ["%1_data", _x], [_score, 7, 0, 0, 0]];
    _list pushBack [_score, _x];
} forEach allBackpacksEmpty;

_list sort true;

{
    lootBackpack pushBack (_x select 1);
} forEach _list;

Info_1("Backpack sorted to %1", lootBackpack apply {getText (configFile >> "CfgVehicles" >> _x >> "displayName")});
