extends "res://generic_projectile_shooter.gd"


var projectile_scene:
	get:
		var scene = Global.player["current_weapon"]["scene"]
		return scene
		

func shootProjectile():
	#projectiles aim at mouse
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	
	var damage = Global.player["damage"]
	var speed = Global.player["projectile_speed"]
	var dex = Global.player["total_dex"]
	
	#shoots
	var isshooting = Input.is_action_pressed("shoot")
	if isshooting and dex_timer.is_stopped():
		var dexspeed = 1/(1.5+6.5*(dex/75))
		dex_timer.start(dexspeed)
		var projectile_instance = projectile_scene.instantiate()
		
		projectile_instance.damage = damage
		projectile_instance.speed = speed
		
		projectile_instance.zindex = z_index -1
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = global_position
		projectile_instance.rotation = rotation


	
	
