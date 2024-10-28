extends Control


var pvp := preload("res://pvp.tscn").instantiate()
var computer := preload("res://pve.tscn").instantiate()


func _on_pvp_button_pressed() -> void:
	get_tree().root.add_child(pvp)
	get_tree().current_scene = pvp
	get_tree().root.remove_child(self)


func _on_computer_button_pressed() -> void:
	get_tree().root.add_child(computer)
	get_tree().current_scene = computer
	get_tree().root.remove_child(self)


func _on_exit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
