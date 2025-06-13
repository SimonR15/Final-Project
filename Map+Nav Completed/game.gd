extends Node2D

var mouse_pos := Vector2.ZERO
var should_draw := false


func _input(event):
	if(has_node("Player")):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				mouse_pos=get_global_mouse_position()
				should_draw = true
			elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				$Player.targetPos=get_global_mouse_position()
				for unit in $Player.units:
					unit.setTarget()
					unit.select(false)
				$Player.targetPos=null
			if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
				should_draw=false
func _process(delta: float):
	if(has_node("Player")and should_draw):
		queue_redraw() 
		for unit in $Player.units:
			if is_between_box(mouse_pos,get_global_mouse_position(),unit.position):
				unit.select(true)
	else:
		queue_redraw()
		

static func is_between_box(a: Vector2, b: Vector2, c: Vector2) -> bool:
	var min_x = min(a.x, b.x)
	var max_x = max(a.x, b.x)
	var min_y = min(a.y, b.y)
	var max_y = max(a.y, b.y)
	
	return c.x >= min_x and c.x <= max_x and c.y >= min_y and c.y <= max_y
	
func _draw():
	if should_draw:
		var col = Color(1, 0, 0)
		var rect = Rect2(mouse_pos, get_global_mouse_position()-mouse_pos)
		draw_rect(rect, col, true)
	
