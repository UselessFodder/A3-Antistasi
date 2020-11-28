///////////////////////////
//   Rebel Information   //
///////////////////////////

["name", ""] call _fnc_saveToTemplate; 						//this line determines the faction name -- Example: ["name", "NATO"] - ENTER ONLY ONE OPTION

["flag", ""] call _fnc_saveToTemplate; 						//this line determines the flag -- Example: ["flag", "Flag_NATO_F"] - ENTER ONLY ONE OPTION
["flagTexture", ""] call _fnc_saveToTemplate; 				//this line determines the flag texture -- Example: ["flagTexture", "\A3\Data_F\Flags\Flag_NATO_CO.paa"] - ENTER ONLY ONE OPTION
["flagMarkerType", ""] call _fnc_saveToTemplate; 			//this line determines the flag marker type -- Example: ["flagMarkerType", "flag_NATO"] - ENTER ONLY ONE OPTION

["vehicleBasic", ""] call _fnc_saveToTemplate; 			//this line determines basic vehicles, the lightest kind available. -- Example: ["vehiclesBasic", ["B_Quadbike_01_F"]] -- Array, can contain multiple assets
["vehicleLightUnarmed", ""] call _fnc_saveToTemplate; 		//this line determines light and unarmed vehicles. -- Example: ["vehiclesLightUnarmed", ["B_MRAP_01_F"]] -- Array, can contain multiple assets
["vehicleLightArmed", ""] call _fnc_saveToTemplate; 		//this line determines light and armed vehicles -- Example: ["vehiclesLightArmed",["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehicleTruck", ""] call _fnc_saveToTemplate; 			//this line determines the trucks -- Example: ["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehicleAT", ""] call _fnc_saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets

["vehicleBoat", ""] call _fnc_saveToTemplate; 	//this line determines transport boats -- Example: ["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] -- Array, can contain multiple assets
["vehicleRepair", ""] call _fnc_saveToTemplate; 			//this line determines gun boats -- Example: ["vehiclesGunboats", ["B_Boat_Armed_01_minigun_F"]] -- Array, can contain multiple assets

["vehiclePlane", ""] call _fnc_saveToTemplate; 		//this line determines CAS planes -- Example: ["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] -- Array, can contain multiple assets
["vehicleHeli", ""] call _fnc_saveToTemplate; 		//this line determines light helis -- Example: ["vehiclesHelisLight", ["B_Heli_Light_01_F"]] -- Array, can contain multiple assets

["vehicleCivCar", ""] call _fnc_saveToTemplate;
["vehicleCivTruck", ""] call _fnc_saveToTemplate;
["vehicleCivHeli", ""] call _fnc_saveToTemplate;
["vehicleCivBoat", ""] call _fnc_saveToTemplate;

["staticMG", ""] call _fnc_saveToTemplate; 					//this line determines static MGs -- Example: ["staticMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["staticAT", ""] call _fnc_saveToTemplate; 					//this line determinesstatic ATs -- Example: ["staticAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["staticAA", ""] call _fnc_saveToTemplate; 					//this line determines static AAs -- Example: ["staticAA", ["B_static_AA_F"]] -- Array, can contain multiple assets
["staticMortar", ""] call _fnc_saveToTemplate; 				//this line determines static mortars -- Example: ["staticMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets
["staticMortarMagHE", ""] call _fnc_saveToTemplate;
["staticMortarMagSmoke", ""] call _fnc_saveToTemplate;

//Static weapon definitions
["baggedMGs", []] call _fnc_saveToTemplate; 				//this line determines bagged static MGs -- Example: ["baggedMGs", [["B_HMG_01_high_F", "B_HMG_01_support_high_F"]]] -- Array, can contain multiple assets
["baggedAT", []] call _fnc_saveToTemplate; 				//this line determines bagged static ATs -- Example: ["baggedAT", [["B_static_AT_F", "B_HMG_01_support_F"]]] -- Array, can contain multiple assets
["baggedAA", []] call _fnc_saveToTemplate; 				//this line determines bagged static ATs -- Example: ["baggedAT", [["B_static_AT_F", "B_HMG_01_support_F"]]] -- Array, can contain multiple assets
["baggedMortars", []] call _fnc_saveToTemplate; 			//this line determines bagged static mortars -- Example: ["baggedMortars", [["B_Mortar_01_F", "B_Mortar_01_support_F"]]] -- Array, can contain multiple assets

["mineAT", ""] call _fnc_saveToTemplate; 				//this line determines AT mines used for spawning in minefields -- Example: ["minefieldAT", ["ATMine_Range_Mag"]] -- Array, can contain multiple assets
["mineAPERS", ""] call _fnc_saveToTemplate; 			//this line determines APERS mines used for spawning in minefields -- Example: ["minefieldAPERS", ["APERSMine_Range_Mag"]] -- Array, can contain multiple assets

["breachingExplosivesAPC", []] call _fnc_saveToTemplate;
["breachingExplosivesTank", []] call _fnc_saveToTemplate;

//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _fnc_createLoadoutData;
_loadoutData setVariable ["rifles", []]; 				//this line determines rifles -- Example: ["arifle_MX_F","arifle_MX_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["carbines", []]; 				//this line determines carbines -- Example: ["arifle_MXC_F","arifle_MXC_Holo_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["grenadeLaunchers", []]; 		//this line determines grenade launchers -- Example: ["arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["SMGs", []]; 					//this line determines SMGs -- Example: ["SMG_01_F","SMG_01_Holo_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["machineGuns", []]; 			//this line determines machine guns -- Example: ["arifle_MX_SW_F","arifle_MX_SW_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["marksmanRifles", []]; 		//this line determines markman rifles -- Example: ["arifle_MXM_F","arifle_MXM_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["sniperRifles", []]; 			//this line determines sniper rifles -- Example: ["srifle_LRR_camo_F","srifle_LRR_camo_SOS_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightATLaunchers", []]; 		//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["ATLaunchers", []]; 			//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["missileATLaunchers", []]; 	//this line determines missile AT launchers -- Example: ["launch_B_Titan_short_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["AALaunchers", []]; 			//this line determines AA launchers -- Example: ["launch_B_Titan_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["sidearms", []]; 				//this line determines handguns/sidearms -- Example: ["hgun_Pistol_heavy_01_F", "hgun_P07_F"] -- Array, can contain multiple assets

_loadoutData setVariable ["ATMines", []]; 				//this line determines the AT mines which can be carried by units -- Example: ["ATMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["APMines", []]; 				//this line determines the APERS mines which can be carried by units -- Example: ["APERSMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightExplosives", []]; 		//this line determines light explosives -- Example: ["DemoCharge_Remote_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["heavyExplosives", []]; 		//this line determines heavy explosives -- Example: ["SatchelCharge_Remote_Mag"] -- Array, can contain multiple assets

_loadoutData setVariable ["antiInfantryGrenades", []]; 	//this line determines anti infantry grenades (frag and such) -- Example: ["HandGrenade","MiniGrenade"] -- Array, can contain multiple assets
_loadoutData setVariable ["antiTankGrenades", []]; 		//this line determines anti tank grenades. Leave empty when not available. -- Array, can contain multiple assets
_loadoutData setVariable ["smokeGrenades", []]; 		//this line determines smoke grenades -- Example: ["SmokeShell", "SmokeShellRed"] -- Array, can contain multiple assets


//Basic equipment. Shouldn't need touching most of the time.
//Mods might override this, or certain mods might want items removed (No GPSs in WW2, for example)
_loadoutData setVariable ["maps", ["ItemMap"]];
_loadoutData setVariable ["watches", ["ItemWatch"]];
_loadoutData setVariable ["compasses", ["ItemCompass"]];
_loadoutData setVariable ["radios", ["ItemRadio"]];
_loadoutData setVariable ["gpses", ["ItemGPS"]];
_loadoutData setVariable ["NVGs", []]; //this line determines NVGs -- Array, can contain multiple assets 
_loadoutData setVariable ["binoculars", ["Binocular"]];

_loadoutData setVariable ["uniforms", []];
_loadoutData setVariable ["vests", []];
_loadoutData setVariable ["backpacks", []];
_loadoutData setVariable ["longRangeRadios", []];
_loadoutData setVariable ["helmets", []];

//Item *set* definitions. These are added in their entirety to unit loadouts. No randomisation is applied.
_loadoutData setVariable ["items_medical_basic", [["FirstAidKit", 2]]];
_loadoutData setVariable ["items_medical_standard", [["FirstAidKit", 3]]];
_loadoutData setVariable ["items_medical_medic", ["Medikit", ["FirstAidKit", 10]]];
_loadoutData setVariable ["items_miscEssentials", []];

//Unit type specific item sets. Add or remove these, depending on the unit types in use.
_loadoutData setVariable ["items_squadleader_extras", []];
_loadoutData setVariable ["items_rifleman_extras", []];
_loadoutData setVariable ["items_medic_extras", []];
_loadoutData setVariable ["items_grenadier_extras", []];
_loadoutData setVariable ["items_explosivesExpert_extras", []];
_loadoutData setVariable ["items_engineer_extras", ["Toolkit", "MineDetector"]];
_loadoutData setVariable ["items_lat_extras", []];
_loadoutData setVariable ["items_at_extras", []];
_loadoutData setVariable ["items_aa_extras", []];
_loadoutData setVariable ["items_machineGunner_extras", []];
_loadoutData setVariable ["items_marksman_extras", []];
_loadoutData setVariable ["items_sniper_extras", []];
_loadoutData setVariable ["items_police_extras", []];
_loadoutData setVariable ["items_crew_extras", []];
_loadoutData setVariable ["items_unarmed_extras", []];

///////////////////////////
//  Rebel Starting Gear  //
///////////////////////////

private _initialRebelEquipment = [];
if (hasTFAR) then {initialRebelEquipment append ["tf_microdagr","tf_anprc154"]};
//if (hasTFAR && startWithLongRangeRadio) then {initialRebelEquipment pushBack "LONG_RANGE_RADIO"};

["initialRebelEquipment", _initialRebelEquipment] call _fnc_saveToTemplate;

////////////////////////
//  Rebel Unit Types  //
///////////////////////.

private _squadLeaderTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	//TODO - Long range radios
	[["longRangeRadios", "backpacks"] call _fnc_fallback] call _fnc_addBackpack;

	[["grenadeLaunchers", "rifles"] call _fnc_fallback] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;
	//TODO: How to add underslung grenade mags.

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_squadLeader_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["antiTankGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["gpses"] call _fnc_addGPS;
	["binoculars"] call _fnc_addBinoculars;
	["NVGs"] call _fnc_addNVGs;
};

private _riflemanTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 8] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_rifleman_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["antiTankGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _medicTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["carbines"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_medic"] call _fnc_addItemSet;
	["items_medic_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _grenadierTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["grenadeLaunchers"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;
	//TODO: How to add underslung grenade mags.

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_grenadier_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 4] call _fnc_addItem;
	["antiTankGrenades", 3] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _explosivesExpertTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;
	//TODO: How to add underslung grenade mags.

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_grenadier_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	["lightExplosives", 2] call _fnc_addItem;
	if (random 1 > 0.5) then {["heavyExplosives", 1] call _fnc_addItem;};
	if (random 1 > 0.5) then {["atMines", 1] call _fnc_addItem;};
	if (random 1 > 0.5) then {["apMines", 1] call _fnc_addItem;};

	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _engineerTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["carbines"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_engineer_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	if (random 1 > 0.5) then {["lightExplosives", 1] call _fnc_addItem;};

	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _latTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 8] call _fnc_addMagazines;

	[["lightATLaunchers", "ATLaunchers"] call _fnc_fallback] call _fnc_addLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 1] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_lat_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["antiTankGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _atTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	[selectRandom ["ATLaunchers", "missileATLaunchers"]] call _fnc_addLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 2] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_at_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["antiTankGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _aaTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["AALaunchers"] call _fnc_addLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 2] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_aa_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _machineGunnerTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["machineGuns"] call _fnc_addPrimary;
	["primary", 4] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_machineGunner_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _marksmanTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["marksmanRifles"] call _fnc_addPrimary;
	["primary", 8] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_marksman_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 3] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _sniperTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["sniperRifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_sniper_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 3] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _policeTemplate = {
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	[selectRandom ["smgs", "carbines"]] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_police_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
};

private _crewTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;

	["smgs"] call _fnc_addPrimary;
	["primary", 3] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_basic"] call _fnc_addItemSet;
	["items_crew_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["gpses"] call _fnc_addGPS;
	["NVGs"] call _fnc_addNVGs;
};

private _unarmedTemplate = {
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;

	["items_medical_basic"] call _fnc_addItemSet;
	["items_unarmed_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
};

private _prefix = "loadouts_rebel_";
private _unitTypes = [
	["Petros", _squadLeaderTemplate],
	["SquadLeader", _squadLeaderTemplate],
	["Rifleman", _riflemanTemplate],
	["Medic", _medicTemplate],
	["Engineer", _engineerTemplate],
	["ExplosivesExpert", _explosivesExpertTemplate],
	["Grenadier", _grenadierTemplate],
	["LAT", _latTemplate],
	["AT", _atTemplate],
	["AA", _aaTemplate],
	["MachineGunner", _machineGunnerTemplate],
	["Marksman", _marksmanTemplate],
	["Sniper", _sniperTemplate],
	["Unarmed", _unarmedTemplate]
];

[_prefix, _unitTypes, _loadoutData] call _fnc_saveUnitLoadoutsToTemplate;