extends Control
class_name FieldManager


const FieldBase := preload("res://field.tscn")


var fields : Dictionary = {}
var num_of_fields : int = 9
var num_of_filled_fields : int = 0
var rowscols : int = 0
var value : int = 0


signal rolled(fm : FieldManager)
signal check_enemy_dices(val : int, field : Field, fm : FieldManager)
signal end()


@onready var texture_button : TextureButton = $TextureButton


func start(num_of_fields : int = 9) -> void:
	fields.clear()
	rowscols = int(sqrt(num_of_fields))
	for i in rowscols:
		$PointCounter.create_label(i, rowscols)
		for j in rowscols:
			var field : Field = FieldBase.instantiate()
			add_child(field)
			field.name = str("Field", i, j)
			fields[[i, j]] = field
			field.col_num = i
			field.position = Vector2(480 * (i + 1)/(rowscols + 1), 320 * (j + 1)/(rowscols + 1)) - Vector2(24, 24)
			field.selected.connect(_on_field_button_pressed)
			field.destroyed.connect(change_num_of_filled_fields)


func check_your_column(val : int, field : Field) -> void:
	var bonus_counter : int = 0
	for j in rowscols:
		if fields[[field.col_num, j]].val == val:
			bonus_counter += 1
	for j in rowscols:
		if fields[[field.col_num, j]].val == val:
			fields[[field.col_num, j]].bonus_score(bonus_counter)


func set_points(col_num: int) -> int:
	var value : int
	for j in rowscols:
		value += fields[[col_num, j]].val * fields[[col_num, j]].bonus
	return value


func check_enemy_column(val : int, field : Field) -> void:
	for j in rowscols:
		if fields[[field.col_num, j]].get_val() == val:
			fields[[field.col_num, j]].destroy()
	$PointCounter.set_label_value(field.col_num, set_points(field.col_num))


func _on_texture_button_pressed() -> void:
	emit_signal("rolled", self)


func change_sprite(num):
	value = num
	$TextureButton.texture_normal = ResourceLoader.load(str("res://art/dice", num, ".png"))
	$TextureButton.disabled = true
	set_fields_disabled(false)


func _on_field_button_pressed(field : Field) -> void:
	field.set_val(value)
	check_your_column(value, field)
	change_num_of_filled_fields(1)
	set_fields_disabled(true)
	$PointCounter.set_label_value(field.col_num, set_points(field.col_num))
	emit_signal("check_enemy_dices", value, field, self)


func set_fields_disabled(is_disabled : bool) -> void:
	for f in fields.keys():
		if fields[f].val == 0:
			fields[f].disabled = is_disabled


func change_num_of_filled_fields(num : int = -1) -> void:
	num_of_filled_fields += num
	if num_of_filled_fields == 9:
		emit_signal("end")


func _game_ended() -> int:
	var score : int
	for f in fields.keys():
		score += fields[f].get_points()
	return score
