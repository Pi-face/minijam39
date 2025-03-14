@tool
class_name TerrainPatch
extends TileMapLayer

const PATCH_SIZE : int = 16 
const TILE_SIZE : int = 16
const TILES : Dictionary = {
	0: [Vector2i(2, 4), Vector2i(0, 3), Vector2i(0, 4), Vector2i(0, 5), Vector2i(0, 6), Vector2i(1, 9), Vector2i(2, 9), Vector2i(3, 9)],
	(BL | L | TL | T | TR): [Vector2i(1, 3)],
	(L | TL | T | TR): [Vector2i(1, 3)],
	(TL | T | TR): [Vector2i(2, 3)],
	(TL | T | TR | R | BR): [Vector2i(3, 3)],
	(TR | R | BR): [Vector2i(3, 4)],
	(TR | R | BR | B | BL): [Vector2i(3, 5)],
	(BR | B | BL): [Vector2i(2, 5)],
	(BR | B | BL | L | TL): [Vector2i(1, 5)],
	(BL | L | TL): [Vector2i(1, 4)],
	(T | TR | R | BR | B | BL | L | TL): [Vector2i(4, 5)],
	(L | BL | B): [Vector2i(1, 5)],
	(L | BL): [Vector2i(1, 4)],
	(TL | L | BL | B): [Vector2i(1, 5)],
	(L | TL): [Vector2i(1, 4)],
	(T | TL | L | BL): [Vector2i(1, 3)],
	(TL | BL): [Vector2i(1, 4)],
	(L | TL | T): [Vector2i(1, 3)],
	(L | BL | B | BR): [Vector2i(1, 5)],
	(BL | B): [Vector2i(2, 5)],
	(BL | B | BR | R): [Vector2i(3, 5)],
	(B | BR): [Vector2i(2, 5)],
	(R | BR): [Vector2i(3, 4)],
	(T | TR | R): [Vector2i(3, 3)],
	(T | TR): [Vector2i(2, 3)],
	(TL | T | TR | R): [Vector2i(3, 3)],
	(TR | R): [Vector2i(3, 4)],
	(TL | T): [Vector2i(2, 3)],
	(T | TR | R | BR): [Vector2i(3, 3)],
	(B | BR | R): [Vector2i(3, 5)],
	(TL | T | TR | BR): [Vector2i(3, 3)],
	(TR | R | BR | B): [Vector2i(3, 5)],
	(BL | BR): [Vector2i(2, 5)],
	(BL | TL | T | TR): [Vector2i(1, 3)],
	(TR | BR | B): [Vector2i(3, 5)],
	(TL | TR): [Vector2i(2, 3)],
	(T): [Vector2i(2, 3)],
	(R): [Vector2i(3, 4)],
	(B): [Vector2i(2, 5)],
	(L): [Vector2i(1, 4)],
	(BR): [Vector2i(4, 3)],
	(BL): [Vector2i(5, 3)],
	(TL): [Vector2i(5, 4)],
	(TR): [Vector2i(4, 4)]
}
enum { #tile neighbor bit-fields
	T = 1 << 0,
	TR= 1 << 1,
	R = 1 << 2,
	BR= 1 << 3,
	B = 1 << 4,
	BL= 1 << 5,
	L = 1 << 6,
	TL= 1 << 7
}

@onready var label : Label = $"Label"

var patch_location : Vector2i

func _ready() -> void:
	label.text = "%d, %d" % [patch_location.x, patch_location.y]

func generate(noise : FastNoiseLite, loc : Vector2i):
	patch_location = loc
	for x in PATCH_SIZE:
		for y in PATCH_SIZE:
			var noise_loc = Vector2i(loc.x * PATCH_SIZE + x, loc.y * PATCH_SIZE + y)
			var value : float = noise.get_noise_2d(noise_loc.x, noise_loc.y)
			if value > 0:
				var n : int = get_neighborhood(noise_loc, noise)
				var t : Array = TILES.get(n, [Vector2i(6, 3)])
				set_cell(Vector2i(x, y), 0, t.pick_random())
				#set_cell(Vector2i(x, y), 0, Vector2i(2, 4))
			else:
				set_cell(Vector2i(x, y), 0, Vector2i(6, 3))

func get_neighborhood(loc : Vector2i, noise : FastNoiseLite) -> int:
	var neighbors : int = 0
	neighbors |= int(noise.get_noise_2d(loc.x, loc.y-1) <= 0) << 0   #T
	neighbors |= int(noise.get_noise_2d(loc.x+1, loc.y-1) <= 0) << 1 #TR
	neighbors |= int(noise.get_noise_2d(loc.x+1, loc.y) <= 0) << 2   #R
	neighbors |= int(noise.get_noise_2d(loc.x+1, loc.y+1) <= 0) << 3 #BR
	neighbors |= int(noise.get_noise_2d(loc.x, loc.y+1) <= 0) << 4   #B
	neighbors |= int(noise.get_noise_2d(loc.x-1, loc.y+1) <= 0) << 5 #BL
	neighbors |= int(noise.get_noise_2d(loc.x-1, loc.y) <= 0) << 6   #L
	neighbors |= int(noise.get_noise_2d(loc.x-1, loc.y-1) <= 0) << 7 #TL
	return neighbors

func print_binary(loc : Vector2i, neighbors : int):
	var bin_str : String = ""
	for i in 8:
		bin_str = str(neighbors & 1) + bin_str
		neighbors = neighbors >> 1
	print(loc, " ", bin_str)
