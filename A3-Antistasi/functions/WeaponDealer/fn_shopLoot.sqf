//Pistols first
["allHandguns", "Handguns"] call A3A_fnc_sortWeaponArray;

//All rifles
["allRifles", "Rifles"] call A3A_fnc_sortWeaponArray;
["allSniperRifles", "SniperRifles"] call A3A_fnc_sortWeaponArray;
["allMachineGuns", "MachineGuns"] call A3A_fnc_sortWeaponArray;
["allSMGs", "SMGs"] call A3A_fnc_sortWeaponArray;
["allShotguns", "Shotguns"] call A3A_fnc_sortWeaponArray;
//Mash all arrays into one big one
allRiflesShop = [+allRifles, +allSniperRifles, +allMachineGuns, +allSMGs, +allShotguns] call A3A_fnc_mergeWeaponArray;

["allMissileLaunchers", "MissileLaunchers"] call A3A_fnc_sortWeaponArray;
["allRocketLaunchers", "RocketLaunchers"] call A3A_fnc_sortWeaponArray;
//Mash all arrays into one big one
allLaunchersShop = [+allMissileLaunchers, +allRocketLaunchers] call A3A_fnc_mergeWeaponArray;

//Sort explosives by damage, explosion radius and maybe weight
[] call A3A_fnc_sortExplosives;

//Ammo sorted so ammo and weapons match
[] call A3A_fnc_sortMagazines;

//Sort by armor level, weight, load, and resistance
allVestsShop = +lootVest;

//Sort by weight and load
allBackpacksShop = +lootBackpack;

//Sorted by the order here
allItemsShop = lootBasicItem + allRadios + allBinoculars + allGPS + allMineDetectors + allLaserBatteries + allLaserDesignators + allUAVTerminals  + allGadgets;
{
    missionNamespace setVariable [format ["%1_data", _x], [1, 9, 0, 0, 0]];
} forEach allItemsShop;
[allItemsShop, "Items"] call A3A_fnc_logArray;

//Fix NVG not having a value
{
    missionNamespace setVariable [format ["%1_data", _x], [1, 8, 0, 0, 0]];
} forEach lootNVG;

//Fix grenades not having a value
{
    missionNamespace setVariable [format ["%1_data", _x], [1, 10, 0, 0, 0]];
} forEach lootGrenade;

//Sort by protection and weight
[] call A3A_fnc_sortHelmets;

//The complete array
shopArrayComplete = [[allHandguns, 0, false], [allRiflesShop, 1, false], [allLaunchersShop, 2, false], [allExplosiveShop, 3, false], [allAmmunitionShop, 4, false], [lootAttachment, 5, false], [allVestsShop, 6, false], [allBackpacksShop, 7, false], [lootNVG, 8, true], [allItemsShop, 9, false], [lootGrenade, 10, true], [allHelmetsShop, 11, false]];
