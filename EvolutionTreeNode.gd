extends Resource

class_name EvolutionTreeNode

const EvolutionStages = preload("res://EvolutionStages.gd")
const ChildNodeType = preload("res://EvolutionTreeChildNode.gd")

@export var name: String
@export var stage = EvolutionStages.Stages.NONE # (EvolutionStages.Stages)
@export var sprite: SpriteFrames
@export var lifetimeInHours: int
@export var lifetimeInMinutes: int
@export var lifetimeInSeconds: int
@export var childNodes: Array
