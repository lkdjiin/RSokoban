require "rsokoban/level"
require "rsokoban/level_loader"
require "rsokoban/exception"
require "rsokoban/position"
require "rsokoban/man"
require "rsokoban/crate"
require "rsokoban/storage"
require "rsokoban/game"
require "rsokoban/ui/console"
#require "rsokoban/ui/curses_console"
require "rsokoban/option"
require "rsokoban/level_set"
require "rsokoban/raw_level"

# I am the main module of the game.
module RSokoban
	# Version of the program
	VERSION = '0.71'
	
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
