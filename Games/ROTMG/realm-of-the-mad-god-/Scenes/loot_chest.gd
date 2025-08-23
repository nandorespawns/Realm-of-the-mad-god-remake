extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var player_pickup_slots:
	get:
		var playerpickupslots = Global.player["pickup_slots"]
		return playerpickupslots

var chest_pickup_slots = []

func _ready() -> void:
	chest_pickup_slots.resize(8)
	chest_pickup_slots.fill(null)
	
	putinPickup(0, Items.sorc2)
	
func _process(delta: float) -> void:
	sprite_2d.rotation = -get_viewport_transform().get_rotation()
	


func _on_pick_up_range_body_entered(body: Node2D) -> void:
	if body.has_method("showSlots"):
		body["ismenuopen"] = true
		body["current_chest"] = self
		body.showSlots()
		
		

func _on_pick_up_range_body_exited(body: Node2D) -> void:
	if body.has_method("showSlots"):
		body["ismenuopen"] = false
		body["current_chest"] = null
		body.showSlots()

func canputinPickup(pickup_index):
	if chest_pickup_slots[pickup_index] == null:
		return true
	return false
	
func putinPickup(pickup_index, item):
	chest_pickup_slots[pickup_index] = item
	player_pickup_slots.get_child(pickup_index).set_texture(item["icon"])
	
