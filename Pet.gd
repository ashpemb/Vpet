extends Node2D

@onready var petSprite : AnimatedSprite2D = $PetSprite
@onready var lifeTime : Timer = $Timer

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
	
	if currentEvolutionNode == null && Input.is_action_pressed("ui_1"):
		SetNewTreeNode(load("res://EvolutionTrees/Normal/NormalEgg.tres"))

func DecayStats():
	SetHunger(hunger - (baseDecay * currentEvolutionNode.hungerModifier))
	SetAttention(attention - (baseDecay * currentEvolutionNode.attentionModifier))
	SetActivity(activity - (baseDecay * currentEvolutionNode.activityModifier))
	updateStats.emit(hunger, attention, activity)
	
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
		ResetDecayInterval()
		isDecaying = true
	else:
		print("New node is null, this shouldn't happen")
	

func UpdateLifeStage():
	var nextNode : EvolutionTreeNode
	
	if currentEvolutionNode.childNodes.size() != 0:
		for node in currentEvolutionNode.childNodes:
			node = node as EvolutionTreeChildNode
			if node.threshold <= happiness || node.threshold == 0:
				nextNode = node.childNode
	
	if nextNode != null:
		SetNewTreeNode(nextNode)
		
func FeedPet(InAmount : float):
	if InAmount > 0:
		SetHunger(hunger + InAmount)
		
func DEBUG_ForceUpdateLifeStage():
	var nextNode : EvolutionTreeNode
	
	if currentEvolutionNode.childNodes.size() != 0:
		nextNode = currentEvolutionNode.childNodes[0].childNode
	
	if nextNode != null:
		SetNewTreeNode(nextNode)

func _on_Timer_timeout():
	UpdateLifeStage()

func Save():
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
