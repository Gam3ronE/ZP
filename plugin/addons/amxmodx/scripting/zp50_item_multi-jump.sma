#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <hamsandwich>

#include <zp50_core>
#include <zp50_items>
#include <zp50_class_nemesis>
#include <zp50_class_survivor>


#define PLUGIN "[ZP] Item: Multi-Jump"
#define VERSION "1.0"
#define AUTHOR "Xalus"

// Global Variables
new zpItem

new zpMultiJump[33]
new bool:plJump[33], plJumps[33]

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	// Register: Extra item
	zpItem = zp_items_register("Multi-Jump", 8)
	
	RegisterHam(Ham_Spawn, "player", "Ham_PlayerSpawn", 1);
}

public zp_fw_items_select_pre(id, itemid) { 
	if(itemid == zpItem)  { 
		if( zp_class_survivor_get(id) || zp_class_nemesis_get(id))
			return ZP_ITEM_DONT_SHOW
	} 
	return ZP_ITEM_AVAILABLE;  
} 

public zp_fw_core_infect_post(id, attacker)
	zpMultiJump[id] = 0
	
public zp_fw_items_select_post(player, itemid) {
	if(itemid == zpItem) {
		zpMultiJump[player]++
		client_print(player, print_center, "Now you can jump %i time(s) in mid-air.", zpMultiJump[player]);
	}
}

public Ham_PlayerSpawn(id)
	if(is_user_alive(id))
		zpMultiJump[id] = 0
		
public client_PreThink(id) {
	if(!is_user_alive(id) || !zpMultiJump[id])
		return

	new plButton[2]
	plButton[0] = get_user_button(id)
	plButton[1] = get_user_oldbutton(id)
	
	if( (plButton[0] & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(plButton[1] & IN_JUMP)) {
		if(plJumps[id] < zpMultiJump[id]) {
			plJump[id] = true
			plJumps[id]++
		}
	}
	else if((plButton[0] & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))
		plJumps[id] = 0
}

public client_PostThink(id) {
	if(!is_user_alive(id) || !plJump[id] || !zpMultiJump[id]) 
		return
	
	new Float:velocity[3]	
	entity_get_vector(id,EV_VEC_velocity,velocity)
	velocity[2] = random_float(265.0,285.0)
	entity_set_vector(id,EV_VEC_velocity,velocity)
	plJump[id] = false
}