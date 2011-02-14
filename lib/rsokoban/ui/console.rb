
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
			initialize_members hash
			display hash
			ask_player hash
		end
		
		private
		
		def initialize_members hash
			if hash[:type] == :start
				@level_title = hash[:title] 
				@set_title = hash[:set]
				@level_number = hash[:number]
				@set_total = hash[:total]
				@record = hash[:record]
			end
		end
		
		def display hash
			clear_screen
			display_header
			display_move_number hash[:move]
			display_map hash[:map]
		end
		
		# Assuming a console window of 24 lines height
		def clear_screen
			puts "\n" * 24 
		end
		
		def display_header
			puts "Set: #{@set_title}"
			puts "Level: #{@level_title} (#{@level_number}/#{@set_total}) Record: #{@record}"
			puts "--------------------"
		end
		
		def display_move_number number
			unless number.nil?
				puts "move #{number}"
			else
				puts ''
			end
		end
		
		def display_map map
			puts ''
			map.each {|line| 
				line.gsub!(/o/, ' ')
				puts line 
			}
			puts ''
		end
		
		def ask_player hash
			if [:display, :start].include?(hash[:type])
				ask_for_action
			else
				# assuming type == 'WIN'
				ask_for_next_level_or_quit
			end
		end
		
		def ask_for_next_level_or_quit
			printf "Play next level ? "
			line = gets.chomp
			if ['yes', 'ye', 'y', 'YES', 'YE', 'Y'].include?(line)
				PlayerAction.new(:next)
			else
				PlayerAction.new(:quit)
			end
		end
		
		def ask_for_action
			response = get_playerinput
			if response.nil?
				puts "Error !"
			elsif response.instance_of?(Symbol) and response == :help
				display_help
			else
				return response
			end
			ask_for_action
		end
		
		def get_playerinput
			printf "Your choice ? "
			line = gets.chomp
			parse line
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
						ask_for_action
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
