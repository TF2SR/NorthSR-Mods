global function SRM_InitSettingsMenu
global function SRM_AddSettingSubmenus

struct
{
	var menu
	table<var,string> buttonDescriptions
	var itemDescriptionBox
} file

void function SRM_InitSettingsMenu()
{
	var menu = GetMenu( "SRM_SettingsMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SRM_OnOpenSettingsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SRM_OnCloseSettingsMenu )

	file.itemDescriptionBox = Hud_GetChild( menu, "LblMenuItemDescription" )

	// HUD
	SetupButton( Hud_GetChild( menu, "SwchSpeedometer" ), "Speedometer", "Enables a speedometer in single player.\n\n`2Requires a reload for changes to take effect" )
	AddButtonEventHandler(
		SetupButton(
			Hud_GetChild( menu, "BtnSpeedometerSettings" ),
			"Speedometer Settings",
			"Settings that control the behavior of the Speedometer"),
		UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "SRM_SpeedometerSettingsMenu" ) )
	)
	SetupButton( Hud_GetChild( menu, "SwchShowFPS"), "Show FPS", "`1FPS: `0Shows a large overlay with FPS and server tickrate\n\n`1FPS/Graph: `0Shows a large FPS overlay and performance graph")
	SetupButton( Hud_GetChild( menu, "SwchShowPos"), "Show Position", "`1Player Position: `0Shows position, angle and velocity from the player model\n\n`1Camera Position: `0Shows position, angle and velocity from the player camera")
	
	// Practice Tools
	AddButtonEventHandler(
		SetupButton(
			Hud_GetChild( menu, "SwchPracticeMode"),
			"Practice Mode",
			"`2NOT LEADERBOARD LEGAL!\n\n`1Some extra tools and settings to make practice a bit easier\n\n`0- Sets sv_cheats to 1\n- Disables input prevention on saveload\n- Makes quicksaves save your velocity\n- Enables use of savestates\n\nNote: Savestates do not account for level progression or NPC positions, as it simply teleports you back to the place where you created the savestate."
			),
		UIE_CLICK, SRM_ClickedPracticeMode
	)
	SetupButton(
		Hud_GetChild( menu, "SwchForceMoonboots"),
		"Force Moonboots",
		"`2NOT LEADERBOARD LEGAL!\n\n`1Forcefully enables moonboots."
		)
	AddButtonEventHandler(
		SetupButton(
			Hud_GetChild( menu, "BtnPracticeWarps" ),
			"Practice Warps",
			"Warp to dev start points throughout the game to practice segments"),
		UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "SRM_PracticeWarpsMenu" ) )
	)

	// Utility
	SetupButton( Hud_GetChild( menu, "SwchCrouchKickFix"), "Crouch Kick Fix", "`1Adds an 8 ms Buffer to your jump and crouch inputs.\n\n`0Pressing both Jump and Crouch up to 8 ms apart from each other will register both inputs at the same time\nThe combined input will be registered at the time of your second input")
	SetupButton( Hud_GetChild( menu, "SwchEnableMP"), "Multiplayer", "`1Enables or disables the multiplayer buttons in the main menu")
	AddButtonEventHandler( 
		SetupButton( 
			Hud_GetChild( menu,
				"BtnResetHelmets" ),
				"Reset Helmets",
				"Reset all the collectible helmet items"),
		UIE_CLICK, SRM_ClickedResetHelmets
	)
	AddButtonEventHandler( 
		SetupButton( 
			Hud_GetChild( menu,
				"BtnUnlockAllLevels" ),
				"Unlock all levels",
				"Unlock all playable levels"),
		UIE_CLICK, SRM_ClickedUnlockAllLevels
	)

	AddEventHandlerToButtonClass( menu, "RuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )
	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function SRM_ClickedPracticeMode( var button )
{
	if (GetConVarInt("srm_practice_mode") == 1)
	{
		SetConVarInt("sv_cheats", 1)
		SetConVarFloat("player_respawnInputDebounceDuration", 0.0)
	}
	else
	{
		SetConVarInt("sv_cheats", 0)
		SetConVarFloat("player_respawnInputDebounceDuration", 0.5)
	}
}

void function SRM_ClickedResetHelmets( var button )
{
    ResetCollectiblesProgress_All()
	SRM_ConfirmDialog( "Helmet Reset", "Helmet Collectibles have been reset", "OK" )
}

void function SRM_ClickedUnlockAllLevels( var button )
{
	SetConVarInt( "sp_unlockedMission", 9 )
	SRM_ConfirmDialog( "Level unlock", "All levels have been unlocked", "OK" )
}

void function SRM_OnOpenSettingsMenu()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )
}

void function SRM_OnCloseSettingsMenu()
{
	SavePlayerSettings()
}

void function SRM_AddSettingSubmenus()
{
	AddMenu( "SRM_SettingsMenu", $"resource/ui/menus/srm_settings.menu", SRM_InitSettingsMenu)
	AddMenu( "SRM_SpeedometerSettingsMenu", $"resource/ui/menus/srm_speedometer_settings.menu", SRM_InitSpeedometerSettingsMenu)
	AddMenu( "SRM_PracticeWarpsMenu", $"resource/ui/menus/srm_practicewarps.menu", SRM_InitPracticeWarpsMenu )
}

var function SetupButton( var button, string buttonText, string description )
{
	SetButtonRuiText( button, buttonText )
	file.buttonDescriptions[ button ] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, Button_Focused )
	return button
}

void function Button_Focused( var button )
{
	string description = file.buttonDescriptions[button]
	RuiSetString( Hud_GetRui( file.itemDescriptionBox ), "description", description )
}

void function FooterButton_Focused( var button )
{
	RuiSetString( Hud_GetRui( file.itemDescriptionBox ), "description", "" )
}