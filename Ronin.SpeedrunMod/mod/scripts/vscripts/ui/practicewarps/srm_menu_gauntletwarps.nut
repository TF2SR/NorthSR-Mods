global function SRM_InitGauntletWarpsMenu

array<string> startPointNames = [
	"Start",
	"Simulation Spawn",
	"Hallway",
	"Circle Room Hallway",
	"Gauntlet Intro",
	"Gauntlet Outro",
	"Titan Intro",
	"Outro Cutscene (1)",
	"Outro Cutscene (2)",
	"Gauntlet Practice Only"
]

void function SRM_InitGauntletWarpsMenu() {
	SRM_InitWarpsMenu("SRM_GauntletWarpsMenu", startPointNames, SRM_LoadGauntletWarp)
}