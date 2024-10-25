extends Main


var fields_comparison : Dictionary = {}


@onready var timer : Timer = $Timer
@onready var p_2_field_manager : FieldManager = $P2FieldManager


func _ready() -> void:
	rng.seed = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
	$P2FieldManager/TextureButton.disabled = true
	$P2FieldManager/TextureButton.position.y = 0
	$P2FieldManager/PointCounter.default_label_offset = 300
	$P2FieldManager.start()
	$P1FieldManager.start()
	set_starting_fields_comparison()


func _check_enemy_dices(val, field, _fm) -> void:
	p_2_field_manager.check_enemy_column(val, field)


func roll(fm : FieldManager) -> void:
	result = dice_roll_result()
	fm.change_sprite(result)


func _on_p_1_field_manager_check_enemy_dices(val, field) -> void:
	p_2_field_manager.check_enemy_column(val, field)
	p_2_field_manager._on_texture_button_pressed()
	p_2_field_manager.texture_button.disabled = true
	fields_comparison[[field.col_num, field.row_num]] = [field, p_2_field_manager.fields[[field.col_num, field.row_num]]]
	timer.wait_time = 1
	timer.start()


func _on_timer_timeout() -> void:
	if timer.wait_time == 1:
		check_next_move()


func check_next_move() -> void:
	var next_move_col : int = get_avalible_col_with_max_value_count()
	for j in p_2_field_manager.rowscols:
		if p_2_field_manager.fields[[next_move_col, j]].val == 0:
			p_2_field_manager._on_field_button_pressed(p_2_field_manager.fields[[next_move_col, j]])
			$P1FieldManager/TextureButton.disabled = false
			return


#func get_next_move_col() -> int:
	#var row_with_max_value : Array = get_avalible_row_with_max_value_count()
	#var avalible_cols = check_col_avalibility()
	#if row_with_max_value[1] > 0 && avalible_cols.has(row_with_max_value[0]):
		#return row_with_max_value[0]
	#else:
		#return avalible_cols[rng.randi_range(0, avalible_cols.size() -1)]


func check_col_avalibility() -> Array:
	var avalible_cols : Array = []
	for i in p_2_field_manager.rowscols:
		var count : int = 3
		for j in p_2_field_manager.rowscols:
			if p_2_field_manager.fields[[i, j]].val != 0:
				count -= 1
		if count > 0:
			avalible_cols.append(i)
	return avalible_cols


func get_avalible_col_with_max_value_count() -> int:
	var avalible_cols : Array = check_col_avalibility()
	var p_2_val_counter : Dictionary = {
		0 : 0,
		1 : 0,
		2 : 0
	}
	for i in avalible_cols.size():
		for j in p_2_field_manager.rowscols:
			if fields_comparison[[avalible_cols[i], j]][0].val == p_2_field_manager.value:
				p_2_val_counter[avalible_cols[i]] += 1
			if fields_comparison[[avalible_cols[i], j]][1].val == p_2_field_manager.value:
				p_2_val_counter[avalible_cols[i]] += 1
	var p_2_val_counter_max : int = 0
	p_2_val_counter_max = p_2_val_counter.values().max()
	if p_2_val_counter_max == 0:
		return avalible_cols[rng.randi_range(0, avalible_cols.size() - 1)]
	return p_2_val_counter.find_key(p_2_val_counter_max)


func _restart() -> void:
	$P1FieldManager.restart()
	p_2_field_manager.restart()
	$EndScreen.visible = false
	set_starting_fields_comparison()


func set_starting_fields_comparison() -> void:
	for i in p_2_field_manager.rowscols:
		for j in p_2_field_manager.rowscols:
			fields_comparison[[i, j]] = [$P1FieldManager.fields[[i, j]], p_2_field_manager.fields[[i, j]]]
