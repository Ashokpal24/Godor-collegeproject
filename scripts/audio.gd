extends Control
onready var GAlabel=get_node("CenterContainer/VBoxContainer/Game Audio/Label")
onready var GMlabel=get_node("CenterContainer/VBoxContainer/Game music/Label")
onready var GA_slider=get_node("CenterContainer/VBoxContainer/Game Audio/GA_audio")
onready var GM_slider=get_node("CenterContainer/VBoxContainer/Game music/GM_audio")
func _ready():
	GA_slider.value=Datamanager.saveData["gameSettings"]["audio"]["gameAudio"]*10
	GM_slider.value=Datamanager.saveData["gameSettings"]["audio"]["gameMusic"]*10
func _on_GA_audio_value_changed(value):
	GAlabel.text=str(value)
	var temp=value*0.1
	Datamanager.saveData["gameSettings"]["audio"]["gameAudio"]=temp
	Datamanager.save_game()
	pass # Replace with function body.
func _on_GM_audio_value_changed(value):
	GMlabel.text=str(value)
	var temp=value*0.1
	Datamanager.saveData["gameSettings"]["audio"]["gameMusic"]=temp
	Datamanager.save_game()
	pass # Replace with function body.


func _on_Button_pressed():
	get_tree().change_scene_to(Datamanager.settings)
	pass # Replace with function body.
