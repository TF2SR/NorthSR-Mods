global function SRM_InitTBFWarpsMenu

array<string> startPointNames = [
	"Start",
	"Drop",
	"Drop (Walls down)",
	"Door",
	"Elevator",
	"Elevator Top",
	"Final Stretch",
	"Outro Cutscene"
]

void function SRM_InitTBFWarpsMenu() {
	SRM_InitWarpsMenu("SRM_TBFWarpsMenu", startPointNames, SRM_LoadTBFWarp)
}