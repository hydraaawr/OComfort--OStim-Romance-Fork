Scriptname oComfort_Main extends quest
{Main logic of oComfort.}

; code

Actor Property PlayerRef  Auto  
oComfort_MCM Property oCom_MCM Auto
OsexIntegrationMain Property OStim Auto
ReferenceAlias property LoveInterest auto
PlayerSleepQuestScript Property SleepQuest auto


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
    SleepQuest.RemoveRested()
    SleepQuest.MarriageRestedMessage.Show()
    PlayerRef.AddSpell(SleepQuest.MarriageSleepAbility, abVerbose = false)
endFunction

bool Function CheckIfValidSpouse(actor[] acts)
    int len = acts.length
    int i = 0
    while i <= Len
        actor act = acts[i]
        if (act == LoveInterest.GetActorReference())
            return true
        endif
        i += 1
    endwhile
    return false
endFunction