extends KinematicBody2D
var velocity:Vector2=Vector2.ZERO
var direction:Vector2=Vector2.ZERO
var speed:int=200
onready var Gui:Control=get_node("CanvasLayer/UI")
onready var gunContainer:Node2D=get_node("gunContainer")
onready var sprite:Sprite=get_node("Sprite")
onready var hand:Sprite=get_node("gunContainer/hand")
onready var gun:Sprite=get_node("gunContainer/hand/gun")
onready var animationPlayer:AnimationPlayer=get_node("AnimationPlayer")
func _ready():
	if gun.texture!=null:
		hand.visible=true
	else:
		hand.visible=false
func _physics_process(delta):
	var rot=(get_global_mouse_position()-global_position).normalized()
	gunContainer.rotation=rot.angle()
	direction.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	direction.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	direction=direction.normalized()
	velocity=lerp(velocity,speed*direction,delta*30)
	move_and_slide(velocity)
	if Input.is_action_just_pressed("ui_focus_next"):
		Gui.visible=!Gui.visible
	if rot.x>0:
		gun.flip_v=false
		hand.flip_v=false
		sprite.flip_h=false
		hand.offset.y=-1
		gunContainer.position=Vector2(-5,-2)
	else:
		gun.flip_v=true
		hand.flip_v=true
		sprite.flip_h=true
		hand.offset.y=1
		gunContainer.position=Vector2(5,-2)
	if direction!=Vector2.ZERO:
		animationPlayer.play("run")
	else:
		animationPlayer.play("idle")
	
func gunUpdate(Name):
	if Name!=null:
		$gunContainer/hand/gun.texture=load("res://assets/weapons/"+Name+".png")
	else:
		$gunContainer/hand/gun.texture=null
	if $gunContainer/hand/gun.texture!=null:
		$gunContainer/hand.visible=true
	else:
		$gunContainer/hand.visible=false
