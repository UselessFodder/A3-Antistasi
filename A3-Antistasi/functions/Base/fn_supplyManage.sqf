#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _array = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];

private _addToArray =
{
    private ["_array","_index","_item","_amount"];
    _array = _this select 0;
    _index = _this select 1;
    _item = _this select 2;
    _amount = _this select 3;

    if!(_index == -1 || _item isEqualTo ""|| _amount == 0)then
    {
        _array set [_index,[_array select _index,[_item,_amount]] call jn_fnc_arsenal_addToArray];
    };
};

private _playerMultiplayer = ceil (sqrt (count allPlayers));
{
    private _itemName = _x;
    private _itemData = missionNamespace getVariable [format ["%1_data", _itemName], [1, -1, 0, 0, 0]];
    if(_itemData#1 == -1) then
    {
        Debug_1("Item %1 has no data set!", _itemName);
    };
    private _all = _itemData#4 + (_itemData#3 * _playerMultiplayer * 0.16);
    private _available = floor (_all);
    _itemData set [4, _all - _available];
    if(_available > 0) then
    {
        private _index = _itemName call jn_fnc_arsenal_itemType;
        [_array, _index, _itemName, _available] call _addToArray;
    };
} forEach allSupplies;

_array call jn_fnc_arsenal_addItem;
