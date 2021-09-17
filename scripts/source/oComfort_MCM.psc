Scriptname oComfort_MCM extends nl_mcm_module
{Provides the mcm menu for oComfort}

; code
oComfort_Main property main auto

bool Property oComfort_Enabled  Auto
bool Property oComfort_SpouseOnly Auto
bool Property oComfort_MessageOn Auto
bool Property oComfort_Manual_Define Auto
int Property oComfort_Manual_Keymap Auto
bool property selectionModeEnabled auto
actor property spouseManual auto

String Blue = "#6699ff"
String Pink = "#ff3389"

Event OnInit()
    RegisterModule("OComfort Options")
endevent

event OnPageInit()
    SetModName("OComfort")
    SetLandingPage("OComfort Options")
    startup()
endEvent

function startup()
    OUtils.RegisterForOUpdate(self)
    oComfort_Enabled = true
    oComfort_SpouseOnly = true
    oComfort_MessageOn = true
    oComfort_Manual_Define = false
    oComfort_Manual_Keymap = 35
    selectionModeEnabled = false

    main.oninit()

    if (main.ostim.GetAPIVersion() < 24)
        debug.MessageBox("Your OStim version is out of date. OComfort requires a newer version")
        return 
    endif

    if (!MiscUtil.FileExists("data/scripts/nl_mcm.pex"))
        Debug.MessageBox("NL_MCM is not installed. Please install it to use OComfort")
        return
    endif 
endFunction

int function getVersion()
    return 2
endFunction

event OnVersionUpdate(int a_version)
    if (CurrentVersion < a_version)
        startup()
        Writelog("Version change detected, scripts updated.", true)
    endif
endevent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption(FONT_CUSTOM("OComfort Options", pink))
    AddToggleOptionST("oComfort_Enabled_State", "Enable Mod:", oComfort_Enabled)
    AddToggleOptionST("oComfort_SpouseOnly_State", "Only active with Spouse:", oComfort_SpouseOnly)
    AddToggleOptionST("oComfort_MessageOn_State", "Show Messages:", oComfort_MessageOn)
    AddHeaderOption(FONT_CUSTOM("Manual Spouse", blue))
    AddToggleOptionST("oComfort_Manual_State", "Manually Define Spouse:", oComfort_Manual_Define)
    AddKeymapOptionST("oComfort_Manual_Keymap_State", "Manual Define Keybind:", oComfort_Manual_Keymap, getOptionFlag(oComfort_Manual_Define))
    AddTextOptionST("oComfort_Current_Manual_Spouse", "Current Manual Spouse:", getspousename(), OPTION_FLAG_DISABLED)
    if (oComfort_Manual_Define)
        AddTextOptionST("oComfort_Enter_Selection_State", "Enable spouse selection mode:", "Click", getOptionFlag(!selectionModeEnabled))
    endif
endEvent

state oComfort_Enabled_State
    event OnDefaultST(string state_id)
        oComfort_Enabled = true
        SetToggleOptionValueST(oComfort_Enabled, false, "oComfort_Enabled_State")
    endevent

    event OnSelectST(string state_id)
        oComfort_Enabled = !oComfort_Enabled
        SetToggleOptionValueST(oComfort_Enabled, false, "oComfort_Enabled_State")
    endevent

    event OnHighlightST(string state_id)
        if (oComfort_Enabled)
            SetInfoText("Disable OComfort")
        else
            SetInfoText("Enable OComfort")
        endif
    endevent
endstate

state oComfort_SpouseOnly_State
    event OnDefaultST(string state_id)
        oComfort_SpouseOnly = true
        SetToggleOptionValueST(oComfort_SpouseOnly, false, "oComfort_SpouseOnly_State")
    endevent

    event OnSelectST(string state_id)
        oComfort_SpouseOnly = !oComfort_SpouseOnly
        SetToggleOptionValueST(oComfort_SpouseOnly, false, "oComfort_SpouseOnly_State")
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("When enabled, you will only gain Lovers Comfort from having sex with your Spouse (Vanilla Skyrim Marriage). \n When disabled, any Ostim scene will give Lovers Comfort. \n ")
    endevent
endstate

state oComfort_MessageOn_State
    event OnDefaultST(string state_id)
        oComfort_MessageOn = true
        SetToggleOptionValueST(oComfort_MessageOn, false, "oComfort_MessageOn_State")
    endevent

    event OnSelectST(string state_id)
        oComfort_MessageOn = !oComfort_MessageOn
        SetToggleOptionValueST(oComfort_MessageOn, false, "oComfort_MessageOn_State")
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Hides after scene Messages.")
    endevent
endstate

state oComfort_Manual_State
    event OnSelectST(string state_id)
        oComfort_Manual_Define = !oComfort_Manual_Define
        ;if (!oComfort_Manual_Keymap)
        ;    oComfort_Manual_Keymap = 35
        ;endif
        ForcePageReset()
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Enable manually defining a spouse, this will allow you to choose any specific NPC to be your spouse instead of your Vanilla one. \n This won't make this NPC persistent, or anything like that though. So if you set this to some random bandit and they de-spawn, that's on you.")
    endevent
endstate

state oComfort_Manual_Keymap_State
	event OnHighlightST(string state_id)
		SetInfoText("Set the keybind to define your spouse.")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		oComfort_Manual_Keymap = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state oComfort_Enter_Selection_State
    event OnHighlightST(string state_id)
        SetInfoText("Enter Spouse selection mode, look at any NPC and press the spouse keybind above to select them as your spouse. \n Once you select an NPC, this mode disables and if you select the wrong NPC you'll need to enable it here again.")
    endEvent

    event OnSelectST(string state_id)
        handleManual()
    endevent
endstate

function handleManual()
    Debug.Messagebox("Exit the MCM and press ["+Outils.KeycodeToKey(oComfort_Manual_Keymap)+"] to select your spouse.")
    selectionModeEnabled = true
    main.EnterSelectionMode()
    ForcePageReset()
endFunction

string function getSpouseName()
    if (!spouseManual)
        return "None"
    Else
        return spouseManual.GetBaseObject().GetName()
    endif
endfunction

int function getOptionFlag(bool x)
    if (x)
        return OPTION_FLAG_NONE
    Else
        return OPTION_FLAG_DISABLED
    endif
endfunction

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("oComfort: " + OutputLog)
    Debug.Trace("oComfort: " + OutputLog)
    if (error == true)
        Debug.Notification("oComfort: " + OutputLog)
    endIF
EndFunction
