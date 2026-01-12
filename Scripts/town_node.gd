@icon("res://Assets/Item Icons/fb47.png")
class_name TownNode extends Node

@export var town_data: Town
@export var region_node: RegionNode

var current_tax_rate: float = 0.1	# runtime, recalculated from town_data

func _ready() -> void:
	_recalculate_tax()

func _recalculate_tax() -> void:
	if town_data == null:
		return
	var base_rate: float = town_data.base_tax_rate if "base_tax_rate" in town_data else town_data.tax_rate
	# Economic power mod keeps things reactive.
	var econ_factor: float = lerp(0.9, 1.1, clamp(town_data.economic_power, 0.5, 1.5) - 0.5)
	var region_factor: float = region_node.get_status_factor() if region_node != null else 1.0
	current_tax_rate = base_rate * econ_factor * region_factor

func get_tax_rate() -> float:
	return current_tax_rate

func get_economic_factor() -> float:
	# Combines econ power and status for restock/gold drift calculations.
	var status_factor := _status_to_factor(town_data.status if town_data != null else GameEnums.Status.STABLE)
	return max(0.25, town_data.economic_power * status_factor)

func _status_to_factor(status: GameEnums.Status) -> float:
	match status:
		GameEnums.Status.PROSPEROUS:
			return 0.9
		GameEnums.Status.STABLE:
			return 1.0
		GameEnums.Status.STRUGGLING:
			return 1.1
		GameEnums.Status.FAMINE:
			return 1.25
		GameEnums.Status.WARFRONT:
			return 1.35
		_:
			return 1.0
