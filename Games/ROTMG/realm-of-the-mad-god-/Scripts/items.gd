class_name items
extends Node



enum ITEM_TYPE{
	WEAPON,
	ABILITY,
	ARMOR,
	RING,
	POTION
}



#NOTHINGS




var noweapon = {
	"scene": preload("res://Scenes/noweapon.tscn"),
	"icon": null,
	"name": "noweapon",
	"type": ITEM_TYPE.WEAPON,
	"damage_mod": 0,
	"dex_mod": 0,
	"mp_mod": 0,
	"wis_mod": 0
}

var noability = {
	"scene": preload("res://Scenes/noweapon.tscn"),
	"icon": null,
	"name": "noability",
	"type": ITEM_TYPE.ABILITY,
	"damage_mod": 0,
	"dex_mod": 0,
	"mp_mod" : 0,
	"wis_mod" :0
}



var default_placeholders = {
	ITEM_TYPE.WEAPON: noweapon,
	ITEM_TYPE.ABILITY: noability
}


#SORCERER WEAPONS

var sorc1 = {
	"scene": preload("res://Scenes/sorc1_projectile.tscn"),
	"icon": preload("res://Assets/ORYX sprites/Sliced/World/object_gem_blue.png"),
	"name": "sorc_wep1",
	"type": ITEM_TYPE.WEAPON,
	"damage_mod" : 0,
	"dex_mod" : 0,
	"mp_mod" : 0,
	"wis_mod" :0
}

var sorc2 = {
	"scene": preload("res://Scenes/sorc2_projectile.tscn"),
	"icon": preload("res://Assets/ORYX sprites/Sliced/World/object_gem_green.png"),
	"name": "sorc_wep2",
	"type": ITEM_TYPE.WEAPON,
	"damage_mod" : 0,
	"dex_mod" : 40,
	"mp_mod" : 100,
	"wis_mod" : 100
}


#SORCERER ABILITY

var sorcab1 = {
	"scene": preload("res://Scenes/sorc_ability.tscn"),
	"icon": preload("res://Assets/ORYX sprites/Sliced/FX/fire_blue_1.png"),
	"name": "sorc_ab1",
	"type": ITEM_TYPE.ABILITY,
	"damage_mod": 0,
	"dex_mod": 0,
	"mp_mod" : 0,
	"wis_mod" :0
}


#SORCERER ARMOR
