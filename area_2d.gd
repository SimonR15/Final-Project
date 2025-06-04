extends Area2D


func body_entered(body):
	get_node(".").add_entity(body)
	print("You entered me:c")
