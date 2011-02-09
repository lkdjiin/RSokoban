module RSokoban::UI
	
	# I am a GUI using tk library.
	# @note I need the tk-img extension library.
	# @note This code is untestable and untested. In fact, I don't know HOW to test it !
	# @since 0.73
	class TkUI
		include RSokoban
		
		# Number of cells in a row
		MAP_WIDTH = 19
		# Number of cells in a column
		MAP_HEIGHT = 16
		# Cell size in pixels, a cell is a square
		CELL_SIZE = 30
		
		X_COORDS = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360, 390, 420, 450, 480, 510, 540]
		Y_COORDS = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360, 390, 420, 450]
		
		# Build and initialize a GUI with the Tk tool kit.
		# @param [Game] game Where we get the logic.
		def initialize game
			@game = game
			@last_move = :up
			@images = {}
			
			init_root
			Menu.new(@tk_root, self)
			@tk_frame_label = FrameOfLabels.new @tk_root
			preload_images
			init_map
			@tk_frame_button = FrameOfButtons.new @tk_root
			make_binding
			
			start_level
		end
		
		# Start the event loop.
		# @since 0.74
		def run
			Tk.mainloop 
		end
		
		def undo
			result = @game.undo
			@tk_frame_label.update_move_information @game
			display_update_after_undo
		end
		
		def my_redo
			result = @game.redo
			@tk_frame_label.update_move_information @game
			display_update_after_undo
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
			dial =  TkLevelDialog.new(@tk_root, "Load a level")
			return unless dial.ok?
			begin
				@game.load_level dial.value
				init_level
			rescue LevelNumberTooHighError
				Tk::messageBox :message => "Sorry, no level ##{@game.level_number} in this set."
			end
		end
		
		def load_set
			dial =  SetDialog.new(@tk_root, "Load a set")
			return unless dial.ok?
			return if dial.value.nil?
			@game.load_a_new_set dial.value
			init_level
		end
		
		private
		
		# For now, map size is restricted to 19x16 on screen.
		def init_level
			if @game.level_width > 19 or @game.level_height > 16
				Tk::messageBox :message => "Sorry, level '#{@game.level_title}' is too big to be displayed."
				@game.restart_set
			end
			@tk_frame_label.reset_labels @game
			reset_map
			display_initial
		end
		
		# Update map rendering. We need only to update man's location and north, south, west
		# and east of him. And because they are walls all around the map, there is no needs to check
		# for limits.
		def display_update
			x = @game.man_x
			y = @game.man_y
			update_array = [[x,y], [x+1,y], [x-1,y], [x,y+1], [x,y-1]]
			update_array.each do |x, y|
				case @game.map_as_array[y][x].chr
					when WALL then display_cell :wall, x, y
					when FLOOR then display_cell :floor, x, y
					when CRATE then display_cell :crate, x, y
					when STORAGE then display_cell :store, x, y
					when MAN then display_man_at x, y
					when MAN_ON_STORAGE then display_man_on_storage_at x, y
					when CRATE_ON_STORAGE then display_cell :crate_store, x, y
				end
			end
		end
		
		def display_cell image, x, y
			@container.copy(@images[image], :to => [X_COORDS[x], Y_COORDS[y]])
		end
		
		def display_update_after_undo
			x = @game.man_x
			y = @game.man_y
			update_array = [[x,y], [x+1,y], [x+2,y], [x-1,y], [x-2,y], [x,y+1], [x,y+2], [x,y-1], [x,y-2]]
			update_array.each do |x, y|
				next if x < 0 or y < 0
				next if @game.map_as_array[y].nil? or @game.map_as_array[y][x].nil?
				display_cell_taking_care_of_outside @game.map_as_array[y][x].chr, x, y
			end
		end
		
		# Display the initial map on screen.
		def display_initial
			y_coord = 0
			@game.map_as_array.each do |row|
				# find first wall
				x_coord = row.index(RSokoban::WALL)
				line = row.strip
				line.each_char do |char|
					display_cell_taking_care_of_outside char, x_coord, y_coord
					x_coord += 1
				end
				y_coord += 1
			end
		end
		
		def display_cell_taking_care_of_outside char, x_coord, y_coord
			case char
				when WALL then display_cell :wall, x_coord, y_coord
				when FLOOR then display_floor_at x_coord, y_coord
				when CRATE then display_cell :crate, x_coord, y_coord
				when STORAGE then display_cell :store, x_coord, y_coord
				when MAN then display_man_at x_coord, y_coord
				when MAN_ON_STORAGE then display_man_on_storage_at x_coord, y_coord
				when CRATE_ON_STORAGE then display_cell :crate_store, x_coord, y_coord
			end
		end
		
		# @todo optimize: @game.map_as_array outside of the loop and see if (0..height) is faster than height.downto(0)
		def display_floor_at x_coord, y_coord
			return if y_coord == 0
			height = y_coord - 1
			height.downto(0).each {|row|
				cell = @game.map_as_array[row][x_coord]
				break if cell.nil?
				if [WALL, FLOOR, CRATE, STORAGE].include?(cell.chr)
					display_cell :floor, x_coord, y_coord
					break
				end
			}
		end
		
		def display_man_at x, y
			case @last_move
				when :up then display_cell :man_up, x, y
				when :down then display_cell :man_down, x, y
				when :left then display_cell :man_left, x, y
				else
					display_cell :man_right, x, y
			end
		end
		
		def display_man_on_storage_at x, y
			case @last_move
				when :up then display_cell :man_store_up, x, y
				when :down then display_cell :man_store_down, x, y
				when :left then display_cell :man_store_left, x, y
				else
					display_cell :man_store_right, x, y
			end
		end
		
		def init_root
			@tk_root = TkRoot.new do
				title "RSokoban " + File.read($RSOKOBAN_PATH + '/VERSION').strip
				minsize(400, 400)
				resizable(false, false)
			end
		end
		
		# Build the map of labels. TkBoxs of the game will be displayed on those labels.
		def init_map
			row_in_grid = 5
			
			@tk_map_label = TkLabel.new(@tk_root) do
				grid('row'=> row_in_grid, 'column'=> 0, 'padx' => 0, 'pady' => 0, 'ipadx' => 0, 'ipady' => 0)
			end
			@tk_map_label['height'] = MAP_HEIGHT * CELL_SIZE
			@tk_map_label['width'] = MAP_WIDTH * CELL_SIZE
			@container = TkPhotoImage.new('height' => MAP_HEIGHT * CELL_SIZE, 'width' => MAP_WIDTH * CELL_SIZE)
			@tk_map_label .configure('image' => @container)
			
			reset_map
		end
		
		# Reset all the map with 'outside' tile.
		# @todo little improvement : reload @images[:outside] image only if there is something else
		#   in the current map.
		def reset_map
			width = MAP_WIDTH * CELL_SIZE - 1
			height = MAP_HEIGHT * CELL_SIZE - 1
			@container.copy(@images[:outside], :to => [0, 0, width, height])
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
			@tk_frame_button.undo_button.command { undo }
			@tk_frame_button.redo_button.command { my_redo }
			@tk_frame_button.retry_button.command { start_level }
			@tk_frame_button.level_button.command { load_level }
			@tk_frame_button.next_level_button.command { next_level }
		end
		
		# Send the move to Level and process response.
		# @param [:ip, :down, :left, :right]
		def move symb
			@last_move = symb
			result = @game.move symb
			unless result.error?
				@tk_frame_label.update_move_information @game
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
			images = [:wall, :crate, :floor, :store, :man_up, :man_down, :man_left, :man_right, :crate_store,
			:man_store_up, :man_store_down, :man_store_left, :man_store_right]
			images.each do |image|
				@images[image] =TkPhotoImage.new('file' => dir + image.to_s + '.bmp', 'height' => CELL_SIZE, 'width' => CELL_SIZE)
			end
			
			@images[:outside] =TkPhotoImage.new('file' => dir + 'outside.bmp', 'height' => 0, 'width' => 0)
		end
		
	end
	
	# Menu bar attached to tk gui.
	# @since 0.74.1
	class Menu
		
		# @param [TkRoot] tk_root
		# @param [TkUI] object_root
		def initialize tk_root, object_root
			TkOption.add '*tearOff', 0
			menubar = TkMenu.new(tk_root)
			tk_root['menu'] = menubar
			
			file = TkMenu.new(menubar)
			helpm = TkMenu.new(menubar)
			menubar.add :cascade, :menu => file, :label => 'File'
			menubar.add :cascade, :menu => helpm, :label => 'Help'
			
			file.add :command, :label => 'Load level', :command => proc{object_root.load_level}, :accelerator => 'Ctrl+L'
			file.add :command, :label => 'Load set', :command => proc{object_root.load_set}
			file.add :separator
			file.add :command, :label => 'Undo', :command => proc{object_root.undo}, :accelerator => 'Ctrl+Z'
			file.add :command, :label => 'Redo', :command => proc{object_root.my_redo}, :accelerator => 'Ctrl+Y'
			file.add :command, :label => 'Restart level', :command => proc{object_root.start_level}, :accelerator => 'Ctrl+R'
			file.add :command, :label => 'Next level', :command => proc{object_root.next_level}, :accelerator => 'Ctrl+N'
			file.add :separator
			file.add :command, :label => 'Quit', :command => proc{exit}
			
			helpm.add :command, :label => 'Help', :command => proc{object_root.help}, :accelerator => 'F1'
			helpm.add :separator
			helpm.add :command, :label => 'About', :command => proc{object_root.about}
		end
		
	end
	
	# I am a frame attached to tk gui. I display information through some labels.
	# @since 0.74.1
	class FrameOfLabels
		
		def initialize tk_root
			@frame = TkFrame.new(tk_root) do
				grid('row' => 0, 'column' => 0, 'columnspan' => 19, 'sticky' => 'w')
				padx 5
				pady 5
			end
			@label_set = TkLabel.new(@frame) do
			 	grid('row' => 0, 'column' => 0, 'sticky' => 'w')
			end
			@label_level = TkLabel.new(@frame) do
				grid('row'=>1, 'column'=> 0, 'sticky' => 'w')
			end
			@label_move = TkLabel.new(@frame) do
				grid('row'=>2, 'column'=>0, 'sticky' => 'w')
			end
		end
		
		def reset_labels game
			@label_set.configure('text' => "Set: #{game.set_title}")
			@label_level.configure('text' => "Level: #{game.level_title} (#{game.level_number}/#{game.set_size})")
			update_move_information game
		end
		
		def update_move_information game
			@label_move.configure('text' => "Move: #{game.move_number}")
		end
		
	end
	
	# @since 0.74.1
	class FrameOfButtons
		attr_reader :undo_button, :redo_button, :retry_button, :level_button, :next_level_button
		
		def initialize tk_root
			@frame = TkFrame.new(tk_root) do
				grid('row' => 1, 'column' => 0, 'columnspan' => 19, 'sticky' => 'w')
				padx 5
				pady 5
			end
			@undo_button = TkButton.new(@frame) do
				text 'Undo'
				grid('row'=> 0, 'column'=> 0)
			end
			@redo_button = TkButton.new(@frame) do
				text 'Redo'
				grid('row'=> 0, 'column'=> 1)
			end
			
			@retry_button = TkButton.new(@frame) do
				text 'Retry'
				grid('row'=> 0, 'column'=> 2)
			end
			
			@level_button = TkButton.new(@frame) do
				text 'Level'
				grid('row'=> 0, 'column'=> 3)
			end
			
			@next_level_button = TkButton.new(@frame) do
				text 'Next'
				grid('row'=> 0, 'column'=> 4)
			end
		end
	end
	
end
