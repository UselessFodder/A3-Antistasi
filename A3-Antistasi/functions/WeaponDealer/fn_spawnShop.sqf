/*
Author: Wurzel0701
    Spawns a store location on the given marker if possible

Arguments:
    <OBJECT> The garage the store should be spawned in
    <NUMBER> The support value
    <STRING> The marker the store should spawn on

Return Value:
    <NIL>

Scope: Server
Environment: Scheduled
Public: Yes
Dependencies:
    <ARRAY> shopArrayComplete
    <NAMESPACE> spawner

Example:
    [_mygarage, 0.5, "testMarker"] call A3A_fnc_spawnShop;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

#define STORE_SIZE_SMALL     1
#define STORE_SIZE_MEDIUM    2
#define STORE_SIZE_LARGE     3

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

params
[
    ["_garage", objNull, [objNull]],
    ["_citySupportRatio", 0, [0]],
    ["_marker", "", [""]]
];

Info_1("Spawning store in %1 now", _marker);
private _storeSize = (floor (_citySupportRatio / 0.22) + 1) min 3;
Info_1("Selected store size is %1", _storeSize);
private _assets = [];

switch (_storeSize) do
{
    case (STORE_SIZE_SMALL):
    {
        _assets =
        [
            ["Land_CampingTable_small_F", [-3, 2.3, 0], 180],
            ["C_Soldier_VR_F", [-2, 2, -0.4], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Box_NATO_Equip_F", [-3, -2.2, 0.2], 90]
        ];
    };
    case (STORE_SIZE_MEDIUM):
    {
        _assets =
        [
            ["Land_CampingTable_small_F", [-3, 2.3, 0], 180],
            ["C_Soldier_VR_F", [-2, 2, -0.4], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [4.5, -2.2, 0], 0],
            ["C_Soldier_VR_F", [3.5, -1.9, -0.4], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Box_NATO_Equip_F", [-3, -2.2, 0.2], 90]
        ];
    };
    case (STORE_SIZE_LARGE):
    {
        _assets =
        [
            ["Land_CampingTable_small_F", [-3, 2.3, 0], 180],
            ["C_Soldier_VR_F", [-2, 2, -0.4], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [4.5, -2.2, 0], 0],
            ["C_Soldier_VR_F", [3.5, -1.9, -0.4], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Land_MapBoard_01_Wall_F", [0, 2.7, 1.25], 180],
            ["Land_MapBoard_01_Wall_F", [1.5, -2.6, 1.25], 0],
            ["Box_NATO_Equip_F", [-3, -2.2, 0.2], 90]
        ];
    };
};

private _fnc_getSlotPositions =
{
    params ["_asset"];
    private _result = [];
    switch (typeOf _asset) do
    {
        case ("Land_CampingTable_small_F"):
        {
            private _pos = (getPosWorld _asset) vectorAdd [0, 0, 0.45];
            private _rot = [150 + (getDir _asset), 0, 0];
            _result pushBack [_asset, _pos, _rot, [EXPLOSIVES, GRENADES, HELMET, VESTS, BACKPACKS, NVG]];
        };
        case ("Land_CampingTable_F"):
        {
            private _tableForward = vectorDir _asset;
            private _tableSide = _tableForward vectorCrossProduct [0, 0, 1];
            private _pos = (getPosWorld _asset) vectorAdd (_tableSide vectorMultiply -0.5) vectorAdd [0, 0, 0.45];
            private _rot = [150 + (getDir _asset), 0, 0];
            _result pushBack [_asset, _pos, _rot, [RIFLES, LAUNCHERS, PISTOLS, ITEM, GRENADES, VESTS, BACKPACKS, NVG, ATTACHMENT]];
            _pos = (getPosWorld _asset) vectorAdd (_tableSide vectorMultiply 0.5) vectorAdd [0, 0, 0.45];
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS, PISTOLS, ITEM, VESTS, BACKPACKS, NVG]];
        };
        case ("Land_MapBoard_01_Wall_F"):
        {
            private _pos = (getPosWorld _asset) vectorAdd ((vectorDir _asset) vectorMultiply 0.05);
            private _rot = [getDir _asset + 180, 270, 0];
            _result pushBack [_asset, _pos, _rot, [PISTOLS, LAUNCHERS, AMMUNITION, ATTACHMENT, GRENADES, HELMET, ITEM, EXPLOSIVES, VESTS, BACKPACKS, NVG]];
        };
        case ("C_Soldier_VR_F"):
        {
            _result pushBack [_asset, [], 0, [PISTOLS, RIFLES, LAUNCHERS, AMMUNITION, ATTACHMENT, GRENADES, HELMET, ITEM, EXPLOSIVES]];
        };
    };
    _result;
};

private _fnc_chooseSpawnItem =
{
    private _fnc_getRandomNumber =
    {
        //Returns a number between 0 and 1
        params ["_meanValue", "_derivation"];

        private _result = _meanValue + sin (random 360) * _derivation;
        _result = (_result max 0) min 1;

        _result;
    };

    params ["_chooseArray", "_blockArray", "_supportPoint", "_alreadySelected"];
    private _arrayCopy = +_chooseArray;

    {
        _arrayCopy set [_x, 0];
    } forEach _blockArray;

    private _selection = shopArrayComplete selectRandomWeighted _arrayCopy;
    private _spawnItem = "";
    private _itemData = [1, 0, 0, -1];
    private _abort = 5;
    if(_selection#2) then
    {
        while {(_spawnItem == "") || {(_itemData#3 == -1) || (_spawnItem in _alreadySelected)}} do
        {
            _spawnItem = selectRandom (_selection#0);
            _itemData = missionNamespace getVariable [format ["%1_data", _spawnItem], [1, 0, 0, -1]];
            if(count _itemData <= 4) then
            {
                Debug_1("%1 has no data set", _spawnItem);
            };
            _abort = _abort - 1;
            if(_abort < 0) exitWith
            {
                Info("Selection aborted, run into endless loop!");
                _spawnItem = "";
            };
        };
    }
    else
    {
        while {(_spawnItem == "") || {((_itemData#3) == -1) || (_spawnItem in _alreadySelected)}} do
        {
            private _itemCount = (count (_selection#0)) - 1;
            private _spawnItemIndex = ([_supportPoint, 0.2] call _fnc_getRandomNumber) * _itemCount;
            _spawnItem = (_selection#0)#_spawnItemIndex;
            _itemData = missionNamespace getVariable [format ["%1_data", _spawnItem], [1, 0, 0, -1]];
            if(count _itemData <= 4) then
            {
                Debug_1("%1 has no data set", _spawnItem);
            };
            _abort = _abort - 1;
            if(_abort < 0) exitWith
            {
                Info("Selection aborted, run into endless loop!");
                _spawnItem = "";
            };
        };
    };

    _chooseArray set [_selection#1, (_chooseArray#(_selection#1)) - 1];
    [_selection#1, _spawnItem, _chooseArray];
};

private _fnc_spawnItem =
{
    params ["_type", "_item", "_slotPos", "_orientation", "_asset"];
    private _object = objNull;
    switch (_type) do
    {
        case (PISTOLS);
        case (RIFLES);
        case (LAUNCHERS):
        {
            if(A3A_hasRHS) then
            {
                _object = (format ["Item_%1", _item]) createVehicle _slotPos;
            }
            else
            {
                _object = (format ["Weapon_%1", _item]) createVehicle _slotPos;
            };
            _object setDamage 1;
            _object enableSimulationGlobal false;
            _object setPosWorld _slotPos;
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            [_object, "CfgWeapons", _item, _type] call A3A_fnc_addShopActions;
        };
        case (AMMUNITION):
        {
            _object = "Box_NATO_Ammo_F" createVehicle _slotPos;
            _object enableSimulationGlobal false;
            _object setDamage 1;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.26]);
            _object setDir ((_orientation#0) - 60);
            [_object, "CfgMagazines", _item, _type] call A3A_fnc_addShopActions;
        };
        case (GRENADES):
        {
            _object = "Box_NATO_Grenades_F" createVehicle _slotPos;
            _object enableSimulationGlobal false;
            _object setDamage 1;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.26]);
            _object setDir ((_orientation#0) - 60);
            [_object, "CfgMagazines", _item, _type] call A3A_fnc_addShopActions;
        };
        case (EXPLOSIVES):
        {
            //These are bitches, maybe find a better way
            _object = "Box_NATO_AmmoOrd_F" createVehicle _slotPos;
            _object enableSimulationGlobal false;
            _object setDamage 1;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.26]);
            _object setDir ((_orientation#0) - 60);
            [_object, "CfgMagazines", _item, _type] call A3A_fnc_addShopActions;
        };
        case (ITEM);
        case (ATTACHMENT):
        {
            _object = (format ["Item_%1", _item]) createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.64]);
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            _object setDamage 1;
            [_object, "CfgWeapons", _item, _type] call A3A_fnc_addShopActions;
        };
        case (NVG):
        {
            _asset enableSimulationGlobal true;
            _asset linkItem _item;
            sleep 0.1;
            _asset enableSimulationGlobal false;
            [_asset, "CfgWeapons", _item, _type] call A3A_fnc_addShopActions;
        };
        case (VESTS):
        {
            _asset enableSimulationGlobal true;
            _asset addVest _item;
            sleep 0.1;
            _asset enableSimulationGlobal false;
            [_asset, "CfgWeapons", _item, _type] call A3A_fnc_addShopActions;
        };
        case (BACKPACKS):
        {
            _asset enableSimulationGlobal true;
            _asset addBackpackGlobal _item;
            sleep 0.1;
            _asset enableSimulationGlobal false;
            [_asset, "CfgVehicles", _item, _type] call A3A_fnc_addShopActions;
        };
        case (HELMET):
        {
            if(A3A_hasRHS) then
            {
                _object = (format ["Item_%1", _item]) createVehicle _slotPos;
            }
            else
            {
                _object = (format ["Headgear_%1", _item]) createVehicle _slotPos;
            };
            _object setPosWorld _slotPos;//(_slotPos vectorAdd [0, 0, 0.05]);
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            _object setDamage 1;
            [_object, "CfgWeapons", _item, _type] call A3A_fnc_addShopActions;
        };
    };
    if(!(isNull _object)) then
    {
        _object setVariable ["DoNotGarbageClean", true, true];
    };
    _object;
};

private _allObjects = [];

private _garageRight = vectorDir _garage;
private _garageUp = vectorUp _garage;
private _garageForward = _garageRight vectorCrossProduct _garageUp;
private _garagePos = getPosWorld _garage;
private _garageDir = getDir _garage;
private _slots = [];

{
    private _assetPos = _garagePos vectorAdd (_garageForward vectorMultiply _x#1#0) vectorAdd (_garageRight vectorMultiply _x#1#1) vectorAdd (_garageUp vectorMultiply _x#1#2);
    private _asset = (_x#0) createVehicle _garagePos;
    _asset allowDamage false;
    _asset enableSimulationGlobal false;
    _asset setDir (_x#2 + _garageDir);
    _asset setPosWorld (_assetPos vectorAdd [0,0,0.3]);
    clearItemCargoGlobal _asset;
    _slots append ([_asset] call _fnc_getSlotPositions);
    _allObjects pushBack _asset;
    if((_x#0) == "Box_NATO_Equip_F") then
    {
        //The sell box
        _asset spawn
        {
            sleep 1;
            _this enableSimulationGlobal true;
        };
        [_asset, ["Sell content of box", {[_this select 0] call A3A_fnc_sellBoxContent;}]] remoteExec ["addAction", [civilian, teamplayer], true];

        //TODO block ACE from carrying the box
    };
} forEach _assets;

Info_1("Assets spawned in for store in %1", _marker);
Info_1("Checking for saved slots in %1", _marker);
private _savedArray = server getVariable [format ["%1_storeSlotSave", _marker], []];
if(server getVariable [format ["%1_storeSlotTime", _marker], -1] < time) then
{
    _savedArray = [];
};

if(count _savedArray == count _slots) then
{
    {
        private _savedSlot = _x;
        private _slot = _slots#_forEachIndex;
        _allObjects pushBack ([_savedSlot#0, _savedSlot#1, _slot#1, _slot#2, _slot#0] call _fnc_spawnItem);
    } forEach _savedArray;
}
else
{
    private _chooseArray = [3, 8, 1, 3, 6, 6, 5, 7, 1, 6, 4, 3];
    private _alreadySelected = [];
    {
        private _counter = 3;
        private _item = "";
        private _itemType = 0;
        while {_item == ""} do
        {
            private _itemData = [_chooseArray, _x#3, _citySupportRatio, _alreadySelected] call _fnc_chooseSpawnItem;

            _item = _itemData#1;
            _itemType = _itemData#0;
            _chooseArray = _itemData#2;

            _counter = _counter - 1;
            if(_counter <= 0) exitWith {};
        };
        if(_item == "") then
        {
            Info_1("No selection done on slot %1, staying empty", _x);
        }
        else
        {
            _alreadySelected pushBack _item;
            Info_3("Selected %1 of type %2 for slot %3", _item, _itemType, _x);
            _allObjects pushBack ([_itemType, _item, _x#1, _x#2, _x#0] call _fnc_spawnItem);
        };
        _savedArray pushBack [_itemType, _item];
    } forEach _slots;

    server setVariable [format ["%1_storeSlotSave", _marker], _savedArray];
    server setVariable [format ["%1_storeSlotTime", _marker], time + 1800];
};

server setVariable [format ["%1_storeObjects", _marker], _allObjects];

if(!(_garage getVariable ["storeEventHandlerDone", false])) then
{
    _garage setVariable ["storeMarker", _marker];
    _garage addEventhandler
    [
        "Killed",
        {
            params ["_garage"];
            private _marker = _garage getVariable ["storeMarker", ""];
            private _objects = server getVariable [format ["%1_storeObjects", _marker], []];
            {
                deleteVehicle _x;
            } forEach _objects;
            _garage removeEventHandler ["Killed", _thisEventHandler];
            _garage setVariable ["storeEventHandlerDone", nil];
            //Activates a cooldown of 30 minutes
            server setVariable [format ["%1_storeCooldown", _marker], time + 1800];
            server setVariable [format ["%1_storeSlotSave", _marker], []];
            server setVariable [format ["%1_storeSlotTime", _marker], 0];
            server setVariable [format ["%1_isDetected", _marker], false];
            deleteMarker format ["%1_storeMarker", _marker];

            if(format ["%1_SHOP", _marker] call BIS_fnc_taskExists) then
            {
                [format ["%1_SHOP", _marker], "FAILED", true] call BIS_fnc_taskSetState;
                (format ["%1_SHOP", _marker]) spawn
                {
                    sleep 60;
                    [_this, true] call BIS_fnc_deleteTask;
                };
            };

            Info_1("Store in %1 destroyed, setting 30 minutes countdown", _marker);
        }
    ];
    _garage setVariable ["storeEventHandlerDone", true];
    Info_1("EventHandler for store in %1 set", _marker);
};

Info_1("Checking for detection mission for shop in %1", _marker);
private _isDetected = server getVariable [format ["%1_isDetected", _marker], false];
if(!_isDetected) then
{
    [_garage, _marker] spawn A3A_fnc_SHOP_Detection;
};

[_allObjects, _marker] spawn
{
    params ["_allObjects", "_marker"];
    waitUntil {sleep 10; (spawner getVariable _marker == 2)};
    {
        deleteVehicle _x;
    } forEach _allObjects;
    Info_1("Store despawned on %1", _marker);
};
