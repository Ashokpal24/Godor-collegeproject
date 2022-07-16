extends Control
func _on_audio_pressed():
	get_tree().change_scene_to(Datamanager.audio)
	pass # Replace with function body.
func _on_video_pressed():
	get_tree().change_scene_to(Datamanager.visual)
	pass # Replace with function body.
func _on_back_pressed():
	get_tree().change_scene_to(Datamanager.mainmenu)
	pass # Replace with function body.
