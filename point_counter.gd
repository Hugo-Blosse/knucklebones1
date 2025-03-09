extends Control


var default_label_offset : int = 0
var is_2_player : bool = false


@onready var score_label : Label = $Score


func create_label(i : int) -> void:
	var label : Label = get_node(str(i))
	if default_label_offset > 0:
		if is_2_player:
			print('yes')
			label.scale.y = -1
		label.position.y = size.y - 30
	label.text = "0"


func set_label_value(i : int, value : int) -> void:
	var label : Label = get_node(str(i))
	label.text = str(value)
	var score : int = 0
	score_label.text = str(0)
	for l in get_children():
		score += int(l.text)
	score_label.text = str(score)
