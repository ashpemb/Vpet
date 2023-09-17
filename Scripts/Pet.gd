extends Node2D

@onready var petSprite : AnimatedSprite2D = $PetSprite
@onready var lifeTime : Timer = $Timer
@onready var graveSprite : SpriteFrames = preload("res://Sprites/Generic/SpriteFramesGrave.tres")

var currentEvolutionNode : EvolutionTreeNode
var currentStage : int = EvolutionStages.Stages.NONE

var hunger : float = 10
var attention : float = 10
var activity : float = 10
var happiness : float = 0

@export var baseDecay : float
@export var decayInterval : float = 60
var curTime : float
var nextDecayTick : float
var isDecaying : bool = false
signal updateStats(hunger, attention, activity)

signal EnableFeed
signal PetDied

func SetHunger(InValue):
	hunger = InValue
	hunger = clampf(hunger, 0, 10)

func SetAttention(InValue):
	attention = InValue
	attention = clampf(attention, 0, 10)

func SetActivity(InValue):
	activity = InValue
	activity = clampf(activity, 0, 10)

func _process(_delta):
	if isDecaying:
		curTime = Time.get_ticks_msec() as float / 1000
		if curTime >= nextDecayTick:
			DecayStats()
			ResetDecayInterval()

func DecayStats():
	SetHunger(hunger - (baseDecay * currentEvolutionNode.hungerModifier))
	SetAttention(attention - (baseDecay * currentEvolutionNode.attentionModifier))
	SetActivity(activity - (baseDecay * currentEvolutionNode.activityModifier))
	updateStats.emit(hunger, attention, activity)
	if hunger <= 0:
		KillPet()
	
func ResetDecayInterval():
	nextDecayTick = curTime + decayInterval
	
func ResetStats():
	SetHunger(10)
	SetAttention(10)
	SetActivity(10)

func SetNewTreeNode(newTreeNode : EvolutionTreeNode):
	if newTreeNode != null:
		currentEvolutionNode = newTreeNode
		currentStage = newTreeNode.stage
		petSprite.sprite_frames = newTreeNode.sprite
		petSprite.play()
		var newLifeTime = ((newTreeNode.lifetimeInHours * 60) * 60) + (newTreeNode.lifetimeInMinutes * 60) + newTreeNode.lifetimeInSeconds
		lifeTime.start(newLifeTime)
		ResetStats()
		updateStats.emit(hunger, attention, activity)
		if currentStage > EvolutionStages.Stages.EGG:
			EnableFeed.emit()
			ResetDecayInterval()
			isDecaying = true
	else:
		printerr("New node is null, this shouldn't happen")
	

func UpdateLifeStage():
	var nextNode : EvolutionTreeNode
	
	if currentEvolutionNode.childNodes.size() != 0:
		for node in currentEvolutionNode.childNodes:
			node = node as EvolutionTreeChildNode
			if node.threshold <= happiness || node.threshold == 0:
				nextNode = node.childNode
	
	if nextNode != null:
		SetNewTreeNode(nextNode)
	else:
		KillPet()
		
func KillPet():
	petSprite.sprite_frames = graveSprite
	currentStage = -1
	currentEvolutionNode = null
	isDecaying = false
	PetDied.emit()

func FeedPet(InAmount : float):
	if InAmount > 0:
		SetHunger(hunger + InAmount)
		updateStats.emit(hunger, attention, activity)
		
func DEBUG_ForceUpdateLifeStage():
	var nextNode : EvolutionTreeNode
	
	if currentEvolutionNode.childNodes.size() != 0:
		nextNode = currentEvolutionNode.childNodes[0].childNode
	
	if nextNode != null:
		SetNewTreeNode(nextNode)
	else:
		KillPet()

func _on_Timer_timeout():
	UpdateLifeStage()

func Save():
	if currentEvolutionNode != null:
		var save_data = {
			"filename" : get_path(),
			"hunger" : hunger,
			"attention" : attention,
			"activity" : activity,
			"happiness" : happiness,
			"currentStage" : currentStage,
			"remainingLifeTime" : lifeTime.time_left,
			"currentNode" : currentEvolutionNode.resource_path
		}
		return save_data
	else:
		var save_data = {
			"filename" : get_path(),
			"hunger" : hunger,
			"attention" : attention,
			"activity" : activity,
			"happiness" : happiness,
			"currentStage" : currentStage,
			"remainingLifeTime" : 0,
			"currentNode" : null
		}
		return save_data

func _on_ui_scene_feed_pet_signal(amount):
	FeedPet(amount)
