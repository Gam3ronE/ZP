// Thanks to H.RED.ZONE and MeRcyLeZZ at https://forums.alliedmods.net/showthread.php?p=1628536#post1628536

#include <amxmodx>
#include <zp50_core>
#include <zp50_items>
#include <zp50_class_nemesis>
#include <zp50_class_survivor>
#include <zp50_gamemodes>
#include <zp50_colorchat>

new g_nemesis, g_survivor, g_GameModeNemesisID, g_GameModeSurvivorID

public plugin_cfg()
{
    g_GameModeNemesisID = zp_gamemodes_get_id("Nemesis Mode")
    g_GameModeSurvivorID = zp_gamemodes_get_id("Survivor Mode")
}

public plugin_init()
{
        register_plugin("[ZP] Item: Buy Nemesis or Survivor", "1", "snaker-beatter")
        
        g_nemesis = zp_items_register("Buy Nemesis", 75)
        g_survivor = zp_items_register("Buy Survivor", 75)
}

public zp_fw_items_select_pre(player, itemid)
{
    if (itemid == g_nemesis)
    {
        if (!zp_core_is_zombie(player) || zp_class_nemesis_get(player) || zp_class_survivor_get(player))
            return ZP_ITEM_DONT_SHOW;
        
        // No game mode in progress and Nemesis mode disabled
        if (zp_gamemodes_get_current() == ZP_NO_GAME_MODE && g_GameModeNemesisID == ZP_INVALID_GAME_MODE)
            return ZP_ITEM_DONT_SHOW;
        
        return ZP_ITEM_AVAILABLE;
    }
	
    else if (itemid == g_survivor)
    {
        if (zp_core_is_zombie(player) || zp_class_survivor_get(player) || zp_class_nemesis_get(player))
            return ZP_ITEM_DONT_SHOW;
        
        // No game mode in progress and Survivor mode disabled
        if (zp_gamemodes_get_current() == ZP_NO_GAME_MODE && g_GameModeSurvivorID == ZP_INVALID_GAME_MODE)
            return ZP_ITEM_DONT_SHOW;
	}
	return ZP_ITEM_DONT_SHOW;
}

public zp_fw_items_select_post(player, itemid)
{
    if (itemid == g_nemesis)
    {
        // Check if a game mode is in progress
        if (zp_gamemodes_get_current() == ZP_NO_GAME_MODE)
        {
            // Start nemesis game mode with this target player
            if (!zp_gamemodes_start(g_GameModeNemesisID, player))
            {
                zp_colored_print(player, "%L", player, "GAME_MODE_CANT_START")
                return;
            }
        }
        else
        {
            // Make player nemesis
            zp_class_nemesis_set(player)
        }
    }
    else if (itemid == g_survivor)
    {
        // Check if a game mode is in progress
        if (zp_gamemodes_get_current() == ZP_NO_GAME_MODE)
        {
            // Start survivor game mode with this target player
            if (!zp_gamemodes_start(g_GameModeSurvivorID, player))
            {
                zp_colored_print(player, "%L", player, "GAME_MODE_CANT_START")
                return;
            }
        }
        else
        {
            // Make player survivor
            zp_class_survivor_set(player)
        }
    }
}
