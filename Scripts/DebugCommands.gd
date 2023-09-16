extends Node2D

@onready var PetNode = $Pet
@onready var SaveSys = $SaveSystem

@export var DebugEnabled: bool = false;

func _process(delta):
	if DebugEnabled == false:
		return
	
	if Input.is_action_just_pressed("ui_page_up"):
		PetNode.DEBUG_ForceUpdateLifeStage()
		
	if Input.is_action_just_pressed("ui_accept"):
		SaveSys.save_game()
		
	if Input.is_action_just_pressed("ui_cancel"):
		SaveSys.load_game()
		
	if Input.is_action_just_pressed("ui_text_delete"):
		SaveSys.delete_save()
