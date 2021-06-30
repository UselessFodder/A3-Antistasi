//////////////////
// Basic Items ///
//////////////////
lootBasicItem append allMaps + allToolkits + allWatches + allCompasses + allMedikits + allFirstAidKits;

/////////////////
//    NVG'S   ///
/////////////////
lootNVG append allNVGs;

/////////////////////
// Assigned Items ///
/////////////////////
lootItem append allUAVTerminals + allMineDetectors + allGPS + allRadios + allLaserDesignators + allBinoculars + allLaserBatteries + lootNVG + allGadgets;

////////////////////
//    Weapons    ///
////////////////////
lootWeapon append allRifles + allSniperRifles + allHandguns + allMachineGuns + allMissileLaunchers + allRocketLaunchers + allSMGs + allShotguns;

/////////////////////////////
//   Weapon Attachments   ///
/////////////////////////////
//lootAttachment append allBipods + allOptics + allMuzzleAttachments + allPointerAttachments;
//Does what the commented line does, but sorts the attachments based on value
[] call A3A_fnc_sortAttachments;

////////////////////
//    Grenades   ///
////////////////////
lootGrenade append allGrenades + allMagShell + allIRGrenades + allMagSmokeShell + allMagFlare;

////////////////////
//   Magazines   ///
////////////////////
lootMagazine append allMagBullet + allMagShotgun + allMagMissile + allMagRocket + lootGrenade;

///////////////////
//  Explosives  ///
///////////////////
lootExplosive append allMine + allMineDirectional + allMineBounding;

lootExplosive deleteAt (lootExplosive find "APERSMineDispenser_Mag");
lootExplosive deleteAt (lootExplosive find "TrainingMine_Mag");
lootExplosive deleteAt (lootExplosive find "IEDLandSmall_Remote_Mag");
lootExplosive deleteAt (lootExplosive find "IEDUrbanSmall_Remote_Mag");
lootExplosive deleteAt (lootExplosive find "IEDLandBig_Remote_Mag");
lootExplosive deleteAt (lootExplosive find "IEDUrbanBig_Remote_Mag");

///////////////////
//   Backpacks  ///
///////////////////
//lootBackpack append allBackpacksEmpty;
//Does what the commented line does, but sorts the vests based on value
[] call A3A_fnc_sortBackpacks;

/////////////////
//   Helmets  ///
/////////////////
lootHelmet append allArmoredHeadgear;

///////////////
//   Vests  ///
///////////////
//lootVest append allArmoredVests + allCivilianVests;
//Does what the commented line does, but sorts the vests based on value
[] call A3A_fnc_sortVests;

/////////////////////
//   Device Bags  ///
/////////////////////
private _lootDeviceBag = [];

switch (teamPlayer) do {
     case independent: {_lootDeviceBag append rebelBackpackDevice};
     default {_lootDeviceBag append occupantBackpackDevice};
};
lootDevice append _lootDeviceBag + allBackpacksRadio;

////////////////////////////////////
//      REBEL STARTING ITEMS     ///
////////////////////////////////////
//KEEP AT BOTTOM!!!
initialRebelEquipment append allMaps + allWatches + allCompasses + allFirstAidKits;
{
    initialRebelEquipment pushBack [_x, 1, 5];
} forEach (allMedikits + allToolkits);
initialRebelEquipment append (A3A_faction_reb getVariable "uniforms");
initialRebelEquipment append (A3A_faction_civ getVariable "uniforms");
initialRebelEquipment append allCosmeticHeadgear;
initialRebelEquipment append allCosmeticGlasses;
