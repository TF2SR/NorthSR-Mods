global function SRM_Speedometer_Init

struct
{
	var speedometer = null
	var speedometerUnit = null
} file

void function SRM_Speedometer_Init()
{
	if (GetConVarInt("srm_enable_speedometer") != 1) return
	
	SRM_CreateSpeedometer()
	AddCallback_EntitiesDidLoad( SRM_SpeedometerUpdate )
}

void function SRM_CreateSpeedometer()
{
	// value display
	file.speedometer = CreatePermanentCockpitRui( $"ui/cockpit_console_text_top_left.rpak" )
    RuiSetFloat2( file.speedometer, "msgPos",
    	<
    	GetConVarFloat("srm_speedometer_position_x"),
    	GetConVarFloat("srm_speedometer_position_y"),
    	0.0
    	>
    )
    RuiSetFloat( file.speedometer, "msgFontSize", 45 )
    RuiSetFloat( file.speedometer, "msgAlpha", GetConVarFloat("srm_speedometer_alpha") )
    RuiSetFloat3( file.speedometer, "msgColor", <1.0,1.0,1.0> )

    // unit label
    file.speedometerUnit = CreatePermanentCockpitRui( $"ui/cockpit_console_text_top_left.rpak" )
    RuiSetFloat2( file.speedometerUnit, "msgPos",
    	<
    	GetConVarFloat("srm_speedometer_position_x"),
    	GetConVarFloat("srm_speedometer_position_y") + 0.04,
    	0.0
    	>
    )
    RuiSetFloat( file.speedometerUnit, "msgFontSize", 20 )
    RuiSetFloat( file.speedometerUnit, "msgAlpha", GetConVarFloat("srm_speedometer_alpha") )
    RuiSetFloat3( file.speedometerUnit, "msgColor", <1.0,1.0,1.0> )
}

void function SRM_SpeedometerUpdate()
{
	float unitConversionModifier
	string speedometerUnitLabel
	switch ( GetConVarInt("srm_speedometer_unit") )
	{
		case 0:
			unitConversionModifier = 0.090
			speedometerUnitLabel   = "km/h"
			break
		case 1:
			unitConversionModifier = 0.025
			speedometerUnitLabel   = "m/s"
			break
		case 2:
			unitConversionModifier = 0.056
			speedometerUnitLabel   = "mph"
			break
		case 3:
			unitConversionModifier = 1.000
			speedometerUnitLabel   = "u"
			break
	}

	RuiSetString( file.speedometerUnit, "msgText", speedometerUnitLabel )

	vector speedometerVelocityVector
	float  speedometerVelocity
	while (true)
	{
		WaitFrame()

		speedometerVelocityVector = GetLocalClientPlayer().GetVelocity()

		switch ( GetConVarInt("srm_speedometer_axismode") )
		{
			// XY
			case 0: speedometerVelocityVector = < speedometerVelocityVector.x, speedometerVelocityVector.y, 0.0 >
			break
			// XYZ
			case 1: // redundant since the other cases just eliminate axes to ignore
			break
			// Z
			case 2: speedometerVelocityVector = < 0.0, 0.0, speedometerVelocityVector.z >
			break
		}

		speedometerVelocity = speedometerVelocityVector.Length()

		// update color depending on speed (lerp between 0 - 1000 u)
		RuiSetFloat3( file.speedometer, "msgColor", SRM_SpeedometerColorLerp( speedometerVelocity ) )
		RuiSetFloat3( file.speedometerUnit, "msgColor", SRM_SpeedometerColorLerp( speedometerVelocity ) )
		speedometerVelocity *= unitConversionModifier
		// cut off decimals and then convert to string
		RuiSetString( file.speedometer, "msgText", speedometerVelocity.tointeger().tostring() )
	}
}

vector function SRM_SpeedometerColorLerp(float speedometerVelocity)
{
	// there's probably a much better way of doing this by storing the convars as an actual vector but idk how :[
	return <
	GraphCapped( speedometerVelocity, 300.0, 1000.0, GetConVarFloat("srm_speedometer_color_slow_r") / 255, GetConVarFloat("srm_speedometer_color_fast_r") / 255 ),
	GraphCapped( speedometerVelocity, 300.0, 1000.0, GetConVarFloat("srm_speedometer_color_slow_g") / 255, GetConVarFloat("srm_speedometer_color_fast_g") / 255 ),
	GraphCapped( speedometerVelocity, 300.0, 1000.0, GetConVarFloat("srm_speedometer_color_slow_b") / 255, GetConVarFloat("srm_speedometer_color_fast_b") / 255 )
	>
}

// unused
void function SRM_DestroySpeedometer()
{
	if ( file.speedometer == null )
		return

	RuiDestroyIfAlive( file.speedometer )
	file.speedometer = null
}
