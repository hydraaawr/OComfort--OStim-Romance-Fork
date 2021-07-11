Scriptname oComfort_MCM extends nl_mcm_module
{Provides the mcm menu for oComfort}

; code
bool Property oComfort_Enabled  Auto
bool Property oComfort_SpouseOnly Auto
bool Property oComfort_MessageOn Auto

String Blue = "#6699ff"
String Pink = "#ff3389"

Event OnInit()
    RegisterModule("OComfort Options")
endevent

event OnPageInit()
    SetModName("OComfort")
    SetLandingPage("OComfort Options")
    oComfort_Enabled = true
    oComfort_SpouseOnly = true
    oComfort_MessageOn = true
endEvent

int function getVersion()
    return 1
endFunction

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption(FONT_CUSTOM("OComfort Options", pink))
    AddToggleOptionST("oComfort_Enabled_State", "Enable Mod:", oComfort_Enabled)
    AddToggleOptionST("oComfort_SpouseOnly_State", "Only active with Spouse:", oComfort_SpouseOnly)
    AddToggleOptionST("oComfort_MessageOn_State", "Show Messages:", oComfort_MessageOn)
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