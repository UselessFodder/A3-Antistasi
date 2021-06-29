#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params ["_object", "_configClass", "_item", "_class"];

private _displayName = getText (configFile >> _configClass >> _item >> "displayName");

#define PISTOLS             0
#define RIFLES              1
#define LAUNCHERS           2
#define EXPLOSIVES          3
#define AMMUNITION          4
#define ATTACHMENT          5
#define VESTS               6
#define BACKPACKS           7
#define NVG                 8
#define ITEM                9
#define GRENADES            10
#define HELMET              11

private _priceModifier = 1;
switch (_class) do
{
    case (PISTOLS):
    {
        _priceModifier = 1.4;
    };
    case (RIFLES):
    {
        _priceModifier = 3.8;
    };
    case (LAUNCHERS):
    {
        _priceModifier = 7.8;
    };
    case (EXPLOSIVES):
    {
        _priceModifier = 3;
    };
    case (AMMUNITION):
    {
        _priceModifier = 0.3;
    };
    case (ATTACHMENT):
    {
        _priceModifier = 2.8;
    };
    case (VESTS):
    {
        _priceModifier = 4.5;
    };
    case (BACKPACKS):
    {
        _priceModifier = 0.8;
    };
    case (NVG):
    {
        _priceModifier = 9;
    };
    case (ITEM):
    {
        _priceModifier = 0.1;
    };
    case (GRENADES):
    {
        _priceModifier = 0.4;
    };
    case (HELMET):
    {
        _priceModifier = 7;
    };
};

//Maybe get the score of the item in too
private _itemData = missionNamespace getVariable [format ["%1_data", _item], []];
if(count _itemData == 0) exitWith
{
    Error_1("%1 does not have any data defined", _item);
};

private _itemValue = _itemData # 0;
private _upgradedTimes = _itemData # 2;

private _basePrice = ceil (5 * _priceModifier * _itemValue) * 5;
private _supplyPrice = round (_basePrice * exp (_upgradedTimes/20)) * 5;

_object setVariable ["basePrice", _basePrice, true];
_object setVariable ["supplyPrice", _supplyPrice, true];

[_object, [format ["Buy %1 for %2", _displayName, _basePrice], {([_this select 0] + (_this select 3)) call A3A_fnc_singleBuyAction;}, [_item, _class, _displayName]]] remoteExec ["addAction", [civilian, teamplayer], true];
[_object, [format ["Buy %1 supply for %2", _displayName, _supplyPrice], {([_this select 0, _this select 2] + (_this select 3)) call A3A_fnc_supplyBuyAction;}, [_item, _class, _displayName]]] remoteExec ["addAction", [civilian, teamPlayer], true];
//_object addAction [format ["Steal %1", _displayName], {hint "Weapon bought!";}];
