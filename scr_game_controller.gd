extends Node2D

var loadedEntities = []

func addEntity(entity):
	loadedEntities.append(entity);

func removeEntity(entity):
	for i in range(loadedEntities.size()):
		if loadedEntities[i] == entity:
			loadedEntities.remove_at(i)
			return true
	return false


func _on_body_entered(body: Node2D) -> void:
	addEntity(body)
	print("ur in me;)")


func _on_area_2d_body_exited(body: Node2D) -> void:
	removeEntity(body)
	print("ur outta me:c")
