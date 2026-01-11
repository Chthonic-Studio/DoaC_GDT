class_name Town extends Resource

@export var id: String
@export var name: String
@export var region_id: String
@export var economic_power: float = 1.0
@export var status: GameEnums.Status = GameEnums.Status.STABLE
@export var reputation: int = 0				# player vs town, -100..100
@export var stock_speed: float = 1.0
@export var tax_rate: float = 0.1				# applied to buys and sells
@export var wanted_pool: Array[String] = []		# item ids eligible to be picked as wanted
@export var unwanted_pool: Array[String] = []	# item ids eligible to be picked as unwanted
@export var wanted_dynamic: Array[DemandEntry] = []
@export var unwanted_dynamic: Array[DemandEntry] = []
@export var shopkeepers: Array[NPC] = []
