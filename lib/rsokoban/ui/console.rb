
module RSokoban::UI

	# I am a portable console for the user interface.
	class Console
		
		def initialize
			@levelTitle = ''
		end
		
		# Based on things found in the arguments, the user you tell
		# what it want to do.
		#
		# List of action I can return :
		# :quit ::                     to quit game
		# :next ::                     to load and play next level
		# :retry ::                    to restart the current level
		# :up, :down, :left, :right :: to move the man
		# a number ::                  to load this level number
		# an .xsb filename ::          to load the set with this name
		# 
		# @param ['START'|'DISPLAY'|'WIN'] type the type of message
		# @parma [Array<String>] level the picture of the level
		# @param [String] message a message to be displayed
		# @return [Object] the user's action
		def get_action(type, level, message)
			@levelTitle = message if type == 'START'
			message = 'OK move 0' if type == 'START'
			display level, message
			if type == 'DISPLAY' or type == 'START'
				askPlayer
			else
				# assuming type == 'WIN'
				askForNextLevel
			end
		end
		
		private
		
		def display level, message
			blankConsole = "\n" * 24 # assuming a console window of 24 lines height
			puts blankConsole
			puts @levelTitle
			puts "--------------------"
			puts message
			puts ''
			level.each {|line| puts line }
			puts ''
		end
		
		def askForNextLevel
			printf "Play next level ? "
			line = readline.chomp
			if ['yes', 'ye', 'y', 'YES', 'YE', 'Y'].include?(line)
				:next
			else
				:quit
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
				when 'quit', 'up', 'down', 'right', 'left', 'retry', 'help'
					str.to_sym
				when 'z'
					:up
				when 's'
					:down
				when 'q'
					:left
				when 'd'
					:right
				when '1'..'999'
					str.to_i
				when /\.xsb$/
					str
			end
		end
		
		def displayHelp
			help=<<EOS
------------------------------
General commands :

quit         : Quit game
help         : Display this screen
retry        : Restart level
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
