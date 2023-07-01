global function SRM_InitInputDisplaySettingsMenu

string colorDescription = "Individual color components"

void function SRM_InitInputDisplaySettingsMenu()
{
	SRM_MenuInit( "SRM_InputDisplaySettingsMenu" )

	SRM_SetupSlider( "SldInputDisplayColorR", "Color R", colorDescription )
	SRM_SetupSlider( "SldInputDisplayColorG", "Color G", colorDescription )
	SRM_SetupSlider( "SldInputDisplayColorB", "Color B", colorDescription )

	SRM_SetupFooter()
}