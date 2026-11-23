extends CharacterBody2D

signal skeleton_touched

@export var speed: float = 80.0
var last_skeleton: Node2D

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var wasd := Vector2(
		int(Input.is_physical_key_pressed(KEY_D)) - int(Input.is_physical_key_pressed(KEY_A)),
		int(Input.is_physical_key_pressed(KEY_S)) - int(Input.is_physical_key_pressed(KEY_W))
	)
	velocity = (direction + wasd).limit_length() * speed
	if velocity.x != 0.0:
		$Sprite.flip_h = velocity.x < 0.0
	move_and_slide()
	# Both bodies have a five-pixel radius. Rearm after walking clear.
	if is_instance_valid(last_skeleton) and global_position.distance_to(last_skeleton.global_position) > 12.0:
		last_skeleton = null
	for index in get_slide_collision_count():
		var body := get_slide_collision(index).get_collider() as Node2D
		if body and body.is_in_group("skeletons") and body != last_skeleton:
			last_skeleton = body
			skeleton_touched.emit()
			break
