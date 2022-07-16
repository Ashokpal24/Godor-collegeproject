extends Control
func _on_start_pressed():
	get_tree().change_scene_to(Datamanager.mainScene)
	pass 
func _on_setting_pressed():
	get_tree().change_scene_to(Datamanager.settings)
	pass 
func _on_quit_pressed():
	get_tree().quit()
	pass 
func _on_credit_pressed():
	pass
