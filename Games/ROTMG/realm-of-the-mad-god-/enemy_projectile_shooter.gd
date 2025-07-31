extends "res://generic_projectile_shooter.gd"

@export var projectile_scene: PackedScene
var attack = "notattacking"

func shootProjectile():
	var player_sprite: AnimatedSprite2D = Global.player.get_node("AnimatedSprite2D")
	var dex = get_parent()["dex"]
	var damage = get_parent()["damage"]
	var speed = get_parent()["projectile_speed"]
	
	if player_sprite and player_sprite.sprite_frames:
		var anim = player_sprite.animation
		var frame = player_sprite.frame
		var texture = player_sprite.sprite_frames.get_frame_texture(anim, frame)
		if texture:
			var texture_size = texture.get_size()
			look_at(Global.player.global_position - texture_size/ 2)
			if attack == "attacking" and dex_timer.is_stopped():
				dex_timer.start(dex)
				var projectile_instance = projectile_scene.instantiate()
				get_tree().root.add_child(projectile_instance)
				
				projectile_instance.damage = damage
				projectile_instance.speed = speed

				projectile_instance.global_position = global_position 
				projectile_instance.rotation = rotation
				
	

func _on_shoot_area_body_entered(body: Node2D) -> void:
	#print("im shootin ya")
	attack = "attacking"


func _on_shoot_area_body_exited(body: Node2D) -> void:
	#print("drats im not shootin ya")
	attack = "notattacking"
