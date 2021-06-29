/*
Author: Wurzel0701
    Sorts all attachments into a single array sorted by the value of each attachment

Arguments:
    <NIL>

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <ARRAY> allMuzzleAttachments
    <ARRAY> allBipods
    <ARRAY> allPointerAttachments
    <ARRAY> allOptics

Example:
    [] call A3A_fnc_sortAttachments;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

//Would be nice to sort them by size of the weapon, but that is sadly not easily possible
//There might be a way over the MuzzleSlot class, but not sure
private _silencers = allMuzzleAttachments apply
{
    private _mass = getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "mass");
    [1 + (0.1 * _mass), _x]
};
Debug_1("Sorted %1 silencers", count _silencers);

private _bipods = allBipods apply {[0.4 + random 0.2, _x]};
Debug_1("Sorted %1 bipods", count _bipods);

private _flashlights = [];
private _IRPointer = [];
{
    if(isClass (configFile >> "CfgVehicles" >> format ["Item_%1", _x])) then
    {
        if(isClass (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "Pointer")) then
        {
            _IRPointer pushBack [0.75 + random 0.5, _x];
        }
        else
        {
            _flashlights pushBack [0.2 + random 0.3, _x];
        };
    }
    else
    {
        Info_1("%1 does not have model attached and will be filtered out!", _x);
    };
} forEach allPointerAttachments;
Debug_2("Sorted %1 lights and %2 lasers", count _flashlights, count _IRPointer);

private _optics = [];
{
    private _optic = _x;
    private _maxZoom = 1;
    private _maxDistance = 100;
    private _hasThermal = false;
    private _hasNightVision = false;
    private _classes = "true" configClasses (configFile >> "CfgWeapons" >> _optic >> "ItemInfo" >> "OpticsModes");
    {
        private _distance = getNumber (_x >> "distanceZoomMax");
        if(_distance > _maxDistance) then {_maxDistance = _distance};

        //0.25 is the magic number to calculate the FOV for zoom in arma
        //https://forums.bohemia.net/forums/topic/80837-how-to-get-correct-magnification/
        //The min is the safety mechanism to ensure even wrong configs are correctly calculated
        //Cause the smallest value returns the biggest zoom (opticsZoomMin could refer to zoom or value)
        private _zoom = 0.25 / (getNumber (_x >> "opticsZoomMin") min getNumber (_x >> "opticsZoomMax"));
        if(_zoom > _maxZoom) then {_maxZoom = _zoom};

        private _modes = getArray (_x >> "VisionMode");
        if("NVG" in _modes) then {_hasNightVision = true};
        if("Ti" in _modes) then {_hasThermal = true};
    } forEach _classes;

    private _mass = getNumber (configFile >> "CfgWeapons" >> _optic >> "ItemInfo" >> "mass");
    private _score =    _mass / 10 +
                        _maxDistance / 300 +
                        _maxZoom / 5;
    //Create an average value
    _score = _score / 3;

    if(_hasNightVision) then
    {
        _score = _score * 2.5;
    };
    if(_hasThermal) then
    {
        _score = _score * 3;
    };
    _optics pushBack [_score, _optic];
} forEach allOptics;
Debug_1("Sorted %1 optics", count _optics);

_allAttachments = _optics + _bipods + _silencers + _flashlights + _IRPointer;
_allAttachments sort true;

private _newOrder = [];
{
    _newOrder pushBack (_x select 1);
    missionNamespace setVariable [format ["%1_data", _x select 1], [_x select 0, 5, 0, 0, 0]];
} forEach _allAttachments;

Debug_1("%1", _newOrder apply {getText (configFile >> "CfgWeapons" >> _x >> "displayName")});
missionNamespace setVariable ["lootAttachment", _newOrder];
