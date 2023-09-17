extends Node2D

@onready var PetNode = $DebugCommands/Pet
@onready var UIScene = $CanvasLayer/UI_Scene
@onready var SaveSys = $DebugCommands/SaveSystem

func _ready():
	SaveSys.load_game()
	if PetNode.currentEvolutionNode != null:
		UIScene.UpdateUIState(1)
	

func _process(_delta):
	if PetNode.currentEvolutionNode == null && Input.is_action_just_pressed("mouse_left_click"):
		PetNode.SetNewTreeNode(load("res://EvolutionTrees/Normal/NormalEgg.tres"))
		UIScene.UpdateUIState(1)


func _on_pet_pet_died():
	UIScene.UpdateUIState(0)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveSys.save_game()
