extends Control
class_name Main


var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var result : int = 0


func _ready() -> void:
	rng.seed = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
	$P2FieldManager/TextureButton.disabled = true
	$P2FieldManager/TextureButton.position.y = 0
	$P2FieldManager/PointCounter.default_label_offset = 300
	$P2FieldManager.start()
	$P1FieldManager.start()


func dice_roll_result() -> int:
	return rng.randi_range(1, 6)


func roll(fm : FieldManager) -> void:
	result = dice_roll_result()
	$P2FieldManager/TextureButton.disabled = false
	$P1FieldManager/TextureButton.disabled = false
	fm.change_sprite(result)


func _end() -> void:
	var score1 : int = $P1FieldManager._game_ended()
	var score2 : int = $P2FieldManager._game_ended()
	$EndScreen/VBoxContainer/Label2.text = str(score1, " ", score2)
	if score1 > score2:
		$EndScreen/VBoxContainer/Label.text = "1 win"
	elif  score1 < score2:
		$EndScreen/VBoxContainer/Label.text = "2 win"
	else:
		$EndScreen/VBoxContainer/Label.text = "draw"
	$EndScreen.visible = true


func _check_enemy_dices(val, field, fm) -> void:
	if fm == $P1FieldManager:
		$P2FieldManager.check_enemy_column(val, field)
	else:
		$P1FieldManager.check_enemy_column(val, field)
