extends Control
signal hotbarUpdated
const slotClass=preload("res://scripts/slot.gd")
onready var inv=get_node("inv/grid")
onready var buildContainer=get_node("build/HBoxContainer")
onready var build=get_node("build")
onready var hotbarContainer=get_node("hotbar/HBoxContainer")
var holdingItem=null
var slotcount=1
var gamedata={}
var activenum=1
var slotTemp=null
func _ready():
	Datamanager.get_data()
	gamedata=Datamanager.saveData
	for slot in inv.get_children():
		slot.connect('gui_input',self,'slotInput',[slot])
		slot.slotnumber=slotcount
		if gamedata["inventory"].has(str(slotcount)):
			slot.addItem(gamedata["inventory"][str(slotcount)]["name"],gamedata["inventory"][str(slotcount)]["amt"])
		slotcount=slotcount+1
	slotcount=1
	for slot in buildContainer.get_children():
		slot.connect('gui_input',self,'slotInput',[slot])
		slot.slotnumber=slotcount
		if gamedata["build"].has(str(slotcount)):
			slot.addItem(gamedata["build"][str(slotcount)]["name"],gamedata["build"][str(slotcount)]["amt"])
			build.checkslotput()
		slotcount=slotcount+1
	slotcount=1
	for slot in hotbarContainer.get_children():
		slot.connect('gui_input',self,'slotInput',[slot])
		self.connect("hotbarUpdated",slot,"refresh")
		slot.slotnumber=slotcount
		if gamedata["hotbar"].has(str(slotcount)):
			slot.addItem(gamedata["hotbar"][str(slotcount)]["name"],gamedata["hotbar"][str(slotcount)]["amt"])
			build.checkslotput()
		slotcount=slotcount+1
	emit_signal("hotbarUpdated")
	build.get_node("output").connect('gui_input',self,'slotInput',[build.get_node("output")])
	build.get_node("output").slotnumber==0
	if gamedata["output"].has("0"):
		build.get_node("output").addItem(gamedata["output"]["0"]["name"],gamedata["output"][str(slotcount)]["amt"])
	self.connect("gui_input",self,'removeItem')
func slotInput(event:InputEvent,slot:slotClass):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_LEFT && event.pressed:
			if holdingItem!=null:
				if slot.itemPrefab!=null:
					var rtrn=slottypecheck(slot)
					if rtrn:
						var temp=holdingItem
						holdingItem=null
						slot.pickup()
						holdingItem.global_position=get_global_mouse_position()
						if slot.type==slot.slotType.build:
							build.checkslotpick()
						slot.putintoslot(temp)
						if slot.type==slot.slotType.build:
							build.checkslotput()
				else:
					var rtrn=slottypecheck(slot)
					if rtrn:
						slot.putintoslot(holdingItem)
						if slot.type==slot.slotType.build:
							build.checkslotput()
						holdingItem=null
						
			else:
				if slot.itemPrefab!=null:
					slot.pickup()
					holdingItem.global_position=get_global_mouse_position()
					if slot.type==slot.slotType.build:
							build.checkslotpick()

func slottypecheck(slot):
	match holdingItem.itemType:
		"weapon" :
			if slot.type==slot.slotType.inv or slot.type==slot.slotType.hotbar:
				return true
			else:
				return false
		"gunpart":
			if slot.type!=slot.slotType.hotbar:
				if slot.type==slot.slotType.build:
					if build.get_node("output").get_child_count()==0:
						match holdingItem.parttype:
							"gunbody":
								if slot.partType==slot.gunparts.body:
									if build.recipy!="":
										if holdingItem.recipy==build.recipy:
											return true
										else:
											return false
									else:
										return true
								else:
									return false
							"gunscope":
								if slot.partType==slot.gunparts.scope:
									if build.recipy!="":
										if holdingItem.recipy==build.recipy:
											return true
										else:
											return false
									else:
										return true
								else:
									return false
							"guntrigger":
								if slot.partType==slot.gunparts.trigger:
									if build.recipy!="":
										if holdingItem.recipy==build.recipy:
											return true
										else:
											return false
									else:
										return true
								else:
									return false
					else:
						false
				else:
					return true
			else:
				return false
		"consumable":
			if slot.type==slot.slotType.inv:
				return true
			else:
				return false
func _input(event):
	if holdingItem:
		holdingItem.global_position=get_global_mouse_position()
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("wheeldown"):
			activenum-=1
			if activenum<1:
				activenum=5
		elif Input.is_action_just_pressed("wheelup"):
			activenum+=1
			if activenum>5:
				activenum=1
		emit_signal("hotbarUpdated")
func removeItem(event:InputEvent):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_LEFT and event.pressed and holdingItem!=null:
			print(holdingItem.itemName)
			remove_child(holdingItem)
			holdingItem=null
func invSlotsearch():
	for slot in inv.get_children():
		if slot.states==slot.slotState.Empty:
			slotTemp=slot
			return true
	return false
func hotbarSlotsearch():
	for slot in hotbarContainer.get_children():
		if slot.states==slot.slotState.Empty or slot.states==slot.slotState.Emptyactive:
			slotTemp=slot
			return true
	return false
func additeminslot(Name,amt):
	if slotTemp!=null:
		slotTemp.addItem(Name,amt)
		slotTemp=null
func conUpdate(amt,ref):
	for s in inv.get_children():
		if s.states==s.slotState.Empty:
			slotTemp=s
			return true
		else:
			if s.get_child(0).itemType=="consumable" and s.get_child(0).stackAmount<300:
				var temp=Datamanager.itemDict[ref.itemName]["maxstack"]
				if temp>s.get_child(0).stackAmount+amt:
					s.get_child(0).stackAmount=s.get_child(0).stackAmount+amt
					s.get_child(0).label.text=str(s.get_child(0).stackAmount)
					ref.queue_free()
					s.saveData(true)
				else:
					var ItemAmt=s.get_child(0).stackAmount+amt-temp
					s.get_child(0).stackAmount=temp
					s.get_child(0).label.text=str(s.get_child(0).stackAmount)
					s.saveData(true)
					ref.stackamount=ItemAmt
					var rtrn=invSlotsearch()
					return rtrn
				return false
