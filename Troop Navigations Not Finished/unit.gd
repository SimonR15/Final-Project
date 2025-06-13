extends CharacterBody2D
class_name Unit

signal died(unit)

@onready var attack=preload("res://attack.tscn")
@export var moveSpeed:float=10.0

@export var maxHp:int=10
var hp:int

@export var attackRange:float=20.0
@export var attackRate:float=0.5
@export var damage:int=2
var currentCooldown=0
@onready var nav=$NavigationAgent2D
func _ready():
	hp=maxHp
func _physics_process(delta: float):
	move(delta)
func _process(delta: float):
	currentCooldown-=delta
	if(hp<1):
		die()

func takeDamage(damage:int):
	hp-=damage
func die():
	emit_signal("died",self)
	queue_free()

func move(delta:float):
	print("attacking")
	attacking()
func attacking():
	if(currentCooldown<=0):
		var attacsdadk =attack.instantiate()
		attacsdadk.init(self)
		currentCooldown=attackRate
		get_parent().add_child(attacsdadk)
		
func getRelPos()->Vector2:
	return Vector2(0,0)
