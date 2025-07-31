extends CharacterBody2D



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hover_direction_timer: Timer = $HoverDirectionTimer
@onready var enemy_projectile_shooter: Node2D = $EnemyProjectileShooter
@onready var animation_timer: Timer = $AnimationTimer

var player_range = "none"
var randomdirection = RandomNumberGenerator.new()
var randomnumber = 0
@export var hp = 10
@export var dex: float = 0.9
@export var speed: int = 15
@export var damage: int = 1
@export var projectile_speed = 60
@export var exp_worth: int  = 5


func takesDamage(damage):
	hp -= damage
	print("Enemy HP: ", hp)
	if hp <= 0:
		givesExperience()
		queue_free()
		
func givesExperience():
	Global.player["current_exp"] += exp_worth
	print(Global.player["current_exp"])

func playAnimation():
	var randomanimation = randf_range(0,1)
	if enemy_projectile_shooter["attack"] == "attacking":
		if randomanimation >= 0.5 and animation_timer.is_stopped():
			animation_timer.start()
			animated_sprite_2d.play("atk right")
		elif randomanimation <= 0.5 and animation_timer.is_stopped():
			animation_timer.start()
			animated_sprite_2d.play("atk left")
	else:
		animated_sprite_2d.play("idle")


func moveEnemy():
	animated_sprite_2d.rotation = -get_viewport_transform().get_rotation()
	playAnimation()
	
	if Global.player and player_range =="none":
		velocity = Vector2.ZERO
	
	elif Global.player and player_range == "far":
		var direction = (Global.player.global_position - global_position).normalized() 
		
		velocity = direction * speed 
	elif Global.player and player_range == "hover":
		
		if hover_direction_timer.is_stopped():
			hover_direction_timer.start()
			randomnumber = randomdirection.randf_range(0,1)
			
			var direction = Vector2.from_angle(randomnumber).normalized()
			velocity = direction * speed
			#print(direction, velocity)
	else:
		var direction = (global_position - Global.player.global_position).normalized() 
		velocity = direction * speed 
		
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moveEnemy()

		



func _on_hover_area_body_entered(body: Node2D) -> void:
	#print("detected")
	player_range = "hover"

func _on_hover_area_body_exited(body: Node2D) -> void:
	#print("no longer detected")
	player_range = "far"
	
func _on_close_area_body_entered(body: Node2D) -> void:
	#print("i am inside u")
	player_range = "close"

func _on_close_area_body_exited(body: Node2D) -> void:
	#print("i am no longer inside you :(")
	player_range = "hover"

func _on_find_player_body_entered(body: Node2D) -> void:
	player_range = "far"
