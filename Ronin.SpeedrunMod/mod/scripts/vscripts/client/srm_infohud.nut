global function SRM_InfoHUD_Init


struct ConVarDisplay
{
    var rui
}

struct SRM_ConVar
{
    string ConVarName
    string displayName
    float defautValue
    float value
    bool isModded
}

int defaultConVarDisplayLines = 3
float[2]& screenSize

array<SRM_ConVar> SRM_DefaultConVars
array<SRM_ConVar> SRM_CustomConVars

ConVarDisplay CustomConVarDisplay
ConVarDisplay DefaultConVarDisplay

void function SRM_InfoHUD_Init()
{    
    // the first modded custom convar (one that starts with "srm_")
    // that is found will be displayed and everything else will be skipped
    // otherwise convars are displayed in order as they are registered
    RegisterConVar( "srm_practice_mode", 0.0, "Practice Mode" )
    RegisterConVar( "srm_force_moonboots", 0.0, "Forced Moonboots" )
    RegisterConVar( "sv_cheats", 0.0 )
    RegisterConVar( "host_timescale", 1.0 )
    RegisterConVar( "player_respawnInputDebounceDuration", 0.5 )

    screenSize = GetScreenSize()

    thread SRM_InfoHUD_Thread()
}

// continuously check and update hud based on convar values
void function SRM_InfoHUD_Thread()
{
    ConVarDisplay CustomConVarDisplay = CreateConVarDisplay( < 0.01, 0.15, 0.0 >, 40.0, < 1.0, 0.4, 0.2 >, 0.9 )
    ConVarDisplay DefaultConVarDisplay = CreateConVarDisplay( < 0.02, 0.2, 0.0 >, 30.0, < 1.0, 1.0, 1.0 >, 0.5 )

    while(true)
    {
        WaitFrame()

        if (GetConVarInt("srm_tasmode") == 1) 
        {
            RuiSetString( CustomConVarDisplay.rui, "msgText", "" )
            RuiSetString( DefaultConVarDisplay.rui, "msgText", "" )
            continue
        }

        UpdateModdedConVars( SRM_CustomConVars )
        for (int i = 0; i < SRM_CustomConVars.len(); i++)
        {
            if (SRM_CustomConVars[i].isModded)
            {
                // set hud text for first modded custom convar it can find, then exit the loop
                RuiSetString( CustomConVarDisplay.rui, "msgText", SRM_CustomConVars[i].displayName )
                break;
            }
            RuiSetString( CustomConVarDisplay.rui, "msgText", "" )
        }

        UpdateModdedConVars( SRM_DefaultConVars )
        string SRM_ModdedDefaultConVarsDisplayText = ""
        for (int i = 0; i < SRM_DefaultConVars.len(); i++)
        {
            if (SRM_DefaultConVars[i].isModded)
                SRM_ModdedDefaultConVarsDisplayText += SRM_DefaultConVars[i].ConVarName + " " + SRM_DefaultConVars[i].value.tostring() + "\n"
        }
        RuiSetString( DefaultConVarDisplay.rui, "msgText", SRM_ModdedDefaultConVarsDisplayText )
    }
}

// load convars into arrays that can be referenced later
void function RegisterConVar( string ConVarName, float defautValue, string displayName = "" )
{
    SRM_ConVar ConVar

    ConVar.ConVarName = ConVarName

    if (displayName == "")
        ConVar.displayName = ConVarName
    else
        ConVar.displayName = displayName

    ConVar.defautValue = defautValue
    ConVar.value = GetConVarFloat(ConVarName)

    if (SRM_StartsWith(ConVarName, "srm_"))
        SRM_CustomConVars.append(ConVar)
    else
        SRM_DefaultConVars.append(ConVar)
}

// repeatedly check if a convar has a non default value
void function UpdateModdedConVars( array<SRM_ConVar> ConVarArray )
{
    for (int i = 0; i < ConVarArray.len(); i++)
    {
        SRM_ConVar ConVar = ConVarArray[i]
        ConVar.value = GetConVarFloat(ConVar.ConVarName)
        ConVar.isModded = ConVar.value != ConVar.defautValue
    }
}

ConVarDisplay function CreateConVarDisplay( vector position, float fontSize, vector color, float alpha )
{
    ConVarDisplay display

    var rui
    rui = CreateFullscreenRui( $"ui/cockpit_console_text_top_left.rpak" )
    RuiSetResolution( rui, screenSize[0], screenSize[1])
    RuiSetString( rui, "msgText", "" )
    RuiSetFloat2( rui, "msgPos", position )
    RuiSetFloat( rui, "msgFontSize", fontSize )
    RuiSetFloat( rui, "msgAlpha", alpha )
    RuiSetFloat3( rui, "msgColor", color )
    display.rui = rui

    return display
}