/*
Maintainer: Caleb Serafin
    Adds a mouse click eventHandler to the map.

Arguments:
    <navGridHM> Needed for mouse event code
    <posRegions> Needed for mouse event code

Return Value:
    <BOOLEAN> true if added.

Scope: Client
Environment: Unscheduled
Public: No
Dependants Created:
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> A3A_NGSA_selectedStruct;
    <STRING> A3A_NGSA_modeConnect_selMarkerName;

Example:
    [] spawn A3A_fnc_NGSA_EH_add;
*/
#include "\a3\ui_f\hpp\definedikcodes.inc";

params [
    "_navGridHM",
    "_navGridPosRegionHM"
];

[localNamespace,"A3A_NGPP","navGridHM",_navGridHM] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","navGridPosRegionHM",_navGridPosRegionHM] call Col_fnc_nestLoc_set;

waitUntil {
    uiSleep 0.5;
    !isNull findDisplay 12 && !isNull findDisplay 46;
};
private _map = findDisplay 12;
private _gameWindow = findDisplay 46;

A3A_NGSA_DIKToKeyName = createHashMapFromArray [
    [DIK_LSHIFT,"shift"],
    [DIK_RSHIFT,"shift"],
    [DIK_LCONTROL,"ctrl"],
    [DIK_RCONTROL,"ctrl"],
    [DIK_LALT,"alt"],
    [DIK_RALT,"alt"],
    [DIK_C,"c"],
    [DIK_D,"d"],
    [DIK_F,"f"],
    [DIK_H,"h"],
    [DIK_R,"r"],
    [DIK_S,"s"],
    [DIK_V,"v"]
];
A3A_NGSA_depressedKeysHM = createHashMap;    // Will always be sorted, this allows direct array comparison

A3A_NGSA_dotBaseSize = 1.2;
A3A_NGSA_lineBaseSize = 4;
A3A_NGSA_nodeOnlyOnRoad = true;

A3A_NGSA_clickModeEnum = 1;
A3A_NGSA_toolModeChanged = true;
A3A_NGSA_maxSelectionRadius = 50; // metres
A3A_NGSA_brushSelectionRadius = 50; // meters

A3A_NGSA_UI_marker0_name = "A3A_NGSA_UI_marker0";
A3A_NGSA_UI_marker0_pos = [0,0];
createMarker [A3A_NGSA_UI_marker0_name,A3A_NGSA_UI_marker0_pos];
A3A_NGSA_UI_marker1_name = "A3A_NGSA_UI_marker1";
A3A_NGSA_UI_marker1_pos = [0,0];
createMarker [A3A_NGSA_UI_marker1_name,A3A_NGSA_UI_marker1_pos];

A3A_NGSA_modeConnect_roadTypeEnum = 0;
A3A_NGSA_modeConnect_targetExists = false;
A3A_NGSA_modeConnect_targetNode = [];
A3A_NGSA_modeConnect_selectedExists = false;
A3A_NGSA_modeConnect_selectedNode = [];

A3A_NGSA_modeConnect_lineName = "A3A_NGSA_UI_modeConnect_line";
createMarkerLocal [A3A_NGSA_modeConnect_lineName,[0,0]];

A3A_NGSA_modeBrush_recentDeletion = false;
A3A_NGSA_refresh_busy = false;

private _mapEH_mouseDown = _map displayAddEventHandler ["MouseButtonDown", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    if !(A3A_NGSA_depressedKeysHM set [["mbt0","mbt1"]#_button,[_shift, _ctrl, _alt]]) then {   // Will only be left or right
        _this call A3A_fnc_NGSA_onMouseClick;   // Only fires on new keys.
    };
    nil;
}];
private _mapEH_mouseUp = _map displayAddEventHandler ["MouseButtonUp", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM deleteAt (["mbt0","mbt1"]#_button);    // Will only be left or right
    nil;
}];
[localNamespace,"A3A_NGPP","mapEH_mouseDown",_mapEH_mouseDown] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","mapEH_mouseUp",_mapEH_mouseUp] call Col_fnc_nestLoc_set;


private _missionEH_eachFrame_ID = addMissionEventHandler ["EachFrame", {
    //params ["_control"];
    call A3A_fnc_NGSA_onUIUpdate;
}];
[localNamespace,"A3A_NGPP","MissionEH_eachFrame_ID",_missionEH_eachFrame_ID] call Col_fnc_nestLoc_set;



private _missionEH_keyDown = _gameWindow displayAddEventHandler ["KeyDown", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    private _return = false;
    if !(A3A_NGSA_depressedKeysHM set [A3A_NGSA_DIKToKeyName getOrDefault [_key,_key],[_shift, _ctrl, _alt]]) then {
        _return = _this call A3A_fnc_NGSA_onKeyDown;   // Only fires on new keys.
    };
    _return;
}];
private _missionEH_keyUp = _gameWindow displayAddEventHandler ["KeyUp", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM deleteAt (A3A_NGSA_DIKToKeyName getOrDefault [_key,_key]);
    nil;
}];
[localNamespace,"A3A_NGPP","missionEH_keyDown",_missionEH_keyDown] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","missionEH_keyUp",_missionEH_keyUp] call Col_fnc_nestLoc_set;

true;
