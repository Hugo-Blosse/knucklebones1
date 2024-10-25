extends TextureButton
class_name Field


var val : int = 0
var bonus : int = 0
var col_num : int
var row_num : int


signal selected(field : Field)
signal destroyed()


@onready var dice : Sprite2D = $Dice


func get_val() -> int:
	return val


func destroy() -> void:
	val = 0
	bonus = 0
	dice.visible = false
	emit_signal("destroyed")


func bonus_score(new_bonus : int) -> void:
	bonus = new_bonus
	dice.material.set("shader_parameter/bonus", bonus)


func _on_pressed() -> void:
	disabled = true
	emit_signal("selected", self)


func set_val(value : int) -> void:
	val = value
	dice.visible = true
	dice.texture = ResourceLoader.load(str("res://art/dice", val, ".png"))


func get_points() -> int:
	return val * bonus
