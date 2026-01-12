class_name Region extends Resource

@export var id: String
@export var name: String
@export var status: GameEnums.Status = GameEnums.Status.STABLE
@export var town_ids: Array[String] = []
