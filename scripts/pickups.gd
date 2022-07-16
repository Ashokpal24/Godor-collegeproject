extends Sprite
var itemName=null
var itemType=null
var target=null
var free=false
export var stackamount:int=1
func _ready():
	if self.texture!=null:
		itemName=texture.resource_path
		itemName=itemName.replace("res://assets/weapons/","")
		itemName=itemName.replace(".png","")
		itemType=Datamanager.itemDict[itemName]["item_type"]
		print(itemName)
func _physics_process(delta):
	if Input.is_action_just_pressed("equip"):
		if target!=null:
			match itemType:
				"weapon":
					stackamount=1
					free=target.get_node("CanvasLayer/UI").hotbarSlotsearch()
					if free==false:
						free=target.get_node("CanvasLayer/UI").invSlotsearch()
				"gunparts":
					stackamount=1
					free=target.get_node("CanvasLayer/UI").invSlotsearch()
				"consumable":
					free=target.get_node("CanvasLayer/UI").conUpdate(stackamount,self)
			if free:
				position=lerp(position,target.position,delta*10)
				if self.global_position.distance_to(target.global_position)<30:
					print(stackamount)
					target.get_node("CanvasLayer/UI").additeminslot(itemName,stackamount)
					queue_free()
func _on_Area2D_body_entered(body):
	if body.name=="player":
		target=body
		self.set_physics_process(true)
	pass # Replace with function body.
func _on_Area2D_body_exited(body):
	target=null
	self.set_physics_process(false)
	pass # Replace with function body.
