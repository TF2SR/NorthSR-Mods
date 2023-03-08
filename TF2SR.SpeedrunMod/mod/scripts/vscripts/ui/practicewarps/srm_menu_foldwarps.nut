global function SRM_InitFoldWarpsMenu

array<string> startPointNames = [
	"Start",
	"Intro Cutscene",
	"Skinny Door",
	"Curved Hallway",
	"New BT",
	"Embark",
	"Big Door",
	"Post Archer Hallway",
	"Pre Slone 1",
	"Pre Slone 2",
	"Post Slone",
	"Ark Injector Cutscene",
	"Escape"
]

void function SRM_InitFoldWarpsMenu() {
	SRM_InitWarpsMenu("SRM_FoldWarpsMenu", startPointNames, SRM_LoadFoldWarp)
}