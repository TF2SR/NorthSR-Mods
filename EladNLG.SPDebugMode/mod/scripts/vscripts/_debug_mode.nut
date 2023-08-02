untyped
globalize_all_functions

struct Objective
{
	string type
    float progress
    float maxProgress
}

table<string, Objective> objectives

void function DebugMode_Init()
{
	RegisterSignal( "StopTrack" )
	AddClientCommandCallback( "restore_doublejump", RestoreDoubleJump )
	AddCallback_OnLoadSaveGame( DebugMode_OnLoadSaveGame )
}

void function DebugMode_OnLoadSaveGame( entity player )
{
	thread LoadObjectives( player )
}

void function LoadObjectives( entity player )
{
	WaitFrame()
	WaitFrame()
	foreach (string id, Objective obj in objectives)
		ServerToClientStringCommand( player, "objective " + id + " create " + obj.type + 
			" " + obj.progress + " " + obj.maxProgress )

	foreach (entity player in GetPlayerArray())
		Remote_CallFunction_NonReplay( player, "ServerCallback_SetStartPointIndex", level.nv.startPointIndex )
}

bool function RestoreDoubleJump( entity player, array<string> args )
{
	if (!GetConVarBool("sv_cheats"))
		return false
	
	return true
}

void function DebugMode_CreateObjective( string id, string type, var progress, float maxProgress )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " create " + type + 
			" " + progress + " " + maxProgress )
	Objective obj
	obj.type = type
	obj.progress = float( progress )
	obj.maxProgress = maxProgress
	objectives[id] <- obj
}

void function DebugMode_SetComplete( string id )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " setComplete" )
	delete objectives[id]
}

void function DebugMode_CreateObjective_EnemyWave( string id, var count, float endTime )
{
	DebugMode_CreateObjective( id, "waitForEnemyCount", float( count ), endTime )
}

void function DebugMode_SetProgress( string id, var progress )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " setProgress " + progress )
	objectives[id].progress = float( progress )
}

void function DebugMode_SetMaxProgress( string id, float maxProgress )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " setMaxProgress " + maxProgress )
	objectives[id].maxProgress = maxProgress
}

void function DebugMode_TrackEnemyArray( string id, array<entity> arr )
{
	svGlobal.levelEnt.EndSignal( "StopTrack" )

	// fix for servertoclientstringcommands not necessarily arriving at the order you send them.
	WaitFrame()

	while ( 1 )
	{
		ArrayRemoveDeadOrLeeched( arr )
		DebugMode_SetProgress( id, arr.len() )
		WaitFrame()
	}
}

// util func for leeched spectres, to preserve vanilla behavior - elad
void function ArrayRemoveDeadOrLeeched( array<entity> entArray )
{
	for ( int i = entArray.len() - 1; i >= 0; i-- )
	{
		if ( !IsAlive( entArray[ i ] ) || entArray[i].GetTeam() != TEAM_IMC )
			entArray.remove( i )
	}
}
