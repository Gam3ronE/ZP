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
	
	// Rounds you must wait to buy the item again
	cvar_delay = register_cvar("zp_buy_classes_delay", "5")
}

public zp_extra_item_selected(id, itemid)
{
	// If the item is not nemesis, not survivor, not assassin, not sniper - do nothing
	if (itemid != g_item_nemesis && itemid != g_item_survivor && itemid != g_item_assassin && itemid != g_item_sniper)
		return PLUGIN_CONTINUE;
	
	// Check if the item is not buyable. If it's not buyable then show messages.
	// If you always see this message then g_buyable is false. Find out why.
	if (!g_buyable)
	{
		// Check how many rounds we are into the game. If it's equal to the amount we have to wait, next round they can buy.
		// Examples: If Round count 0 and wait is 0. Round 1 Wait 1. Round 1 Wait 2.
		if (RoundCount == get_pcvar_num(cvar_delay))
			zp_colored_print(id, "^x04[ZP]^x01 You have to wait one more round before you can buy this item")
		else
			zp_colored_print(id, "^x04[ZP]^x01 You have to wait %d rounds until you can buy this item", get_pcvar_num(cvar_delay) - RoundCount + 1)
		
		return ZP_PLUGIN_HANDLED;
	}
	
	// If the round has started or the round has ended say you can only buy class before round mode starts.
	if (zp_has_round_started() || g_endround)
	{
		zp_colored_print(id, "^x04[ZP]^x01 This item can only be bought before the round mode starts")
		return ZP_PLUGIN_HANDLED;
	}
	
	// Get name of player.
	new name[32]
	get_user_name(id, name, 31)
	
	// If it's nemesis and nemCount is less than than 1, make user nemesis, add 1 to nemCount so it can be used once in map.
	// Then for Survivor, Assassin and Sniper do the same sort of thing.


	if (itemid == g_item_nemesis && nemCount < 1)
	{
		zp_make_user_nemesis(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Nemesis", name)
		nemCount++
	}
	// If count is greater than or equal to 1 then say it can only be bought once per map.
	else if (itemid == g_item_nemesis && nemCount >= 1)
	{
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01, Nemesis can only be bought once per map.", name)
		return ZP_PLUGIN_HANDLED;
	}
	
	
	else if (itemid == g_item_survivor && survCount < 1)
	{
		zp_make_user_survivor(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Survivor", name)
		survCount++
	}
	// If count is greater than or equal to 1 then say it can only be bought once per map.
	else if (itemid == g_item_survivor && survCount >= 1)
	{
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01, Survivor can only be bought once per map.", name)
		return ZP_PLUGIN_HANDLED;
	}
	
	
	else if (itemid == g_item_assassin && assCount < 1)
	{
		zp_make_user_assassin(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Assassin", name)
		assCount++
	}
	// If count is greater than or equal to 1 then say it can only be bought once per map.
	else if (itemid == g_item_assassin && assCount >= 1)
	{
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01, Assassin can only be bought once per map.", name)
		return ZP_PLUGIN_HANDLED;
	}
	
	
	else if (itemid == g_item_sniper && snipCount < 1)
	{
		zp_make_user_sniper(id)
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01 has bought^x04 Sniper", name)
		snipCount++
	}
	// If count is greater than or equal to 1 then say it can only be bought once per map.
	else if (itemid == g_item_sniper && snipCount >= 1)
	{
		zp_colored_print(0, "^x04[ZP]^x03 %s^x01, Sniper can only be bought once per map.", name)
		return ZP_PLUGIN_HANDLED;
	}
	
	g_buyable = false
	
	return PLUGIN_CONTINUE;
}

// Set end round variable to false when round starts. Used to block buy class at round end.
public event_round_start()
	g_endround = false

// Make classes buyable if the round count is equal to or greater than delay. E.g. round 5 delay 5. Classes buyable.
// Round 4 Delay 5 classes not buyable.
public logevent_round_end()
{
	// Set end round variable to true when round ends. Used to block buy class at round end.
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
