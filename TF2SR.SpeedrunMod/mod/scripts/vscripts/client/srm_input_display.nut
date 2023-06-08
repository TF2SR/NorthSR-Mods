global function SRM_InputDisplay_Init

struct
{
	var forwardDisplay = null
	var backDisplay = null
	var moveleftDisplay = null
	var moverightDisplay = null

	var jumpDisplay = null
	var duckDisplay = null
} file

void function SRM_InputDisplay_Init()
{
	if (!GetConVarInt("srm_input_display")) return

	SRM_CreateInputDisplay()
	AddCallback_EntitiesDidLoad( SRM_InputDisplayUpdate )
}

void function SRM_CreateInputDisplay()
{
	// create hud element for each button display element
}

void function SRM_InputDisplayUpdate()
{
	while (true)
	{
		WaitFrame()
		// check if each button is pressed
		// set alpha to 1 if pressed, 0 if not
	}
}