/*
Author: Wurzel0701
    The action of buying a steady supply from the weapon dealer, handles the money transfer and the data

Arguments:
    <OBJECT> The object this action is added, currently unused
    <STRING> The classname of the item which is bought
    <INT> The class of the item, as defines in the defines
    <STRING> The human readable name of the item
    <NUMBER> The price to pay for the item

Return Value:
    <NIL>

Scope: Local
Environment: Any
Public: No
Dependencies:
    <NIL>

Example:
    [objNull, "SMG_02_F", 1, "Stinger 9 mm", 150] call A3A_fnc_supplyBuyAction;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

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

params ["_object", "_actionID", "_item", "_class", "_name"];

if(!local player) exitWith {};

if (player != player getVariable["owner", player]) exitWith
{
    ["Weapon Shop", "You cannot buy something while you are controlling AI"] call A3A_fnc_customHint;
};

if(!(isNull (objectParent player))) exitWith
{
    ["Weapon Shop", "You cannot buy something from inside a vehicle"] call A3A_fnc_customHint;
};

private _price = _object getVariable ["supplyPrice", 0];
private _moneySource = 0;
if(player != theBoss && player getVariable ["moneyX", 0] < _price) then
{
    ["Weapon Shop", "You dont have enough personal money to buy this"] call A3A_fnc_customHint;
    _moneySource = -1;
};

if(player == theBoss) then
{
    if(player getVariable ["moneyX", 0] < _price) then
    {
        if(server getVariable ["resourcesFIA", 0] > _price) then
        {
            _moneySource = 1;
        }
        else
        {
            _moneySource = -1;
            ["Weapon Shop", "Neither you nor the faction has enough money to buy this"] call A3A_fnc_customHint;
        };
    };
};

if(_moneySource == -1) exitWith {};

if(_moneySource == 1) then
{
    //Send order to server to reduce money
    [0, -_price] remoteExec ["A3A_fnc_resourcesFIA", 2];
};
if(_moneySource == 0) then
{
    [-_price] call A3A_fnc_resourcesPlayer;
};

[_item, _name, _actionID, _object] remoteExec ["A3A_fnc_increaseWeaponSupply", 2];
