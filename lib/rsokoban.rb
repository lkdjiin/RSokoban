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
require "rsokoban/config"

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
	
	# config files will go in this folder
	CONFIG_FOLDER = File.expand_path "~/.rsokoban"
	# primary config file
	CONFIG_FILE = 'config'
	
	# Record files will go in this folder
	RECORD_FOLDER = File.expand_path "~/.rsokoban/record"
end
