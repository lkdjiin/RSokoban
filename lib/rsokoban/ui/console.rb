
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
			if hash[:type] == :start
				@level_title = hash[:title] 
				@set_title = hash[:set]
				@level_number = hash[:number]
				@set_total = hash[:total]
			end
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
			puts "Set: #{@set_title}"
			puts "Level: #{@level_title} (#{@level_number}/#{@set_total})"
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
			line = gets.chomp
			if ['yes', 'ye', 'y', 'YES', 'YE', 'Y'].include?(line)
				PlayerAction.new(:next)
			else
				PlayerAction.new(:quit)
			end
		end
		
		def ask_player
			printf "Your choice ? "
			line = gets.chomp
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
				when '1'..'999'
					if str.to_i > @set_total
						ask_player
					else
					 	PlayerAction.new(str.to_i)
					 end
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
