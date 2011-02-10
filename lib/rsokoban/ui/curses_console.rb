module RSokoban::UI

	# I am a console user interface using curses library.
	# I assume 24 lines height.
	class CursesConsole < BaseUI
	
		SET_LINE = 0
		TITLE_LINE = 1
		MOVES_LINE = 2
		STATUS_LINE = 3
		PICTURE_LINE = 5
		
		def initialize
			super()
			init_screen
		ensure
			Curses.close_screen
		end
		
		def get_action(hash)
			initialize_members_and_clear_screen hash
			if [:display, :start].include?(hash[:type]) 
				ask_player hash
			else
				# assuming :win
				ask_for_next_level hash
			end
		end
		
		private
		
		def initialize_members_and_clear_screen hash
			if hash[:type] == :start
				@level_title = hash[:title]
				@set_title = hash[:set]
				@level_number = hash[:number]
				@set_total = hash[:total]
				Curses.clear
			end
		end
		
		def init_screen
			Curses.noecho # do not show typed keys
			Curses.init_screen
			Curses.stdscr.keypad(true) # enable arrow keys
			Curses.curs_set 0
		end
		
		def display hash
			display_header hash[:move]
			display_map hash[:map]
		end
		
		def display_header move_number
			write SET_LINE, 0, "Set: #{@set_title}"
			write TITLE_LINE, 0, "Level: #{@level_title} (#{@level_number}/#{@set_total})"
			write MOVES_LINE, 0, "moves : #{move_number}   " unless move_number.nil?
			write STATUS_LINE, 0, 'arrows=move (q)uit (r)etry (u)ndo (l)oad level/set'
		end
		
		def display_map map
			line_num = PICTURE_LINE
			map.each {|line| 
				line.gsub!(/o/, ' ')
				write line_num, 0, line
				line_num += 1
			}
		end
		
		def write(line, column, text)
			Curses.setpos(line, column)
			Curses.addstr(text);
		end
		
		def ask_for_next_level hash
			display hash
			write STATUS_LINE, 0, "LEVEL COMPLETED ! Play next level ? (yes, no)        "
			case Curses.getch
				when ?n, ?N then PlayerAction.new(:quit)
				when ?y, ?Y then PlayerAction.new(:next)
				else
					ask_for_next_level hash
			end
		end
		
		def ask_player hash
			display hash
			response = get_player_input
			if response.nil?
				ask_player hash
			else
				response
			end
		end
		
		def get_player_input
			case Curses.getch
				when Curses::Key::UP then PlayerAction.new(:up)
    		when Curses::Key::DOWN then PlayerAction.new(:down)
    		when Curses::Key::LEFT then PlayerAction.new(:left)
    		when Curses::Key::RIGHT then PlayerAction.new(:right)
    		when ?q, ?Q then PlayerAction.new(:quit)
    		when ?r, ?R then PlayerAction.new(:retry)
    		when ?l, ?L then ask_level_or_set
    		when ?u, ?U then PlayerAction.new(:undo)
    		else
    			nil
			end
		end
		
		def ask_level_or_set
			show_cursor
			display_help
			response = Curses.getstr
			hide_cursor
			case response
				when '1'..'999'
					if response.to_i > @set_total
						ask_level_or_set
					else
						PlayerAction.new(response.to_i)
					end
				when /\.xsb$/ then PlayerAction.new(response)
				else
					PlayerAction.new(:retry)
			end
		end
		
		def show_cursor
			Curses.curs_set 1
			Curses.echo
		end
		
		def hide_cursor
			Curses.curs_set 0
			Curses.noecho
		end
		
		def display_help
			Curses.clear
			help=<<EOS
------------------------------------------------------------
To load a level from this set, type its number.
To load a set of level, type its name (with .xsb).
Int 1 : Don't forget to hit return.
Int 2 : type any letter to cancel and restart previous level
------------------------------------------------------------

EOS
			write 0, 0, help
		end
		
	end

end
