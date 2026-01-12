@icon("res://Assets/Item Icons/fb29.png")
class_name RegionNode extends Node

@export var region_data: Region

func get_status_factor() -> float:
	# Matches economy_manager factors.
	return _status_to_factor(region_data.status if region_data != null else GameEnums.Status.STABLE)

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
