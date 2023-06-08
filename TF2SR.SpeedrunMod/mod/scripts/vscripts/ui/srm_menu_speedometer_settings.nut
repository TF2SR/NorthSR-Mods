global function SRM_InitSpeedometerSettingsMenu

struct
{
	var menu
	table<var,string> buttonDescriptions
	var itemDescriptionBox
} file

string colorDescription = "Individual color components.\nThe color will interpolate between the slow & fast components depending on your speed.\n\nFor nerds:\n`1slow`0 is 0\n`1fast`0 is 1000u / 90km/h / 56mph"

void function SRM_InitSpeedometerSettingsMenu()
{
	var menu = GetMenu( "SRM_SpeedometerSettingsMenu" )
	file.menu = menu
	file.itemDescriptionBox = Hud_GetChild( menu, "LblMenuItemDescription" )

	var button = Hud_GetChild( menu, "SwchSpeedometerUnit" )
	SetupButton( button, "Unit", "Determines the measuring unit used for displaying the speed (kph/mph/u)\n\n`2Requires a reload for changes to take effect")
	button = Hud_GetChild( menu, "SwchSpeedometerAxisMode" )
	SetupButton( button, "Axis Mode", "Determine which axes the speedometer should measure")

	button = Hud_GetChild( menu, "SldSpeedometerPositionX" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Position X", "Horizontal position of the Speedometer.\n`10.0`0 = Left\n`11.0`0 = Right\n\n`2Requires a reload for changes to take effect" )
	button = Hud_GetChild( menu, "SldSpeedometerPositionY" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Position Y", "Vertical position of the Speedometer.\n`10.0`0 = Top\n`11.0`0 = Bottom\n\n`2Requires a reload for changes to take effect" )

	button = Hud_GetChild( menu, "SldSpeedometerColorSlowR" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Color R (slow)", colorDescription )
	button = Hud_GetChild( menu, "SldSpeedometerColorSlowG" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Color G (slow)", colorDescription )
	button = Hud_GetChild( menu, "SldSpeedometerColorSlowB" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Color B (slow)", colorDescription )

	button = Hud_GetChild( menu, "SldSpeedometerColorFastR" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Color R (fast)", colorDescription )
	button = Hud_GetChild( menu, "SldSpeedometerColorFastG" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Color G (fast)", colorDescription )
	button = Hud_GetChild( menu, "SldSpeedometerColorFastB" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Color B (fast)", colorDescription )

	button = Hud_GetChild( menu, "SldSpeedometerAlpha" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "Alpha", "Transparency of the Speedometer.\n`11.0`0 = Fully opaque\n`10.0`0 = Fully transparent" )

	AddEventHandlerToButtonClass( menu, "RuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )
	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
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