
module RSokoban::UI

	# I am a portable console for the user interface.
	# In addition to what BaseUI want from me, I offer the user
	# an help feature.
	# I assume 24 lines height.
	class Console < BaseUI
		
		def initialize
			super()
		end
		
		def get_action(type, map, message)
			@level_title = message if type == 'START'
			message = 'OK move 0' if type == 'START'
			display map, message
			if type == 'DISPLAY' or type == 'START'
				askPlayer
			else
				# assuming type == 'WIN'
				askForNextLevel
			end
		end
		
		private
		
		def display map, message
			blankConsole = "\n" * 24 # assuming a console window of 24 lines height
			puts blankConsole
			puts @level_title
			puts "--------------------"
			puts message
			puts ''
			map.each {|line| puts line }
			puts ''
		end
		
		def askForNextLevel
			printf "Play next level ? "
			line = readline.chomp
			if ['yes', 'ye', 'y', 'YES', 'YE', 'Y'].include?(line)
				PlayerAction.new(:next)
			else
				PlayerAction.new(:quit)
			end
		end
		
		def askPlayer
			printf "Your choice ? "
			line = readline.chomp
			response = parse line
			if response.nil?
				puts "Error : #{line}"
				askPlayer
			elsif response == :help
				displayHelp
				askPlayer
			else
				response
			end
		end
		
		def parse str
			case str
				when 'quit', 'up', 'down', 'right', 'left', 'retry', 'help', 'undo'
					PlayerAction.new(str.to_sym)
				when 'z'
					PlayerAction.new(:up)
				when 's'
					PlayerAction.new(:down)
				when 'q'
					PlayerAction.new(:left)
				when 'd'
					PlayerAction.new(:right)
				when '1'..'999'
					PlayerAction.new(str.to_i)
				when /\.xsb$/
					PlayerAction.new(str)
			end
		end
		
		def displayHelp
			help=<<EOS
------------------------------
General commands :

quit         : Quit game
help         : Display this screen
retry        : Restart level
undo         : Undo last move
1 to 999     : Play this level
file.xsb     : Load this set of levels

How to move :

up (or z)    : Move up
down (or s)  : Move down
left (or q)  : Move left
right (or d) : Move right
------------------------------
EOS
			puts help
		end
		
	end

end
