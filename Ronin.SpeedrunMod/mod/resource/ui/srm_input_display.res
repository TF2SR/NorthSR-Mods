"resource/ui/srm_input_display.res"
{
	CenterPoint
	{
		ControlName 		ImagePanel
		xpos 				c
		ypos 				c
		wide 				32
		tall 				32
		image 				"vgui/hud/input_arrow_up"
		visible 			0
		scaleImage 			1
	}
	InputForward
	{
		ControlName 		ImagePanel
		xpos 				0
		ypos 				64
		wide 				32
		tall 				32
		image 				"vgui/hud/input_arrow_up"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}
	InputLeft
	{
		ControlName 		ImagePanel
		xpos 				64
		ypos 				0
		wide 				32
		tall 				32
		image 				"vgui/hud/input_arrow_left"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}
	InputRight
	{
		ControlName 		ImagePanel
		xpos 				-64
		ypos 				0
		wide 				32
		tall 				32
		image 				"vgui/hud/input_arrow_right"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}
	InputBack
	{
		ControlName 		ImagePanel
		xpos 				0
		ypos 				-64
		wide 				32
		tall 				32
		image 				"vgui/hud/input_arrow_down"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}

	InputJump
	{
		ControlName 		ImagePanel
		xpos 				-48
		ypos 				-80
		wide 				32	
		tall 				32	
		image 				"vgui/hud/input_jump"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}
	InputDuck
	{
		ControlName 		ImagePanel
		xpos 				48
		ypos 				-80
		wide 				32	
		tall 				32	
		image 				"vgui/hud/input_crouch"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}

	InputTactical
	{
		ControlName 		ImagePanel
		xpos 				75
		ypos 				-110
		wide 				32	
		tall 				32	
		image 				"vgui/hud/input_square"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}

	InputTitanUtility
	{
		ControlName 		ImagePanel
		xpos 				25
		ypos 				-110
		wide 				32	
		tall 				32	
		image 				"vgui/hud/input_triangle"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}

	InputOrdnance
	{
		ControlName 		ImagePanel
		xpos 				-25
		ypos 				-110
		wide 				32	
		tall 				32	
		image 				"vgui/hud/input_diamond"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}

	InputInteract
	{
		ControlName 		ImagePanel
		xpos 				-75
		ypos 				-110
		wide 				32	
		tall 				32	
		image 				"vgui/hud/input_circle"
		visible 			0
		scaleImage 			1

		pin_to_sibling 				"CenterPoint"
		pin_corner_to_sibling 		CENTER
		pin_to_sibling_corner 		TOP_LEFT
	}
}