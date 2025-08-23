extends Node2D

@onready var ray_cast_2d: RayCast2D = $HitBox/RayCast2D


var speed: int 
var zindex: int
var damage: int
var weapon_dex = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#this gets called in the projectileshooter to make sure it's visibility is under Player
	z_index = zindex
	

func hitObject():
	if ray_cast_2d.is_colliding():
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	hitObject()
	
	


func _on_range_timer_timeout() -> void:
	queue_free()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("takesDamage"):
		body.takesDamage(damage)
