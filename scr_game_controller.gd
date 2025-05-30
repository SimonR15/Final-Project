extends Node2D

var loadedEntities = []

func addEntity(entity):
	loadedEntities.append(entity);

func removeEntity(entity):
	for i in range(loadedEntities.size()):
		if loadedEntities[i] == entity:
			loadedEntities.remove_at(i)
			return
