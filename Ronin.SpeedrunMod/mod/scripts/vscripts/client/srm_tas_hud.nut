global function SRM_TasHUD_Init

struct TasInfoDisplay
{
	var rui
}

float[2]& screenSize

void function SRM_TasHUD_Init()
{
	screenSize = GetScreenSize()

    thread SRM_TasHUD_Thread()
}

void function SRM_TasHUD_Thread()
{
	TasInfoDisplay tasLabel = CreateTasInfoDisplay( <0.26,0.85,0.0>, 40.0 )
	TasInfoDisplay tasTimescaleLabel = CreateTasInfoDisplay( <0.295,0.84,0.0>, 30.0 )

	while(true)
	{
		WaitFrame()

		if (GetConVarInt("fzzy_enableTas") == 1)
		{
    		RuiSetString( tasLabel.rui, "msgText", "TAS" )
    		RuiSetString( tasTimescaleLabel.rui, "msgText", GetConVarString("host_timescale").tostring() )
		}
		else 
		{
	    	RuiSetString( tasLabel.rui, "msgText", "" )
	    	RuiSetString( tasTimescaleLabel.rui, "msgText", "" )
		}
	}
}

TasInfoDisplay function CreateTasInfoDisplay( vector position, float fontSize )
{
    TasInfoDisplay display

    var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak" )
    RuiSetResolution( rui, screenSize[0], screenSize[1])
    RuiSetString( rui, "msgText", "" )
    RuiSetFloat2( rui, "msgPos", position )
    RuiSetFloat( rui, "msgFontSize", fontSize )
    RuiSetFloat( rui, "msgAlpha", 1.0 )
    RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
    display.rui = rui

    return display
}