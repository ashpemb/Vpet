extends Resource

class_name EvolutionTreeNode

const EvolutionStages = preload("res://EvolutionStages.gd")
const ChildNodeType = preload("res://EvolutionTreeChildNode.gd")

export(String) var name
export(EvolutionStages.Stages) var stage = EvolutionStages.Stages.NONE
export(Texture) var sprites
export(int) var lifetimeInHours
export(int) var lifetimeInMinutes
export(int) var lifetimeInSeconds
export(Array) var childNodes
