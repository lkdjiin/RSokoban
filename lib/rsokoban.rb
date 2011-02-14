require "rsokoban/extensions"
require "rsokoban/level"
require "rsokoban/set_loader"
require "rsokoban/exception"
require "rsokoban/position"
require "rsokoban/man"
require "rsokoban/crate"
require "rsokoban/storage"
require "rsokoban/option"
require "rsokoban/level_set"
require "rsokoban/raw_level"
require "rsokoban/ui"
require "rsokoban/move_recorder"
require "rsokoban/map"
require "rsokoban/move_result"
require "rsokoban/game"
require "rsokoban/layered_map"
require "rsokoban/record"
require "rsokoban/install"

# I am the main module of the game.
module RSokoban	
	# Game elements.
	# Those constants are used intensively.
	MAN = '@'
	FLOOR = ' '
	CRATE = '$'
	STORAGE = '.'
	WALL = '#'
	MAN_ON_STORAGE = '+'
	CRATE_ON_STORAGE = '*'
	OUTSIDE = 'o'
	
	# Record files will go in this folder
	RECORD_FOLDER = "~/.rsokoban/record"
end
