extends Resource

class_name EvolutionTreeNode

const EvolutionStages = preload("res://Scripts/EvolutionStages.gd")
const ChildNodeType = preload("res://Scripts/EvolutionTreeChildNode.gd")

@export var name: String
@export var stage = EvolutionStages.Stages.NONE # (EvolutionStages.Stages)
@export var sprite: SpriteFrames
@export var lifetimeInHours: int
@export var lifetimeInMinutes: int
@export var lifetimeInSeconds: int
@export var hungerModifier: float = 1
@export var attentionModifier: float = 1
@export var activityModifier: float = 1
@export var childNodes: Array
