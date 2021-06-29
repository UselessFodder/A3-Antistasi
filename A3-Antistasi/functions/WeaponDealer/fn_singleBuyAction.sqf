/*
Author: Wurzel0701
    The action of buying an item from the weapon dealer, handles money and the equipment process

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
    [objNull, "SMG_02_F", 1, "Stinger 9 mm", 150] call A3A_fnc_singleBuyAction;
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

params ["_object", "_item", "_class", "_name"];

if(!local player) exitWith {};

private _price = _object getVariable ["basePrice", 0];
if(player getVariable ["moneyX", 0] < _price) exitWith
{
    ["Weapon Shop", "You dont have enough money to buy this"] call A3A_fnc_customHint;
};

if (player != player getVariable["owner", player]) exitWith
{
    ["Weapon Shop", "You cannot buy something while you are controlling AI"] call A3A_fnc_customHint;
};

if(!(isNull (objectParent player))) exitWith
{
    ["Weapon Shop", "You cannot buy something from inside a vehicle"] call A3A_fnc_customHint;
};

ServerInfo_3("%1 is about to buy a single %2 for %3", player, _item, _price);

private _fnc_addWeapon =
{
    params ["_weapon", "_magCount", "_toBackpack"];
    private _magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
    if(count _magazine > 0) then
    {
        player addMagazines [_magazine#0 , _magCount];
    };
    if(_toBackpack) then
    {
        player addItemToBackpack _weapon;
    }
    else
    {
        player addWeapon _weapon;
    };
};

private _bought = false;

switch (_class) do
{
    case (RIFLES):
    {
        if(primaryWeapon player != "") then
        {
            if (backpack player == "" || {!(player canAddItemToBackpack _item)}) then
            {
                ["Weapon Shop", "You cannot pick up this rifle and you have no space in your backpack"] call A3A_fnc_customHint;
            }
            else
            {
                [_item, 3, true] call _fnc_addWeapon;
                _bought = true;
                ["Weapon Shop", format ["%1 bought, three mags have been added for free", _name]] call A3A_fnc_customHint;
            };
        }
        else
        {
            [_item, 3, false] call _fnc_addWeapon;
            _bought = true;
            ["Weapon Shop", format ["%1 bought, three mags have been added for free", _name]] call A3A_fnc_customHint;
        };
    };
    case (PISTOLS):
    {
        if(handgunWeapon player != "") then
        {
            if (backpack player == "" || {!(player canAddItemToBackpack _item)}) then
            {
                ["Weapon Shop", "You cannot pick up this sidearm and you have no space in your backpack"] call A3A_fnc_customHint;
            }
            else
            {
                [_item, 3, true] call _fnc_addWeapon;
                _bought = true;
                ["Weapon Shop", format ["%1 bought, three mags have been added for free", _name]] call A3A_fnc_customHint;
            };
        }
        else
        {
            [_item, 3, false] call _fnc_addWeapon;
            _bought = true;
            ["Weapon Shop", format ["%1 bought, three mags have been added for free", _name]] call A3A_fnc_customHint;
        };
    };
    case (LAUNCHERS):
    {
        if(secondaryWeapon player != "") then
        {
            ["Weapon Shop", "You cannot pick up this launcher while having another equipped"] call A3A_fnc_customHint;
        }
        else
        {
            [_item, 2, false] call _fnc_addWeapon;
            _bought = true;
            ["Weapon Shop", format ["%1 bought, two shoots have been added for free", _name]] call A3A_fnc_customHint;
        };
    };
    case (EXPLOSIVES);
    case (GRENADES);
    case (AMMUNITION):
    {
        if(player canAdd _item) then
        {
            player addItem _item;
            ["Weapon Shop", format ["%1 bought and stashed in your inventory", _name]] call A3A_fnc_customHint;
            _bought = true;
        }
        else
        {
            ["Weapon Shop", "You do not have enough space in your inventory to buy this"] call A3A_fnc_customHint;
        };
    };
    case (ATTACHMENT):
    {
        private _text = "";
        //Try putting the attachment on the main gun
        private _currentAttachments = player weaponAccessories (primaryWeapon player);
        _currentAttachments pushBack (primaryWeapon player);
        if(primaryWeapon player != "" && {!(_item in _currentAttachments) && isNil {player addPrimaryWeaponItem _item}}) then
        {
            _text = format ["%1 bought and attached to your primary weapon", _name];
            _bought = true;
        }
        else
        {
            //Try putting the attachment on the launcher
            _currentAttachments = player weaponAccessories (secondaryWeapon player);
            _currentAttachments pushBack (secondaryWeapon player);
            if(secondaryWeapon player != "" && {!(_item in _currentAttachments) && isNil {player addSecondaryWeaponItem _item}}) then
            {
                _text = format ["%1 bought and attached to your launcher", _name];
                _bought = true;
            }
            else
            {
                //Try putting the attachment on the sidearm
                _currentAttachments = player weaponAccessories (handgunWeapon player);
                _currentAttachments pushBack (handgunWeapon player);
                if(handgunWeapon player != "" && {!(_item in _currentAttachments) && isNil {player addHandgunItem _item}}) then
                {
                    _text = format ["%1 bought and attached to your sidearm", _name];
                    _bought = true;
                }
                else
                {
                    _currentAttachments = [];
                    if(player canAdd _item) then
                    {
                        player addItem _item;
                        ["Weapon Shop", format ["%1 bought and stashed in your inventory", _name]] call A3A_fnc_customHint;
                        _bought = true;
                    }
                    else
                    {
                        ["Weapon Shop", "You can't buy this as you do not have enough inventory space and it cannot be attached to one of your weapons"] call A3A_fnc_customHint;
                    };
                };
            };
        };
        if(count _currentAttachments > 0) then
        {
            //Original attachment has been removed, check if it can be stored, otherwise revert
            private _weapon = _currentAttachments deleteAt ((count _currentAttachments) - 1);
            private _removed =  _currentAttachments - (player weaponAccessories _weapon);
            if(count _removed > 0) then
            {
                //There was an attachment that has been removed, see if we can store it
                _removed = _removed#0;
                if(player canAdd _removed) then
                {
                    player addItem _removed;
                    ["Weapon Shop", format ["%1. Original attachment has been stored in your inventory", _text]] call A3A_fnc_customHint;
                }
                else
                {
                    player addWeaponItem [_weapon, _removed, true];
                    _bought = false;
                    ["Weapon Shop", "You cannot buy this while you have a similar item equipped and no space to store it"] call A3A_fnc_customHint;
                };
            }
            else
            {
                ["Weapon Shop", _text] call A3A_fnc_customHint;
            };
        };
    };
    case (VESTS):
    {
        if(vest player == "") then
        {
            player addVest _item;
            ["Weapon Shop", format ["%1 bought and equipped", _name]] call A3A_fnc_customHint;
            _bought = true;
        }
        else
        {
            if(backpack player != "" && {player canAddItemToBackpack _item}) then
            {
                player addItemToBackpack _item;
                ["Weapon Shop", format ["%1 bought and stashed in you backpack", _name]] call A3A_fnc_customHint;
                _bought = true;
            }
            else
            {
                ["Weapon Shop", "You cannot buy this vest as you are already wearing one and have no backpack inventory space"] call A3A_fnc_customHint;
            };
        };
    };
    case (BACKPACKS):
    {
        if(backpack player == "") then
        {
            player addBackpack _item;
            ["Weapon Shop", format ["%1 bought and equipped", _name]] call A3A_fnc_customHint;
            _bought = true;
        }
        else
        {
            ["Weapon Shop", "You cannot buy this backpack as you are already wearing one and backpacks cannot be stashed somewhere"] call A3A_fnc_customHint;
        };
    };
    case (NVG):
    {
        if(hmd player == "") then
        {
            player linkItem _item;
            ["Weapon Shop", format ["%1 bought and equipped", _name]] call A3A_fnc_customHint;
            _bought = true;
        }
        else
        {
            if(player canAdd _item) then
            {
                player addItem _item;
                ["Weapon Shop", format ["%1 bought and stashed in your inventory", _name]] call A3A_fnc_customHint;
                _bought = true;
            }
            else
            {
                ["Weapon Shop", "You cannot buy this NVG as you are already wearing one and have not enough inventory space"] call A3A_fnc_customHint;
            };
        };
    };
    case (ITEM):
    {
        if(_item in (assignedItems player)) then
        {
            if(player canAdd _item) then
            {
                player addItem _item;
                ["Weapon Shop", format ["%1 bought and stashed in your inventory", _name]] call A3A_fnc_customHint;
                _bought = true;
            }
            else
            {
                ["Weapon Shop", "You cannot buy this item as you are already wearing one and have not enough inventory space"] call A3A_fnc_customHint;
            };
        }
        else
        {
            if(player canAdd _item) then
            {
                player addItem _item;
                player assignItem _item;
                if(_item in (assignedItems player)) then
                {
                    ["Weapon Shop", format ["%1 bought and equipped", _name]] call A3A_fnc_customHint;
                    _bought = true;
                }
                else
                {
                    //player addItem _item;
                    ["Weapon Shop", format ["%1 bought and stashed in your inventory", _name]] call A3A_fnc_customHint;
                    _bought = true;
                };
            }
            else
            {
                ["Weapon Shop", "You do not have enough space in your inventory to buy this!"] call A3A_fnc_customHint;
            };
        };
    };
    case (HELMET):
    {
        if(headgear player == "") then
        {
            player linkItem _item;
            ["Weapon Shop", format ["%1 bought and equipped", _name]] call A3A_fnc_customHint;
            _bought = true;
        }
        else
        {
            if(player canAdd _item) then
            {
                player addItem _item;
                ["Weapon Shop", format ["%1 bought and stashed in your inventory", _name]] call A3A_fnc_customHint;
                _bought = true;
            }
            else
            {
                ["Weapon Shop", "You cannot buy this helmet as you are already wearing one and have not enough inventory space"] call A3A_fnc_customHint;
            };
        };
    };
};

if(_bought) then
{
    ServerInfo_3("%1 successful bought a single %2 for %3", player, _item, _price);
    [-_price] call A3A_fnc_resourcesPlayer;
}
else
{
    ServerInfo_4("%1 failed to buy a single %2 for %3 (Type was %4)", player, _item, _price, _class);
};
