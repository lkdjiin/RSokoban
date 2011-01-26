require 'tk'
require 'tkextlib/tkimg'

module RSokoban::UI

	# I am an image of the game who knows how to display itself on an array
	# of TkLabel items.
	# @since 0.73
	class Image
		
		# @param [String] file path of image file
		# @param [Array<Array<TkLabel>>] output an array to display myself
		def initialize file, output
			@box = TkPhotoImage.new('file' => file, 'height' => 0, 'width' => 0)
			@output = output
		end
		
		# Display myself at x,y coordinate
		def display_at x, y
			@output[y][x].configure('image' => @box)
		end
		
	end
	
	class LevelDialog < TkToplevel
		def initialize(root, title)
			super(root)
			title(title)
			minsize(200, 100)
			@state = 'CANCEL'
			grab
			
			$spinval = TkVariable.new
			@spin = TkSpinbox.new(self) do
				textvariable($spinval)
				grid('row'=>0, 'column'=>0)
			end
			@spin.to(999)
			@spin.from(1)
			
			@ok = TkButton.new(self) do
				text 'OK'
				grid('row'=>1, 'column'=>0)
			end
			@ok.command { ok_on_clic }
			
			@cancel = TkButton.new(self) do
				text 'Cancel'
				grid('row'=>1, 'column'=>1)
			end
			@cancel.command { cancel_on_clic }
			
			wait_destroy
		end
		
		def ok_on_clic
			@state = 'OK'
			destroy
		end
		
		def cancel_on_clic
			@state = 'CANCEL'
			destroy
		end
		
		def state
			@state
		end
		
		def value
			$spinval
		end
	end
	
	
	
	# I am a GUI using tk library.
	# @note I need the tk-img extension library.
	# @since 0.73
	# @todo a lot of refactoring is needed. There is a lot of duplicated code with Game,
	#   and maybe Level and BaseUI.
	# @todo need some more documentation
	class TkUI
	
		def initialize
			@level_loader = RSokoban::LevelLoader.new "microban.xsb"
			@level_number = 1
			@level = @level_loader.level(@level_number)
			@move = 0
			@last_move = :up
			@tk_map = []
			init_gui
			display
			Tk.mainloop 
		end
		
		private
		
		def next_level
			@level_number += 1
			start_level
		end
		
		def start_level
			begin
				@level = @level_loader.level(@level_number)
				@move = 0
				init_labels # @todo reset_labels instead
				reset_map
				display
			rescue RSokoban::LevelNumberTooHighError
				Tk::messageBox :message => "Sorry, no level ##{@level_number} in this set."
			end
		end
		
		def load_level
			d =  LevelDialog.new(@tk_root, "Load a level")
			if d.state == 'OK'
				@level_number = d.value.to_i
				start_level
			end
		end
		
		def load_set
			puts 'load_set'
		end
		
		# Display the current map (current state of the level) on screen.
		def display
			y = 0
			@level.map.each do |row|
				# find first wall
				x = row.index(RSokoban::WALL)
				line = row.strip
				line.each_char do |char|
					case char
						when RSokoban::WALL then @wall.display_at x, y
						when RSokoban::FLOOR then @floor.display_at x, y
						when RSokoban::CRATE then @crate.display_at x, y
						when RSokoban::STORAGE then @store.display_at x, y
						when RSokoban::MAN then display_man_at x, y
						when RSokoban::MAN_ON_STORAGE then display_man_on_storage_at x, y
						when RSokoban::CRATE_ON_STORAGE then @crate_store.display_at x, y
					end
					x += 1
				end
				y += 1
			end
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
				title "RSokoban " + File.read('../VERSION').strip
				minsize(400, 400)
				resizable(false, false)
			end
		end
		
		def init_menu
			TkOption.add '*tearOff', 0
			menubar = TkMenu.new(@tk_root)
			@tk_root['menu'] = menubar
			
			file = TkMenu.new(menubar)
			help = TkMenu.new(menubar)
			menubar.add :cascade, :menu => file, :label => 'File'
			menubar.add :cascade, :menu => help, :label => 'Help'
			
			file.add :command, :label => 'Load level', :command => proc{load_level}, :accelerator => 'Ctrl+L'
			file.add :command, :label => 'Load set', :command => proc{load_set}
			file.add :separator
			file.add :command, :label => 'Undo', :command => proc{undo}, :accelerator => 'Ctrl+U'
			file.add :command, :label => 'Restart level', :command => proc{start_level}, :accelerator => 'Ctrl+R'
			file.add :separator
			file.add :command, :label => 'Quit', :command => proc{exit}
		end
		
		def init_labels
			@tk_label_set = TkLabel.new(@tk_root) do
			 	grid('row' => 0, 'column' => 0, 'columnspan' => 19, 'sticky' => 'w')
			end
			@tk_label_set.configure('text' => "Set: #{@level_loader.set.title}")
			
			@tk_label_level = TkLabel.new(@tk_root) do
				grid('row'=>1, 'column'=>0, 'columnspan' => 19, 'sticky' => 'w')
			end
			@tk_label_level.configure('text' => "Level: #{@level.title} (#{@level_number}/#{@level_loader.set.size})")
			
			@tk_label_move = TkLabel.new(@tk_root) do
				grid('row'=>2, 'column'=>0, 'columnspan' => 19, 'sticky' => 'w')
			end
			update_move_information
			
			@tk_label_separator = TkLabel.new(@tk_root) do
				text("")
				grid('row'=>4, 'column'=>0, 'columnspan' => 19)
			end
		end
		
		def update_move_information
			@tk_label_move.configure('text' => "Move: #{@move}")
		end
		
		# Build the map of labels. Images of the game will be displayed on those labels.
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
			@tk_undo_button = TkButton.new(@tk_root) do
				text 'Undo'
				grid('row'=>3, 'column'=>0, 'columnspan' => 3)
			end
			
			@tk_retry_button = TkButton.new(@tk_root) do
				text 'Retry'
				grid('row'=>3, 'column'=>3, 'columnspan' => 3)
			end
			
			@tk_level_button = TkButton.new(@tk_root) do
				text 'Level'
				grid('row'=>3, 'column'=>6, 'columnspan' => 3)
			end
			
			@tk_set_button = TkButton.new(@tk_root) do
				text 'Set'
				grid('row'=>3, 'column'=>9, 'columnspan' => 3)
			end
		end
		
		# Bind user's actions
		def make_binding
			@tk_root.bind('Up') { move :up }
			@tk_root.bind('Down') { move :down }
			@tk_root.bind('Left') { move :left }
			@tk_root.bind('Right') { move :right }
			@tk_root.bind('Control-u') { undo }
			@tk_root.bind('Control-r') { start_level }
			@tk_root.bind('Control-l') { load_level }
			@tk_undo_button.command { undo }
			@tk_retry_button.command { start_level }
			@tk_level_button.command { load_level }
		end
		
		def undo
			result = @level.undo
			@move = get_move_number_from_result_of_last_move result
			update_move_information
			display
		end
		
		# Send the move to Level and process response.
		# @todo the last move is recorded here to permit the display of the man
		#   in the 4 direction. This is a bad thing ! Level#move should returns a hash
		#   with all needed information (status, move number, last move, error message, etc.)
		def move symb
			@last_move = symb
			result = @level.move symb
			unless result.start_with?('ERROR')
				@move = get_move_number_from_result_of_last_move result
				update_move_information
				display
			end
			if result.start_with?('WIN')
				response = Tk::messageBox :type => 'yesno', :message => "Level completed !\nPlay next level ?", 
	    						:icon => 'question', :title => 'You win !', :parent => @tk_root, :default => 'yes'
	    	next_level if response == 'yes'
			end
		end
		
		# Assuming that result start with 'OK' or 'WIN'
		# @return [Fixnum] current move number
		def get_move_number_from_result_of_last_move result
			move_index = result =~ /\d+/
			result[move_index..-1].to_i
		end
		
		def preload_images
			dir = '../skins/default/'
			@wall = Image.new(dir + 'wall.bmp', @tk_map)
			@crate = Image.new(dir + 'crate.bmp', @tk_map)
			@floor = Image.new(dir + 'floor.bmp', @tk_map)
			@store = Image.new(dir + 'store.bmp', @tk_map)
			@man_up = Image.new(dir + 'man_up.bmp', @tk_map)
			@man_down = Image.new(dir + 'man_down.bmp', @tk_map)
			@man_left = Image.new(dir + 'man_left.bmp', @tk_map)
			@man_right = Image.new(dir + 'man_right.bmp', @tk_map)
			@crate_store = Image.new(dir + 'crate_store.bmp', @tk_map)
			@man_store_up = Image.new(dir + 'man_store_up.bmp', @tk_map)
			@man_store_down = Image.new(dir + 'man_store_down.bmp', @tk_map)
			@man_store_left = Image.new(dir + 'man_store_left.bmp', @tk_map)
			@man_store_right = Image.new(dir + 'man_store_right.bmp', @tk_map)
			@outside = Image.new(dir + 'outside.bmp', @tk_map)
		end
		
	end
	
end
