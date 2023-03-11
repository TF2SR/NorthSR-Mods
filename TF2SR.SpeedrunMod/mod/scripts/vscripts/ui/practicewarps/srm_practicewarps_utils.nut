global function SRM_InitWarpsMenu

global function SRM_LoadGauntletWarp
global function SRM_LoadBTWarp
global function SRM_LoadBNRWarp
global function SRM_LoadITAWarp
global function SRM_LoadENCWarp
global function SRM_LoadBWarp
global function SRM_LoadTBFWarp
global function SRM_LoadArkWarp
global function SRM_LoadFoldWarp

void function SRM_InitWarpsMenu( string menuName, array<string> startPointNames, void functionref(var) loadFunc )
{
	var menu = GetMenu( menuName )
	var button

	for (int i=0; i<startPointNames.len(); i++)
	{
		button = Hud_GetChild( menu, "BtnWarp" + i.tostring() )
		SetButtonRuiText( button, startPointNames[i] )
		AddButtonEventHandler( button, UIE_CLICK, loadFunc )
	}
}

void function GetStartpoint( var button )
{
	int buttonID = Hud_GetScriptID( button ).tointeger()
	SetConVarInt("sp_difficulty", 0)
	// math here gets rid of the leading 100x digit denoting chapters
	SetConVarInt("sp_startpoint", buttonID - (buttonID/100) * 100)
}

void function SRM_LoadGauntletWarp( var button )
{
	GetStartpoint(button)
	ClientCommand("map sp_training")
}

void function SRM_LoadBTWarp( var button )
{
	GetStartpoint(button)
	ClientCommand("map sp_crashsite")
}

void function SRM_LoadBNRWarp( var button )
{
	GetStartpoint(button)
	ClientCommand("map sp_sewers1")
}

void function SRM_LoadITAWarp( var button )
{
	array<string> itaBsps = ["sp_boomtown_start", "sp_boomtown", "sp_boomtown_end"]
	GetStartpoint(button)
	string levelBsp = itaBsps[Hud_GetScriptID(button).tointeger()/100 - 1]
	ClientCommand("map " + levelBsp)
}

void function SRM_LoadENCWarp( var button )
{
	array<string> encBsps = ["sp_hub_timeshift", "sp_timeshift_spoke02"]
	GetStartpoint(button)
	string levelBsp = encBsps[Hud_GetScriptID(button).tointeger()/100 - 1]
	ClientCommand("map " + levelBsp)
}

void function SRM_LoadBWarp( var button )
{
	array<string> bBsps = ["sp_beacon", "sp_beacon_spoke0"]
	GetStartpoint(button)
	string levelBsp = bBsps[Hud_GetScriptID(button).tointeger()/100 - 1]
	ClientCommand("map " + levelBsp)
}

void function SRM_LoadTBFWarp( var button )
{
	GetStartpoint(button)
	ClientCommand("map sp_tday")
}

void function SRM_LoadArkWarp( var button )
{
	GetStartpoint(button)
	ClientCommand("map sp_s2s")
}

void function SRM_LoadFoldWarp( var button )
{
	GetStartpoint(button)
	ClientCommand("map sp_skyway_v1")
}