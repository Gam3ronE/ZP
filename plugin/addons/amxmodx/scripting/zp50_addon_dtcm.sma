#include <amxmodx>
#include <zp50_gamemodes>

/*================================================================================
 [Customizations]
=================================================================================*/

// New constant "hud_tag" to contain the beginning of our Display The Current Mode (DTCM) HUD message.
new const hud_tag[] = "[Zombie Plague Mod]^nCurrent Mode: "

// New constant "mode_names" to contain all the mode names to be later displayed with our "hud_tag" constant.
new const mode_names[][] =
{
	"[Zombie Plague Mod]^nWaiting for New Mode...",	// No mode Started
	"Normal Infection",			// Normal Infection, single round
	"Multi-Infection",			// Multiple Infection (like single round, but, more than 1 zombie)
	"Nemesis Mode",				// Nemesis Mode (zombie boss)
	"Survivor Mode",			// Survivor Mode (human boss)
	"Swarm Mode",				// Swarm round (no infections)
	"Plague Mode",				// Plague round (nemesis & zombies vs. survivors & humans)
	"Armageddon	Mode"			// Armageddon Mode (human boss vs. zombie boss)
}

// HUD Message RGB Colours for each mode
// See RGB Colours here: http://web.njit.edu/~kevin/rgb.txt.html

// New constant "rgb_hud_colors" to contain all our HUD Message Colours.
new const rgb_hud_colors[sizeof(mode_names)][3] =
{
//		R    	G	    B
	{	255, 	20, 	147},		// No mode Started
	{	0, 		100, 	0}, 		// Normal Infection, single round
	{	0, 		69, 	0},			// Multiple Infection (like single round, but, more than 1 zombie)
	{	255, 	0, 		0},			// Nemesis Mode (zombie boss)
	{	0, 		191, 	255},		// Survivor Mode (human boss)
	{	255, 	0, 		0},			// Plague round (nemesis & zombies vs. survivors & humans)
	{	255, 	255, 	0},			// Swarm round (no infections)
	{	0, 		191, 	255}		// Armageddon Mode (human boss vs. zombie boss)
}

// X HUD Message Position ( --- ) LEFT to RIGHT
const Float:HUD_MODE_X = 0.65

// Y HUD Message Position ( ||| ) TOP TO BOTTOM
const Float:HUD_MODE_Y = 0.2

// Time at which the HUD Message is displayed. (when user is put in the Server)
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
	register_plugin("[ZP] Addon: Display The Current Mode", "0.1.7", "meTaLiCroSS")
	
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
	
	// If Zombie Plague is not running (bug fix)
	if(!get_pcvar_num(cvar_central))
		pause("a") 
}

public client_putinserver(id)
{
	// Setting HUD
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
	
	// HUD Options
	set_hudmessage(rgb_hud_colors[g_Mode][0], rgb_hud_colors[g_Mode][1], rgb_hud_colors[g_Mode][2], HUD_MODE_X, HUD_MODE_Y, 0, 6.0, 12.0)
	
	// Now the HUD appears
	ShowSyncHudMsg(id, g_SyncHud, "%s%s", (g_Mode == 0 ? "" : hud_tag), mode_names[g_Mode])
}

// When the mode starts.
public zp_round_started(mode, id)
{
	// Update the variable "g_Mode" with the Mode number.
	g_Mode = mode
	// If the Mode is not known take 1 from the mode name?
	if(!(1 <= mode < (sizeof(mode_names) - 1)))
	g_Mode = sizeof(mode_names) - 1
}