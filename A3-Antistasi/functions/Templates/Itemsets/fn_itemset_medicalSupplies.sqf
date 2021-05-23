/*
 * File: fn_loadout_addMedicalSupplies.sqf
 * Author: Spoffy
 * Description:
 *    Description goes here
 * Params:
 *    _level - Level of supplies to give - 'Minimal', 'Standard' or 'Medic'
 * Returns:
 *    Modified loadout
 * Example Usage:
 *    Example usage goes here
 */

 params ["_level"];

if (_level == "MEDIC") exitWith {
	switch (true) do {
		case (A3A_hasACEMedical): {
			[
				["ACE_surgicalKit",1],

				["ACE_PackingBandage",15],
				["ACE_ElasticBandage",10],
				["ACE_QuikClot",10],

				["ACE_Morphine",5],
				["ACE_Epinephrine",5],
				["ACE_Adenosine",5],

				["ACE_PlasmaIV_250",5],
				["ACE_SalineIV_500",3],
				["ACE_BloodIV",1],

				["ACE_Tourniquet",3],
				["ACE_Splint",4]
			]
		};
		default {
			private _mediKits = A3A_faction_reb getVariable ["mediKits",["Medikit"]];
			private _firstAidKits = A3A_faction_reb getVariable ["firstAidKits",["FirstAidKit"]];
			[
				[_mediKits#0, 1],
				[_firstAidKits#0,10]
			]
			};
		};
	};

	if (_level == "STANDARD") exitWith {
	switch (true) do {
		case (A3A_hasACEMedical): {
			[
				["ACE_Tourniquet",1],
				["ACE_SalineIV_500",1],
				["ACE_Morphine",2],
				["ACE_Epinephrine",2],
				["ACE_Adenosine",2],
				["ACE_PackingBandage",5],
				["ACE_ElasticBandage",3],
				["ACE_Quikclot",3],
				["ACE_splint", 2]
			]
		};
		default {
			private _firstAidKits = A3A_faction_reb getVariable ["firstAidKits",["FirstAidKit"]];
			[
				[_firstAidKits#0,3]
			]
		};
	};
};
//If neither of them, return minimal medical supplies
switch (true) do {
	case (A3A_hasACEMedical): {
		[
			["ACE_Morphine",1],
			["ACE_Epinephrine",1],
			["ACE_fieldDressing",3]
		]
	};
	default {
		private _firstAidKits = A3A_faction_reb getVariable ["firstAidKits",["FirstAidKit"]];
		[
			[_firstAidKits#0,3]
		]
	};
};