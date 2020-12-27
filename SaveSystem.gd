extends Node2D

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("Save"):
			print("persistent node '%s' is missing a Save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("Save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
