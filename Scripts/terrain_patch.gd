class_name TerrainPatch
extends TileMapLayer

const PATCH_SIZE : int = 16 
const TILE_SIZE : int = 16

@onready var label : Label = $"Label"

var patch_location : Vector2i

func _ready() -> void:
	label.text = "%d, %d" % [patch_location.x, patch_location.y]

func generate(noise : FastNoiseLite, loc : Vector2i):
	patch_location = loc
	for x in PATCH_SIZE:
		for y in PATCH_SIZE:
			var value : float = noise.get_noise_2d(loc.x * PATCH_SIZE + x,  loc.y * PATCH_SIZE + y)
			if value > 0:
				set_cell(Vector2i(x, y), 0, Vector2i(2, 4))
			else:
				set_cell(Vector2i(x, y), 0, Vector2i(6, 3))