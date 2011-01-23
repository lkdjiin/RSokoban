require 'curses'

module RSokoban::UI

	# I am a console user interface using curses library.
	# I assume 24 lines height.
	class CursesConsole < BaseUI
	
		@@TITLE_LINE = 0
		@@MOVES_LINE = 1
		@@STATUS_LINE = 2
		@@PICTURE_LINE = 4
		
		def initialize
			super()
			init_screen
		ensure
			Curses.close_screen
		end
		
		def get_action(type, map, message)
			if type == 'START' or type == 'END_OF_SET'
				@level_title = message 
				message = 'OK move 0'
				Curses.clear
			end
			if type == 'DISPLAY' or type == 'START'  or type == 'END_OF_SET'
				ask_player map, message
			else
				# assuming type == 'WIN'
				askForNextLevel map, message
			end
		end
		
		private
		
		def init_screen
			Curses.noecho # do not show typed keys
			Curses.init_screen
			Curses.stdscr.keypad(true) # enable arrow keys
			Curses.curs_set 0
		end
		
		def display map, message
			write @@TITLE_LINE, 0, @level_title
			move_index = message =~ /\d+/
			write @@MOVES_LINE, 0, "moves : #{message[move_index..-1]}   " if move_index
			write @@STATUS_LINE, 0, 'arrows=move (q)uit (r)etry (u)ndo (l)oad level/set'
			line_num = @@PICTURE_LINE
			map.each {|line| 
				write line_num, 0, line
				line_num += 1
			}
		end
		
		def write(line, column, text)
			Curses.setpos(line, column)
			Curses.addstr(text);
		end
		
		def askForNextLevel map, message
			display map, message
			write @@STATUS_LINE, 0, "LEVEL COMPLETED ! Play next level ? (yes, no)        "
			case Curses.getch
				when ?n, ?N then PlayerAction.new(:quit)
				when ?y, ?Y then PlayerAction.new(:next)
				else
					askForNextLevel map, message
			end
		end
		
		def ask_player map, message
			display map, message
			response = get_player_input
			if response.nil?
				ask_player map, message
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
			Curses.curs_set 1
			Curses.echo
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
			str = Curses.getstr
			Curses.curs_set 0
			Curses.noecho
			case str
				when '1'..'999' then PlayerAction.new(str.to_i)
				when /\.xsb$/ then PlayerAction.new(str)
				else
					PlayerAction.new(:retry)
			end
		end
		
	end

end
