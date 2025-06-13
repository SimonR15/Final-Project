extends Unit
class_name General
var UnitScene = preload("res://combat_unit.tscn")
var units:Array=[]
var targetPos=null
var lastVelocity:Vector2=Vector2(10,10)
var player:General
var rushPlayer = false
var timer = 60
func createUnit():
	var unit=UnitScene.instantiate()
	get_parent().add_child(unit)
	var combat_unit = unit as CombatUnit
	units.append(combat_unit)
	combat_unit.connect("died", _on_died)
	combat_unit.init(self,Vector2(position.x+randf_range(-10.0, 10.0),position.y+randf_range(-10.0, 10.0)))
func move(delta):
	timer -= delta
	if timer <= 0:
		rushPlayer = true
	if rushPlayer:
		nav.target_position=player.position
		if position.distance_to(nav.target_position)>15:
			var movePos=nav.get_next_path_position()
			var moveDir=global_position.direction_to(movePos)
			velocity=moveDir*moveSpeed
			move_and_slide()
func createStartingUnits(amount:int):
	for i in amount:
		createUnit()
	for unit in units:
		if(randf()<0.5):
			unit.setMode(2)#attac
		elif(randf()<0.8):
			unit.setMode(2)
		else:
			unit.setMode(2)
func _ready():
	super._ready()
	call_deferred("createStartingUnits",12)
	call_deferred("setPlayer")
	
	

func setPlayer():
	player = get_parent().get_node("Player")

func _on_died(unit: Variant) -> void:
	units.erase(unit)


func _on_area_2d_body_entered(body):
	if body == player:
		targetPos = player.position
		for unit in units:
			unit.select(true)
			unit.setTarget()
			unit.select(false)
