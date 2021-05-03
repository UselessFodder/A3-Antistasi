/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from posRegions

Arguments:
    <DISPLAY> _display
    <SCALAR> _button
    <SCALAR> _xPos
    <SCALAR> _yPos
    <BOOLEAN> _shift
    <BOOLEAN> _ctrl
    <BOOLEAN> _alt

Return Value:
    <BOOLEAN> true if deleted, false if not found.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: No
Dependencies:
    scalar _fullSelectionRadius in parent scope
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "posRegionHM")
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "navGridHM")

Example:
    [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_hover_modeConnect;
*/
params ["_worldPos"];


A3A_NGSA_brushSelectionRadius = _fullSelectionRadius;      // Can be much bigger as it fetches all map regions within a pixelated circle. Too big will still slow down.
A3A_NGSA_modeConnect_lineName setMarkerAlpha 0;// Broadcasts
if ("shift" in A3A_NGSA_depressedKeysHM) then {
    A3A_NGSA_brushSelectionRadius = (A3A_NGSA_brushSelectionRadius*2) min 2000;    // Is reset every cycle, so it won't keep growing.
};

if (A3A_NGSA_toolModeChanged) then {
    A3A_NGSA_UI_marker0_name setMarkerShapeLocal "ELLIPSE";
    A3A_NGSA_UI_marker1_name setMarkerShapeLocal "ELLIPSE";
    A3A_NGSA_UI_marker1_name setMarkerBrushLocal "Border";
    [
        "Street Artist Help",
        "<t size='1' align='left'><t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Brush Tool</t><br/>"+   // The titles use a special space for the underlining to work.
        "<t color='#f0d498'>'click'</t>-Set connection to selected type<br/>"+
        "<t color='#f0d498'>'shift'+'click'</t>-Double the brush size<br/>"+
        "<t color='#f0d498'>'alt'+'click'</t>-Delete nodes under brush.<br/>"+
        "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Connection Types</t><br/>"+   // The titles use a special space for the underlining to work.
        "<t color='#f0d498'>'C'</t>-Cycle connection type.<br/>"+
        "<t color='#f57a21'>Orange</t>-Track, dirt/narrow/bumpy<br/>"+
        "<t color='#cfc01c'>Yellow</t>-Road, asphalt/cement/smooth/<br/>"+
        "<t color='#26c91e'>Green</t>-Main Road, smooth/wide/large turns<br/>"+
        "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Node Connections</t><br/>"+   // The titles use a special space for the underlining to work.
        "Black:0  Red:1  Orange:2  Yellow:3  Green:4  Blue:5+<br/>"+
        "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>General</t><br/>"+
        "<t color='#f0d498'>'F'</t>-Cycle tool<br/>"+
        "<t color='#f0d498'>'ctrl'+'S'</t>-Export changes<br/>"+
        "<t color='#f0d498'>'ctrl'+'D'</t>-Cycle Island Colour Division.<br/>"+
        "<t color='#f0d498'>'ctrl'+'R'</t>-Refresh Markers<br/>"+
        "</t>",
        true
    ] call A3A_fnc_customHint;
};
/*
Marker0 is used for fill.
Marker1 is used for border.
*/
A3A_NGSA_UI_marker0_name setMarkerSizeLocal [A3A_NGSA_brushSelectionRadius, A3A_NGSA_brushSelectionRadius];
A3A_NGSA_UI_marker1_name setMarkerSizeLocal [A3A_NGSA_brushSelectionRadius, A3A_NGSA_brushSelectionRadius];
switch (true) do {
    case ("alt" in A3A_NGSA_depressedKeysHM): {
        A3A_NGSA_UI_marker0_name setMarkerBrushLocal "FDiagonal";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorRed";
        A3A_NGSA_UI_marker1_name setMarkerColorLocal "ColorRed";

        if ("mbt0" in A3A_NGSA_depressedKeysHM) then {
            [_worldPos,"shift" in A3A_NGSA_depressedKeysHM, "ctrl" in A3A_NGSA_depressedKeysHM, true] call A3A_fnc_NGSA_click_modeBrush;
            A3A_NGSA_modeBrush_recentDeletion = true;
        } else {
            if !(A3A_NGSA_modeBrush_recentDeletion) exitWith {};
            A3A_NGSA_modeBrush_recentDeletion = false;
            call A3A_fnc_NGSA_action_autoRefresh;
        };
    };
    default {
        private _roadColour = ["ColorOrange","ColorYellow","ColorGreen"] # A3A_NGSA_modeConnect_roadTypeEnum;
        A3A_NGSA_UI_marker0_name setMarkerBrushLocal "Cross";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal _roadColour;
        A3A_NGSA_UI_marker1_name setMarkerColorLocal "ColorBlack";

        if ("mbt0" in A3A_NGSA_depressedKeysHM) then {
            [_worldPos,"shift" in A3A_NGSA_depressedKeysHM, "ctrl" in A3A_NGSA_depressedKeysHM, false] call A3A_fnc_NGSA_click_modeBrush;
        };
    };
};
A3A_NGSA_UI_marker0_name setMarkerPos _worldPos; // Broadcasts marker attributes here
A3A_NGSA_UI_marker1_name setMarkerPos _worldPos; // Broadcasts marker attributes here