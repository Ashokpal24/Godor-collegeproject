extends Sprite
var itemName=""
var itemType=""
var parttype=""
var recipy=""
onready var label=$Label
var stackAmount=0
func _ready():
	if self.texture!=null:
		itemName=self.texture.resource_path
		itemName=itemName.replace("res://assets/weapons/","")
		itemName=itemName.replace(".png","")
		itemType=Datamanager.itemDict[itemName]["item_type"]
		match itemType:
			"gunpart":
				parttype=Datamanager.itemDict[itemName]["part_type"]
				recipy=Datamanager.itemDict[itemName]["recipy_name"]
		if stackAmount>1:
			label.text=str(stackAmount)
		else:
			label.text=""
