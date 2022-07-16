extends TextureRect
var recipy=""
var mCounter=0
func checkslotput():
	var temp
	mCounter=0
	for j in get_node("HBoxContainer").get_children():
		if j.get_child_count()>0:
			mCounter+=1
			temp=j
			print(mCounter)
	if mCounter>0:
		recipy=Datamanager.itemDict[temp.itemName]["recipy_name"]
		get_node("Label").text=str(recipy)
func checkslotpick():
	mCounter=0
	for j in get_node("HBoxContainer").get_children():
		if j.get_child_count()>0:
			mCounter+=1
			print(mCounter)
	if mCounter==0:
		recipy=""
		get_node("Label").text=""
func _on_Button_pressed():
	check()
func check():
	var counter=0
	for i in get_node("HBoxContainer").get_children():
		if i.get_child_count()>0:
			counter+=1
	if counter==3:
		instanceweapon()
func instanceweapon():
	var Name=recipy
	get_node("output").addItem(recipy)
	recipy=""
	get_node("Label").text=""
	for i in get_node("HBoxContainer").get_children():
		i.remove_child(i.get_child(0))
		i.itemPrefab=null
		i.saveData(false)
		i.states=i.slotState.Empty
		i.refresh()
