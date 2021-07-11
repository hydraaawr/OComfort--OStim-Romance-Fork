Scriptname oComfort_Main extends quest
{Main logic of oComfort.}

; code
Actor Property PlayerRef Auto  
oComfort_MCM Property oCom_MCM Auto
OsexIntegrationMain Property OStim Auto
ReferenceAlias property LoveInterest Auto
PlayerSleepQuestScript Property SleepQuest Auto


Event OnInit()
    RegisterForModEvent("ostim_start", "OnOstimStart")
endEvent

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    if (oCom_MCM.oComfort_Enabled && Ostim.IsPlayerInvolved())
        actor[] acts = Ostim.GetActors()
        if (oCom_MCM.oComfort_SpouseOnly)
            if (CheckIfValidSpouse(acts))
                applyLoversComfort()
            endif
        Else
            applyLoversComfort()
        endif
    endif
endEvent

Function applyLoversComfort()
    While Ostim.AnimationRunning()
        Utility.Wait(2.0)
    endWhile
    SleepQuest.RemoveRested()
    if (oCom_MCM.oComfort_MessageOn)
        Debug.Notification("You feel comforted by being with your lover.")
    endif
    PlayerRef.AddSpell(SleepQuest.MarriageSleepAbility, abVerbose = false)
endFunction

bool Function CheckIfValidSpouse(actor[] acts)
    Actor li = LoveInterest.GetActorReference()
    if (li == None)
        return false
    endif
    int len = acts.length
    int i = 0
    while i < Len
        actor act = acts[i]
        if (act == li)
            writelog(act)
            return true
        endif
        i += 1
    endwhile
    return false
endFunction

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("oComfort: " + OutputLog)
    Debug.Trace("oComfort: " + OutputLog)
    if (error == true)
        Debug.Notification("oComfort: " + OutputLog)
    endIF
EndFunction
