#require 'tk'
#require 'tkextlib/tkimg'

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
	
	# As dialog box, I allow the user to choose a specific level number.
	class LevelDialog < TkToplevel
	
		# Create and show the dialog
		# @param [TkRoot|TkToplevel] root the Tk widget I belong to
		# @param [String] title my window title
		def initialize(root, title)
			super(root)
			title(title)
			minsize(200, 100)
			@state = :cancel
			grab
			
			@frame_north = TkFrame.new(self) do
				grid(:row => 0, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			$spinval = TkVariable.new
			@spin = TkSpinbox.new(@frame_north) do
				textvariable($spinval)
				width 3
				grid(:row => 0, :column => 0)
			end
			@spin.to(999)
			@spin.from(1)
			@spin.focus
			@spin.bind 'Key-Return', proc{ ok_on_clic }
			
			@ok = TkButton.new(self) do
				text 'OK'
				grid(:row => 1, :column => 0)
				default :active
			end
			@ok.command { ok_on_clic }
			
			@cancel = TkButton.new(self) do
				text 'Cancel'
				grid(:row => 1, :column => 1)
			end
			@cancel.command { cancel_on_clic }
			
			wait_destroy
		end
		
		# @return true if user clicked the OK button
		def ok?
			@state == :ok
		end
		
		# @return [Fixnum] level number
		def value
			$spinval.to_i
		end
		
		private
		
		def ok_on_clic
			@state = :ok
			destroy
		end
		
		def cancel_on_clic
			@state = :cancel
			destroy
		end
	end
	
	# As dialog box, I allow the user to choose a set name.
	class SetDialog < TkToplevel
		include RSokoban
		# Create and show the dialog
		# @param [TkRoot|TkToplevel] root the Tk widget I belong to
		# @param [String] title my window title
		def initialize(root, title)
			super(root)
			title(title)
			width(300)
			height(400)
			@state = 'CANCEL'
			grab
			self['resizable'] = false, false
			
			@xsb = get_xsb
			$listval = TkVariable.new(@xsb)
			@value = @xsb[0]
			
			# A frame for the listbox
			@frame_north = TkFrame.new(self) do
				grid(:row => 0, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			@list = TkListbox.new(@frame_north) do
				width 40
			 	height 8
			 	listvariable $listval
			 	grid(:row => 0, :column => 0, :sticky => :we)
			end
			
			@list.bind '<ListboxSelect>', proc{ show_description }
			@list.bind 'Double-1', proc{ ok_on_clic }
			@list.bind 'Return', proc{ ok_on_clic }

			
			scroll = TkScrollbar.new(@frame_north) do
				orient 'vertical'
				grid(:row => 0, :column => 1, :sticky => :ns)
			end

			@list.yscrollcommand(proc { |*args| scroll.set(*args) })
			scroll.command(proc { |*args| @list.yview(*args) })
			
			# A frame for the set description
			@frame_desc = TkFrame.new(self) do
				grid(:row => 1, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			@desc = TkText.new(@frame_desc) do
				borderwidth 1
				font TkFont.new('times 12')
				width 40
				height 10
				wrap :word
			 	grid(:row => 0, :column => 0)
			end
			
			scroll2 = TkScrollbar.new(@frame_desc) do
				orient 'vertical'
				grid(:row => 0, :column => 1, :sticky => :ns)
			end

			@desc.yscrollcommand(proc { |*args| scroll2.set(*args) })
			scroll2.command(proc { |*args| @desc.yview(*args) }) 
			
			# The buttons
			@ok = TkButton.new(self) do
				text 'OK'
				grid(:row => 2, :column => 0)
				default :active
			end
			@ok.command { ok_on_clic }
			
			@cancel = TkButton.new(self) do
				text 'Cancel'
				grid(:row => 2, :column => 1)
			end
			@cancel.command { cancel_on_clic }
			
			@list.focus
			wait_destroy
		end
		
		# @return true if user clicked the OK button
		def ok?
			@state == 'OK'
		end
		
		# @return [String] the name of the set
		def value
			@value
		end
		
		private
		
		def ok_on_clic
			@state = 'OK'
			idx = @list.curselection
			unless idx.empty?
				@value = @xsb[idx[0]]
			end
			destroy
		end
		
		def cancel_on_clic
			@state = 'CANCEL'
			destroy
		end
		
		def get_xsb
			current = Dir.pwd
			Dir.chdir $RSOKOBAN_DATA_PATH
			ret = Dir.glob '*.xsb'
			Dir.chdir current
			ret
		end
		
		def show_description
			idx = @list.curselection
			ll = LevelLoader.new @xsb[idx[0]]
			@desc.delete '1.0', :end
			@desc.insert :end, ll.file_description
		end
	end
	
	# As dialog box, I display some help.
	class HelpDialog < TkToplevel
		# Create and show the dialog
		# @param [TkRoot|TkToplevel] root the Tk widget I belong to
		# @param [String] title my window title
		def initialize(root, title)
			super(root)
			title(title)
			minsize(200, 100)

			text = TkText.new(self) do
				borderwidth 1
				font TkFont.new('times 12 bold')
				grid('row' => 0, 'column' => 0)
			end
			
			help=<<EOS
Welcome to RSokoban !

Goal of Sokoban game is to place each crate on a storage location.
Move the man using the arrow keys.
For a more comprehensive help, please visit the wiki at https://github.com/lkdjiin/RSokoban/wiki.
EOS
			
			text.insert 'end', help

			@ok = TkButton.new(self) do
				text 'OK'
				grid('row'=>1, 'column'=>0)
			end
			@ok.command { ok_on_clic }
		end
		
		def ok_on_clic
			destroy
		end
	end
	
	# I am a GUI using tk library.
	# @note I need the tk-img extension library.
	# @since 0.73
	# @todo a lot of refactoring is needed. There is a lot of duplicated code with Game,
	#   and maybe Level and BaseUI.
	# @todo need some more documentation
	class TkUI
		include RSokoban
		def initialize
			@level_loader = LevelLoader.new "microban.xsb"
			@level_number = 1
			@level = @level_loader.level(@level_number)
			@move = 0
			@last_move = :up
			@tk_map = []
			init_gui
			display_initial
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
				# For now, map size is restricted to 19x16 on screen.
				if @level.width > 19 or @level.height > 16
					Tk::messageBox :message => "Sorry, level '#{@level.title}' is too big to be displayed."
					@level_number = 1
					start_level
				end
				@move = 0
				reset_labels
				reset_map
				display_initial
			rescue LevelNumberTooHighError
				Tk::messageBox :message => "Sorry, no level ##{@level_number} in this set."
			end
		end
		
		def load_level
			d =  LevelDialog.new(@tk_root, "Load a level")
			if d.ok?
				@level_number = d.value
				start_level
			end
		end
		
		def load_set
			d =  SetDialog.new(@tk_root, "Load a set")
			new_set = d.value
			if d.ok? and new_set != nil
				@level_loader = LevelLoader.new new_set
				@level_number = 1
				start_level
			end
		end
		
		# Update map rendering. We need only to update man's location and north, south, west
		# and east of it. And because there walls all around the map, there is no needs to check
		# for limits.
		def display_update
			x = @level.man.x
			y = @level.man.y
			update_array = [[x,y], [x+1,y], [x-1,y], [x,y+1], [x,y-1]]
			update_array.each do |x, y|
				case @level.map[y][x].chr
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
		
		# Display the current map (current state of the level) on screen.
		def display_initial
			y = 0
			@level.map.each do |row|
				# find first wall
				x = row.index(RSokoban::WALL)
				line = row.strip
				line.each_char do |char|
					case char
						when WALL then @wall.display_at x, y
						when FLOOR then display_floor_at x, y
						when CRATE then @crate.display_at x, y
						when STORAGE then @store.display_at x, y
						when MAN then display_man_at x, y
						when MAN_ON_STORAGE then display_man_on_storage_at x, y
						when CRATE_ON_STORAGE then @crate_store.display_at x, y
					end
					x += 1
				end
				y += 1
			end
		end
		
		def display_floor_at x, y
			return if y == 0
			height = y - 1
			height.downto(0).each {|row|
				break if @level.map[row][x].nil?
				if [WALL, FLOOR, CRATE, STORAGE].include?(@level.map[row][x].chr)
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
			reset_labels
		end
		
		def reset_labels
			@tk_label_set.configure('text' => "Set: #{@level_loader.set.title}")
			@tk_label_level.configure('text' => "Level: #{@level.title} (#{@level_number}/#{@level_loader.set.size})")
			update_move_information
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
			@tk_frame_button = TkFrame.new(@tk_root) do
				grid('row' => 1, 'column' => 0, 'columnspan' => 19, 'sticky' => 'w')
				padx 5
				pady 5
			end
			@tk_undo_button = TkButton.new(@tk_frame_button) do
				text 'Undo'
				grid('row'=>3, 'column'=>0, 'columnspan' => 3)
			end
			
			@tk_retry_button = TkButton.new(@tk_frame_button) do
				text 'Retry'
				grid('row'=>3, 'column'=>3, 'columnspan' => 3)
			end
			
			@tk_level_button = TkButton.new(@tk_frame_button) do
				text 'Level'
				grid('row'=>3, 'column'=>6, 'columnspan' => 3)
			end
			
			@tk_next_level_button = TkButton.new(@tk_frame_button) do
				text 'Next'
				grid('row'=>3, 'column'=>9, 'columnspan' => 3)
			end
		end
		
		# Bind user's actions
		def make_binding
			@tk_root.bind('Up') { move :up }
			@tk_root.bind('Down') { move :down }
			@tk_root.bind('Left') { move :left }
			@tk_root.bind('Right') { move :right }
			@tk_root.bind('Control-z') { undo }
			@tk_root.bind('Control-r') { start_level }
			@tk_root.bind('Control-l') { load_level }
			@tk_root.bind('Control-n') { next_level }
			@tk_root.bind('F1') { help }
			@tk_undo_button.command { undo }
			@tk_retry_button.command { start_level }
			@tk_level_button.command { load_level }
			@tk_next_level_button.command { next_level }
		end
		
		def undo
			result = @level.undo
			@move = get_move_number_from_result_of_last_move result
			update_move_information
			display_update
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
				display_update
			end
			if result.start_with?('WIN')
				response = Tk::messageBox :type => 'yesno', :message => "Level completed !\nPlay next level ?", 
	    						:icon => 'question', :title => 'You win !', :parent => @tk_root, :default => 'yes'
	    	next_level if response == 'yes'
	    	start_level if response == 'no'
			end
		end
		
		# Assuming that result start with 'OK' or 'WIN'
		# @return [Fixnum] current move number
		def get_move_number_from_result_of_last_move result
			move_index = result =~ /\d+/
			result[move_index..-1].to_i
		end
		
		def preload_images
			dir = $RSOKOBAN_PATH + '/skins/default/'
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
