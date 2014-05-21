/*================================================================================
	
	----------------------------------
	-*- [ZP] Class: Human: Light -*-
	----------------------------------
	
	This plugin is part of Zombie Plague Mod and is distributed under the
	terms of the GNU General Public License. Check ZP_ReadMe.txt for details.
	
================================================================================*/

#include <amxmodx>
#include <zp50_class_human>

// Light Human Attributes
new const humanclass3_name[] = "Light Human"
new const humanclass3_info[] = "HP- Speed= Jump+"
new const humanclass3_models[][] = { "terror" }
const humanclass3_health = 250
const Float:humanclass3_speed = 1.00
const Float:humanclass3_gravity = 0.75

new g_HumanClassID

public plugin_precache()
{
	register_plugin("[ZP] Class: Human: Light", ZP_VERSION_STRING, "ZP Dev Team")
	
	g_HumanClassID = zp_class_human_register(humanclass3_name, humanclass3_info, humanclass3_health, humanclass3_speed, humanclass3_gravity)
	new index
	for (index = 0; index < sizeof humanclass3_models; index++)
		zp_class_human_register_model(g_HumanClassID, humanclass3_models[index])
}
