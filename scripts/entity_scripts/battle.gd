extends CanvasLayer

signal finished

const IMPACT_TIME := 0.10
var hero: EntityData
var enemy: EntityData
var inventory
var busy := false
var inventory_open := false

func _ready() -> void:
	%Attack.pressed.connect(_take_turn.bind("Attack"))
	%Potion.pressed.connect(_take_turn.bind("Health Potion"))
	%Bomb.pressed.connect(_take_turn.bind("Bomb"))
	$Backdrop/EndBattle.pressed.connect(_leave)

func begin(player_stats: EntityData, enemy_stats: EntityData, bag) -> void:
	hero = player_stats
	enemy = enemy_stats
	inventory = bag
	busy = false
	for sprite: TextureRect in [$Backdrop/Player, $Backdrop/Skeleton]:
		sprite.rotation = 0.0
		sprite.pivot_offset = sprite.size * 0.5
	show()
	%Message.text = "A skeleton blocks your path."
	_refresh()
	%Attack.grab_focus()

func set_inventory_open(opened: bool) -> void:
	inventory_open = opened
	if visible and hero:
		_refresh()

func _refresh() -> void:
	var over := hero.health == 0 or enemy.health == 0
	var locked := busy or inventory_open or over
	%Health.text = "Player  %d/%d HP     Skeleton  %d/%d HP" % [hero.health, hero.max_health, enemy.health, enemy.max_health]
	%Attack.disabled = locked
	%Potion.text = "Health Potion × %d" % inventory.quantities["Health Potion"]
	%Bomb.text = "Bomb × %d" % inventory.quantities["Bomb"]
	%Potion.disabled = locked or hero.health == hero.max_health or inventory.quantities["Health Potion"] == 0
	%Bomb.disabled = locked or inventory.quantities["Bomb"] == 0
	$Backdrop/EndBattle.disabled = busy or inventory_open
	$Backdrop/EndBattle.text = "Restart" if hero.health == 0 else "End Battle"
	if over and not busy:
		%Message.text = "You were defeated." if hero.health == 0 else "Skeleton defeated!"

func _leave() -> void:
	if not busy and not inventory_open:
		finished.emit()

func _take_turn(action: String) -> void:
	if busy or inventory_open or hero.health == 0 or enemy.health == 0:
		return
	if action == "Health Potion" and hero.health == hero.max_health:
		return
	if action != "Attack" and not inventory.consume(action):
		return
	busy = true
	_refresh()
	if action == "Health Potion":
		var before := hero.health
		hero.heal(inventory.POTION_HEAL)
		%Message.text = "Recovered %d HP." % (hero.health - before)
		_refresh()
	else:
		var damage := hero.attack
		var message := "You hit for %d." % damage
		if action == "Bomb":
			damage = inventory.BOMB_DAMAGE
			message = "Bomb hits for %d." % damage
		elif randf() < 0.10:
			damage *= 2
			message = "Critical hit for %d!" % damage
		await _strike($Backdrop/Player, $Backdrop/Skeleton, enemy, damage, message)
	if enemy.health > 0:
		await get_tree().create_timer(0.38).timeout
		var damage := 0 if randf() < 0.17 else enemy.attack
		var message := "Skeleton misses!" if damage == 0 else "Skeleton hits for %d." % damage
		await _strike($Backdrop/Skeleton, $Backdrop/Player, hero, damage, message)
	busy = false
	_refresh()

func _strike(attacker: Control, victim: TextureRect, target: EntityData, damage: int, message: String) -> void:
	var origin := attacker.position
	var resting := victim.position
	var direction := attacker.get_rect().get_center().direction_to(victim.get_rect().get_center())
	victim.pivot_offset = victim.size * 0.5
	var lethal := damage >= target.health
	var original_tint := victim.self_modulate
	
	if lethal:
		# Keep the far bottom corner of the centered, aspect-fitted texture fixed.
		var native_size := victim.texture.get_size()
		var drawn_size := native_size * minf(victim.size.x / native_size.x, victim.size.y / native_size.y)
		victim.pivot_offset += Vector2(signf(direction.x) * drawn_size.x, drawn_size.y) * 0.5
	var motion := create_tween()
	motion.tween_property(attacker, "position", origin + direction * 18.0, IMPACT_TIME).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	motion.tween_callback(func():
		target.take_damage(damage)
		if damage > 0:
			victim.self_modulate = Color(1.0,0.25,0.25)
		%Message.text = message
		_refresh()
	)
	motion.tween_property(attacker, "position", origin, 0.14)
	if lethal:
		motion.parallel().tween_property(victim, "rotation", signf(direction.x) * PI / 2.0, 0.34).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	elif damage > 0:
		motion.parallel().tween_property(victim, "position", resting + direction * 10.0 + Vector2.UP * 7.0, 0.07)
		motion.parallel().tween_property(victim, "rotation", signf(direction.x) * deg_to_rad(6.0), 0.07)
		motion.tween_property(victim, "position", resting, 0.17).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		motion.parallel().tween_property(victim, "rotation", 0.0, 0.15)
	if damage > 0:
		motion.tween_property(victim, "self_modulate", original_tint, 0.12)
	await motion.finished
