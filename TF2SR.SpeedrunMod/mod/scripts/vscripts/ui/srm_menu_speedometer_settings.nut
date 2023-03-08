global function SRM_InitSpeedometerSettingsMenu

struct
{
	var menu
	table<var,string> buttonDescriptions
	var itemDescriptionBox
} file

void function SRM_InitSpeedometerSettingsMenu()
{
	var menu = GetMenu( "SRM_SpeedometerSettingsMenu" )
	file.menu = menu
	file.itemDescriptionBox = Hud_GetChild( menu, "LblMenuItemDescription" )

	SetupButton( Hud_GetChild( menu, "SwchSpeedometerUnit"), "Unit", "Determines the measuring unit used for displaying the speed (kph/mph)")
	SetupButton( Hud_GetChild( menu, "SwchSpeedometerIncludeZ"), "Include Z axis", "Include the Z axis in the speed calculation or only the horizontal plane")
	SetupButton( Hud_GetChild( menu, "SwchSpeedometerFadeout"), "Fadeout", "Fade out the speedometer when moving at low speeds")

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