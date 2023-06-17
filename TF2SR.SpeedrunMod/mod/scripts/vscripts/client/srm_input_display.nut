global function SRM_InputDisplay_Init

array<int> keyListeners = [
	IN_FORWARD,
	IN_BACK,
	IN_MOVELEFT,
	IN_MOVERIGHT,

	IN_JUMP,
	IN_DUCK
]

array<var> inputDisplays = []

void function SRM_InputDisplay_Init()
{
	// if ( !GetConVarInt("srm_input_display") ) return

	AddCallback_EntitiesDidLoad( SRM_SetupInputDisplay )
	AddCallback_EntitiesDidLoad( SRM_InputDisplayUpdate )
}

void function SRM_SetupInputDisplay()
{
	var inputDisplay = HudElement( "InputDisplay" )

	inputDisplays.append( Hud_GetChild( inputDisplay, "InputForward" ) )
	inputDisplays.append( Hud_GetChild( inputDisplay, "InputBack" ) )
	inputDisplays.append( Hud_GetChild( inputDisplay, "InputLeft" ) )
	inputDisplays.append( Hud_GetChild( inputDisplay, "InputRight" ) )

	inputDisplays.append( Hud_GetChild( inputDisplay, "InputJump" ) )
	inputDisplays.append( Hud_GetChild( inputDisplay, "InputDuck" ) )
}

void function SRM_InputDisplayUpdate()
{
	entity player = GetLocalViewPlayer()
	// var inputDisplay = HudElement( "InputDisplay" )

	while (true)
	{
		WaitFrame()

		// pin position to crosshair
		// vector crosshairPos = GetCrosshairPos()
		// Hud_SetPos(
		// 	inputDisplay,
		// 	crosshairPos.x - Hud_GetWidth( inputDisplay ),
		// 	crosshairPos.y - Hud_GetHeight( inputDisplay )
		// )

		// check if input is pressed
		for (int i = 0; i < inputDisplays.len(); i++)
		{
			if ( player.IsInputCommandHeld( keyListeners[i] ) )
				Hud_SetVisible( inputDisplays[i], true )
			else
				Hud_SetVisible( inputDisplays[i], false )
		}
	}
}