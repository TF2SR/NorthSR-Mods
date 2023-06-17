untyped
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
	if ( !GetConVarInt("srm_enable_input_display") ) return

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

	for (int i = 0; i < inputDisplays.len(); i++)
	{
		Hud_SetColor(
			inputDisplays[i],
			GetConVarInt("srm_input_display_r"),
			GetConVarInt("srm_input_display_g"),
			GetConVarInt("srm_input_display_b"),
			255
		)
	}
}

void function SRM_InputDisplayUpdate()
{
	entity player = GetLocalViewPlayer()
	var inputDisplay = HudElement( "InputDisplay" )

	while (true)
	{
		WaitFrame()

		// pin position to crosshair
		vector crosshairPos = GetCrosshairPos()
		Hud_SetPos(
			inputDisplay,
			crosshairPos.x - Hud_GetWidth( inputDisplay ) / 2,
			crosshairPos.y - Hud_GetHeight( inputDisplay ) / 2
		)

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

vector function GetCrosshairPos()
{
	vector crosshairPos = GetLocalViewPlayer().CameraPosition()
    if ( IsValid( GetLocalViewPlayer().GetActiveWeapon() ) )
        crosshairPos += GetLocalViewPlayer().GetActiveWeapon().GetAttackDirection() * 500
    else
        crosshairPos += GetLocalViewPlayer().GetViewVector()

    array pos = expect array( Hud.ToScreenSpace( crosshairPos ) )

    vector result = <pos[0], pos[1], 0 >
    pos.clear()
    return result
}