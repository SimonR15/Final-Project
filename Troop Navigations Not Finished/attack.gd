extends Area2D

class_name Attack
var damage
var timer:float
var hitEntities:Array=[]
var attacker:Unit
func _process(delta:float):
	timer-=delta
	if(timer<=0):
		for unit in hitEntities:
			if(is_instance_valid(unit)):
				unit.takeDamage(damage)
		queue_free()

func init(attacker:Unit):
	damage=attacker.damage
	position=attacker.position
	self.attacker=attacker
	timer=attacker.attackRate-0.3
	var dir=attacker.getRelPos()
	var angle=dir.angle()
	rotate(angle)
	
func _on_body_entered(body: Node2D):
	if(body is Unit and body!=attacker):
		hitEntities.append(body)
		
