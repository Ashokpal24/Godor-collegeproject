extends Node
const SAVEGAME="user://Savegame.json"
onready var mainScene=preload("res://scene/main.tscn")
onready var mainmenu=preload("res://scene/mainmenu.tscn")
onready var settings=preload("res://scene/settings.tscn")
onready var visual=preload("res://scene/visual.tscn")
onready var audio=preload("res://scene/audio.tscn")
var saveData={}
var itemDict={
	"ammobox":{
		"item_type":"consumable",
		"maxstack":300
	},
	"spitfire":{
		"item_type":"weapon",
		"damage":10,
		"ammo_count":100,
		"mag_size":10,
		"waitTime":0.3,
		"maxstack":1
	},
	"spitfire-body":{
		"item_type":"gunpart",
		"part_type":"gunbody",
		"recipy_name":"spitfire",
		"maxstack":1
	},
	"spitfire-scope":{
		"item_type":"gunpart",
		"part_type":"gunscope",
		"recipy_name":"spitfire",
		"maxstack":1
	},
	"spitfire-trigger":{
		"item_type":"gunpart",
		"part_type":"guntrigger",
		"recipy_name":"spitfire",
		"maxstack":1
	},
	"smg":{
		"item_type":"weapon",
		"damage":5,
		"ammo_count":200,
		"mag_size":30,
		"waitTime":0.1,
		"maxstack":1
	},
	"smg-body":{
		"item_type":"gunpart",
		"part_type":"gunbody",
		"recipy_name":"smg",
		"maxstack":1
	},
	"smg-scope":{
		"item_type":"gunpart",
		"part_type":"gunscope",
		"recipy_name":"smg",
		"maxstack":1
	},
	"smg-trigger":{
		"item_type":"gunpart",
		"part_type":"guntrigger",
		"recipy_name":"smg",
		"maxstack":1
	}
}
func _ready():
	get_data()
func get_data():
	var file=File.new()
	if not file.file_exists(SAVEGAME):
		saveData={"inventory":{},"hotbar":{},"build":{},"output":{},"gameSettings":{"visual":{"bloom":0,"brightness":0,"saturation":0},"audio":{"gameAudio":0,"gameMusic":0}}}
		save_game()
	file.open(SAVEGAME,File.READ)
	var content=file.get_as_text()
	var data=parse_json(content)
	saveData=data
	file.close()
func save_game():
	var saveGame=File.new()
	saveGame.open(SAVEGAME,File.WRITE)
	saveGame.store_line(to_json(saveData))
