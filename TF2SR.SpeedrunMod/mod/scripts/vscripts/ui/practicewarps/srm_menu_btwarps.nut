global function SRM_InitBTWarpsMenu

array<string> startPointNames = [
	"Start",
	"Post Crashlanding",
	"18hr Cutscene 1",
	"18hr Cutscene 2",
	"18hr Cutscene 3",
	"Lastimosa dies",
	"Lastimosa burial",
	"Post Lastimosa Burial",
	"Circle Room",
	"Prowler Pad",
	"Bat1 Insert",
	"Encampment",
	"Post Encampment",
	"Bat2 Enemy Clear"
]

void function SRM_InitBTWarpsMenu() {
	SRM_InitWarpsMenu("SRM_BTWarpsMenu", startPointNames, SRM_LoadBTWarp)
}