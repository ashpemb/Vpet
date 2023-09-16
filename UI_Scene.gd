extends Control

@onready var Stats : Label = $Stats

var formatString = "Hunger: %s 
Attention: %s 
Activity: %s"

func _on_pet_update_stats(hunger, attention, activity):
	Stats.text = formatString % [ roundi(hunger), roundi(attention), roundi(activity)]
