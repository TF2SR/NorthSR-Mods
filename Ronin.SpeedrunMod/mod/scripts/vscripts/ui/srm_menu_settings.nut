global function SRM_InitSettingsMenu
global function SRM_AddSettingSubmenus


void function SRM_InitSettingsMenu()
{
	SRM_MenuInit( "SRM_SettingsMenu" )

	// HUD
	SRM_SetupNormalButton( "SwchSpeedometer", "Speedometer", "Enables a speedometer in single player."+mustReloadNote )
	AddButtonEventHandler(
		SRM_SetupNormalButton( "BtnSpeedometerSettings", "Speedometer Settings", "Settings that control the behavior of the Speedometer" ),
		UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "SRM_SpeedometerSettingsMenu" ) )
	)
	SRM_SetupNormalButton( "SwchInputDisplay", "Input Display", "`1Movement Input Display: `0Shows your WASD, jump and crouch inputs on your screen around your crosshair.\n\nRecommended for leaderboard submissions"+mustReloadNote )
	AddButtonEventHandler(
		SRM_SetupNormalButton( "BtnInputDisplaySettings", "Input Display Settings", "Settings for the appearance of the Input Display" ),
		UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "SRM_InputDisplaySettingsMenu" ) )
	)
	SRM_SetupNormalButton( "SwchShowFPS", "Show FPS", "`1FPS: `0Shows a large overlay with FPS and server tickrate\n\n`1FPS/Graph: `0Shows a large FPS overlay and performance graph" )
	SRM_SetupNormalButton( "SwchShowPos", "Show Position", "`1Player Position: `0Shows position, angle and velocity from the player model\n\n`1Camera Position: `0Shows position, angle and velocity from the player camera" )

	// Practice Tools
	AddButtonEventHandler(
		SRM_SetupNormalButton( "SwchPracticeMode", "Practice Mode", lbIllegalNote+"`1Some extra tools and settings to make practice a bit easier\n\n`0- Sets sv_cheats to 1\n- Disables input prevention on saveload\n- Makes quicksaves save your velocity\n- Enables use of savestates\n\nNote: Savestates do not account for level progression or NPC positions, as it simply teleports you back to the place where you created the savestate." ),
		UIE_CLICK, SRM_ClickedPracticeMode
	)
	SRM_SetupNormalButton( "SwchForceMoonboots", "Force Moonboots", lbIllegalNote+"`1Forcefully enables moonboots.\n\n`2Does not work on NCS saves" )
	AddButtonEventHandler(
		SRM_SetupNormalButton( "BtnPracticeWarps", "Practice Warps", "Warp to dev start points throughout the game to practice segments" ),
		UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "SRM_PracticeWarpsMenu" ) )
	)

	// Utility
	SRM_SetupNormalButton( "SwchCrouchKickFix", "Crouch Kick Fix", "`1Adds an 8 ms Buffer to your jump and crouch inputs.\n\n`0Pressing both Jump and Crouch up to 8 ms apart from each other will register both inputs at the same time\nThe combined input will be registered at the time of your second input" )
	SRM_SetupNormalButton( "SwchEnableMP", "Multiplayer", "`1Enables or disables the multiplayer buttons in the main menu" )
	AddButtonEventHandler( 
		SRM_SetupNormalButton( "BtnResetHelmets", "Reset Helmets", "Reset all the collectible helmet items" ),
		UIE_CLICK, SRM_ClickedResetHelmets
	)
	AddButtonEventHandler( 
		SRM_SetupNormalButton( "BtnUnlockAllLevels", "Unlock all levels", "Unlock all playable levels" ),
		UIE_CLICK, SRM_ClickedUnlockAllLevels
	)

	AddButtonEventHandler(
		SRM_SetupNormalButton( "SwchTasMode", "TAS Mode", lbIllegalNote+"`1Enables some settings to make segmented TASing easier\n\n`0- sv_cheats\n- input debounce\n- audio fade" ),
		UIE_CLICK, SRM_ClickedTasMode
	)

	SRM_SetupFooter()
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

void function SRM_ClickedTasMode( var button )
{
	if (GetConVarInt("fzzy_enableTas") == 1)
	{
		SetConVarInt("sv_cheats", 1)
		// input prevention on load
		SetConVarFloat("player_respawnInputDebounceDuration", 0.0)
		// audio fade
		SetConVarFloat("miles_map_begin_fade_time", 0)
		SetConVarFloat("miles_map_begin_silence_time", 0)
		// command queue to make lower timescales work
		SetConVarInt("sv_usercmd_max_queued", 1000)
	} else
	{
		// revert to default values
		SetConVarInt("sv_cheats", 0)
		SetConVarFloat("player_respawnInputDebounceDuration", 0.5)
		SetConVarFloat("miles_map_begin_fade_time", 1.5)
		SetConVarFloat("miles_map_begin_silence_time", 0.5)
		SetConVarInt("sv_usercmd_max_queued", 40)
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

void function SRM_AddSettingSubmenus()
{
	AddMenu( "SRM_SettingsMenu", $"resource/ui/menus/srm_settings.menu", SRM_InitSettingsMenu)
	AddMenu( "SRM_SpeedometerSettingsMenu", $"resource/ui/menus/srm_speedometer_settings.menu", SRM_InitSpeedometerSettingsMenu)
	AddMenu( "SRM_InputDisplaySettingsMenu", $"resource/ui/menus/srm_input_display_settings.menu", SRM_InitInputDisplaySettingsMenu)
	AddMenu( "SRM_PracticeWarpsMenu", $"resource/ui/menus/srm_practicewarps.menu", SRM_InitPracticeWarpsMenu )
}