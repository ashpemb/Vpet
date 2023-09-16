extends AnimatedSprite2D


func _on_ui_scene_feed_pet_signal(amount):
	visible = true
	play("eat")

func _on_animation_finished():
	visible = false
