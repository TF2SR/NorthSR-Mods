global function SRM_InitBNRWarpsMenu

array<string> startPointNames = [
	"Start",
	"Tone Pickup",
	"Post Control Room",
	"Post Sniper Canal",
	"Post Grunt Hallways",
	"BT Reunion",
	"Sludge Fight",
	"Kane"
]

void function SRM_InitBNRWarpsMenu() {
	SRM_InitWarpsMenu("SRM_BNRWarpsMenu", startPointNames, SRM_LoadBNRWarp)
}