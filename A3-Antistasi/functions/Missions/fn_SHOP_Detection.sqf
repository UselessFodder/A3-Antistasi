/*
Author: Wurzel0701
    Spawns the mission to detect a shop in a city

Arguments:
    <OBJECT> The garage the store has been spawned in
    <STRING> The marker the store has been spawned on

Return Value:
    <NIL>

Scope: Server
Environment: Scheduled
Public: Yes
Dependencies:
    <OBJECT> petros

Example:
    [_mygarage, "testMarker"] call A3A_fnc_spawnShop;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params
[
    ["_garage", objNull, [objNull]],
    ["_marker", "", [""]]
];
private _taskName = format ["%1_SHOP", _marker];

if([_taskName] call BIS_fnc_taskExists) exitWith {};

private _textPossibilites =
[
    "They say size doesn't matter, but ... you might wanna upgrade your weapons anyways!",
    "Weapons, armor, items and maybe some WMD, I got what you need!",
    "Winning a rebelions with that weapons? Maybe you wanna increase your chances a bit!",
    "I know exactly what you need, and I might even have that in stock!"
];

petros globalChat (selectRandom _textPossibilites);

[
    true,
    _taskName,
    [format ["A weapons dealer in %1 contacted you, go to his shop to see what he has to offer and to permantly mark his store on the map!", [_marker] call A3A_fnc_localizar], "Find weapon shop", _marker],
    _garage,
    "AUTOASSIGNED",
    -1,
    true,
    "rifle",
    true
] call BIS_fnc_taskCreate;

[_garage, _taskName, _marker] spawn
{
    params ["_garage", "_taskName", "_marker"];

    waitUntil { sleep 2; allPlayers findIf { _x distance2d _garage < 15} != -1};

    [_taskName, "SUCCEEDED", true] call BIS_fnc_taskSetState;

    private _garageMarker = createMarker [format ["%1_storeMarker", _marker], getPos _garage];
    _garageMarker setMarkerShape "ICON";
    _garageMarker setMarkerType "loc_Rifle";

    sleep 60;
    [_taskName, true] call BIS_fnc_deleteTask;
};
