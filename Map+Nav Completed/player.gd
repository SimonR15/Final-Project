extends General

var startMouse=null
var currentMousePos
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if(Input.is_action_pressed("ui_select")):
		createUnit()
	if(Input.is_action_just_released("ui_shift")):
		for unit in units:
			if unit.selected:
				unit.setMode((unit.getMode()+1)%3)
	velocity = input_direction * moveSpeed
func die():
	super.die()
	print("player ded")
func move(delta):
	if(velocity.x!=0 and velocity.y!=0):
		lastVelocity=velocity
	get_input()
	move_and_slide()
