class_name Recipe extends Resource

@export var id: String
@export var display_name: String
@export var required_tags: Array[String] = []	
@export var required_items: Array[String] = []	
@export var failure_chance: float = 0.2			
@export var result_item_id: String				
