require "rsokoban/level"
require "rsokoban/level_loader"
require "rsokoban/exception"
require "rsokoban/position"
require "rsokoban/man"
require "rsokoban/crate"
require "rsokoban/storage"
require "rsokoban/game"
require "rsokoban/ui/console"
require "rsokoban/option"
require "rsokoban/level_set"
require "rsokoban/raw_level"

module RSokoban
	VERSION = '0.70'
	
	MAN = '@'
	FLOOR = ' '
	CRATE = '$'
	STORAGE = '.'
	WALL = '#'
	MAN_ON_STORAGE = '+'
	CRATE_ON_STORAGE = '*'
	
end
