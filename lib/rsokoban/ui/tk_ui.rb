module RSokoban::UI
	
	# I am a GUI using tk library.
	#
	# The grid is:
	# * a frame with some labels (game info)
	# * a frame with some buttons (menu shortcuts)
	# * a frame with the rendered map
	#
	# @note I need the tk-img extension library.
	# @note This code is untestable and untested. In fact, I don't know HOW to test it !
	# @since 0.73
	class TkUI
		include RSokoban
		
		# Number of maximum displayed cells in a row
		MAP_WIDTH = 19
		# Number of maximum displayed cells in a column
		MAP_HEIGHT = 16
		
		# Build and initialize a GUI with the Tk tool kit.
		# @param [Game] game Where we get the logic.
		def initialize game
			@game = game
			@last_move = :up
			@images = {}
			@x_bounds = []
			@y_bounds = []
			@cell_size = 30
			init_root
			Menu.new(@tk_root, self)
			@tk_frame_label = FrameOfLabels.new @tk_root
			load_skin File.join($RSOKOBAN_PATH, 'skins', 'default')
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
		
		def scroll_right
			@left_window += 10
			if @left_window + MAP_WIDTH > @game.level_width
				@left_window = @game.level_width - MAP_WIDTH 
			end
			@left_window = 0 if @left_window < 0
			window_update
		end
		
		def scroll_left
			@left_window -= 10
			@left_window = 0 if @left_window < 0
			window_update
		end
		
		def scroll_up
			@top_window -= 10
			@top_window = 0 if @top_window < 0
			window_update
		end
		
		def scroll_down
			@top_window += 10
			if @top_window + MAP_HEIGHT > @game.level_height
				@top_window = @game.level_height - MAP_HEIGHT
			end
			@top_window = 0 if @top_window < 0
			window_update
		end
		
		# @since 0.76
		def select_skin
			dial =  SkinDialog.new(@tk_root, "Change skin")
			return unless dial.ok?
			return if dial.value.nil?
			load_skin dial.value
			init_level
		end
		
		private
		
		def init_level
			width, height = get_dimension_in_cells
			compute_bounds width, height
			@top_window = @left_window = 0
			@tk_frame_label.reset_labels @game
			@tk_frame_render.geometry width, height, @cell_size
			reset_map
			display_initial
		end
		
		def get_dimension_in_cells			
			width = @game.level_width > MAP_WIDTH ? MAP_WIDTH : @game.level_width
			height = @game.level_height > MAP_HEIGHT ? MAP_HEIGHT : @game.level_height
			[width, height]
		end
		
		def compute_bounds width, height
			@x_bounds = []
			(0...width).each {|idx| @x_bounds.push idx * @cell_size}
			@y_bounds = []
			(0...height).each {|idx| @y_bounds.push idx * @cell_size}
		end
		
		def display update_locations
			return if man_goes_offscreen?
			
			update_locations.each do |x, y|
				next if y >= @top_window + MAP_HEIGHT
				next if x >= @left_window + MAP_WIDTH
				next if x < 0 or y < 0
				# I think there should be something wrong with the tests above.
				# Else I don't need the two following tests.
				row = window[y]
				next if row.nil?
				cell = row[x]
				next if cell.nil?
				display_cell_taking_care_of_content cell.chr, x, y
			end
		end
		
		# We need only to update man's location and north, south, west
		# and east of him.
		def display_update
			x = @game.man_x - @left_window
			y = @game.man_y - @top_window
			display [[x,y], [x+1,y], [x-1,y], [x,y+1], [x,y-1]]
		end
		
		def display_update_after_undo
			x = @game.man_x - @left_window
			y = @game.man_y - @top_window
			display [[x,y], [x+1,y], [x+2,y], [x-1,y], [x-2,y], [x,y+1], [x,y+2], [x,y-1], [x,y-2]]
		end
		
		# If the man goes offscreen, do an autoscrolling.
		# @return [Boolean]
		def man_goes_offscreen?
			if @game.man_x < @left_window
				scroll_left
			elsif @game.man_x >= @left_window + MAP_WIDTH
				scroll_right
			elsif @game.man_y < @top_window
				scroll_up
			elsif @game.man_y >= @top_window + MAP_HEIGHT
				scroll_down
			else
				return false
			end
			true
		end
		
		def render_cell image, x, y
			@render.copy(@images[image], :to => [@x_bounds[x], @y_bounds[y]])
		end
		
		# Display the initial map on screen.
		def display_initial
			window.each_with_index do |row, y_coord|
				x_coord = 0
				row.each_char do |char|
					display_cell_taking_care_of_content char, x_coord, y_coord
					x_coord += 1
				end
			end
		end
		
		# Get the game map through a window
		# @todo refactor. All this stuff (#window, @top_window, MAP_WIDTH, etc) don't belong to this 
		#   class. Maybe it belongs to Map or LayeredMap or a new class named Window ?
		def window
			ret = []
			@game.map_as_array.each_with_index do |row, y|
				if y >= @top_window and y < @top_window + MAP_HEIGHT
					ret.push row[@left_window, MAP_WIDTH]
				end
			end
			ret
		end
		
		def window_update
			reset_map
			display_initial
		end
		
		def display_cell_taking_care_of_content char, x_coord, y_coord
			case char
				when WALL then render_wall x_coord, y_coord #render_cell :wall, x_coord, y_coord
				when FLOOR then render_cell :floor, x_coord, y_coord
				when CRATE then render_cell :crate, x_coord, y_coord
				when STORAGE then render_cell :store, x_coord, y_coord
				when MAN then display_man_at x_coord, y_coord
				when MAN_ON_STORAGE then display_man_on_storage_at x_coord, y_coord
				when CRATE_ON_STORAGE then render_cell :crate_store, x_coord, y_coord
			end
		end
		
		def render_wall x, y
			up_down_left_right = []
			near = [[x,y-1], [x,y+1], [x-1,y], [x+1,y]]
			map = window
			near.each do |xx, yy|
				if map[yy].nil? or yy < 0
					up_down_left_right << false 
				elsif map[yy][xx].nil? or xx < 0
					up_down_left_right << false 
				elsif map[yy][xx].chr == WALL
					up_down_left_right << true 
				else
					up_down_left_right << false 
				end
			end
			
			case up_down_left_right
				when [false, false, false, false] then render_cell :wall, x, y
				when [true, false, false, false] then render_cell :wall_u, x, y
				when [false, true, false, false] then render_cell :wall_d, x, y
				when [false, false, true, false] then render_cell :wall_l, x, y
				when [false, false, false, true] then render_cell :wall_r, x, y
				when [true, true, false, false] then render_cell :wall_ud, x, y
				when [true, false, true, false] then render_cell :wall_ul, x, y
				when [true, false, false, true] then render_cell :wall_ur, x, y
				when [false, true, true, false] then render_cell :wall_dl, x, y
				when [false, true, false, true] then render_cell :wall_dr, x, y
				when [false, false, true, true] then render_cell :wall_lr, x, y
				when [true, true, true, false] then render_cell :wall_udl, x, y
				when [true, true, false, true] then render_cell :wall_udr, x, y
				when [true, false, true, true] then render_cell :wall_ulr, x, y
				when [false, true, true, true] then render_cell :wall_dlr, x, y
				when [true, true, true, true] then render_cell :wall_udlr, x, y
			end
		end
		
		def display_man_at x, y
			case @last_move
				when :up then render_cell :man_up, x, y
				when :down then render_cell :man_down, x, y
				when :left then render_cell :man_left, x, y
				else
					render_cell :man_right, x, y
			end
		end
		
		def display_man_on_storage_at x, y
			case @last_move
				when :up then render_cell :man_store_up, x, y
				when :down then render_cell :man_store_down, x, y
				when :left then render_cell :man_store_left, x, y
				else
					render_cell :man_store_right, x, y
			end
		end
		
		def init_root
			@tk_root = TkRoot.new do
				title "RSokoban " + File.read($RSOKOBAN_PATH + '/VERSION').strip
				resizable(false, false)
			end
		end
		
		# Let FrameRender build an image to render game in.
		# @todo we don't need the @render member.
		def init_map						
			@tk_frame_render = FrameRender.new @tk_root, @cell_size
			@render = @tk_frame_render.render
			reset_map
		end
		
		# Reset all the map with 'outside' tile.
		def reset_map
			width = MAP_WIDTH * @cell_size - 1
			height = MAP_HEIGHT * @cell_size - 1
			@render.copy(@images[:outside], :to => [0, 0, width, height])
		end
		
		# Bind user's actions
		def make_binding
			@tk_root.bind('Control-Right') { scroll_right }
			@tk_root.bind('Control-Left') { scroll_left }
			@tk_root.bind('Control-Up') { scroll_up }
			@tk_root.bind('Control-Down') { scroll_down }
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
				message = if @game.update_record
					"Congratulations ! New record !\n"
				else
					"Level completed !\n"
				end
				# ask for continue ?
				response = Tk::messageBox :type => 'yesno', :message => message + "Play next level ?", 
	    						:icon => 'question', :title => 'You win !', :parent => @tk_root, :default => 'yes'
	    	next_level if response == 'yes'
	    	start_level if response == 'no'
			end
		end
		
		def load_skin dir
			@cell_size = Skin.new.size_of dir
			images = [:crate, :floor, :store, :crate_store]
			images.each do |image|
				@images[image] =TkPhotoImage.new('file' => File.join(dir, image.to_s + '.bmp'), 'height' => @cell_size, 'width' => @cell_size)
			end
			@images[:outside] =TkPhotoImage.new('file' => File.join(dir, 'outside.bmp'), 'height' => 0, 'width' => 0)
			
			# The man
			man_file = File.join(dir, 'man.bmp')
			if File.exist?(man_file)
				@images[:man_up] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
				@images[:man_down] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
				@images[:man_left] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
				@images[:man_right] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
			else
				images = [:man_up, :man_down, :man_left, :man_right]
				images.each do |image|
					@images[image] =TkPhotoImage.new('file' => File.join(dir, image.to_s + '.bmp'), 'height' => @cell_size, 'width' => @cell_size)
				end
			end
			
			# The man on storage
			man_file = File.join(dir, 'man_store.bmp')
			if File.exist?(man_file)
				@images[:man_store_up] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
				@images[:man_store_down] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
				@images[:man_store_left] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
				@images[:man_store_right] =TkPhotoImage.new('file' => man_file, 'height' => @cell_size, 'width' => @cell_size)
			else
				images = [:man_store_up, :man_store_down, :man_store_left, :man_store_right]
				images.each do |image|
					@images[image] =TkPhotoImage.new('file' => File.join(dir, image.to_s + '.bmp'), 'height' => @cell_size, 'width' => @cell_size)
				end
			end
			
			# The wall
			wall_test_file = File.join(dir, 'wall_d.bmp')
			images = [:wall, :wall_d, :wall_dl, :wall_dlr, :wall_dr, :wall_l, :wall_lr, :wall_r,
				        :wall_u, :wall_ud, :wall_udl, :wall_udlr, :wall_udr, :wall_ul, :wall_ulr, :wall_ur]
			if File.exist?(wall_test_file)
				images.each do |image|
					@images[image] =TkPhotoImage.new('file' => File.join(dir, image.to_s + '.bmp'), 'height' => @cell_size, 'width' => @cell_size)
				end
			else
				images.each do |image|
					@images[image] =TkPhotoImage.new('file' => File.join(dir, 'wall.bmp'), 'height' => @cell_size, 'width' => @cell_size)
				end
			end
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
			menubar[:font] = 'TkMenuFont'
			tk_root['menu'] = menubar
			
			file = TkMenu.new(menubar)
			file[:font] = 'TkMenuFont'
			window = TkMenu.new(menubar)
			window[:font] = 'TkMenuFont'
			options = TkMenu.new(menubar)
			options[:font] = 'TkMenuFont'
			helpm = TkMenu.new(menubar)
			helpm[:font] = 'TkMenuFont'
			menubar.add :cascade, :menu => file, :label => 'File'
			menubar.add :cascade, :menu => window, :label => 'Window'
			menubar.add :cascade, :menu => options, :label => 'Options'
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
			
			window.add :command, :label => 'Scroll left', :command => proc{object_root.scroll_left}, :accelerator => 'Ctrl+Left'
			window.add :command, :label => 'Scroll right', :command => proc{object_root.scroll_right}, :accelerator => 'Ctrl+Right'
			window.add :command, :label => 'Scroll up', :command => proc{object_root.scroll_up}, :accelerator => 'Ctrl+Up'
			window.add :command, :label => 'Scroll down', :command => proc{object_root.scroll_down}, :accelerator => 'Ctrl+Down'
			
			options.add :command, :label => 'Change skin...', :command => proc{object_root.select_skin}
			
			helpm.add :command, :label => 'Help', :command => proc{object_root.help}, :accelerator => 'F1'
			helpm.add :separator
			helpm.add :command, :label => 'About', :command => proc{object_root.about}
		end
		
	end
	
	# @since 0.75
	class FrameRender
		attr_reader :render
		
		def initialize tk_root, cell_size
			@frame = Tk::Tile::Frame.new(tk_root) do
				grid(:row => 2, :column => 0, :sticky => 'w')
				padding 5
			end
			
			@render_label = TkLabel.new(@frame) do
				grid(:row => 0, :column => 0, :padx => 0, :pady => 0, :ipadx => 0, :ipady => 0)
			end
			@render = TkPhotoImage.new(:height => TkUI::MAP_HEIGHT * cell_size, :width => TkUI::MAP_WIDTH * cell_size)
			@render_label .configure(:image => @render)
		end
		
		def geometry width_in_cells, height_in_cells, cell_size
			@render[:height] = height_in_cells * cell_size
			@render[:width] = width_in_cells * cell_size
		end
		
	end
	
	# I am a frame attached to tk gui. I display information through some labels.
	# @since 0.74.1
	class FrameOfLabels
		
		def initialize tk_root
			@frame = Tk::Tile::Frame.new(tk_root) do
				grid(:row => 0, :column => 0, :sticky => 'w')
				padding 5
			end
			@label_set = Tk::Tile::Label.new(@frame) do
			 	grid(:row => 0, :column => 0, :sticky => 'w')
			end
			@label_level = Tk::Tile::Label.new(@frame) do
				grid(:row => 1, :column => 0, :sticky => 'w')
			end
			@label_move = Tk::Tile::Label.new(@frame) do
				grid(:row => 2, :column => 0, :sticky => 'w')
			end
		end
		
		def reset_labels game
			@label_set.configure('text' => "Set: #{game.set_title}")
			@label_level.configure('text' => "Level: #{game.level_title} (#{game.level_number}/#{game.set_size}) Record: #{game.record}")
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
			@frame = Tk::Tile::Frame.new(tk_root) do
				grid(:row => 1, :column => 0, :sticky => 'w')
				padding 5
			end
			@undo_button = Tk::Tile::Button.new(@frame) do
				text 'Undo'
				grid(:row => 0, :column => 0)
			end
			@redo_button = Tk::Tile::Button.new(@frame) do
				text 'Redo'
				grid(:row => 0, :column => 1)
			end
			
			@retry_button = Tk::Tile::Button.new(@frame) do
				text 'Retry'
				grid(:row => 0, :column => 2)
			end
			
			@level_button = Tk::Tile::Button.new(@frame) do
				text 'Level'
				grid(:row => 0, :column => 3)
			end
			
			@next_level_button = Tk::Tile::Button.new(@frame) do
				text 'Next'
				grid(:row => 0, :column => 4)
			end
		end
	end
	
end
