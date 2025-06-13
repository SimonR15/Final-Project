extends Unit
class_name General
var UnitScene = preload("res://combat_unit.tscn")
var units:Array=[]
var targetPos=null
var lastVelocity:Vector2=Vector2(10,10)
func createUnit():
	var unit=UnitScene.instantiate()
	get_parent().add_child(unit)
	var combat_unit = unit as CombatUnit
	units.append(combat_unit)
	combat_unit.connect("died", _on_died)
	combat_unit.init(self,Vector2(position.x+randf_range(-10.0, 10.0),position.y+randf_range(-10.0, 10.0)))
func move(delta):
	pass #program the general ai
func createStartingUnits(amount:int):
	for i in amount:
		createUnit()
	for unit in units:
		if(randf()<0.5):
			unit.setMode(0)#attac
		elif(randf()<0.8):
			unit.setMode(1)
		else:
			unit.setMode(2)
func _ready():
	super._ready()
	call_deferred("createStartingUnits",12)
	


func _on_died(unit: Variant) -> void:
	units.erase(unit)
