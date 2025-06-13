extends Unit



class_name CombatUnit

@onready var attackModeSprite=preload("res://modeAttack.png")
@onready var defenseModeSprite=preload("res://modeDefense.png")
@onready var followModeSprite=preload("res://modeFollow.png")

var seenEnemies:Array=[]

@onready var area=$area
enum Mode{ATTACK, DEFEND, FOLLOW}
@export var mode:Mode
var general:General
var target:Vector2
var offset
var selected:bool=false
var enemy:Unit=null
func move(delta):
	setTarget()
	nav.target_position=target
	
	if nav.is_navigation_finished():
		velocity = Vector2.ZERO
		nav.set_velocity(Vector2.ZERO)  
	else:
		if position.distance_to(nav.target_position)>15:
			var movePos=nav.get_next_path_position()
			var moveDir=global_position.direction_to(movePos)
		
			velocity=moveDir*moveSpeed
			move_and_slide()
	avoid_friendly_units()
	if(is_instance_valid(enemy)&&enemy!=null&&position.distance_to(enemy.position)<=attackRange):
		super.move(delta)

func avoid_friendly_units():
	if(is_instance_valid(general)and general!=null):
		var overlapping=area.get_overlapping_bodies()
		for other in overlapping:
			if other == self:
				continue
			if not other is CombatUnit:
				continue
			if not other.general==general:
				continue
			
			var diff = global_position - other.global_position
			var dist = diff.length()
			if dist < 64 and dist > 0:
				var repel_force = diff.normalized() * ((64 - dist) / 64) * 200
				velocity += repel_force

func takeDamage(damage:int):
	if mode==Mode.DEFEND:
		damage/=2
	super.takeDamage(damage)
	
func _process(delta: float):
	super._process(delta)
	
	match mode:
		Mode.ATTACK:
			$ModeIndicator.texture=attackModeSprite
		Mode.DEFEND:
			$ModeIndicator.texture=defenseModeSprite
		Mode.FOLLOW:
			$ModeIndicator.texture=followModeSprite

func select(select:bool):
	selected=select
	$Highlight.visible = selected
func init(general:General, startPos:Vector2):
	self.general=general
	position=startPos
	nav.avoidance_enabled=true
	nav.target_desired_distance = 20
	offset = Vector2(randf_range(-16, 16), randf_range(-16, 16))

func setMode(mode:Mode):
	self.mode=mode
func getMode()-> Mode:
	return mode
func setTarget():
	if(!is_instance_valid(general) or general==null):
		mode=Mode.ATTACK
	if(mode==Mode.FOLLOW):
		var to_general = general.global_position - global_position
		var dist = to_general.length()
		var desired_distance = 64.0

		if dist > desired_distance:
			var offset = to_general.normalized() * (dist - desired_distance)
			target = global_position + offset  # a point 'desired_distance' from the general
		else:
			target = global_position
	elif mode==Mode.ATTACK and enemy!=null:
		target=enemy.position


	elif selected and typeof(general.targetPos)==TYPE_VECTOR2:
		target=general.targetPos
	


func _on_view_box_body_entered(body):
	if(is_instance_valid(general) and general!=null):
		if(body is General and body!=general):
			seenEnemies.append(body)
		elif(body is CombatUnit && (body as CombatUnit).general!=general):
			seenEnemies.append(body)
			if !is_connected("died", _on_died):
				body.connect("died", _on_died)

	if(seenEnemies.size()>0):
		var minDist:float=seenEnemies[0].position.distance_to(position)
		var closestUnit:Unit=seenEnemies[0]
		for unit in seenEnemies:
			var dist=unit.position.distance_to(position)
			if dist<minDist:
				minDist=dist
				closestUnit=unit
		enemy=closestUnit
		
	


func _on_view_box_body_exited(body: Node2D):
	seenEnemies.erase(body)


func _on_died(unit:Unit):
	seenEnemies.erase(unit)
	if(unit==enemy):
		enemy=null

func getRelPos()->Vector2:
	return (enemy.position-position).normalized()
