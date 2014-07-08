/*================================================================================ 

    Display the Current Mode
	
	- Add all modes for ZPA.
	
	- Show the following:
	
1. Nemesis Round = Human: %d | Nemesis: %d
2. Survivor Round: Survivor: %d | Zombie: %d
3. Assassin Round: Human: %d | Assassin: %d
4. Sniper Round: Sniper: %d | Zombie: %d
5. LNJ Round: Survivor: %d | Nemesis: %d
6. etc

Nemesis Round
Humans: %i | Nemesis's: %i

Survivor Round
Survivors: %i | Zombies: %i

Asassin Round
Assassins: %i | Humans: %i

Sniper Round
Snipers: %i | Humans: %i

Plague Round
Nemesis': %i | Zombies: %i | Survivors: %i | Humans %i

LNJ / Armageddon Round
Nemesis': %i | Zombies: %i | Survivors: %i | Humans %i

Snipers VS Assassins Round
Snipers: %i | Assassins: %i

=================================================================================*/ 

#include <amxmodx> 
#include <zombie_plague_advance> 

// Hudmessage tag 
new const hud_tag[] = "Current Mode :" 

// Name for each Hudmessage Mode 
new const mode_names[][] = 
{ 
    "Waiting for New Mode...",    	// No mode Started 
    "[Normal Infection]",        	// Normal Infection, single round 
    "[Nemesis Mode]",           	// Nemesis Mode (zombie boss) 
    "[Assassin Mode]",           	// Assasin Mode (zombie boss) 
    "[Survivor Mode]",        		// Survivor Mode (human boss) 
    "[Sniper Mode]",           		// Sniper Mode (human boss) 
    "[Swarm Mode]",            		// Swarm round (no infections) 
    "[Multi-Infection]",        	// Multiple Infection (like single round, but, more than 1 zombie) 
    "[Plague Mode]",            	// Plague round (nemesis & zombies vs. survivors & humans) 
    "[Armageddon Mode]",            // LNJ round (nemesis & zombies vs. survivors & humans) 
    "[Snipers VS Assassins]"        // An unofficial mode (edited/created/modified by user) 
} 

// RGB Colors for each Hudmessage Mode 
new const rgb_hud_colors[sizeof(mode_names)][3] = 
{ 
//  	R    		G    		B 
    {	255,     	20,     	147},      // No mode Started 
    {	0,     		100,     	0},        // Normal Infection, single round 
    {	255,    	0,     		0},        // Nemesis Mode (zombie boss) 
    {	255,     	0,     		0},        // Assasin Mode (zombie boss) 
    {	0,     		191,     	255},      // Survivor Mode (human boss) 
    {	0,     		0,     		255},      // Sniper Mode (human boss) 
    {	255,     	255,     	0},        // Swarm round (no infections) 
    {	0,     		69,     	0},        // Multiple Infection (like single round, but, more than 1 zombie) 
    {	255,    	0,     		0},        // Plague round (nemesis & zombies vs. survivors & humans) 
    {	255,     	0,     		0},        // LNJ round (nemesis & zombies vs. survivors & humans) 
    {	255,     	20,     	147}       // An unofficial mode (edited/created/modified by user) 
}

// X Hudmessage Position ( --- ) 
const Float:HUD_MODE_X = 0.65 

// Y Hudmessage Position ( ||| ) 
const Float:HUD_MODE_Y = 0.45

// Time at which the Hudmessage is displayed. (when user is puted into the Server) 
const Float:START_TIME = 3.0 

/*================================================================================ 
 Customization ends here! Yes, that's it. Editing anything beyond 
 here is not officially supported. Proceed at your own risk... 
=================================================================================*/ 

// Variables 
new g_SyncHud, g_Mode 

// Cvar pointers 
new cvar_enable, cvar_central 

public plugin_init()  
{ 
    // Plugin Info 
    register_plugin("[ZP] Addon: Display the Current Mode", "0.1.7", "meTaLiCroSS & SeniorRamos") 
     
    // Round Start Event 
    register_event("HLTV", "event_RoundStart", "a", "1=0", "2=0") 
     
    // Enable Cvar 
    cvar_enable = register_cvar("zp_display_mode", "1") 
     
    // Server Cvar 
    register_cvar("zp_addon_dtcm", "v0.1.6 by meTaLiCroSS", FCVAR_SERVER|FCVAR_SPONLY) 
     
    // Variables 
    g_SyncHud = CreateHudSyncObj() 
     
    // Getting "zp_on" cvar 
    if(cvar_exists("zp_on")) 
        cvar_central = get_cvar_pointer("zp_on") 
     
    // If Zombie Plague is not running (bugfix) 
    if(!get_pcvar_num(cvar_central)) 
        pause("a")  
} 

public client_putinserver(id) 
{ 
    // Setting Hud 
    set_task(START_TIME, "mode_hud", id, _, _, "b") 
} 

public event_RoundStart() 
{ 
    // Update var (no mode started / in delay) 
    g_Mode = 0 
} 

public mode_hud(id) 
{ 
	// If the Cvar isn't enabled 
	if(!get_pcvar_num(cvar_enable)) 
		return;

	new zombies = zp_get_zombie_count()
	new humans = zp_get_human_count()
	new nemesis = zp_get_nemesis_count()
	new survivors = zp_get_survivor_count()
	new assassins = zp_get_assassin_count()
	new snipers = zp_get_sniper_count()

/*	
	// Hud Options 
	set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 

	// Now the hud appears 
	ShowSyncHudMsg(id, g_SyncHud, "%s%s^nHumans: %i | Zombies: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], humans, zombies)
*/

	if( zp_is_nemesis_round() ) 
	{
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 
		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nHumans: %i | Nemesis's: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], humans, nemesis)  
	}
	else if ( zp_is_survivor_round() )
    {
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 
		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nSurvivors: %i | Zombies: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], survivors, zombies)  
	}
	else if ( zp_is_assassin_round() )
    {
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 
		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nAssassins: %i | Humans: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], assassins, humans)  
	}
	else if ( zp_is_sniper_round() )
    {
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 
		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nSnipers: %i | Humans: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], snipers, humans)  
	}
	else if ( zp_is_lnj_round() || zp_is_plague_round() )
    {
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 
		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nNemesis': %i | Zombies: %i | Snipers: %i | Humans: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], nemesis, zombies, survivors, humans)  
	}
	else if ( zp_get_current_mode() == MODE_INFECTION || MODE_SWARM || MODE_MULTI )
	{
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 

		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nHumans: %i | Zombies: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], humans, zombies)
	}
	else // Must be the Sniper vs Assassins now.
	{
		// Hud Options 
		set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0) 

		// Now the hud appears 
		ShowSyncHudMsg(id, g_SyncHud, "%s%s^nSnipers: %i | Assassins: %i", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode], snipers, assassins)
	}
} 

public zp_round_started(mode, id) 
{ 
    // Update var with Mode num 
    g_Mode = mode 
     
    // An unofficial mode 
    if(!(1 <= mode < (sizeof(mode_names) - 1))) 
        g_Mode = sizeof(mode_names) - 1 
}  