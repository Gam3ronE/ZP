/*================================================================================
	
	------------------------------------
	-*- [ZP] Extra Item: Buy Classes -*-
	------------------------------------
	
================================================================================*/

// Restrict buy classes to once per map for https://forums.alliedmods.net/showthread.php?p=2162383

#include <amxmodx>
#include <zombie_plague_advance>

new g_item_nemesis, g_item_survivor, g_item_assassin, g_item_sniper, g_maxplayers, g_msgSayText

new const g_item_nem_name[] = "Buy Nemesis"
const g_item_nem_cost = 75

new const g_item_surv_name[] = "Buy Survivor"
const g_item_surv_cost = 75

new const g_item_assassin_name[] = "Buy Assassin"
const g_item_assassin_cost = 75

new const g_item_sniper_name[] = "Buy Sniper"
const g_item_sniper_cost = 75

new g_buyable, g_endround, RoundCount, cvar_delay, nemCount, survCount, assCount, snipCount

public plugin_init()
{
	register_plugin("[ZP] Extra Item: Buy Classes", "1.1", "93()|29!/<")
	
	register_event("HLTV", "event_round_start", "a", "1=0", "2=0")
	register_logevent("logevent_round_end", 2, "1=Round_End")
	
	g_maxplayers = get_maxplayers()
	g_msgSayText = get_user_msgid("SayText")
	
	g_buyable = true
	RoundCount = 0
	// Count uses of each class for one per map limit
	nemCount = 0
	survCount = 0
	assCount = 0
	snipCount = 0
}

public plugin_precache()
{
	g_item_nemesis = zp_register_extra_item(g_item_nem_name, g_item_nem_cost, ZP_TEAM_HUMAN)
	g_item_survivor = zp_register_extra_item(g_item_surv_name, g_item_surv_cost, ZP_TEAM_HUMAN)
	g_item_assassin = zp_register_extra_item(g_item_assassin_name, g_item_assassin_cost, ZP_TEAM_HUMAN)
	g_item_sniper = zp_register_extra_item(g_item_sniper_name, g_item_sniper_cost, ZP_TEAM_HUMAN)
	
	cvar_delay = register_cvar("zp_buy_classes_delay", "25")
}

public zp_extra_item_selected(id, itemid)
{
	// If the item is not nemesis, not survivor, not assassin, not sniper - do nothing
	if (itemid != g_item_nemesis && itemid != g_item_survivor && itemid != g_item_assassin && itemid != g_item_sniper)
		return PLUGIN_CONTINUE;
	
	// Check if the item is not buyable. If it's not then proceed to if options.
	if (!g_buyable)
	{
		// Check how many rounds we are into the game. If it's equal to the amount we have to wait, next round they can buy.
		if (RoundCount == get_pcvar_num(cvar_delay))
			zp_colored_print(id, "^x04[ZP]^x01 You have to wait one more round before you can buy this item")
		else
			zp_colored_print(id, "^x04[ZP]^x01 You have to wait %d rounds until you can buy this item", get_pcvar_num(cvar_delay) - RoundCount + 1)
		
		return ZP_PLUGIN_HANDLED;
	}
	
	// If the round has started or the round has ended do something.
	if (zp_has_round_started() == 1 || g_endround)
	{
		zp_colored_print(id, "^x04[ZP]^x01 This item can only be bought before the round mode starts")
		return ZP_PLUGIN_HANDLED;
	}
	
	// Get name of player.
	new name[32]
	get_user_name(id, name, 31)
	
	// If it's nemesis and nemCount is greater than 0, make user nemesis, add 1 to nemCount so it can be used once in map.
	// Then for Survivor, Assassin and Sniper do the same sort of thing.
	if (itemid == g_item_nemesis && nemCount > 0)
	{
		zp_make_user_nemesis(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Nemesis", name)
		nemCount++
	}
	else if (itemid == g_item_survivor && survCount > 0)
	{
		zp_make_user_survivor(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Survivor", name)
		survCount++
	}
	else if (itemid == g_item_assassin && assCount > 0)
	{
		zp_make_user_assassin(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Assassin", name)
		assCount++
	}
	else if (itemid == g_item_sniper && snipCount > 0)
	{
		zp_make_user_sniper(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Sniper", name)
		snipCount++
	}
	
	g_buyable = false
	
	return PLUGIN_CONTINUE;
}

public event_round_start()
	g_endround = false

public logevent_round_end()
{
	g_endround = true
	
	if (g_buyable)
		return;
	
	if (RoundCount < get_pcvar_num(cvar_delay))
		RoundCount++
	else if (RoundCount >= get_pcvar_num(cvar_delay))
	{
		g_buyable = true
		RoundCount = 0
	}
}

// Colored chat print by MeRcyLeZZ
zp_colored_print(target, const message[], any:...)
{
	static buffer[512], i, argscount
	argscount = numargs()
	
	// Send to everyone
	if (!target)
	{
		static player
		for (player = 1; player <= g_maxplayers; player++)
		{
			// Not connected
			if (!is_user_connected(player))
				continue;
			
			// Remember changed arguments
			static changed[5], changedcount // [5] = max LANG_PLAYER occurencies
			changedcount = 0
			
			// Replace LANG_PLAYER with player id
			for (i = 2; i < argscount; i++)
			{
				if (getarg(i) == LANG_PLAYER)
				{
					setarg(i, 0, player)
					changed[changedcount] = i
					changedcount++
				}
			}
			
			// Format message for player
			vformat(buffer, charsmax(buffer), message, 3)
			
			// Send it
			message_begin(MSG_ONE_UNRELIABLE, g_msgSayText, _, player)
			write_byte(player)
			write_string(buffer)
			message_end()
			
			// Replace back player id's with LANG_PLAYER
			for (i = 0; i < changedcount; i++)
				setarg(changed[i], 0, LANG_PLAYER)
		}
	}
	// Send to specific target
	else
	{
		// Format message for player
		vformat(buffer, charsmax(buffer), message, 3)
		
		// Send it
		message_begin(MSG_ONE, g_msgSayText, _, target)
		write_byte(target)
		write_string(buffer)
		message_end()
	}
}