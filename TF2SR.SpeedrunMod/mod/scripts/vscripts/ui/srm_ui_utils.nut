globalize_all_functions

struct
{
	var menu
	table<var,string> buttonDescriptions
	var itemDescriptionBox
} file

global string mustReloadNote = "\n\n`2Requires a reload for changes to take effect"
global string lbIllegalNote = "`2NOT LEADERBOARD LEGAL!\n\n"

void function SRM_ConfirmDialog( string header, string message, string confirmMessage )
{
	DialogData dialog
	dialog.header = header
	dialog.message = message
    AddDialogButton( dialog, confirmMessage )
    OpenDialog( dialog )
}

void function SRM_MenuInit( string menuRes, string descriptionBoxRes )
{
	file.menu = GetMenu( menuRes )
	file.itemDescriptionBox = Hud_GetChild( file.menu, descriptionBoxRes )
}

var function SRM_SetupButton( var button, string label, string description )
{
	SetButtonRuiText( button, label )
	file.buttonDescriptions[ button ] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, SRM_Button_Focused )
	return button
}

var function SRM_SetupNormalButton( string resName, string label, string description )
{
	var button = Hud_GetChild( file.menu, resName )
	return SRM_SetupButton( button, label, description  )
}

var function SRM_SetupSlider( string resName, string label, string description )
{
	var button = Hud_GetChild( Hud_GetChild( file.menu, resName ), "BtnDropButton" )
	return SRM_SetupButton( button, label, description )
}

void function SRM_Button_Focused( var button )
{
	string description = file.buttonDescriptions[button]
	RuiSetString( Hud_GetRui( file.itemDescriptionBox ), "description", description )
}

void function SRM_SetupFooter()
{
	AddEventHandlerToButtonClass( file.menu, "RuiFooterButtonClass", UIE_GET_FOCUS, SRM_FooterButton_Focused )
	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function SRM_FooterButton_Focused( var button )
{
	RuiSetString( Hud_GetRui( file.itemDescriptionBox ), "description", "" )
}