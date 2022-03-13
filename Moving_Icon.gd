extends Control

var speed = 200

var direction = Vector2(1,1) #move diagonally

func _ready():
	randomize()
	direction.x = rand_range(-1.0,1.0)
	direction.y = rand_range(-1.0,1.0)

func _process(delta):
	var viewport_rect = get_viewport_rect()
	
	
	if rect_global_position.x <= 0:
		direction.x = rand_range(0,1)
	if rect_global_position.x + rect_size.x >= viewport_rect.size.x:
		direction.x = rand_range(-1,0)
	
	if rect_global_position.y <= 0:
		direction.y = rand_range(0,1)
	if rect_global_position.y + rect_size.y >= viewport_rect.size.y:
		direction.y = rand_range(-1,0)
	
	var position_change = Vector2.ZERO
	position_change.x = direction.x * speed * delta
	position_change.y = direction.y * speed * delta

	rect_global_position += position_change
