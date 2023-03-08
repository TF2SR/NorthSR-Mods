global function SRM_InitBWarpsMenu

array<string> startPointNames = [
	"Start",
	"Bunker Entry",

	"Start",
	"Killroom",
	"Arc Tool",
	"Fan Launch",
	"Heatsink",
	"Fast Fans",
	"Slow Fans",

	"Start",
	"Post Generator",
	"Fastball (No Moon boots)",
	"House 1",
	"House 2",
	"Combat 1",
	"Rooftop",
	"2 Cranes",
	"Window Platform",
	"Detached Dish",
	"Arc Tool Walls",
	"Dish Fight",
	"Dish Climb",
	"Richter Fight",
	"Post Richter Fight",
	"Outro Cutscene"
]
		
void function SRM_InitBWarpsMenu() {
	SRM_InitWarpsMenu("SRM_BWarpsMenu", startPointNames, SRM_LoadBWarp)
}