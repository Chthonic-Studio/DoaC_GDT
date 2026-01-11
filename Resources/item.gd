class_name Item extends Resource

@export var id: String
@export var display_name: String
@export var description: String = ""
@export var category: GameEnums.ItemCategory = GameEnums.ItemCategory.RAW_MATERIALS
@export var tags: Array[String] = []	# e.g., ["Spice", "Herb"]
@export var weight: float = 1.0
@export var base_price: int = 10
