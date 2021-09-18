Scriptname oComfort_mcm_ohshitiforgotthealias extends quest

Event OnInit()
	quest mcm_quest = self as quest
	oComfort_MCM mcm_page = mcm_quest as oComfort_MCM 
	
	if (mcm_page.CurrentVersion == 1)
		MiscUtil.PrintConsole("oComfort: Version change detected, scripts updated.")
		debug.Notification("oComfort: Version change detected, scripts updated.")
		referencealias mcm_alias = mcm_quest.GetNthAlias(0) as referencealias
		mcm_alias.ForceRefIfEmpty(Game.GetPlayer())
		mcm_alias.OnPlayerLoadGame()
	endif
endevent