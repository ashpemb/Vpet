extends Control

@onready var Stats : Label = $Stats
@onready var FeedButton : Button = $Feed

var formatString = "Hunger: %s 
Attention: %s 
Activity: %s"

signal FeedPetSignal(amount)

func _on_pet_update_stats(hunger, attention, activity):
	Stats.text = formatString % [ roundi(hunger), roundi(attention), roundi(activity)]


func _on_feed_button_pressed():
	FeedPetSignal.emit(3)
