#include <amxmodx>
#include <amxmisc>
#include <fun> 
#include <fakemeta>
#include <hamsandwich>
#include <cstrike>

#include <zp50_core>
#include <zp50_items>
#include <zp50_class_nemesis>
#include <zp50_class_survivor>

#define PLUGIN "[ZP] Item: Golden AK-47"
#define VERSION "1.0"
#define AUTHOR "Xalus"

// Models
new const Golden_Models[2][] = {
	"models/zombie_plague/v_golden_ak47.mdl",
	"models/zombie_plague/p_golden_ak47.mdl"
}

// Global Variables
new zpItem
new m_spriteTexture
new bool:plAk[33]

public plugin_precache() {
	for(new i = 0; i < sizeof(Golden_Models); i++)
		precache_model(Golden_Models[i])
		
	m_spriteTexture = precache_model("sprites/dot.spr")
}

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	// Register: Extra item
	zpItem = zp_items_register("Golden AK-47", 45) 

	// Register: Event
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1", "3>0")

	// Register: Ham
	RegisterHam(Ham_TakeDamage, "player", "Ham_PlayerTakeDamage");
	RegisterHam(Ham_Spawn, "player", "Ham_PlayerSpawn", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_ak47", "Ham_GoldenModel", 1);
}	

public zp_fw_items_select_pre(id, itemid) { 
	if(itemid == zpItem)  { 
		if( zp_core_is_zombie(id) || zp_class_survivor_get(id) || zp_class_nemesis_get(id))
			return ZP_ITEM_DONT_SHOW
	} 
	return ZP_ITEM_AVAILABLE; 
} 

public zp_fw_core_infect_post(id, attacker)
	if(zp_core_is_zombie(id))
		plAk[id] = false
		
public zp_fw_items_select_post(player, itemid) {
	if(itemid == zpItem) {
		plAk[player] = true;
		if(!user_has_weapon(player, CSW_AK47) )
			give_item(player, "weapon_ak47")
		
		client_cmd(player, "weapon_knife")
		client_cmd(player, "weapon_ak47")
	}
}

public Ham_GoldenModel( entity ) {
	if(pev_valid(entity) != 2) 
		return HAM_IGNORED;
    
	new id = get_pdata_cbase( entity, 41, 4 );
    
	if(!is_user_alive(id) || !plAk[id])
		return HAM_IGNORED
		
	set_pev(id, pev_viewmodel2, Golden_Models[0])
	set_pev(id, pev_weaponmodel2, Golden_Models[1])
	
	return HAM_IGNORED
}

public Event_CurWeapon(id) {
	new szWeapID = read_data(2)
	
	if(szWeapID != CSW_AK47)
		return PLUGIN_CONTINUE
		
	if(plAk[id]) {
		new clip; get_user_weapon(id, clip)
		if(clip <= 3) {
			clip = fm_find_ent_by_owner(clip, "weapon_ak47", id)
			set_pdata_int(clip, 51, 30, 4);
		}

		// Golden: Bullet
		new Vector[2][3]
		get_user_origin(id, Vector[0], 1)
		get_user_origin(id, Vector[1], 4)
			
		message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(0)
		write_coord(Vector[0][0])
		write_coord(Vector[0][1])
		write_coord(Vector[0][2])
		write_coord(Vector[1][0])
		write_coord(Vector[1][1])
		write_coord(Vector[1][2])
		write_short(m_spriteTexture)
		write_byte(1)
		write_byte(5)
		write_byte(2)
		write_byte(10)
		write_byte(0)
		write_byte(255)
		write_byte(215)
		write_byte(0)
		write_byte(200)
		write_byte(150)
		message_end()
	}
	return PLUGIN_CONTINUE
}

public Ham_PlayerTakeDamage(id, inflictor, iAttacker, Float:damage, damagebits)
	if(is_user_alive(iAttacker) && (damagebits & DMG_BULLET) && get_user_weapon(iAttacker) == CSW_AK47 && plAk[iAttacker])
		SetHamParamFloat(4, damage * 3.0)
		
public Ham_PlayerSpawn(id) {
	if(is_user_alive(id)) {
		plAk[id] = false
		if(user_has_weapon(id, CSW_AK47)) {
			client_cmd(id, "weapon_knife")
			client_cmd(id, "weapon_ak47")
		}
	}
}

stock fm_find_ent_by_owner(entity, const classname[], owner) {
	while ((entity = engfunc(EngFunc_FindEntityByString, entity, "classname", classname)) && pev(entity, pev_owner) != owner) {}
	
	return entity;
}