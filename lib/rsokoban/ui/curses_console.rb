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
		
		def get_action(type, level, message)
			if type == 'START' or type == 'END_OF_SET'
				@level_title = message 
				message = 'OK move 0'
				Curses.clear
			end
			if type == 'DISPLAY' or type == 'START'  or type == 'END_OF_SET'
				ask_player level, message
			else
				# assuming type == 'WIN'
				askForNextLevel level, message
			end
		end
		
		private
		
		def init_screen
			Curses.noecho # do not show typed keys
			Curses.init_screen
			Curses.stdscr.keypad(true) # enable arrow keys
			Curses.curs_set 0
		end
		
		def display level, message
			write @@TITLE_LINE, 0, @level_title
			move_index = message =~ /\d+/
			write @@MOVES_LINE, 0, "moves : #{message[move_index..-1]}   " if move_index
			write @@STATUS_LINE, 0, 'arrows=move (q)uit (r)etry (u)ndo (l)oad level/set'
			line_num = @@PICTURE_LINE
			level.each {|line| 
				write line_num, 0, line
				line_num += 1
			}
		end
		
		def write(line, column, text)
			Curses.setpos(line, column)
			Curses.addstr(text);
		end
		
		def askForNextLevel level, message
			display level, message
			write @@STATUS_LINE, 0, "LEVEL COMPLETED ! Play next level ? (yes, no)        "
			case Curses.getch
				when ?n, ?N then :quit
				when ?y, ?Y then :next
				else
					askForNextLevel level, message
			end
		end
		
		def ask_player level, message
			display level, message
			response = get_player_input
			if response.nil?
				ask_player level, message
			else
				response
			end
		end
		
		def get_player_input
			case Curses.getch
				when Curses::Key::UP then :up
    		when Curses::Key::DOWN then :down
    		when Curses::Key::LEFT then :left
    		when Curses::Key::RIGHT then :right
    		when ?q, ?Q then :quit
    		when ?r, ?R then :retry
    		when ?l, ?L then ask_level_or_set
    		when ?u, ?U then :undo
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
				when '1'..'999' then str.to_i
				when /\.xsb$/ then str
				else
					:retry
			end
		end
		
	end

end
