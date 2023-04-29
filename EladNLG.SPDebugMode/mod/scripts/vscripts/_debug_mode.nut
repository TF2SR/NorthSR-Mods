globalize_all_functions

void function DebugMode_CreateObjective( string id, string type, var progress, float maxProgress )
{
	foreach (entity player in GetPlayerArray())
		ServerToClientStringCommand( player, "objective " + id + " create " + type + 
			" " + progress + " " + maxProgress )
}

void function DebugMode_SetComplete( string id, bool complete )
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