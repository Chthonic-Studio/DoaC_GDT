extends Node

signal gold_changed(new_gold: int)
signal inventory_changed()
signal capacity_changed(current_weight: float, max_capacity: float)
signal market_refreshed(town_id: String)
signal tick_elapsed(ticks: int)
signal haggle_result(success: bool, delta: float)
signal mood_changed(shopkeeper_id: String, mood_value: float)
signal trade_preview_updated(buy_total: int, sell_total: int, weight_after: float)
signal trade_committed(town_id: String)

## Helper emitters keep all scripts decoupled; call these instead of direct emit where possible.
func emit_gold_changed(value: int) -> void:
	emit_signal("gold_changed", value)

func emit_inventory_changed() -> void:
	emit_signal("inventory_changed")

func emit_capacity_changed(current_weight: float, max_capacity: float) -> void:
	emit_signal("capacity_changed", current_weight, max_capacity)

func emit_market_refreshed(town_id: String) -> void:
	emit_signal("market_refreshed", town_id)

func emit_tick_elapsed(ticks: int) -> void:
	emit_signal("tick_elapsed", ticks)

func emit_haggle_result(success: bool, delta: float) -> void:
	emit_signal("haggle_result", success, delta)

func emit_mood_changed(shopkeeper_id: String, mood_value: float) -> void:
	emit_signal("mood_changed", shopkeeper_id, mood_value)

func emit_trade_preview_updated(buy_total: int, sell_total: int, weight_after: float) -> void:
	emit_signal("trade_preview_updated", buy_total, sell_total, weight_after)

func emit_trade_committed(town_id: String) -> void:
	emit_signal("trade_committed", town_id)
