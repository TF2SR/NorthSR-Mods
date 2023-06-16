global function ForceMoonboots_Init

void function ForceMoonboots_Init()
{
    thread ForceMoonboots()
}

void function ForceMoonboots()
{
    bool hasMoonboots
    while (1)
    {
        WaitFrame()
        if (GetPlayerArray().len() < 1)
            continue

        if (GetConVarBool("srm_force_moonboots"))
        {
            hasMoonboots = true
            // this is the value used for moonboots, checked by testing
            GetFirstPlayer().kv.gravity = 0.75
        }
        else if (hasMoonboots)
        {
            hasMoonboots = false
            // note: the reason we don't use player.GetPlayerSettingsField( "gravityScale" )
            // is because that's the cause of the bug. .kv.gravityScale and gravityScale
            // are multiplicative, not overriding each other.
            GetFirstPlayer().kv.gravity = 0.0
        }
    }
}