extends Control
onready var bloomlabel=get_node("CenterContainer/VBoxContainer/bloom/Label")
onready var brightnesslabel=get_node("CenterContainer/VBoxContainer/brightness/Label")
onready var saturationlabel=get_node("CenterContainer/VBoxContainer/saturation/Label")
onready var bloom_slider=get_node("CenterContainer/VBoxContainer/bloom/bloom_slider")
onready var brightness_slider=get_node("CenterContainer/VBoxContainer/brightness/brightness_slider")
onready var saturation_slider=get_node("CenterContainer/VBoxContainer/saturation/saturation_slider")
func _ready():
	bloom_slider.value=Datamanager.saveData["gameSettings"]["visual"]["bloom"]*10
	brightness_slider.value=Datamanager.saveData["gameSettings"]["visual"]["brightness"]*10-7
	saturation_slider.value=Datamanager.saveData["gameSettings"]["visual"]["saturation"]*10-7
func _on_saturation_slider_value_changed(value):
	saturationlabel.text=str(value)
	var temp=0.7+value*0.1
	Datamanager.saveData["gameSettings"]["visual"]["saturation"]=temp
	Datamanager.save_game()
	pass
func _on_brightness_slider_value_changed(value):
	brightnesslabel.text=str(value)
	var temp=0.7+value*0.1
	Datamanager.saveData["gameSettings"]["visual"]["brightness"]=temp
	Datamanager.save_game()
	pass 
func _on_bloom_slider_value_changed(value):
	bloomlabel.text=str(value)
	var temp=value*0.1
	Datamanager.saveData["gameSettings"]["visual"]["bloom"]=temp
	Datamanager.save_game()
	pass


func _on_Button_pressed():
	get_tree().change_scene_to(Datamanager.settings)
	pass # Replace with function body.
