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
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "posRegionHM")
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "navGridHM")

Example:
    [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_hover_modeConnect;
*/
params ["_worldPos"];

private _navGridPosRegionHM = [localNamespace,"A3A_NGPP","navGridPosRegionHM",0] call Col_fnc_nestLoc_get;
private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;

private _targetPos = [];
private _closestDistance = A3A_NGSA_maxSelectionRadius; // max selection
{
    private _distance = _x distance2D _worldPos;
    if (_distance < _closestDistance) then {
        _closestDistance = _distance;
        _targetPos = _x;
    };
} forEach ([_navGridPosRegionHM,_worldPos] call A3A_fnc_NGSA_posRegionHM_allAdjacent);

A3A_NGSA_modeConnect_targetExists = count _targetPos != 0;
if (A3A_NGSA_modeConnect_targetExists) then {
    A3A_NGSA_modeConnect_targetNode = _navGridHM get _targetPos;
};

A3A_NGSA_UI_marker0_pos = [_worldPos,_targetPos] select A3A_NGSA_modeConnect_targetExists;

private _lineColour = ["ColorOrange","ColorYellow","ColorGreen"] #A3A_NGSA_modeConnect_roadTypeEnum; // ["TRACK", "ROAD", "MAIN ROAD"]
private _lineStartPos = +A3A_NGSA_UI_marker1_pos;
private _lineEndPos = _targetPos;
private _lineBrush = "SolidFull";

if (A3A_NGSA_toolModeChanged) then {
    A3A_NGSA_UI_marker1_name setMarkerShapeLocal "ICON";
    A3A_NGSA_UI_marker0_name setMarkerShapeLocal "ICON";
    [
        "Street Artist Help",
        "<t size='1' align='left'><t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Connection Tool</t><br/>"+   // The titles use a special space for the underlining to work.
        "<t color='#f0d498'>'click'</t>-Select &amp; connect roads<br/>"+
        "<t color='#f0d498'>'shift'+'click'</t>-Create new node<br/>"+
        "<t color='#f0d498'>'alt'</t>-Deselect node<br/>"+
        "<t color='#f0d498'>'alt'+'click'</t>-Delete node<br/>"+
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
Marker0 is used for icon under cursor.
Marker1 is used for selected node.
*/

A3A_NGSA_UI_marker1_name setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
A3A_NGSA_UI_marker1_name setMarkerType (["Empty","mil_start"] select (A3A_NGSA_modeConnect_selectedExists && A3A_NGSA_UI_marker0_pos isNotEqualTo A3A_NGSA_UI_marker1_pos));       // Broadcasts for selected marker.
A3A_NGSA_UI_marker1_name setMarkerColorLocal _lineColour;

A3A_NGSA_UI_marker0_name setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
switch (true) do {       // Broadcast here.
    case ("shift" in A3A_NGSA_depressedKeysHM): {                       // Add new node
        A3A_NGSA_UI_marker0_pos = _worldPos;
        _lineEndPos = _worldPos;
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "mil_destroy_noShadow";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal (["ColorRed","ColorBlack"] select ([_worldPos] call A3A_fnc_NGSA_isValidRoad));
    };
    case ("alt" in A3A_NGSA_depressedKeysHM): {                         // Deselect current. Delete node.
        A3A_NGSA_modeConnect_selectedExists = false;
        A3A_NGSA_modeConnect_selectedNode = [];
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "KIA";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
        A3A_NGSA_UI_marker1_name setMarkerType "Empty";
    };
    case (!A3A_NGSA_modeConnect_targetExists && !A3A_NGSA_modeConnect_selectedExists): {    // Nothing under cursor, and nothing selected // Nothing
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "selector_selectable";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
    };
    case (!A3A_NGSA_modeConnect_targetExists): {                        // Nothing under cursor, there is a node selected. //Deselect
        _lineEndPos = _worldPos;
        A3A_NGSA_UI_marker0_name setMarkerSizeLocal [1.2,1.2];
        _lineBrush = "DiagGrid";
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "waypoint";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
    };
    case (!A3A_NGSA_modeConnect_selectedExists): {                      // Node under cursor, nothing selected. // Select
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "selector_selectable";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
    };
    case (A3A_NGSA_UI_marker0_pos isEqualTo A3A_NGSA_UI_marker1_pos): { // Already selected node under cursor. // Deselect
        A3A_NGSA_UI_marker0_name setMarkerSizeLocal [1.2,1.2];
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "waypoint";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
    };
    case ((A3A_NGSA_modeConnect_targetNode#3) findIf {(_x#0) isEqualTo (A3A_NGSA_modeConnect_selectedNode#0)} != -1): { // Node under cursor is connected to select node. // Disconnect nodes.
        _lineColour = "ColorRed";
        _lineBrush = "DiagGrid";
        A3A_NGSA_UI_marker0_name setMarkerTypeLocal "mil_objective";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorRed";
        A3A_NGSA_UI_marker1_name setMarkerType "mil_objective";
        A3A_NGSA_UI_marker1_name setMarkerColorLocal "ColorRed";
    };
    default {                                                           // Node under cursor, and a node is selected // Connect nodes.
        A3A_NGSA_UI_marker0_name setMarkerType "mil_pickup";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal _lineColour;
    };
};
A3A_NGSA_UI_marker0_name setMarkerPos A3A_NGSA_UI_marker0_pos; // Broadcasts marker attributes here



if (A3A_NGSA_modeConnect_selectedExists) then {
    A3A_NGSA_modeConnect_lineName setMarkerAlphaLocal 1;
    [A3A_NGSA_modeConnect_lineName,true,_lineStartPos,_lineEndPos,_lineColour,A3A_NGSA_lineBaseSize,_lineBrush] call A3A_fnc_NG_draw_line;
};