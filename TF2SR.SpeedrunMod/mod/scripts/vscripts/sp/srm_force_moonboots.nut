global function SRM_ForceMoonboots_Init

void function SRM_ForceMoonboots_Init()
{
    thread SRM_ForceMoonboots()
}

void function SRM_ForceMoonboots()
{
    bool hasMoonboots
    while ( true )
    {
        WaitFrame()
        if ( GetPlayerArray().len() < 1 ) continue

        if ( GetConVarBool("srm_force_moonboots") )
        {
            hasMoonboots = true
            GetFirstPlayer().kv.gravity = 0.75
        }
        else if ( hasMoonboots )
        {
            hasMoonboots = false
            GetFirstPlayer().kv.gravity = 0.0
        }
    }
}