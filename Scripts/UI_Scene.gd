extends Control

enum UIState {CLEAR = 0, MAIN = 1}

@onready var MainUI : Control = $MainUI

var CurrentUIState : UIState = UIState.CLEAR

@onready var Stats : Label = $MainUI/Stats
@onready var FeedButton : Button = $MainUI/Feed

var formatString = "Hunger: %s 
Attention: %s 
Activity: %s"

signal FeedPetSignal(amount)

func _ready():
	UpdateUIState(UIState.CLEAR)

func _on_pet_update_stats(hunger, attention, activity):
	Stats.text = formatString % [ roundi(hunger), roundi(attention), roundi(activity)]

func _on_feed_button_pressed():
	FeedPetSignal.emit(3)
	FeedButton.disabled = true

func _on_meat_sprite_animation_finished():
	FeedButton.disabled = false

func UpdateUIState(inState : UIState):
	match inState:
		UIState.CLEAR:
			ResetMain()
			MainUI.hide()
		UIState.MAIN:
			MainUI.visible = true

func _on_pet_enable_feed():
	FeedButton.disabled = false
	
func ResetMain():
	FeedButton.disabled = true
