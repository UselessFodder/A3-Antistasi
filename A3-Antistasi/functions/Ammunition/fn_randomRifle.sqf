/*
Maintainer: Wurzel0701
    Selects a rifle for a unit and equips it with said rifle. Also sets optics, attachments and ammo.
    Should be after a check of rifle available to see if any rifle is available currently

Arguments:
    <OBJECT> The unit which should be equipped
    <ARRAY> The main class of rifle wanted
    <BOOL> If the unit is part of a garrison, changes where the rifle is grabbed from

Return Value:
    <BOOL> If the unit has been equipped with a rifle

Scope: Server
Environment: Any
Public: Yes
Dependencies:
    <ARRAY> unlockedRifles

Example:
    [_myUnit, unlockedShotguns, false] call A3A_fnc_randomRifle;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params
[
    ["_unit", objNull, [objNull]],
    ["_pool", [], [[]]],
    ["_isGarrison", false, [false]]
];

private _exit = false;
//Check if the given pool has any entries
if (count _pool == 0) then
{
    _pool = unlockedRifles + unlockedSMGs + unlockedShotguns;
    if(count _pool == 0) then
    {
        _exit = true;
    };
};

//If no rifle available return here

if(_exit) exitWith
{
    Debug("No rifle unlocked to select for unit!");
    false;
};

private _selectedRifle = "";
if(_isGarrison) then
{
    //Garrisons take from the income, so they wont actually reduce stuff
    private _items = [];
    private _chance = [];
    {
        _items pushBack _x;
        private _itemData = missionNamespace getVariable (format ["%1_data", _x]);
        _chance pushBack (_items#3);
    } forEach _pool;
    _selectedRifle = _items selectRandomWeighted _chance;
}
else
{
    //Private units take from what is actually there
    private _riflesInArsenal = jna_dataList#0;
    private _availableInArsenal = _riflesInArsenal select {(_x#0) in _pool};
    if(count _availableInArsenal > 0) then
    {
        private _items = [];
        private _chance = [];
        {
            _items pushBack (_x#0);
            _chance pushBack (_x#1);
        } forEach _availableInArsenal;
        _selectedRifle = _items selectRandomWeighted _chance;
    };
};


if(_selectedRifle == "") exitWith {false;};

private _index = _selectedRifle call jn_fnc_arsenal_itemType;
[_index, _selectedRifle, 1] call jn_fnc_arsenal_removeItem;

//Remove primary weapon if the unit has one
if !(primaryWeapon _unit isEqualTo "") then
{
    if (_selectedRifle == primaryWeapon _unit) exitWith {};
    private _magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
    {
        if(_x in _magazines) then
        {
            _unit removeMagazineGlobal _x;
        };
    } forEach magazines _unit;
    _unit removeWeapon (primaryWeapon _unit);
};

if (_selectedRifle in unlockedGrenadeLaunchers && {_selectedRifle in unlockedRifles} ) then
{
    // lookup real underbarrel GL magazine, because not everything is 40mm
    private _config = configFile >> "CfgWeapons" >> _rifleFinal;
    private _glmuzzle = getArray (_config >> "muzzles") select 1;       // guaranteed by category
    private _glmag = getArray (_config >> _glmuzzle >> "magazines") select 0;
    _unit addMagazines [_glmag, 5];
};

[_unit, _rifleFinal, 5, 0] call BIS_fnc_addWeapon;

if (count unlockedOptics > 0) then
{
    private _compatibleX = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
    private _potentials = unlockedOptics select {_x in _compatibleX};
    if (count _potentials > 0) then {_unit addPrimaryWeaponItem (selectRandom _potentials)};
};
