#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()


if (!isServer) exitWith {};
private ["_subObject","_ammunition","_originX","_destinationX"];
_originX = _this select 0;
if (isNull _originX) exitWith {};
_destinationX = _this select 1;

if (isNil {	// Run in unschedule scope.
	if (_originX getVariable ["A3A_JNA_ammunitionTransfer_busy",false]) then {
		nil;  // will lead to exit.
	} else {
		_originX setVariable ["A3A_JNA_ammunitionTransfer_busy",true];
		0;  // not nil, will allow script to continue.
	};
}) exitWith {};  // Silent exit, likely due to spamming


//THAT ENTIRE FILE COUNT NEED A REWRITE, HAVE A LOOK AT A3A_fnc_sellBoxContent FOR HOW TO IMPROVE THAT

_ammunition= [];
_items = [];
_ammunition = magazineCargo _originX;
_items = itemCargo _originX;
_weaponsX = [];
_weaponsItemsCargo = weaponsItemsCargo _originX;
_backpcks = [];

if (count backpackCargo _originX > 0) then
	{
	{
	_backpcks pushBack (_x call A3A_fnc_basicBackpack);
	} forEach backpackCargo _originX;
	};
_containers = everyContainer _originX;
if (count _containers > 0) then
	{
	for "_i" from 0 to (count _containers) - 1 do
		{
		_subObject = magazineCargo ((_containers select _i) select 1);
		if (!isNil "_subObject") then {_ammunition = _ammunition + _subObject} else {Error_1("Error from %1",magazineCargo (_containers select _i))};
		//_ammunition = _ammunition + (magazineCargo ((_containers select _i) select 1));
		_items = _items + (itemCargo ((_containers select _i) select 1));
		_weaponsItemsCargo = _weaponsItemsCargo + weaponsItemsCargo ((_containers select _i) select 1);
		};
	};
if (!isNil "_weaponsItemsCargo") then
	{
	if (count _weaponsItemsCargo > 0) then
		{
		{
		_weaponsX pushBack ([(_x select 0)] call BIS_fnc_baseWeapon);
		for "_i" from 1 to (count _x) - 1 do
			{
			_thingX = _x select _i;
			if (_thingX isEqualType "") then
				{
				if (_thingX != "") then {_items pushBack _thingX};
				}
			else
				{
				if (_thingX isEqualType []) then
					{
					if (count _thingX > 0) then
						{
						_ammunition pushBack (_thingX select 0);
						};
					};
				};
			};
		} forEach _weaponsItemsCargo;
		};
	};

_weaponsFinal = [];
_weaponsFinalCount = [];
{
    private _weapon = _x;
    private _itemData = missionNamespace getVariable [format ["%1_data", _weapon], [1, 0, 0, -1]];
    if ((!(_weapon in _weaponsFinal)) && (_itemData#3 != -1)) then
    {
        _weaponsFinal pushBack _weapon;
        _weaponsFinalCount pushBack ({_x == _weapon} count _weaponsX);
    };
} forEach _weaponsX;

if (count _weaponsFinal > 0) then
	{
	for "_i" from 0 to (count _weaponsFinal) - 1 do
		{
		_destinationX addWeaponCargoGlobal [_weaponsFinal select _i,_weaponsFinalCount select _i];
		};
	};

_ammunitionFinal = [];
_ammunitionFinalCount = [];
if (isNil "_ammunition") then
{
    Error_4("Ammunition transmission error. I had this: %1 and these containers: %2, the originX was a %3 and the objectX is defined as: %4", magazineCargo _originX, everyContainer _originX,typeOf _originX,_originX);
}
else
{
    {
        private _ammo = _x;
        private _itemData = missionNamespace getVariable [format ["%1_data", _ammo], [1, 0, 0, -1]];
        if ((!(_ammo in _ammunitionFinal)) && (_itemData#3 != -1)) then
        {
            _ammunitionFinal pushBack _ammo;
            _ammunitionFinalCount pushBack ({_x == _ammo} count _ammunition);
        };
    } forEach  _ammunition;
};


if (count _ammunitionFinal > 0) then
	{
	for "_i" from 0 to (count _ammunitionFinal) - 1 do
		{
		_destinationX addMagazineCargoGlobal [_ammunitionFinal select _i,_ammunitionFinalCount select _i];
		};
	};

_itemsFinal = [];
_itemsFinalCount = [];
{
    private _item = _x;
    private _itemData = missionNamespace getVariable [format ["%1_data", _item], [1, 0, 0, -1]];
    if ((_item in _itemsFinal) && (_itemData#3 != -1)) then
    {
        _itemsFinal pushBack _item;
        _itemsFinalCount pushBack ({_x == _item} count _items);
    };
} forEach _items;

if (count _itemsFinal > 0) then
	{
	for "_i" from 0 to (count _itemsFinal) - 1 do
		{
		_destinationX addItemCargoGlobal [_itemsFinal select _i,_itemsFinalCount select _i];
		};
	};

_backpcksFinal = [];
_backpcksFinalCount = [];
{
    private _backpack = _x;
    private _itemData = missionNamespace getVariable [format ["%1_data", _backpack], [1, 0, 0, -1]];
    if ((!(_backpack in _backpcksFinal)) && (_itemData#3 != -1)) then
    {
        _backpcksFinal pushBack _backpack;
        _backpcksFinalCount pushBack ({_x == _backpack} count _backpcks);
    };
} forEach _backpcks;

if (count _backpcksFinal > 0) then
	{
	for "_i" from 0 to (count _backpcksFinal) - 1 do
		{
		_destinationX addBackpackCargoGlobal [_backpcksFinal select _i,_backpcksFinalCount select _i];
		};
	};

if (count _this == 3) then
	{
	deleteVehicle _originX;
	}
else
	{
	clearMagazineCargoGlobal _originX;
	clearWeaponCargoGlobal _originX;
	clearItemCargoGlobal _originX;
	clearBackpackCargoGlobal _originX;
	};

if (_destinationX == boxX) then
	{
//	{if (_x distance boxX < 10) then {[petros,"hint","Ammobox Loaded", "Cargo"] remoteExec ["A3A_fnc_commsMP",_x]}} forEach (call A3A_fnc_playableUnits);
	if ((_originX isKindOf "ReammoBox_F") and (_originX != vehicleBox)) then {deleteVehicle _originX};
	_updated = [] call A3A_fnc_arsenalManage;
	if (_updated != "") then
		{
		_updated = format ["<t size='0.5' color='#C1C0BB'>Arsenal Updated<br/><br/>%1</t>",_updated];
		[petros,"income",_updated] remoteExec ["A3A_fnc_commsMP",[teamPlayer,civilian]];
		};
	}
else
	{
	[petros,"hint","Truck Loaded", "Cargo"] remoteExec ["A3A_fnc_commsMP",driver _destinationX];
	};

if (!isNull _originX) then {
	_originX setVariable ["A3A_JNA_ammunitionTransfer_busy",false];
};
