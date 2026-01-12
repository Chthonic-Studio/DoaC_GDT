extends Node

var tick_interval_seconds: float = 5.0	# real-time between ticks while traveling
var _accumulator: float = 0.0
var is_in_town: bool = true

func _process(delta: float) -> void:
	if is_in_town:
		return	# timer off while in town
	_accumulator += delta
	if _accumulator >= tick_interval_seconds:
		var ticks := int(floor(_accumulator / tick_interval_seconds))
		_accumulator -= tick_interval_seconds * ticks
		SignalManager.emit_tick_elapsed(ticks)
