extends Panel
var empty=preload("res://assets/UI/slot.png")
var full=preload("res://assets/UI/slotactive.png")
var active=preload("res://assets/UI/slotselect.png")
var path="res://assets/weapons/"
onready var itemScene=preload("res://scene/itemUi.tscn")
var emptyStyle:StyleBoxTexture=null
var fullStyle:StyleBoxTexture=null
var activeStyle:StyleBoxTexture=null
enum slotState{
	Empty,Full,Active,Emptyactive
}
var states=slotState.Empty
var itemPrefab=null
var slotnumber=0
enum slotType{
	inv,
	hotbar,
	build,
	output
}
var itemName=null
export(slotType) var type=slotType.inv
enum gunparts{
	body,
	scope,
	trigger
}
export(gunparts) var partType
func _ready():
	if get_child_count()>0:
		itemPrefab=get_child(0)
		itemPrefab.position=Vector2(self.rect_min_size.x/2,self.rect_min_size.y/2)
		states=slotState.Full
		refresh()
	emptyStyle=StyleBoxTexture.new()
	emptyStyle.texture=empty
	fullStyle=StyleBoxTexture.new()
	fullStyle.texture=full
	activeStyle=StyleBoxTexture.new()
	activeStyle.texture=active
	refresh()
func refresh():
	if type==slotType.hotbar and slotnumber==get_parent().get_parent().get_parent().activenum:
		if get_child_count()>0:
			states=slotState.Active
		else:
			states=slotState.Emptyactive
		find_parent("player").gunUpdate(itemName)
	elif get_child_count()>0:
		states=slotState.Full
	else:
		states=slotState.Empty
	match states:
		slotState.Empty:
			set("custom_styles/panel",emptyStyle)
		slotState.Full:
			set("custom_styles/panel",fullStyle)
		slotState.Active:
			set("custom_styles/panel",activeStyle)
		slotState.Emptyactive:
			set("custom_styles/panel",activeStyle)
func putintoslot(item):
	itemPrefab=item
	var inventory=find_parent("UI")
	inventory.remove_child(itemPrefab)
	itemName=itemPrefab.texture.resource_path
	itemName=itemName.replace(path,"")
	itemName=itemName.replace(".png","")
	itemPrefab.position=Vector2(self.rect_min_size.x/2,self.rect_min_size.y/2)
	add_child(itemPrefab)
	states=slotState.Full
	refresh()
	saveData(true)
func pickup():
	remove_child(itemPrefab)
	var inventory=find_parent("UI")
	inventory.add_child(itemPrefab)
	inventory.holdingItem=itemPrefab
	itemName=null
	itemPrefab=null
	states=slotState.Empty
	refresh()
	saveData(false)
func addItem(Name,amt):
	var itemInstance=itemScene.instance()
	itemName=Name
	itemInstance.texture=load(path+str(itemName)+".png")
	itemInstance.position=Vector2(self.rect_min_size.x/2,self.rect_min_size.y/2)
	itemInstance.stackAmount=amt
	add_child(itemInstance)
	itemPrefab=itemInstance
	states=slotState.Full
	refresh()
	saveData(true)
func saveData(add:bool):
	match type:
		slotType.inv:
			if add==true:
				Datamanager.saveData["inventory"][str(slotnumber)]={"name":itemName,"amt":get_child(0).stackAmount}
			else:
				Datamanager.saveData["inventory"].erase(str(slotnumber))
		slotType.hotbar:
			if add==true:
				Datamanager.saveData["hotbar"][str(slotnumber)]={"name":itemName,"amt":get_child(0).stackAmount}
			else:
				Datamanager.saveData["hotbar"].erase(str(slotnumber))
		slotType.build:
			if add==true:
				Datamanager.saveData["build"][str(slotnumber)]={"name":itemName,"amt":get_child(0).stackAmount}
			else:
				Datamanager.saveData["build"].erase(str(slotnumber))
		slotType.output:
			if add==true:
				Datamanager.saveData["output"][str(slotnumber)]={"name":itemName,"amt":get_child(0).stackAmount}
			else:
				Datamanager.saveData["output"].erase(str(slotnumber))
	Datamanager.save_game()
	Datamanager.get_data()
