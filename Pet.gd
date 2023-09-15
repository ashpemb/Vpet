extends Node2D

@onready var petSprite : AnimatedSprite2D = $PetSprite
@onready var lifeTime : Timer = $Timer

var currentEvolutionNode : EvolutionTreeNode
var currentStage : int = EvolutionStages.Stages.NONE

var hunger : float = 1.0
var attention : float = 1.0
var activity : float = 1.0
var happiness : float = 0

func _process(delta):
	if Input.is_action_pressed("ui_1"):
		SetNewTreeNode(load("res://EvolutionTrees/Normal/NormalEgg.tres"))

func SetNewTreeNode(newTreeNode : EvolutionTreeNode):
	if newTreeNode != null:
		currentEvolutionNode = newTreeNode
		currentStage = newTreeNode.stage
		petSprite.sprite_frames = newTreeNode.sprite
		petSprite.play()
		var newLifeTime = ((newTreeNode.lifetimeInHours * 60) * 60) + (newTreeNode.lifetimeInMinutes * 60) + newTreeNode.lifetimeInSeconds
		lifeTime.start(newLifeTime)
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
