global function LoadingScreen_Init

void function LoadingScreen_Init()
{
    thread LoadingScreen()
}

void function LoadingScreen()
{
    while (true)
	{
		wait 0

        var loadingMenu = null
        var mapLabel = null
        var timeLabel = null
        try
        {
            loadingMenu = Hud_GetChild(Hud_GetParent(GetMenu("SRM_SettingsMenu")), "LoadingProgress")
            //mapLabel = Hud_GetChild(loadingMenu, "")
            timeLabel = Hud_GetChild(loadingMenu, "UnixTimestamp")
        }
        catch (ex)
        {
            continue
        }

        Hud_SetText(timeLabel, GetUnixTimestamp().tostring())
        //print(Hud_GetUTF8Text(modeLabel) + "HELO")

        //Hud_SetVisible(Hud_GetChild(loadingMenu, "LoadingTip"), true)

	}
}