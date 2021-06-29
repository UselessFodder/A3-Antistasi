/*
Author: Wurzel0701
    Sorts all vest into the lootVest array from worst to best

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
    [] call A3A_fnc_sortVests;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _list = [];

{
    private _config = configFile >> "CfgWeapons" >> _x >> "ItemInfo";

    private _mass = getNumber (_config >> "mass");
    private _container = getText (_config >> "containerClass");
    private _cargo = getNumber (configFile >> "CfgVehicles" >> _container >> "maximumLoad");

    private _armorClass = "true" configClasses (_config >> "HitpointsProtectionInfo");
    private _maxArmor = 0;
    {
        private _armor = getNumber (_x >> "armor");
        if(_armor > _maxArmor) then {_maxArmor = _armor;};
    } forEach _armorClass;

    //Debug_4("Vest %1 has %2 mass, %3 armor and %4 cargo", _x, _mass, _maxArmor, _cargo);

    private _score = (_mass / 40) + (_maxArmor / 8) + (_cargo / 100);
    _score = _score / 3;

    //Debug_2("Vest %1 end score is %2", _x, _score);
    missionNamespace setVariable [format ["%1_data", _x], [_score, 6, 0, 0, 0]];
    _list pushBack [_score, _x];
} forEach (allCivilianVests + allArmoredVests);

_list sort true;

{
    lootVest pushBack (_x select 1);
} forEach _list;

Info_1("Vests sorted to %1", lootVest apply {getText (configFile >> "CfgWeapons" >> _x >> "displayName")});
