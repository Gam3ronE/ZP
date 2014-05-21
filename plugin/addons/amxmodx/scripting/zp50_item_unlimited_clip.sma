#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <hamsandwich>

#include <zp50_core>
#include <zp50_items>
#include <zp50_class_nemesis>
#include <zp50_class_survivor>

#define PLUGIN "[ZP] Item: Unlimited Clip"
#define VERSION "1.0"
#define AUTHOR "Xalus"

// Global Variables
new zpItem
new bool:zpUnlimmited[33]

new const MAXCLIP[] = {
	-1, 13, -1, 10, 1, 7, -1, 30, 30, 1, 30, 20, 25, 30, 35, 25, 12, 20,
	10, 30, 100, 8, 30, 30, 20, 2, 7, 30, 30, -1, 50 
}

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	// Register: Extra Item
	zpItem = zp_items_register("Unlimited Clip", 20) 
	
	// Register: Event
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1", "3>0")
	
	// Register: Ham
	RegisterHam(Ham_Spawn, "player", "Ham_PlayerSpawn", 1);
}

public zp_fw_items_select_pre(id, itemid) { 
	if(itemid == zpItem) 
		if( zp_core_is_zombie(id) || zp_class_survivor_get(id) || zp_class_nemesis_get(id))
			return ZP_ITEM_DONT_SHOW
 
	return ZP_ITEM_AVAILABLE; 
} 		

public zp_fw_items_select_post(player, itemid)
	if(itemid == zpItem)
		zpUnlimmited[player] = true;

public Event_CurWeapon(id) {
	new szWeapID = read_data(2)
	
	if(zpUnlimmited[id] && MAXCLIP[szWeapID] >= 1) {
		new clip; get_user_weapon(id, clip)
		if(clip <= 3) {
			static szWeapName[64]
			get_weaponname(szWeapID, szWeapName, charsmax(szWeapName))
			
			clip = fm_find_ent_by_owner(clip, szWeapName, id)
			set_pdata_int(clip, 51, MAXCLIP[szWeapID], 4);
		}
	}
}

public Ham_PlayerSpawn(id)
	if(is_user_alive(id))
		zpUnlimmited[id] = false

stock fm_find_ent_by_owner(entity, const classname[], owner) {
	while ((entity = engfunc(EngFunc_FindEntityByString, entity, "classname", classname)) && pev(entity, pev_owner) != owner) {}
	
	return entity;
}