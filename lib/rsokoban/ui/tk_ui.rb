module RSokoban::UI
	
	# I am a GUI using tk library.
	# @note I need the tk-img extension library.
	# @since 0.73
	# @todo need some examples and more documentation for private methods
	class TkUI
		include RSokoban
		
		# Build and initialize a GUI with the Tk tool kit.
		# @param [Game] game Where we get the logic.
		def initialize game
			@game = game
			@last_move = :up
			@tk_map = []
			init_gui
			start_level
		end
		
		# Start the event loop.
		# @since 0.74
		def run
			Tk.mainloop 
		end
		
		private
		
		def next_level
			begin
				@game.next_level
				init_level
			rescue LevelNumberTooHighError
				Tk::messageBox :message => "Sorry, no level ##{@game.level_number} in this set."
			end
		end
		
		def start_level
			begin
				@game.start_level
				init_level
			rescue LevelNumberTooHighError
				Tk::messageBox :message => "Sorry, no level ##{@game.level_number} in this set."
			end
		end
		
		def load_level
			d =  TkLevelDialog.new(@tk_root, "Load a level")
			return unless d.ok?
			begin
				@game.load_level d.value
				init_level
			rescue LevelNumberTooHighError
				Tk::messageBox :message => "Sorry, no level ##{@game.level_number} in this set."
			end
		end
		
		def load_set
			d =  SetDialog.new(@tk_root, "Load a set")
			return unless d.ok?
			return if d.value.nil?
			@game.load_a_new_set d.value
			init_level
		end
		
		# For now, map size is restricted to 19x16 on screen.
		def init_level
			if @game.level_width > 19 or @game.level_height > 16
				Tk::messageBox :message => "Sorry, level '#{@game.level_title}' is too big to be displayed."
				@game.restart_set
			end
			reset_labels
			reset_map
			display_initial
		end
		
		# Update map rendering. We need only to update man's location and north, south, west
		# and east of him. And because there walls all around the map, there is no needs to check
		# for limits.
		def display_update
			x = @game.man_x
			y = @game.man_y
			update_array = [[x,y], [x+1,y], [x-1,y], [x,y+1], [x,y-1]]
			update_array.each do |x, y|
				case @game.map[y][x].chr
					when WALL then @wall.display_at x, y
					when FLOOR then @floor.display_at x, y
					when CRATE then @crate.display_at x, y
					when STORAGE then @store.display_at x, y
					when MAN then display_man_at x, y
					when MAN_ON_STORAGE then display_man_on_storage_at x, y
					when CRATE_ON_STORAGE then @crate_store.display_at x, y
				end
			end
		end
		
		def display_update_after_undo
			x = @game.man_x
			y = @game.man_y
			update_array = [[x,y], [x+1,y], [x+2,y], [x-1,y], [x-2,y], [x,y+1], [x,y+2], [x,y-1], [x,y-2]]
			update_array.each do |x, y|
				next if x < 0 or y < 0
				next if @game.map[y].nil? or @game.map[y][x].nil?
				display_cell_taking_care_of_outside @game.map[y][x].chr, x, y
			end
		end
		
		# Display the initial map on screen.
		def display_initial
			y = 0
			@game.map.each do |row|
				# find first wall
				x = row.index(RSokoban::WALL)
				line = row.strip
				line.each_char do |char|
					display_cell_taking_care_of_outside char, x, y
					x += 1
				end
				y += 1
			end
		end
		
		def display_cell_taking_care_of_outside char, x, y
			case char
				when WALL then @wall.display_at x, y
				when FLOOR then display_floor_at x, y
				when CRATE then @crate.display_at x, y
				when STORAGE then @store.display_at x, y
				when MAN then display_man_at x, y
				when MAN_ON_STORAGE then display_man_on_storage_at x, y
				when CRATE_ON_STORAGE then @crate_store.display_at x, y
			end
		end
		
		def display_floor_at x, y
			return if y == 0
			height = y - 1
			height.downto(0).each {|row|
				break if @game.map[row][x].nil?
				if [WALL, FLOOR, CRATE, STORAGE].include?(@game.map[row][x].chr)
					@floor.display_at x, y
					break
				end
			}
		end
		
		def display_man_at x, y
			case @last_move
				when :up then @man_up.display_at x, y
				when :down then @man_down.display_at x, y
				when :left then @man_left.display_at x, y
				else
					@man_right.display_at x, y
			end
		end
		
		def display_man_on_storage_at x, y
			case @last_move
				when :up then @man_store_up.display_at x, y
				when :down then @man_store_down.display_at x, y
				when :left then @man_store_left.display_at x, y
				else
					@man_store_right.display_at x, y
			end
		end
		
		def init_gui
			init_root
			init_menu
			init_labels
			preload_images
			init_map
			init_buttons
			make_binding
		end
		
		def init_root
			@tk_root = TkRoot.new do
				title "RSokoban " + File.read($RSOKOBAN_PATH + '/VERSION').strip
				minsize(400, 400)
				resizable(false, false)
			end
		end
		
		def init_menu
			TkOption.add '*tearOff', 0
			menubar = TkMenu.new(@tk_root)
			@tk_root['menu'] = menubar
			
			file = TkMenu.new(menubar)
			helpm = TkMenu.new(menubar)
			menubar.add :cascade, :menu => file, :label => 'File'
			menubar.add :cascade, :menu => helpm, :label => 'Help'
			
			file.add :command, :label => 'Load level', :command => proc{load_level}, :accelerator => 'Ctrl+L'
			file.add :command, :label => 'Load set', :command => proc{load_set}
			file.add :separator
			file.add :command, :label => 'Undo', :command => proc{undo}, :accelerator => 'Ctrl+Z'
			file.add :command, :label => 'Redo', :command => proc{my_redo}, :accelerator => 'Ctrl+Y'
			file.add :command, :label => 'Restart level', :command => proc{start_level}, :accelerator => 'Ctrl+R'
			file.add :command, :label => 'Next level', :command => proc{next_level}, :accelerator => 'Ctrl+N'
			file.add :separator
			file.add :command, :label => 'Quit', :command => proc{exit}
			
			helpm.add :command, :label => 'Help', :command => proc{help}, :accelerator => 'F1'
			helpm.add :separator
			helpm.add :command, :label => 'About', :command => proc{about}
		end
		
		def init_labels
			@tk_frame_label = TkFrame.new(@tk_root) do
				grid('row' => 0, 'column' => 0, 'columnspan' => 19, 'sticky' => 'w')
				padx 5
				pady 5
			end
			@tk_label_set = TkLabel.new(@tk_frame_label) do
			 	grid('row' => 0, 'column' => 0, 'sticky' => 'w')
			end
			@tk_label_level = TkLabel.new(@tk_frame_label) do
				grid('row'=>1, 'column'=> 0, 'sticky' => 'w')
			end
			@tk_label_move = TkLabel.new(@tk_frame_label) do
				grid('row'=>2, 'column'=>0, 'sticky' => 'w')
			end
		end
		
		def reset_labels
			@tk_label_set.configure('text' => "Set: #{@game.set_title}")
			@tk_label_level.configure('text' => "Level: #{@game.level_title} (#{@game.level_number}/#{@game.set_size})")
			update_move_information
		end
		
		def update_move_information
			@tk_label_move.configure('text' => "Move: #{@game.move_number}")
		end
		
		# Build the map of labels. TkBoxs of the game will be displayed on those labels.
		def init_map
			row_in_grid = 5
			(0...16).each {|row_index|
				row = []
				(0...19).each {|col_index|
					label = TkLabel.new(@tk_root) do
					 	grid('row'=> row_in_grid, 'column'=> col_index, 'padx' => 0, 'pady' => 0, 'ipadx' => 0, 'ipady' => 0)
					end
					label['borderwidth'] = 0
					row.push label
				}
				@tk_map.push row
				row_in_grid += 1
			}
			reset_map
		end
		
		# Reset all the map with 'outside' tile.
		# @todo little improvement : reload @outside image only if there is something else
		#   in the current map.
		def reset_map
			@tk_map.each_index {|y|
				@tk_map[y].each_index {|x| @outside.display_at(x, y) }
			}
		end
		
		def init_buttons
			@tk_frame_button = TkFrame.new(@tk_root) do
				grid('row' => 1, 'column' => 0, 'columnspan' => 19, 'sticky' => 'w')
				padx 5
				pady 5
			end
			@tk_undo_button = TkButton.new(@tk_frame_button) do
				text 'Undo'
				grid('row'=> 0, 'column'=> 0)
			end
			@tk_redo_button = TkButton.new(@tk_frame_button) do
				text 'Redo'
				grid('row'=> 0, 'column'=> 1)
			end
			
			@tk_retry_button = TkButton.new(@tk_frame_button) do
				text 'Retry'
				grid('row'=> 0, 'column'=> 2)
			end
			
			@tk_level_button = TkButton.new(@tk_frame_button) do
				text 'Level'
				grid('row'=> 0, 'column'=> 3)
			end
			
			@tk_next_level_button = TkButton.new(@tk_frame_button) do
				text 'Next'
				grid('row'=> 0, 'column'=> 4)
			end
		end
		
		# Bind user's actions
		def make_binding
			@tk_root.bind('Up') { move :up }
			@tk_root.bind('Down') { move :down }
			@tk_root.bind('Left') { move :left }
			@tk_root.bind('Right') { move :right }
			@tk_root.bind('Control-z') { undo }
			@tk_root.bind('Control-y') { my_redo }
			@tk_root.bind('Control-r') { start_level }
			@tk_root.bind('Control-l') { load_level }
			@tk_root.bind('Control-n') { next_level }
			@tk_root.bind('F1') { help }
			@tk_undo_button.command { undo }
			@tk_redo_button.command { my_redo }
			@tk_retry_button.command { start_level }
			@tk_level_button.command { load_level }
			@tk_next_level_button.command { next_level }
		end
		
		def undo
			result = @game.undo
			update_move_information
			display_update_after_undo
		end
		
		def my_redo
			result = @game.redo
			update_move_information
			display_update_after_undo
		end
		
		# Send the move to Level and process response.
		# @param [:ip, :down, :left, :right]
		def move symb
			@last_move = symb
			result = @game.move symb
			unless result.error?
				update_move_information
				display_update
			end
			if result.win?
				response = Tk::messageBox :type => 'yesno', :message => "Level completed !\nPlay next level ?", 
	    						:icon => 'question', :title => 'You win !', :parent => @tk_root, :default => 'yes'
	    	next_level if response == 'yes'
	    	start_level if response == 'no'
			end
		end
		
		def preload_images
			dir = $RSOKOBAN_PATH + '/skins/default/'
			@wall = TkBox.new(dir + 'wall.bmp', @tk_map)
			@crate = TkBox.new(dir + 'crate.bmp', @tk_map)
			@floor = TkBox.new(dir + 'floor.bmp', @tk_map)
			@store = TkBox.new(dir + 'store.bmp', @tk_map)
			@man_up = TkBox.new(dir + 'man_up.bmp', @tk_map)
			@man_down = TkBox.new(dir + 'man_down.bmp', @tk_map)
			@man_left = TkBox.new(dir + 'man_left.bmp', @tk_map)
			@man_right = TkBox.new(dir + 'man_right.bmp', @tk_map)
			@crate_store = TkBox.new(dir + 'crate_store.bmp', @tk_map)
			@man_store_up = TkBox.new(dir + 'man_store_up.bmp', @tk_map)
			@man_store_down = TkBox.new(dir + 'man_store_down.bmp', @tk_map)
			@man_store_left = TkBox.new(dir + 'man_store_left.bmp', @tk_map)
			@man_store_right = TkBox.new(dir + 'man_store_right.bmp', @tk_map)
			@outside = TkBox.new(dir + 'outside.bmp', @tk_map)
		end
		
		def help
			HelpDialog.new(@tk_root, "RSokoban Help")
		end
		
		def about
			text = "RSokoban #{File.read($RSOKOBAN_PATH + '/VERSION').strip} \n"
			text += "This is free software !\n"
			text += "Copyright 2011, Xavier Nayrac\n"
			text += "Licensed under the GPL-3\n"
			text += "Contact: xavier.nayrac@gmail.com"
			Tk::messageBox :message => text, :title => 'About'
		end
		
	end
	
end
