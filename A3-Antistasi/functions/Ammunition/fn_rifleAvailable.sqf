/*
Author: Wurzel0701
    Checks if at least one rifle is available for AI units to grab

Arguments:
    <ARRAY> The pool of weapons which will be checked

Return Value:
    <BOOL> True if a rifle is available, false otherwise

Scope: Server
Environment: Any
Public: Yes
Dependencies:
    <ARRAY> unlockedRifles

Example:
    [unlockedSniperRifles] call A3A_fnc_rifleAvailable;
*/

params ["_pool"];

private _count = (count _pool) + (count unlockedRifles) + (count unlockedSMGs) + (count unlockedShotguns);
private _isAvailable = (_count > 0);

_isAvailable;
