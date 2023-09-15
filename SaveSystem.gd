extends Node2D

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("Save"):
			print("persistent node '%s' is missing a Save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("Save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(JSON.new().stringify(node_data))
	save_game.close()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.


	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var PetNode = get_node(node_data["filename"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "currentNode":
				PetNode.set("currentEvolutionNode", load(node_data["currentNode"]))
				PetNode.SetNewTreeNode(PetNode.currentEvolutionNode)
				continue
			PetNode.set(i, node_data[i])
			
func delete_save():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		
	var dir = DirAccess.remove_absolute("user://savegame.save")
