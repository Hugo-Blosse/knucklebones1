extends Main


func _ready() -> void:
	rng.seed = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
	$P2FieldManager/TextureButton.disabled = true
	$P2FieldManager/TextureButton.position.y = 0
	$P2FieldManager/PointCounter.default_label_offset = 300
	$P2FieldManager.start()
	$P1FieldManager.start()


func _on_p_1_field_manager_check_enemy_dices(val, field, fm):
	pass # Replace with function body.
