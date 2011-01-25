require 'tk'
require 'tkextlib/tkimg'

module RSokoban::UI

	# 
	class TkUI
	
		def initialize
			@level_loader = RSokoban::LevelLoader.new "original.xsb"
			@level_number = 1
			@level = @level_loader.level(@level_number)
			@move = 0
			@last_move = :up
			init_gui
			display
			Tk.mainloop 
		end
		
		private
		
		def next_level
			begin
				@level_number += 1
				start_level
			rescue RSokoban::LevelNumberTooHighError
				Tk::messageBox :message => 'Sorry, no more levels in this set.'
			end
		end
		
		def start_level
			@level = @level_loader.level(@level_number)
			@move = 0
			init_labels # @todo reset_labels instead
			reset_map
			display
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
						when RSokoban::WALL then display_tile_at @wall, x, y
						when RSokoban::FLOOR then display_tile_at @floor, x, y
						when RSokoban::CRATE then display_tile_at @crate, x, y
						when RSokoban::STORAGE then display_tile_at @store, x, y
						when RSokoban::MAN then display_man_at x, y
						when RSokoban::MAN_ON_STORAGE then display_man_on_storage_at x, y
						when RSokoban::CRATE_ON_STORAGE then display_tile_at @crate_store, x, y
					end
					x += 1
				end
				y += 1
			end
		end
		
		def display_tile_at tile, x, y
			@tk_map[y][x].configure('image' => tile)
		end
		
		def display_man_at x, y
			case @last_move
				when :up then display_tile_at @man_up, x, y
				when :down then display_tile_at @man_down, x, y
				when :left then display_tile_at @man_left, x, y
				else
					display_tile_at @man_right, x, y
			end
		end
		
		def display_man_on_storage_at x, y
			case @last_move
				when :up then display_tile_at @man_store_up, x, y
				when :down then display_tile_at @man_store_down, x, y
				when :left then display_tile_at @man_store_left, x, y
				else
					display_tile_at @man_store_right, x, y
			end
		end
		
		def init_gui
			init_root
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
		
		# Fill map on screen with the outside tile.
		def init_map
			row_in_grid = 5
			# @outside is not seen within the block of TkLabel#new, so make a local copy
			out = @outside
			@tk_map = []
			(0...16).each {|row_index|
				row = []
				(0...19).each {|col_index|
					label = TkLabel.new(@tk_root) do
						image(out)
					 	grid('row'=> row_in_grid, 'column'=> col_index, 'padx' => 0, 'pady' => 0, 'ipadx' => 0, 'ipady' => 0)
					end
					label['borderwidth'] = 0
					row.push label
				}
				@tk_map.push row
				row_in_grid += 1
			}
		end
		
		# Reset all the map with 'outside' tile.
		# @todo little improvement : reload @outside image only if there is something else
		#   in the current map.
		def reset_map
			y = 0
			@tk_map.each do |row|
				x = 0
				row.each do |cell|
					@tk_map[y][x].configure('image' => @outside)
					x += 1
				end
				y += 1
			end
		end
		
		def init_buttons
			@tk_undo_button = TkButton.new(@tk_root) do
				text 'Undo'
				grid('row'=>3, 'column'=>0, 'columnspan' => 3)
			end
			@tk_undo_button.command { undo }
			
			@tk_retry_button = TkButton.new(@tk_root) do
				text 'Retry'
				grid('row'=>3, 'column'=>3, 'columnspan' => 3)
			end
			@tk_retry_button.command { start_level }
			
			@tk_level_button = TkButton.new(@tk_root) do
				text 'Level'
				grid('row'=>3, 'column'=>6, 'columnspan' => 3)
			end
			
			@tk_set_button = TkButton.new(@tk_root) do
				text 'Set'
				grid('row'=>3, 'column'=>9, 'columnspan' => 3)
			end
		end
		
		def make_binding
			@tk_root.bind('Up') { move :up }
			@tk_root.bind('Down') { move :down }
			@tk_root.bind('Left') { move :left }
			@tk_root.bind('Right') { move :right }
			@tk_root.bind('Control-u') { undo }
			@tk_root.bind('Control-r') { start_level }
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
			@wall = TkPhotoImage.new('file' => dir + 'wall.bmp', 'height' => 0, 'width' => 0)
			@crate = TkPhotoImage.new('file' => dir + 'crate.bmp', 'height' => 0, 'width' => 0)
			@floor = TkPhotoImage.new('file' => dir + 'floor.bmp', 'height' => 0, 'width' => 0)
			@store = TkPhotoImage.new('file' => dir + 'store.bmp', 'height' => 0, 'width' => 0)
			@man_up = TkPhotoImage.new('file' => dir + 'man_up.bmp', 'height' => 0, 'width' => 0)
			@man_down = TkPhotoImage.new('file' => dir + 'man_down.bmp', 'height' => 0, 'width' => 0)
			@man_left = TkPhotoImage.new('file' => dir + 'man_left.bmp', 'height' => 0, 'width' => 0)
			@man_right = TkPhotoImage.new('file' => dir + 'man_right.bmp', 'height' => 0, 'width' => 0)
			@crate_store = TkPhotoImage.new('file' => dir + 'crate_store.bmp', 'height' => 0, 'width' => 0)
			@man_store_up = TkPhotoImage.new('file' => dir + 'man_store_up.bmp', 'height' => 0, 'width' => 0)
			@man_store_down = TkPhotoImage.new('file' => dir + 'man_store_down.bmp', 'height' => 0, 'width' => 0)
			@man_store_left = TkPhotoImage.new('file' => dir + 'man_store_left.bmp', 'height' => 0, 'width' => 0)
			@man_store_right = TkPhotoImage.new('file' => dir + 'man_store_right.bmp', 'height' => 0, 'width' => 0)
			@outside = TkPhotoImage.new('file' => dir + 'outside.bmp', 'height' => 0, 'width' => 0)
		end
		
	end
	
end
