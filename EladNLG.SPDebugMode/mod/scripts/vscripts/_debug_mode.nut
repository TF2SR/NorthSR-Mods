untyped
globalize_all_functions

void function DebugMode_Init()
{
	AddClientCommandCallback( "restore_doublejump", RestoreDoubleJump )
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
}

void function DebugMode_SetComplete( string id, bool complete = true )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " setComplete " + (complete ? 1 : 0) )
}

void function DebugMode_CreateObjective_EnemyWave( string id, var count, float endTime )
{
	DebugMode_CreateObjective( id, "waitForEnemyCount", float( count ), endTime )
}

void function DebugMode_SetProgress( string id, var progress )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " setProgress " + progress )
}

void function DebugMode_SetMaxProgress( string id, var maxProgress )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " setMaxProgress " + maxProgress )
}

void function DebugMode_TrackEnemyArray( string id, array<entity> arr )
{
	svGlobal.levelEnt.EndSignal( "StopTrack" )

	while ( 1 )
	{
		ArrayRemoveDead( arr )
		DebugMode_SetProgress( id, arr.len() )
		WaitFrame()
	}
}