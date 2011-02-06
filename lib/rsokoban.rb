require "rsokoban/extensions"
require "rsokoban/level"
require "rsokoban/level_loader"
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
require "rsokoban/game_ui"
require "rsokoban/game_gui"
require "rsokoban/game_factory"
require "rsokoban/game_portable"
require "rsokoban/game_curses"
require "rsokoban/game_tk"

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
	
end
