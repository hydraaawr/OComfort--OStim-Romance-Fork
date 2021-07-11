Scriptname oComfort_Main extends quest
{Main logic of oComfort.}

; code
Actor Property PlayerRef Auto  
oComfort_MCM Property oCom_MCM Auto
OsexIntegrationMain Property OStim Auto
ReferenceAlias property LoveInterest Auto
PlayerSleepQuestScript Property SleepQuest Auto


Event OnInit()
    RegisterForModEvent("ostim_end", "OnOstimEnd")
endEvent

Event OnOstimEnd(string eventName, string strArg, float numArg, Form sender)
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
    SleepQuest.RemoveRested()
    if (oCom_MCM.oComfort_MessageOn)
        Debug.Notification("You feel comforted by being with your lover.")
    endif
    PlayerRef.AddSpell(SleepQuest.MarriageSleepAbility, abVerbose = false)
endFunction

bool Function CheckIfValidSpouse(actor[] acts)
    Actor li = LoveInterest.GetActorReference()
    int liArrPos = acts.Find(li)

    if (li == None) || (liArrPos == -1)
        return false
    else 
        writelog(li)
        return true
    endif
endFunction

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("oComfort: " + OutputLog)
    Debug.Trace("oComfort: " + OutputLog)
    if (error == true)
        Debug.Notification("oComfort: " + OutputLog)
    endIF
EndFunction
