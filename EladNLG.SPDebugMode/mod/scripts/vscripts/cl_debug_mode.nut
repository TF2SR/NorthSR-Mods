global function Cl_DebugMode_Init
global function ServerCallback_SetStartPointIndex

const RUI_TEXT_RIGHT = $"ui/cockpit_console_text_top_right.rpak"
const RUI_TEXT_LEFT = $"ui/cockpit_console_text_top_left.rpak"
const RUI_TEXT_CENTER = $"ui/cockpit_console_text_center.rpak"

const vector GREEN = <0.2, 0.75, 0.2>
const vector WHITE = <0.9, 0.9, 0.9>

// Sets the objective display type.
// SINGLE has a single condition.
// EITHER_OR can have either condition completed.
enum ObjectiveDisplayType
{
    SINGLE,
    EITHER_OR
}

// An objective instance.
struct Objective
{
    string id
    int displayType = ObjectiveDisplayType.SINGLE
    // The objective type.
    string type = ""
    string topLabel
    string bottomLabel
    string topLabel2
    string bottomLabel2
    // Set by server. If true, the objective should end,
    // and won't be loaded from checkpoints.
    bool isComplete = false
    bool showCompleteMessage = true
    // Set by server. Represents a progress variable.
    float progress
    // Set by server. Represents another progress variable.
    float maxProgress
}

struct ObjectiveDisplay
{
    var labelRui
    var objectiveRui
    var option1LabelRui
    var option1Rui
    var option2LabelRui
    var option2Rui
}

struct
{
    array<Objective> objectives
    // A table for setting objective threads, based on type.
    table<string, void functionref( Objective )> objectiveCallbacks 
    var progressRui
    var partLabelRui
    array<ObjectiveDisplay> displays
    int startPointIndex
} file

void function Cl_DebugMode_Init()
{
    if (!GetConVarInt("srm_practice_mode")) return
    
    // Receiving objectives
    AddServerToClientStringCommandCallback( "objective", ServerCallback_ObjectiveReceived )
    // add new objective functions here.
    // the key is the objective TYPE, not ID.
    file.objectiveCallbacks["waitForEnemyCount"] <- Objective_WaitForEnemyCount
    file.objectiveCallbacks["tdayWaves"] <- Objective_TDayWaves
    file.objectiveCallbacks["maltaGunGroup"] <- Objective_MaltaGunGroup
    file.objectiveCallbacks["hangarEnemyWave"] <- Objective_HangarEnemyWave
    file.objectiveCallbacks["beacon2Triggers"] <- Objective_Beacon2Triggers
    file.objectiveCallbacks["hubFight"] <- Objective_HubFight
    file.objectiveCallbacks["becaon3FinalFight"] <- Objective_Beacon3FinalFight
    file.objectiveCallbacks["endless"] <- Objective_EndlessBT
    file.objectiveCallbacks["b3Triggers"] <- Objective_Beacon3Triggers

    // TITLE
    var rui = RuiCreate( RUI_TEXT_CENTER, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
    RuiSetInt( rui, "maxLines", 1 )
    RuiSetInt( rui, "lineNum", 0 )
    RuiSetFloat2( rui, "msgPos", <0.35, -0.4 + 0.3, 0> )
    RuiSetFloat3( rui, "msgColor", WHITE )
     RuiSetString( rui, "msgText", "Part X of Y" )
    RuiSetFloat( rui, "msgFontSize", 18.0 )
    RuiSetFloat( rui, "msgAlpha", 0.8 )
    RuiSetFloat( rui, "thicken", 0.0 )
    file.progressRui = rui

    rui = RuiCreate( RUI_TEXT_CENTER, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
    RuiSetInt( rui, "maxLines", 1 )
    RuiSetInt( rui, "lineNum", 0 )
    RuiSetFloat2( rui, "msgPos", <0.35, -0.375 + 0.3, 0> )
    RuiSetFloat3( rui, "msgColor", WHITE )
    RuiSetString( rui, "msgText", "PART TITLE" )
    RuiSetFloat( rui, "msgFontSize", 36.0 )
    RuiSetFloat( rui, "msgAlpha", 0.8 )
    RuiSetFloat( rui, "thicken", 0.25 )
    file.partLabelRui = rui

    // OBJECTIVE 1
    for (int i = 0; i < 3; i++)
    {
        float offset = 0.3 + 0.07 * i
        ObjectiveDisplay d
        rui = RuiCreate( RUI_TEXT_CENTER, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
        RuiSetInt( rui, "maxLines", 1 )
        RuiSetInt( rui, "lineNum", 0 )
        RuiSetFloat2( rui, "msgPos", <0.35, -0.328 + offset, 0> )
        RuiSetFloat3( rui, "msgColor", WHITE )
        RuiSetString( rui, "msgText", "DO" )
        RuiSetFloat( rui, "msgFontSize", 24.0 )
        RuiSetFloat( rui, "msgAlpha", 0.8 )
        RuiSetFloat( rui, "thicken", 0.0 )
        d.labelRui = rui

        rui = RuiCreate( RUI_TEXT_CENTER, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
        RuiSetInt( rui, "maxLines", 1 )
        RuiSetInt( rui, "lineNum", 0 )
        // -0.315
        RuiSetFloat2( rui, "msgPos", <0.35, -0.303 + offset, 0> )
        RuiSetFloat3( rui, "msgColor", GREEN )
        RuiSetString( rui, "msgText", "OR" )
        RuiSetFloat( rui, "msgFontSize", 36.0 )
        RuiSetFloat( rui, "msgAlpha", 0.8 )
        RuiSetFloat( rui, "thicken", 0.0 )
        d.objectiveRui = rui

        // OBJECTIVE 1 OPTION 1

        rui = RuiCreate( RUI_TEXT_RIGHT, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
        RuiSetInt( rui, "maxLines", 1 )
        RuiSetInt( rui, "lineNum", 0 )
        RuiSetFloat2( rui, "msgPos", <0.835, 0.335 - 0.175 + offset, 0> )
        RuiSetFloat3( rui, "msgColor", WHITE )
        RuiSetString( rui, "msgText", "OPTION 1" )
        RuiSetFloat( rui, "msgFontSize", 24.0 )
        RuiSetFloat( rui, "msgAlpha", 0.8 )
        RuiSetFloat( rui, "thicken", 0.0 )
        d.option1LabelRui = rui

        rui = RuiCreate( RUI_TEXT_RIGHT, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
        RuiSetInt( rui, "maxLines", 1 )
        RuiSetInt( rui, "lineNum", 0 )
        RuiSetFloat2( rui, "msgPos", <0.835, 0.355 - 0.175 + offset, 0> )
        RuiSetFloat3( rui, "msgColor", WHITE )
        RuiSetString( rui, "msgText", "OP1 PROGRESS" )
        RuiSetFloat( rui, "msgFontSize", 36.0 )
        RuiSetFloat( rui, "msgAlpha", 0.8 )
        RuiSetFloat( rui, "thicken", 0.0 )
        d.option1Rui = rui
        
        // OBJECTIVE 1 OPTION 2

        rui = RuiCreate( RUI_TEXT_LEFT, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
        RuiSetInt( rui, "maxLines", 1 )
        RuiSetInt( rui, "lineNum", 0 )
        RuiSetFloat2( rui, "msgPos", <0.866, 0.335 - 0.175 + offset, 0> )
        RuiSetFloat3( rui, "msgColor", WHITE )
        RuiSetString( rui, "msgText", "OPTION 2" )
        RuiSetFloat( rui, "msgFontSize", 24.0 )
        RuiSetFloat( rui, "msgAlpha", 0.8 )
        RuiSetFloat( rui, "thicken", 0.0 )
        d.option2LabelRui = rui

        rui = RuiCreate( RUI_TEXT_LEFT, clGlobal.topoCockpitHud, RUI_DRAW_COCKPIT, 0 )
        RuiSetInt( rui, "maxLines", 1 )
        RuiSetInt( rui, "lineNum", 0 )
        RuiSetFloat2( rui, "msgPos", <0.866, 0.355 - 0.175 + offset, 0> )
        RuiSetFloat3( rui, "msgColor", WHITE )
        RuiSetString( rui, "msgText", "OP2 PROGRESS" )
        RuiSetFloat( rui, "msgFontSize", 36.0 )
        RuiSetFloat( rui, "msgAlpha", 0.8 )
        RuiSetFloat( rui, "thicken", 0.0 )
        d.option2Rui = rui
        file.displays.append(d)
    }

    thread Objectives_Update()
}

void function Objectives_Update()
{
    while ( 1 )
    {
        WaitFrame()

        int part = file.startPointIndex
        array<StartPointCSV> startPoints = GetStartPointsForMap( GetMapName() )
        int parts = startPoints.len()
        
        if (GetConVarBool("srm_practice_mode"))
        {
            RuiSetString( file.progressRui, "msgText", format( "sp_StartPoint %i", part ) )
            RuiSetString( file.partLabelRui, "msgText", startPoints[file.startPointIndex].name )
        }
        else
        {
            RuiSetString( file.progressRui, "msgText", "" )
            RuiSetString( file.partLabelRui, "msgText", "" )
        }

        for (int i = 0; i < file.displays.len(); i++)
        {
            ObjectiveDisplay d = file.displays[i]
            
            // clean all ruis
            RuiSetString( d.labelRui, "msgText", "" )
            RuiSetString( d.objectiveRui, "msgText", "" )
            RuiSetString( d.option1LabelRui, "msgText", "" )
            RuiSetString( d.option1Rui, "msgText", "" )
            RuiSetString( d.option2LabelRui, "msgText", "" )
            RuiSetString( d.option2Rui, "msgText", "" )
    
            if (file.objectives.len() > i && GetConVarBool("srm_practice_mode")) // there's an objective in the array
            {
                Objective obj = file.objectives[i]
                switch (obj.displayType)
                {
                    case ObjectiveDisplayType.SINGLE:
                        RuiSetString( d.labelRui, "msgText", obj.topLabel )
                        RuiSetString( d.objectiveRui, "msgText", obj.bottomLabel )
                        RuiSetFloat3( d.objectiveRui, "msgColor", WHITE )
                        break
                    case ObjectiveDisplayType.EITHER_OR:
                        RuiSetString( d.objectiveRui, "msgText", "OR" )
                        RuiSetFloat3( d.objectiveRui, "msgColor", GREEN )
                        RuiSetString( d.option1LabelRui, "msgText", obj.topLabel )
                        RuiSetString( d.option1Rui, "msgText", obj.bottomLabel )
                        RuiSetString( d.option2LabelRui, "msgText", obj.topLabel2 )
                        RuiSetString( d.option2Rui, "msgText", obj.bottomLabel2 )
                        break
                }
            }
        }
    }
}


string function CombineArgsIntoString( array<string> args )
{
	string result
	
	// Ignore the first argument
	for( int i = 1; i < args.len(); i++ )
		result += Localize( args[i] ) + " "
	
	return result
}

void function ServerCallback_ObjectiveReceived( array<string> args )
{
    if (args.len() < 2)
        return
    string command = args[1]
    string objectiveId = args[0]
    Objective ornull objective = FindObjectiveById(objectiveId)

    switch (command)
    {
        case "create":
            Objective obj
            obj.id = objectiveId
            obj.type = args[2]
            obj.progress = float( args[3] )
            obj.maxProgress = float( args[4] )
            if (!(obj.type in file.objectiveCallbacks))
                throw "Tried to set objective type as \"" + args[2] + "\" which isn't valid (did you forget to add it?)"
            file.objectives.append(obj)
            thread ObjectiveThread( obj, file.objectiveCallbacks[obj.type] )
            break
        case "setComplete":
            expect Objective( objective )
            // side-note - objectives should end when this is set
            objective.isComplete = true
            break
        case "setProgress":
            expect Objective( objective )
            objective.progress = float( args[2] )
            break
        case "setMaxProgress":
            expect Objective( objective )
            objective.maxProgress = float( args[2] )
            break
    }
}

void function ObjectiveThread( Objective obj, void functionref( Objective ) callback )
{
    OnThreadEnd( 
        function() : ( obj )
        {
            file.objectives.fastremovebyvalue(obj)
        }
    )
    waitthread callback( obj )

    if (!obj.showCompleteMessage)
        return
    
    // Blink "Objective Complete" for 2.5s
    obj.displayType = ObjectiveDisplayType.SINGLE
    for (int i = 0; i < 5; i++)
    {
        if (i % 2 == 0)
        {
            obj.topLabel = "Objective"
            obj.bottomLabel = "Complete"
        }
        else    
        {
            obj.topLabel = ""
            obj.bottomLabel = ""
        }
        wait 0.49
    }
}

Objective ornull function FindObjectiveById( string id )
{
    foreach (Objective obj in file.objectives)
    {
        if (obj.id == id)
            return obj
    }
    return null
}

void function AddObjectiveCallback( string objType, void functionref( Objective ) callback )
{
    file.objectiveCallbacks[objType] <- callback
}

void function ServerCallback_SetStartPointIndex( int index )
{
    file.startPointIndex = index
}

void function WaitUntilComplete( Objective obj )
{
    while ( !obj.isComplete )
    {
        WaitFrame()
    }
}

// an objective is a thread - when the thread ends,
// the objective is considered complete. always
// make sure to add `!obj.isComplete` as a condition
// for while loops, so when the server sets an
// objective as complete, it ends on client as well.
void function Objective_WaitForEnemyCount( Objective obj )
{
    obj.displayType = ObjectiveDisplayType.EITHER_OR
    obj.topLabel = "Kill Enemies"
    obj.topLabel2 = "Wait"
    
    // progress - enemies left, maxProgress - end time
    while (obj.progress > 0.0 && Time() < obj.maxProgress && !obj.isComplete)
    {
        WaitFrame()
        obj.bottomLabel = format( "%i remain", int( obj.progress ) )
        int timeLeft = int( ceil(obj.maxProgress - Time()) )
        obj.bottomLabel2 = format( "%i:%02i", timeLeft / 60, timeLeft % 60 )
    }
}

void function Objective_TDayWaves( Objective obj )
{
    obj.displayType = ObjectiveDisplayType.SINGLE
    obj.topLabel = "Wave 1 of 3"
    
    // isComplete - are all enemies spawned
    // progress - wave number
    // maxProgress - wave count
    while (obj.maxProgress <= 3 && !obj.isComplete)
    {
        WaitFrame()
        obj.topLabel = format( "wave %i of 3", int( obj.maxProgress ) )
        if (obj.progress == -1)
        {
            obj.bottomLabel = "Spawning enemies..."
        }
        else
        {
            obj.bottomLabel = format( "%i titans left", int( obj.progress ) )
        }
    }

    obj.displayType = ObjectiveDisplayType.EITHER_OR
    float endTime = Time() + 12.0
    obj.topLabel = "Kill"
    obj.topLabel2 = "Wait"

    while (!obj.isComplete)
    {
        WaitFrame()
        obj.bottomLabel = format( "%i more", int( obj.progress ) )
        int timeLeft = int( ceil(endTime - Time()) )
        obj.bottomLabel2 = format( "%i:%02i", timeLeft / 60, timeLeft % 60 )
    }
}

void function Objective_MaltaGunGroup( Objective obj )
{
    int gun = int( obj.id.slice(obj.id.len() - 1) )
    obj.displayType = ObjectiveDisplayType.SINGLE
    obj.topLabel = "Gun " + gun + " progress"

    while (obj.maxProgress == 0)
    {
        obj.bottomLabel = format( "%i grunts left", int( obj.progress ) )
        WaitFrame()
    }

    while (!obj.isComplete)
    {
        obj.bottomLabel = format( "%i spectres left", int( obj.progress ) )
        WaitFrame()
    }
}

void function Objective_HangarEnemyWave( Objective obj )
{
    int gun = int( obj.id.slice(obj.id.len() - 1) )
    obj.displayType = ObjectiveDisplayType.SINGLE
    obj.topLabel = "kill all enemies"

    while (obj.progress > 0)
    {
        obj.bottomLabel = format( "%i enemies left", int( obj.progress ) )
        WaitFrame()
    }
}

void function Objective_Beacon2Triggers( Objective obj )
{
    obj.topLabel = "status"
    while (!obj.isComplete)
    {
        int progress = int(obj.progress)
        int maxProgress = int(obj.maxProgress)
        switch (progress)
        {
            case 0:
                obj.topLabel = "go to fightroom"
                break
            case 1:
                obj.bottomLabel = "killroom skip time :3"
                break
            case 2:
                obj.bottomLabel = "fuck the mrvn"
                break
            case 3:
                obj.bottomLabel = "get to fans"
                break
            case 4:
                obj.bottomLabel = "fans"
                break
            case 5:
                obj.bottomLabel = "weeeeeeeeeeee"
                break
            case 6:
                obj.bottomLabel = "fzzyfans or die"
                break
        }
        WaitFrame()
    }
}

void function Objective_HubFight( Objective obj )
{
    obj.topLabel = "spawning enemies..."
    while (!obj.isComplete)
    {
        if (obj.maxProgress > 0)
        {
            float timeUntilCleanup = obj.maxProgress - Time()
            if (timeUntilCleanup > 0)
            {
                obj.topLabel = "Cleanup in " + int(ceil(timeUntilCleanup)) + "..."
            }
            else
            {
                obj.topLabel = "Cleanup in progress"
            }
        }
        else obj.topLabel = "spawning enemies..."
        obj.bottomLabel = int( obj.progress ) + " remain"
        WaitFrame()
    }
}

void function Objective_Beacon3FinalFight( Objective obj )
{
    obj.topLabel = "Kill all enemies"
    while (!obj.isComplete)
    {
        obj.bottomLabel = int(obj.progress) + " remain"
        WaitFrame()
    }
}

void function Objective_Beacon3Triggers( Objective obj )
{
    obj.topLabel = "Triggers hit"
    while (!obj.isComplete)
    {
        obj.bottomLabel = format( "%i of %i", int(obj.progress), int(obj.maxProgress) )
        WaitFrame()
    }
}


void function Objective_EndlessBT( Objective obj )
{
    obj.topLabel = "Endless fight status"
    while (!obj.isComplete)
    {
        if (obj.maxProgress == 0.0)
            obj.bottomLabel = format( "Ongoing | %i", int(obj.progress) )
        else obj.bottomLabel = format( "0:%02i | %i", int(ceil(obj.maxProgress - Time())), int(obj.progress) )
        WaitFrame()
    }
}