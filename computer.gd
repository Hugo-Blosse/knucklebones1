extends Main


var fields_comparison : Dictionary = {}
var ai_level : int = 2


@onready var timer : Timer = $Timer
@onready var p_2_field_manager : FieldManager = $P2FieldManager


func _ready() -> void:
	rng.seed = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
	$P2FieldManager/TextureButton.disabled = true
	$P2FieldManager/TextureButton.position.y = 0
	$P2FieldManager/PointCounter.default_label_offset = 300
	$P2FieldManager.start()
	$P1FieldManager.start()
	$DiceRollTimer.timeout.connect(_on_dice_roll_timer_timeout)
	$DiceRollTimer.wait_time = 0.2
	$DiceRollTimer.one_shot = true
	set_starting_fields_comparison()


func _check_enemy_dices(val, field, _fm) -> void:
	$P1FieldManager.check_enemy_column(val, field)


func roll(fm : FieldManager) -> void:
	result = dice_roll_result()
	current_fm = fm
	rolls = 6
	$DiceRollTimer.start()


func _on_dice_roll_timer_timeout() -> void:
	rolls -= 1
	if rolls != 0:
		dice_animation()
	else:
		current_fm.change_sprite(result)
		if current_fm == p_2_field_manager:
			timer.wait_time = 1
			timer.start()
		current_fm._on_roll_ended()


func _on_p_1_field_manager_check_enemy_dices(val, field, _fm) -> void:
	p_2_field_manager.check_enemy_column(val, field)
	if $P1FieldManager.num_of_filled_fields != 8:
		p_2_field_manager._on_texture_button_pressed()
		p_2_field_manager.texture_button.disabled = true
		fields_comparison[[field.col_num, field.row_num]] = [field, p_2_field_manager.fields[[field.col_num, field.row_num]]]


func _on_timer_timeout() -> void:
	check_next_move()


func check_next_move() -> void:
	var next_move_col : int = get_avalible_col_with_max_value_count()
	for j in p_2_field_manager.rowscols:
		if p_2_field_manager.fields[[next_move_col, j]].val == 0:
			p_2_field_manager._on_field_button_pressed(p_2_field_manager.fields[[next_move_col, j]])
			$P1FieldManager/TextureButton.disabled = false
			return


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
	var p_2_val_counter_max : int = 0
	
	if ai_level == 2 && avalible_cols.size() > 1:
		avalible_cols = check_enemy_fields(avalible_cols)
	if avalible_cols.size() == 1:
		return avalible_cols[0]
	
	for i in avalible_cols.size():
		for j in p_2_field_manager.rowscols:
			if fields_comparison[[avalible_cols[i], j]][0].val == p_2_field_manager.value:
				p_2_val_counter[avalible_cols[i]] += 1
			if fields_comparison[[avalible_cols[i], j]][1].val == p_2_field_manager.value:
				p_2_val_counter[avalible_cols[i]] += 1
	p_2_val_counter_max = p_2_val_counter.values().max()
	if p_2_val_counter_max == 0:
		return avalible_cols[rng.randi_range(0, avalible_cols.size() - 1)]
	return p_2_val_counter.find_key(p_2_val_counter_max)


func check_enemy_fields(avalible_cols : Array) -> Array:
	var ai_fields : Array = []
	var k : int = 0
	for i in p_2_field_manager.rowscols:
		for j in p_2_field_manager.rowscols:
			ai_fields.append(fields_comparison.values()[k][1])
			k += 1
	
	if $P1FieldManager.num_of_filled_fields > 6 && $P1FieldManager.get_score() > p_2_field_manager.get_score():
		var enemy_same_val_fields : Array = get_list_of_enemy_vals_equal_to_ai_val(fields_comparison)
		if enemy_same_val_fields.max() > 0:
			return avalible_cols.filter(func(num): return num == enemy_same_val_fields.bsearch(enemy_same_val_fields.max()))
	elif p_2_field_manager.value <= 2:
		var enemy_low_val_fields : Array = get_list_of_enemy_vals_equal_to_ai_val(fields_comparison)
		if enemy_low_val_fields.max() > 0:
			avalible_cols.remove_at(enemy_low_val_fields.bsearch(enemy_low_val_fields.max()))
	elif p_2_field_manager.value >= 4 && !check_for_same_field(p_2_field_manager.value):
		var b : Array = []
		for i in p_2_field_manager.rowscols:
			var l : int = 0
			b.append(0)
			for j in p_2_field_manager.rowscols:
				if fields_comparison[[i, j]][0].val <= 3 && fields_comparison[[i, j]][0].val != 0:
					l += 11
				elif fields_comparison[[i, j]][0].val > 3:
					l += 10
			b[i] = l
		if b.max() > 0:
			return avalible_cols.filter(func(num): return num == b.bsearch(b.max()))
	return avalible_cols


func check_for_same_field(value : int, id : int = 1) -> bool:
	for i in p_2_field_manager.rowscols:
		for j in p_2_field_manager.rowscols:
			if value == fields_comparison[[i, j]][id].value:
				return true
	return false


func get_list_of_enemy_vals_equal_to_ai_val(fields : Dictionary) -> Array:
	var a : Array = []
	for i in p_2_field_manager.rowscols:
		var k : int = 0
		a.append(0)
		for j in p_2_field_manager.rowscols:
			if fields[[i, j]][0].val == p_2_field_manager.value:
				k += 1
		a[i] = k
	return a


func _restart() -> void:
	$P1FieldManager.restart()
	p_2_field_manager.restart()
	$EndScreen.visible = false
	set_starting_fields_comparison()


func set_starting_fields_comparison() -> void:
	for i in p_2_field_manager.rowscols:
		for j in p_2_field_manager.rowscols:
			fields_comparison[[i, j]] = [$P1FieldManager.fields[[i, j]], p_2_field_manager.fields[[i, j]]]



