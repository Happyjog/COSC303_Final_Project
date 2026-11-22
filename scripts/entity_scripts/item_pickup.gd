extends Area2D

signal collected(item_name: String)

@export_enum("Health Potion", "Bomb") var item_name: String = "Health Potion"

func _ready() -> void:
	if item_name == "Bomb":
		$Sprite.texture = preload("res://assets/2D Pixel Dungeon Asset Pack/items and trap_animation/mini_chest/mini_chest_1.png")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_queued_for_deletion():
		queue_free()
		collected.emit(item_name)
