extends Control


var default_label_offset : int = 0
var is_2_player : bool = false


func create_label(i : int, rowscols : int) -> void:
	var label : Label = Label.new()
	label.position = Vector2(480 * (i + 1)/(rowscols + 1) - 5, default_label_offset)
	if default_label_offset > 0 and is_2_player:
		label.scale.y = -1
	label.text = "0"
	label.name = str(i)
	add_child(label)


func set_label_value(i : int, value : int) -> void:
	var label : Label = get_node(str(i))
	label.text = str(value)
