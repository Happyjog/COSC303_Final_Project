class_name EntityData
extends RefCounted

var max_health: int
var health: int
var attack: int

func _init(hp: int = 100, power: int = 15) -> void:
	max_health = hp
	health = hp
	attack = power

func take_damage(amount: int) -> void:
	health = maxi(0, health - amount)

func heal(amount: int) -> void:
	health = mini(max_health, health + amount)
