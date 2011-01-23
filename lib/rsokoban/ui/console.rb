
module RSokoban::UI

	# I am a portable console for the user interface.
	# In addition to what BaseUI want from me, I offer the user
	# an help feature.
	# I assume 24 lines height.
	class Console < BaseUI
		
		def initialize
			super()
		end
		
		def get_action(hash)
			@level_title = hash[:title] if hash[:type] == :start
			display hash
			if [:display, :start].include?(hash[:type])
				ask_player
			else
				# assuming type == 'WIN'
				ask_for_next_level
			end
		end
		
		private
		
		def display hash
			blankConsole = "\n" * 24 # assuming a console window of 24 lines height
			puts blankConsole
			puts @level_title
			puts "--------------------"
			unless hash[:move].nil?
				puts "move #{hash[:move]}"
			else
				puts ''
			end
			puts ''
			hash[:map].each {|line| puts line }
			puts ''
		end
		
		def ask_for_next_level
			printf "Play next level ? "
			line = readline.chomp
			if ['yes', 'ye', 'y', 'YES', 'YE', 'Y'].include?(line)
				PlayerAction.new(:next)
			else
				PlayerAction.new(:quit)
			end
		end
		
		def ask_player
			printf "Your choice ? "
			line = readline.chomp
			response = parse line
			if response.nil?
				puts "Error : #{line}"
				ask_player
			elsif response.instance_of?(Symbol) and response == :help
				display_help
				ask_player
			else
				response
			end
		end
		
		def parse str
			case str
				when 'quit', 'up', 'down', 'right', 'left', 'retry', 'undo'
					PlayerAction.new(str.to_sym)
				when 'help' then :help
				when 'z' then PlayerAction.new(:up)
				when 's' then PlayerAction.new(:down)
				when 'q' then PlayerAction.new(:left)
				when 'd' then PlayerAction.new(:right)
				when '1'..'999' then PlayerAction.new(str.to_i)
				when /\.xsb$/ then PlayerAction.new(str)
			end
		end
		
		def display_help
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
