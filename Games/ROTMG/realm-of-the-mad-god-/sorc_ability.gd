extends Node2D

var zindex: int
var damage: int
@onready var duration: Timer = $duration

func _ready() -> void:
	#this gets called in the abilityshooter to make sure it's visibility is under Player
	z_index = zindex + 1
	
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("takesDamage"):
		body.takesDamage(damage)
		


func _on_duration_timeout() -> void:
	queue_free()
