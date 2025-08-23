extends TextureRect
class_name DragDrop

var texture_rect = self

@export var UI_array_index :int = 0
@export var UI_array_name : String


var player_inventory:
	get:
		return Global.player[UI_array_name]

func _get_drag_data(at_position):
	
	set_drag_preview(get_preview())
	texture_rect.visible = false
	
	
	return {
		"node": texture_rect,
		"index": UI_array_index,
		"array_name": UI_array_name
	}
	
	
	
func _can_drop_data(_pos, data):
	#data = target
	return typeof(data) == TYPE_DICTIONARY \
		and data.has("node") \
		and data.has("index") \
		and data.has("array_name")\
		and data.node is TextureRect

func _drop_data(_pos, data):
	
	
	#data = origin
	
	var source_array_name = data["array_name"]
	var source_array = Global.player[source_array_name]
	var source_index = data["index"]

	var target_array_name = UI_array_name
	var target_array = Global.player[target_array_name]
	var target_index = UI_array_index

	# Swap items between the two arrays
	var temp_item = target_array[target_index]
	target_array[target_index] = source_array[source_index]
	source_array[source_index] = temp_item

	print("Swapped:", temp_item, "<->", target_array[target_index], "\n")
	

	var temp_tex = texture_rect.texture
	texture_rect.texture = data["node"].texture
	data["node"].texture = temp_tex
	
	if target_array[target_index] == null:
		target_array[target_index] = Items.default_placeholders[temp_item.type]
	if source_array[source_index] == null:
		source_array[source_index] = Items.default_placeholders[target_array[target_index].type]
	
	
	
	
	if UI_array_name == "equipment" and UI_array_index == 0:
		Global.player.current_weapon = player_inventory[UI_array_index]
	if data["array_name"] == "equipment" and data["index"] == 0:
		Global.player.current_weapon = Global.player.equipment[0]
	if UI_array_name == "equipment" and UI_array_index == 1:
		Global.player.current_ability = player_inventory[UI_array_index]
	if data["array_name"] == "equipment" and data["index"] == 1:
		Global.player.current_ability = Global.player.equipment[1]
	
	
	
	
	
	#MAKE IT SO I CANNOT DROP A WEAPON INTO THE ABILITY SLOT AND VICEVERSA
	

func get_preview():
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = size
	preview_texture.position = -size/2
	
	var preview = Control.new()
	preview.z_index = 999
	preview.add_child(preview_texture)
	
	preview.rotation = -get_viewport_transform().get_rotation()
	
	
	return preview
	



func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		# Restore visibility no matter where the item was dropped
		texture_rect.visible = true
