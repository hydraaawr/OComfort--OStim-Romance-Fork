Scriptname oComfort_MCM extends nl_mcm_module
{Provides the mcm menu for oComfort}

; code
bool Property oComfort_Enabled  Auto
bool Property oComfort_SpouseOnly Auto

String Blue = "#6699ff"
String Pink = "#ff3389"

Event OnInit()
    RegisterModule("oComfort Options")
endevent

event OnPageInit()
    SetModName("oComfort")
    SetLandingPage("oComfort Options")
endEvent

int function getVersion()
    return 1
endFunction

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption(FONT_CUSTOM("oComfort Options", pink))
    AddToggleOptionST("oComfort_Enabled_State", "Enable Mod", oComfort_Enabled)
    AddToggleOptionST("oComfort_SpouseOnly_State", "Only with Spouse", oComfort_SpouseOnly)
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
            SetInfoText("Disable oComfort")
        else
            SetInfoText("Enable oComfort")
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
        SetInfoText("When enabled, you will only gain Lovers Comfort from having sex with your Spouse. /nWhen disabled, any Ostim scene will give Lovers Comfort.")
    endevent
endstate