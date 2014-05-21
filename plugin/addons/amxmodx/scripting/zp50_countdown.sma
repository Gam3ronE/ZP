// Source: https://forums.alliedmods.net/showthread.php?t=209029
// Set zp_gamemode_delay to 15

#include <amxmodx>
#include <csx>
#include <amxmisc>

#define PLUGIN "[ZP] Countdown"
#define VERSION "1.3"
#define AUTHOR "Dels"

new countdown_timer, cvar_countdown_sound;
new g_msgsync;
const TASK_ID = 1603;

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);	
	register_event("HLTV", "event_round_start", "a", "1=0", "2=0");
	
	//needed for smooth countdown display
	g_msgsync = CreateHudSyncObj();
	
	//cvars
	cvar_countdown_sound = register_cvar("countdown_sound", "1"); //1 to enable, 0 to disable
}
 
public plugin_precache()
{
    precache_sound("fvox/biohazard_detected.wav");
    precache_sound("fvox/one.wav");
    precache_sound("fvox/two.wav");
    precache_sound("fvox/three.wav");
    precache_sound("fvox/four.wav");
    precache_sound("fvox/five.wav");
    precache_sound("fvox/six.wav");
    precache_sound("fvox/seven.wav");
    precache_sound("fvox/eight.wav");
    precache_sound("fvox/nine.wav");
    precache_sound("fvox/ten.wav");
    precache_sound("fvox/eleven.wav");
    precache_sound("fvox/twelve.wav");
    precache_sound("fvox/thirteen.wav");
    precache_sound("fvox/fourteen.wav");
    precache_sound("fvox/fifteen.wav");
}

public event_round_start()
{
	//bugfix
	remove_task(TASK_ID);
	
	countdown_timer = get_cvar_num("zp_gamemode_delay") - 3;
	set_task(5.0, "countdown", TASK_ID);
}

public countdown()
{	
	new speak[16][] = { 
    "fvox/biohazard_detected.wav",
	"fvox/one.wav", 
	"fvox/two.wav", 
	"fvox/three.wav", 
	"fvox/four.wav", 
	"fvox/five.wav", 
	"fvox/six.wav", 
	"fvox/seven.wav", 
	"fvox/eight.wav", 
	"fvox/nine.wav",
	"fvox/ten.wav",
	"fvox/eleven.wav",
	"fvox/twelve.wav",
	"fvox/thirteen.wav",
	"fvox/fourteen.wav",
	"fvox/fifteen.wav"
	}

	if (countdown_timer > 1)
	{ 
		//emit_sound(0, CHAN_VOICE, speak[countdown_timer-1], 1.0, ATTN_NORM, 0, PITCH_NORM);
		if (cvar_countdown_sound != 0)
			client_cmd(0, "spk %s", speak[countdown_timer-2]);
			
		set_hudmessage(179, 0, 0, -1.0, 0.28, 2, 0.02, 1.0, 0.01, 0.1, 10);	
		if (countdown_timer != 1)
			ShowSyncHudMsg(0, g_msgsync, "%L", countdown_timer-2); //the new way
	}
	--countdown_timer;
		
	if(countdown_timer >= 1)
        set_task(1.0, "countdown", TASK_ID);
	else
		remove_task(TASK_ID);
}