global function SRM_Speedometer_Init

struct
{
	var rui = null
	bool useMetric = true
} file

void function SRM_Speedometer_Init()
{
	// 0 = metric, 1 = imperial
	// NOTE: needs to be rewritten if we decide to add game units as a measurement unit
	file.useMetric = GetConVarInt("srm_speedometer_unit") == 0

	if (GetConVarInt("srm_enable_speedometer") == 1) {
		AddCreatePilotCockpitCallback( SRM_CreateSpeedometer )
	} else return

	var player = GetLocalClientPlayer()

	// RuiSetString( file.rui, "msgText", GetLocalClientPlayer().GetVelocity().tostring() )
}

void function SRM_CreateSpeedometer( entity cockpit, entity player )
{
	file.rui = CreatePermanentCockpitRui( $"ui/cockpit_console_text_top_left.rpak" )
    RuiSetString( file.rui, "msgText", "hello" )
    RuiSetFloat2( file.rui, "msgPos", <0.5,0.5,0.0> )
    RuiSetFloat( file.rui, "msgFontSize", 40 )
    RuiSetFloat( file.rui, "msgAlpha", 1.0 )
    RuiSetFloat3( file.rui, "msgColor", <0.0,1.0,0.7> )

	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : (  )
		{
			SRM_DestroySpeedometer()
		}
	)

	WaitForever()
}

void function SRM_DestroySpeedometer()
{
	if ( file.rui == null )
		return

	RuiDestroyIfAlive( file.rui )
	file.rui = null
}
