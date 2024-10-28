extends ColorRect


signal restart()
signal exit()


func _on_button_pressed():
	emit_signal("restart")


func _on_exit_pressed():
	emit_signal("exit")


func set_labels_text(s1 : String, s2 : String) -> void:
	visible = true
	$VBoxContainer/Label.text = s1
	$VBoxContainer/Label2.text = s2
