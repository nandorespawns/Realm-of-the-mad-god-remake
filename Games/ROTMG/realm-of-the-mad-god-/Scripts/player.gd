extends CharacterBody2D



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $CameraAnchor/Camera2DCenter
@onready var node_2d: Node2D = $CameraAnchor

#User Interface
@onready var exp_bar: ProgressBar = $CameraAnchor/Camera2DCenter/Panel/ExpBar
@onready var hp_bar: ProgressBar = $CameraAnchor/Camera2DCenter/Panel/HpBar
@onready var mp_bar: ProgressBar = $CameraAnchor/Camera2DCenter/Panel/MpBar

@onready var level_label: Label = $CameraAnchor/Camera2DCenter/Panel/GridContainer/Level
@onready var hp_label: Label = $CameraAnchor/Camera2DCenter/Panel/GridContainer/HP
@onready var mp_label: Label = $CameraAnchor/Camera2DCenter/Panel/GridContainer/MP

@onready var att_num: Label = $CameraAnchor/Camera2DCenter/Panel/StatContainer/Att_num
@onready var def_num: Label = $CameraAnchor/Camera2DCenter/Panel/StatContainer/Def_num
@onready var spd_num: Label = $CameraAnchor/Camera2DCenter/Panel/StatContainer/Spd_num
@onready var dex_num: Label = $CameraAnchor/Camera2DCenter/Panel/StatContainer/Dex_num
@onready var vit_num: Label = $CameraAnchor/Camera2DCenter/Panel/StatContainer/Vit_num
@onready var wis_num: Label = $CameraAnchor/Camera2DCenter/Panel/StatContainer/Wis_num


#Timers
@onready var vit_timer: Timer = $VitTimer
@onready var wis_timer: Timer = $WisTimer


var hascamoffset = false
var VCAM_OFFSET = 25
var HCAM_OFFSET = 19.5


var projectile_speed = 150



#STATS

var level: int = 1
var current_exp: int = 0
var exp_to_level: int = 10
var hp: int = 100
var max_hp: int = 100
var mp: int = 100
var max_mp: int = 100
var dex: float = 23
var damage = 17
var vitality: float = 17
var wisdom: float = 23
var defense: int = 0
var speed: float = 27



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player = self

func getDirection():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.rotated(node_2d.rotation)
	
	return direction


func movePlayer(direction):
	var speedrate = 12*(4 + 5.6 * (speed / 75))
	velocity = direction * speedrate
	
	move_and_slide()
	
func setCamOffset():
	#camera 2d is there to offset view
	var iscamoffsetinputpressed = Input.is_action_just_pressed("uncenter_cam")
	
	if iscamoffsetinputpressed and hascamoffset == false:
		camera_2d.position = Vector2(HCAM_OFFSET, -VCAM_OFFSET)
		hascamoffset = true
	elif iscamoffsetinputpressed and hascamoffset == true:
		camera_2d.position = Vector2(HCAM_OFFSET, 0)
		hascamoffset = false

func rotateCam():
	#Camera rotation
	#Camera rotation is based on the Node2d
	
	
	var isrotatingright = Input.is_action_pressed("rotate_right")
	var isrotatingleft = Input.is_action_pressed("rotate_left")
	var iscamcenter = Input.is_action_pressed("center_cam")
	
	
	if isrotatingright:
		node_2d.rotation += 0.05
		animated_sprite_2d.rotation = node_2d.rotation
	if isrotatingleft:
		node_2d.rotation -= 0.05
		animated_sprite_2d.rotation = node_2d.rotation
	if iscamcenter:
		node_2d.rotation = 0
		animated_sprite_2d.rotation = node_2d.rotation

		

func shootingAnim(mouseposition, playerposition):
	if abs(mouseposition.x - playerposition.x) > abs(mouseposition.y - playerposition.y):
		if mouseposition.x > playerposition.x:
			animated_sprite_2d.play("atk right")
				
		else:
			animated_sprite_2d.play("atk left")
	else:
		if mouseposition.y > playerposition.y:
			animated_sprite_2d.play("atk down")
		else:
			animated_sprite_2d.play("atk up")




func walkingAnim(direction):
	#idle when no moving and when no shooting
	if direction.x == 0 and direction.y ==0:
		animated_sprite_2d.play("idle down")
	#movement
	elif Input.is_action_pressed("move_right"):
		animated_sprite_2d.play("walk right")
	elif Input.is_action_pressed("move_left"):
		animated_sprite_2d.play("walk left")
	elif Input.is_action_pressed("move_down"):
		animated_sprite_2d.play("walk down")
	elif Input.is_action_pressed("move_up"):
		animated_sprite_2d.play("walk up")

func animateSprite(direction):
	var playerposition = get_global_transform_with_canvas().get_origin()
	var mouseposition = get_viewport().get_mouse_position()
	var isshooting = Input.is_action_pressed("shoot")
	var isability = Input.is_action_pressed("ability")
	
	
	if isshooting or isability:
		shootingAnim(mouseposition, playerposition)
		
	else:
		walkingAnim(direction)
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = getDirection()
	
	movePlayer(direction)
	
	setCamOffset()
	
	rotateCam()
	
	animateSprite(direction)
	
	modifyBars()
	
	getsLevel()
	
	regenStats()

func getsLevel():	
	if current_exp >= exp_to_level:
		var randomdef = randf_range(0,1)
		level += 1
		current_exp = 0
		exp_to_level *= 1.20
		max_hp += 25
		hp = max_hp
		max_mp += 10
		mp = max_mp
		damage += 2
		dex -= 0.03
		vitality += 2
		wisdom += 1
		speed += 1
		if randomdef >= 0.5:
			defense += 1
		else:
			pass
		
		


func takesDamage(damage):
	hp -= damage
	print("Player HP: ", hp)
	if hp == 0:
		print("deaded")

func regenVitality():
	var regenvit = (2 + 0.2407 * vitality)
	if vit_timer.is_stopped():
		vit_timer.start(1)
		
		if hp >= max_hp:
			pass
		elif max_hp - hp < regenvit:
			hp = max_hp
		else:
			hp += regenvit

func regenWisdom():
	var regenwis = 0.5 + 0.12 * wisdom
	if wis_timer.is_stopped():
		wis_timer.start(1)
		
		if mp >= max_mp:
			pass
		elif max_mp - mp < regenwis:
			mp = max_mp
		else:
			mp += regenwis
			
func regenStats():
	regenVitality()
	regenWisdom()


func modifyBars():
	#handles modifying HP
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	
	
	#handles modifying MP
	mp_bar.max_value = max_mp
	mp_bar.value = mp
	
	#handles modifying Level
	exp_bar.max_value = exp_to_level
	exp_bar.value = current_exp
	
	updateUI()

func updateUI():
	#updates the text on the progressbars
	#THERE ARE SPACES TO MAKE THE NUMS APPEAR IN THE MIDDLE LOL
	#THIS IS string interpolation
	hp_label.text = "HP:             %d / %d" % [hp, max_hp]
	mp_label.text = "MP:            %d / %d" % [mp, max_mp]
	level_label.text = "Level %d:       %d / %d" % [level, current_exp, exp_to_level]
	
	att_num.text = "%d" % [damage]
	def_num.text = "%d" % [defense]
	spd_num.text = "%d" % [speed]
	dex_num.text = "%d" % [dex]
	vit_num.text = "%d" % [vitality]
	wis_num.text = "%d" % [wisdom]




#func _on_hurt_box_area_entered(area: Area2D) -> void:
	#var unknownprojectiles = area.get_tree().get_nodes_in_group("Enemy Projectiles")
	#for unknownprojectile in unknownprojectiles:
		#if unknownprojectile.name == "EnemyProjectile":
			#hp -= 1
			#print(hp)
			#if hp == 0:
				#print("dieded")
