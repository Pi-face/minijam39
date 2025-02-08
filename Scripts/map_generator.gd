extends Node

@onready var tile_map : TileMapLayer = $"../BackgroundTiles"

var noise : FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	for x in range(1024):
		for y in range(1024):
			var value = noise.get_noise_2d(x, y)
			if value > 0:
				tile_map.set_cell(Vector2i(x, y), 0, Vector2i(2, 4))
			else:
				tile_map.set_cell(Vector2i(x, y), 0, Vector2i(6, 3))
