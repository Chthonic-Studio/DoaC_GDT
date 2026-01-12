extends Node

var max_capacity: float = 100.0	# wagon capacity source of truth
var gold: int = 100						# starting gold; adjust in inspector or save load
var current_date: int = 0				# tick-based; replace with calendar later
var war_front_progress: float = 0.0		# placeholder

func _ready() -> void:
	# No per-frame logic; this singleton just stores state and emits changes.
	pass

func set_gold(value: int) -> void:
	gold = max(0, value)
	SignalManager.emit_gold_changed(gold)

func add_gold(delta: int) -> void:
	set_gold(gold + delta)

func spend_gold(delta: int) -> bool:
	# Returns true if spend is allowed.
	if gold >= delta:
		set_gold(gold - delta)
		return true
	return false

func set_max_capacity(value: float) -> void:
	max_capacity = max(0.0, value)
	SignalManager.emit_capacity_changed(InventoryManager.get_current_weight(), max_capacity)
