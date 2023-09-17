extends Node2D

@export var MainScene : PackedScene

func _process(_delta):
	if Input.is_anything_pressed() && MainScene != null:
		get_tree().change_scene_to_packed(MainScene)
