Scriptname oComfort_Main extends quest
{Main logic of oComfort.}

; code
Actor Property PlayerRef Auto  
oComfort_MCM Property oCom_MCM Auto
OsexIntegrationMain Property OStim Auto
ReferenceAlias property LoveInterest Auto
PlayerSleepQuestScript Property SleepQuest Auto
IOSS_SceneInteractions Property IOSS_Scene Auto
IOSS_Relationship Property IOSS_Rel auto
Int Property CurrentAnimation auto
Int Property CUrrentQuery auto

Event OnInit()

    RegisterForModEvent("ostim_end", "OnOstimEnd")
    RegisterForModEvent("ostim_start", "OstimStart")

endEvent


; OStim Romance Fork System Addition ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OStimStart(string eventName, string strArg, float numArg, Form sender) ;Save AnimationPlayed for later evaluation
    
    ;Debug.Notification("Ostim scene started")
    CurrentAnimation = IOSS_Scene.AnimationPlayed
    ;Debug.Notification("CurrentAnimation = " + CurrentAnimation)
    
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Event OnOstimEnd(string eventName, string strArg, float numArg, Form sender)

    CurrentQuery = IOSS_Rel.Query
    ;Debug.Notification("CurrentQuery = " + IOSS_Rel.Query)

    if ((CurrentAnimation == 0 && (CurrentQuery == 0 || CurrentQuery == 4 || CurrentQuery ==  6 || CurrentQuery == 8)) || CurrentAnimation == 5 || CurrentAnimation == 7) ; Evaluates Current Animation and Dialogue (OStim Romance Fork)
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
    ; Else
    ;     Debug.Notification("Not a sex/succesful sex scene") DEBUG
    endif
endEvent

Function applyLoversComfort()
    SleepQuest.RemoveRested()
    if (oCom_MCM.oComfort_MessageOn)
        Utility.Wait(0.5)
        Debug.Notification("You feel comforted by being with your lover.")
    endif
    PlayerRef.AddSpell(SleepQuest.MarriageSleepAbility, abVerbose = false)
endFunction

bool Function CheckIfValidSpouse(actor[] acts)
    Actor li
    if (oCom_MCM.oComfort_Manual_Define && oCom_MCM.spouseManual)
        li = oCom_MCM.spouseManual
    else
        li = LoveInterest.GetActorReference()
    endif

    int liArrPos = acts.Find(li)

    if (li == None) || (liArrPos == -1)
        return false
    else 
        return true
    endif
endFunction

Function EnterSelectionMode()
    RegisterForMenu("Journal Menu")
    RegisterForKey(oCom_MCM.oComfort_Manual_Keymap)
endFunction

Event OnMenuClose(String MenuName)
    if (MenuName == "Journal Menu")
        Outils.DisplayToastText("Hover your crosshair over your Spouse and press ["+Outils.KeycodeToKey(oCom_MCM.oComfort_Manual_Keymap) +"] to select them.", 3.5)
        UnRegisterForMenu("Journal Menu")
    endif
endEvent

event OnKeyDown(int keycode)
    if (keycode == oCom_MCM.oComfort_Manual_Keymap && !Utility.IsInMenuMode())
        Actor act = Game.GetCurrentCrosshairRef() as Actor
        if (act)
            oCom_MCM.spouseManual = act
            Debug.Notification("Added "+ oCom_MCM.spouseManual.GetBaseObject().GetName() + " as manually designated spouse.")
            UnregisterForKey(oCom_MCM.oComfort_Manual_Keymap)
            oCom_MCM.selectionModeEnabled = false
        endif
    endif
endEvent

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("oComfort: " + OutputLog)
    Debug.Trace("oComfort: " + OutputLog)
    if (error == true)
        Debug.Notification("oComfort: " + OutputLog)
    endIF
EndFunction
