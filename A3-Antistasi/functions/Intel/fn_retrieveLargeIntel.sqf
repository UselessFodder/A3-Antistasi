params ["_intel", "_marker", "_searchAction"];

/*  Handles the action which downloads large intel
*   Params:
*       _intel : OBJECT : The object which is holding the intel
*       _marker : STRING : The string of the marker where the intel is
*       _searchAction : NUMBER : The ID of the action which started this script
*
*   Returns:
*       Nothing
*/

//Remove so no double calls
_intel removeAction _searchAction;

private _bomb = _intel getVariable ["trapBomb", objNull];
private _isTrap = !(isNull _bomb);
if(_isTrap) exitWith
{
    _intel setObjectTextureGlobal [0, "Pictures\laptop_die.jpg"];
    {
        [petros,"hint","The screen says:\nPrepare to die!"] remoteExec ["A3A_fnc_commsMP",_x];
    } forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    sleep (2 + (random 3));
    private _bombPos = getPosWorld _bomb;
    deleteVehicle _bomb;
    _bomb = "DemoCharge_Remote_Ammo_Scripted" createVehicle [0,0,0];
    _bomb setPosWorld _bombPos;
    _bomb setDamage 1;
    deleteVehicle _intel;
};

private _side = sidesX getVariable _marker;
private _isAirport = (_marker in airportsX);

//Hack laptop to get intel
private _pointsPerSecond = 25;
if(tierWar > 4) then
{
  _pointsPerSecond = _pointsPerSecond - (tierWar * 2);
}
else
{
    if(tierWar > 2) then
    {
        _pointsPerSecond = _pointsPerSecond - tierWar
    };
};

private _pointSum = 0;
//Currently DEBUG up to 1000 after testing
private _neededPoints = 1000 + random 1000;
//Min war tier (40 sec - 80 sec) with UAV Hacker (20 sec - 40 sec)
//Max war tier (200 sec - 400 sec) with UAV Hacker (100 sec - 200 sec)

{
    private _friendly = _x;
    diag_log format ["Current object : %1", _friendly];
    if (captive _friendly) then
    {
        [_friendly,false] remoteExec ["setCaptive",0,_friendly];
        _friendly setCaptive false;
    };
} forEach ([200, 0, _intel, teamPlayer] call A3A_fnc_distanceUnits);

private _noAttackChance = 0.2;
if(_isAirport) then
{
    _noAttackChance = 0;
}
else
{
    if(tierWar > 3) then
    {
        _noAttackChance = _noAttackChance - 0.02 * tierWar;
    };
};
private _largeAttackChance = 0.2;
if(_isAirport) then
{
    _largeAttackChance = 0.4;
}
else
{
    if(tierWar > 3) then
    {
        _largeAttackChance = _largeAttackChance + 0.02 * tierWar;
    };
};
private _attack = selectRandomWeighted ["No", _noAttackChance, "Small", 0.6, "Large", _largeAttackChance];
private _isLargeAttack = (_attack == "Large");
if(!(_attack == "No")) then
{
    private _attackType = "";
    if(tierWar < 5) then
    {
        _attackType = "Normal";
    }
    else
    {
        _attackType = selectRandomWeighted ["Normal", 0.6, "Tank", 0.4];
    };
    [[_marker, _side, _attackType, _isLargeAttack],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2];
};

_intel setVariable ["ActionNeeded", false];
["", 0, 0] params ["_errorText", "_errorChance", "_enemyCounter"];

_intel setObjectTextureGlobal [0, "Pictures\laptop_downloading.jpg"];
while {_pointSum <= _neededPoints} do
{
    sleep 1;

    //Checking for players in range
    private _playerList = [20, 0, _intel, teamPlayer] call A3A_fnc_distanceUnits;
    if({[_x] call A3A_fnc_canFight} count _playerList == 0) exitWith
    {
        _pointSum = 0;
        {[petros,"hint","No one in range of the intel, reseting download!"] remoteExec ["A3A_fnc_commsMP",_x]} forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    };

    //Checking if the terminal should throw some error
    private _actionNeeded = _intel getVariable ["ActionNeeded", false];
    if(!_actionNeeded) then
    {
        _errorChance = _errorChance + 1 + (0.1 * tierWar);
        if(random 1000 < _errorChance) then
        {
            //"Something went wrong, oopsie", generating error message to force player to move to the intel laptop
            _actionNeeded = true;
            _intel setVariable ["ActionNeeded", true];
            private _error = selectRandomWeighted ["Err_Sml_01", 0.25, "Err_Sml_02", 0.2, "Err_Sml_03", 0.15, "Err_Med_01", 0.15, "Err_Med_02", 0.15, "Err_Lar_01", 0.1];
            private _actionText = "";
            private _penalty = 0;
            private _picturePath = "";
            switch (_error) do
            {
                case ("Err_Sml_01"):
                {
                    _errorText = "Data Fragment Error. File {002451%12-215502%} has to be confirmed manually!";
                    _actionText = "Confirm file";
                    _penalty = 150 + random 100;
                    _picturePath = "error1";
                };
                case ("Err_Sml_02"):
                {
                    _errorText = "404 Error on server. URL incorrect. Skip URL?";
                    _actionText = "Skip URL";
                    _penalty = 150 + random 50;
                    _picturePath = "error2";
                };
                case ("Err_Sml_03"):
                {
                    _errorText = "Windows needs an update. Update now and lose all data?";
                    _actionText = "Stop windows update";
                    _penalty = 200 + random 150;
                    _picturePath = "error3";
                };
                case ("Err_Med_01"):
                {
                    _errorText = "Download port closed on server. Manual reroute required!";
                    _actionText = "Reroute download";
                    _penalty = 250 + random 150;
                    _picturePath = "error4";
                };
                case ("Err_Med_02"):
                {
                    _errorText = "Error in NetworkAdapter. Hardware not responding. Restart now?";
                    _actionText = "Restart NetworkAdapter";
                    _penalty = 350 + random 100;
                    _picturePath = "error5";
                };
                case ("Err_Lar_01"):
                {
                    _errorText = "Critical Error in network infrastructur. Server returned ErrorCode: CRITICAL_ARMA_PROCESS_DIED";
                    _actionText = "Restart server process";
                    _penalty = 600 + random 250;
                    _picturePath = "error6";
                };
            };
            _picturePath = format ["Pictures\laptop_%1.jpg", _picturePath];
            _intel setObjectTextureGlobal [0, _picturePath];
            _intel addAction
            [
                _actionText,
                {
                    (_this select 0) setVariable ["ActionNeeded", false];
                    (_this select 0) removeAction (_this select 2);
                    (_this select 0) setObjectTextureGlobal [0, "Pictures\laptop_downloading.jpg"];
                },nil,4,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4
            ];
            _pointSum = _pointSum - _penalty;
            if(_pointSum < 0) then {_pointSum = 0};
            _errorChance = 0;
        };
    };

    //Sending in enemy troups to secure the terminal
    if(_enemyCounter > 10) then
    {
        {
            _x doMove (getPos _intel);
        } forEach ([300, 0, _intel, Invaders] call A3A_fnc_distanceUnits);
        {
            _x doMove (getPos _intel);
        } forEach ([300, 0, _intel, Occupants] call A3A_fnc_distanceUnits);
        _enemyCounter = 0;
    }
    else
    {
        _enemyCounter = _enemyCounter + 1;
    };

    if(_actionNeeded) then
    {
        {
            [petros,"intelError", _errorText] remoteExec ["A3A_fnc_commsMP",_x]
        } forEach _playerList;
    }
    else
    {
        _UAVHacker = (_playerList findIf {_x getUnitTrait "UAVHacker"} != -1);
        if(_UAVHacker) then
        {
            _pointSum = _pointSum + (_pointsPerSecond * 2);
        }
        else
        {
            _pointSum = _pointSum + _pointsPerSecond;
        };
        {
            [petros,"hintS", format ["Download at %1%2",((round ((_pointSum/_neededPoints) * 10000))/ 100), "%"]] remoteExec ["A3A_fnc_commsMP",_x]
        } forEach _playerList;
    };
};

_intel setVariable ["ActionNeeded", nil];

if(_pointSum >= _neededPoints) then
{
    _intel setObjectTextureGlobal [0, "Pictures\laptop_completed.jpg"];
    {
        [petros,"hint","You managed to download the intel!"] remoteExec ["A3A_fnc_commsMP",_x];
        [10,_x] call A3A_fnc_playerScoreAdd;
    } forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    [5, theBoss] call A3A_fnc_playerScoreAdd;
    ["Large", _side] spawn A3A_fnc_selectIntel;
}
else
{
    //Players failed to retrieve the intel
    removeAllActions _intel;
    _intel addAction ["Retrieve Intel", {["Large", _this select 0, _this select 3, false, _this select 2] call A3A_fnc_retrieveIntel}, _marker,4,false,true,"","(isPlayer _this)",4];

};