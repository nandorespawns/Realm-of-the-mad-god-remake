extends Node2D

@export var ability_scene: PackedScene
@onready var area_2d: Area2D = $Area2D
@onready var cooldown: Timer = $Cooldown

var EnemyBodies = []
var manacost = 50




func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	
	var damage = Global.player["damage"] / 2
	
	
	#shoots
	var abilityuse = Input.is_action_pressed("ability")
	if abilityuse and cooldown.is_stopped() and Global.player["mp"] >= manacost:
		cooldown.start()
		Global.player["mp"] -= manacost
		for body in EnemyBodies:
			if body and is_instance_valid(body):
				
				var ability = ability_scene.instantiate()
				
				ability.damage = damage
				
				
				ability.zindex = z_index -1
				ability.position = body.global_position
				ability.rotation = -get_viewport_transform().get_rotation()
				get_tree().root.add_child(ability)


func _on_area_2d_body_entered(body: Node2D) -> void:
	EnemyBodies.append(body)
	print(body)
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	EnemyBodies.erase(body)
	
