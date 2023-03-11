global function SRM_InitPracticeWarpsMenu
global function SRM_AddPracticeWarpSubmenus

struct SPLevelStartStruct
{
	int levelNum
	string levelBsp
	string startPoint
	string levelId
	string levelName
	string levelDesc
	asset levelImage = $""
	bool showLions
}

struct
{
	var menu
	GridMenuData gridData
	bool isGridInitialized = false
	array<SPLevelStartStruct> mainLevels
	table< int, array<SPLevelStartStruct> > allLevels
	int lastLevelSelected = 0
	int lastLevelUnlocked = 0
	int difficulty = DIFFICULTY_NORMAL
	int selectedLevelNum = -1
	string selectedLevel = ""
	string selectedStartPoint = ""
	bool playIntro = false
	int currentBackground = 0
	bool addObjectiveReminderOnSaveLoad
	array<void functionref()> levelPartSelectFunc
	int focusedElemNum = 0
} file

void function SRM_InitPracticeWarpsMenu()
{
	var menu = GetMenu( "SRM_PracticeWarpsMenu" )
	file.menu = menu

	var dataTable = GetDataTable( $"datatable/sp_levels.rpak" )
	int numRows = GetDatatableRowCount( dataTable )

	for ( int i=0; i<numRows; i++ )
	{
		bool isMain = GetDataTableBool( dataTable, i, GetDataTableColumnByName( dataTable, "mainEntry" ) )
		SPLevelStartStruct data
		data.levelBsp = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "level" ) )
		data.startPoint = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "startPoint" ) )
		data.levelId = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "levelId" ) )
		data.levelNum = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "levelNum" ) )
		data.levelName = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "title" ) )
		data.levelDesc = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "desc" ) )
		data.levelImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "missionSelectImage" ) )

		if ( isMain )
		{
			file.mainLevels.append( data )
		}

		if (!( data.levelNum in file.allLevels ))
		{
			file.allLevels[ data.levelNum ] <- []
		}

		file.allLevels[ data.levelNum ].append( data )
	}

	file.gridData.rows = 2
	file.gridData.columns = 5
	file.gridData.paddingVert = 5
	file.gridData.paddingHorz = 5
	file.gridData.numElements = file.mainLevels.len()
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.tileWidth = Grid_GetMaxWidthForSettings( menu, file.gridData )

	float tileHeight = ( file.gridData.tileWidth * 9.0 ) / 21.0

	file.gridData.tileHeight = minint( Grid_GetMaxHeightForSettings( menu, file.gridData ), int( tileHeight ) + 80 )
	file.gridData.initCallback = SPButtonInit
	file.gridData.getFocusCallback = SPButton_GetFocus
	file.gridData.clickCallback = SPButton_Click

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenPracticeWarpsMenu )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT", "", null, IsUnlockedChapterFocused )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function SRM_AddPracticeWarpSubmenus()
{
	AddMenu( "SRM_GauntletWarpsMenu", $"resource/ui/menus/warpmenus/srm_gauntletwarps.menu", SRM_InitGauntletWarpsMenu)
	AddMenu( "SRM_BTWarpsMenu", $"resource/ui/menus/warpmenus/srm_btwarps.menu", SRM_InitBTWarpsMenu)
	AddMenu( "SRM_BNRWarpsMenu", $"resource/ui/menus/warpmenus/srm_bnrwarps.menu", SRM_InitBNRWarpsMenu)
	AddMenu( "SRM_ITAWarpsMenu", $"resource/ui/menus/warpmenus/srm_itawarps.menu", SRM_InitITAWarpsMenu)
	AddMenu( "SRM_ENCWarpsMenu", $"resource/ui/menus/warpmenus/srm_encwarps.menu", SRM_InitENCWarpsMenu)
	AddMenu( "SRM_BWarpsMenu", $"resource/ui/menus/warpmenus/srm_bwarps.menu", SRM_InitBWarpsMenu)
	AddMenu( "SRM_TBFWarpsMenu", $"resource/ui/menus/warpmenus/srm_tbfwarps.menu", SRM_InitTBFWarpsMenu)
	AddMenu( "SRM_ArkWarpsMenu", $"resource/ui/menus/warpmenus/srm_arkwarps.menu", SRM_InitArkWarpsMenu)
	AddMenu( "SRM_FoldWarpsMenu", $"resource/ui/menus/warpmenus/srm_foldwarps.menu", SRM_InitFoldWarpsMenu)
}

bool function SPButtonInit( var button, int elemNum )
{
	var rui = Hud_GetRui( button )

	SPLevelStartStruct data = file.mainLevels[ elemNum ]

	asset levelImage = data.levelImage

	RuiSetImage( rui, "itemImage", levelImage )

	UpdateButtonData( button, elemNum )

	return true
}

void function UpdateButtonData( var button, int elemNum )
{
	SPLevelStartStruct data = file.mainLevels[ elemNum ]
	var rui = Hud_GetRui( button )
	string bspName = data.levelBsp
	string levelName = data.levelName

	RuiSetString( rui, "title", levelName )
	Hud_SetLocked( button, false )
}

void function SPButton_GetFocus( var button, int elemNum )
{
	file.focusedElemNum = elemNum

	SPLevelStartStruct data = file.mainLevels[ elemNum ]
	string levelName = data.levelName
	string desc = data.levelDesc

	file.lastLevelSelected = elemNum

	HudElem_SetText( GetMenuChild( file.menu, "ContentDescriptionTitle" ), levelName )
	HudElem_SetText( GetMenuChild( file.menu, "ContentDescription" ), desc )
}

void function SPButton_Click( var button, int elemNum )
{
	SPLevelStartStruct data = file.mainLevels[ elemNum ]
	file.selectedLevelNum = elemNum
	file.selectedLevel = data.levelBsp
	file.selectedStartPoint = data.startPoint
	file.playIntro = false

	switch (elemNum)
	{
		case 0: AdvanceMenu( GetMenu( "SRM_GauntletWarpsMenu" ) ); break
		case 1: AdvanceMenu( GetMenu( "SRM_BTWarpsMenu" ) ); break
		case 2: AdvanceMenu( GetMenu( "SRM_BNRWarpsMenu" ) ); break
		case 3: AdvanceMenu( GetMenu( "SRM_ITAWarpsMenu" ) ); break
		case 4: AdvanceMenu( GetMenu( "SRM_ENCWarpsMenu" ) ); break
		case 5: AdvanceMenu( GetMenu( "SRM_BWarpsMenu" ) ); break
		case 6: AdvanceMenu( GetMenu( "SRM_TBFWarpsMenu" ) ); break
		case 7: AdvanceMenu( GetMenu( "SRM_ArkWarpsMenu" ) ); break
		case 8: AdvanceMenu( GetMenu( "SRM_FoldWarpsMenu" ) ); break
	}
}

void function OnOpenPracticeWarpsMenu()
{
	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	file.lastLevelUnlocked = 9

	Grid_InitPage( file.menu, file.gridData )

	int levelFocus = minint( file.lastLevelUnlocked, file.lastLevelSelected )

	int row = Grid_GetRowFromElementNumber( levelFocus, file.gridData )
	int col = Grid_GetColumnFromElementNumber( levelFocus, file.gridData )
	Hud_SetFocused( Grid_GetButtonAtRowColumn( file.menu, row, col ) )
}

bool function IsUnlockedChapterFocused()
{
	if ( file.focusedElemNum <= file.lastLevelUnlocked )
		return true

	return false
}
