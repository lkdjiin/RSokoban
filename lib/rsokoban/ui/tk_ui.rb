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
			init_gui
			display
			Tk.mainloop 
		end
		
		private
		
		def display
			y = 0
			@level.map.each do |row|
				# find first wall
				x = row.index(RSokoban::WALL)
				line = row.strip
				line.each_char do |char|
					@tk_map[y][x].configure('image' => @wall) if char == RSokoban::WALL
					@tk_map[y][x].configure('image' => @floor) if char == RSokoban::FLOOR
					@tk_map[y][x].configure('image' => @crate) if char == RSokoban::CRATE
					@tk_map[y][x].configure('image' => @store) if char == RSokoban::STORAGE
					@tk_map[y][x].configure('image' => @man) if char == RSokoban::MAN
					@tk_map[y][x].configure('image' => @crate_store) if char == RSokoban::CRATE_ON_STORAGE
					@tk_map[y][x].configure('image' => @man_store) if char == RSokoban::MAN_ON_STORAGE
					x += 1
				end
				y += 1
			end
		end
		
		def init_gui
			init_root
			init_labels
			init_map
			init_buttons
			make_binding
			preload_images
		end
		
		def init_root
			@tk_root = TkRoot.new do
				title "RSokoban " + File.read('../VERSION').strip
				minsize(400, 400)
			end
		end
		
		def init_labels
			@tk_label_set = TkLabel.new(@tk_root) do
			 	grid('row' => 0, 'column' => 0, 'columnspan' => 19)
			end
			@tk_label_set.configure('text' => "Set: #{@level_loader.set.title}")
			
			@tk_label_level = TkLabel.new(@tk_root) do
				grid('row'=>1, 'column'=>0, 'columnspan' => 19)
			end
			@tk_label_level.configure('text' => "Level: #{@level.title} (#{@level_number}/#{@level_loader.set.size})")
			
			@tk_label_move = TkLabel.new(@tk_root) do
				grid('row'=>2, 'column'=>0, 'columnspan' => 19)
			end
			@tk_label_move.configure('text' => "Move: #{@move}")
			
			@tk_label_separator = TkLabel.new(@tk_root) do
				text("")
				grid('row'=>4, 'column'=>0, 'columnspan' => 19)
			end
		end
		
		def init_map
			row_in_grid = 5
			photo = TkPhotoImage.new
			photo.file = "../skins/default/outside.bmp"
			photo.height = 0
			photo.width = 0
			
			@tk_map = []
			(0...16).each {|row_index|
				row = []
				(0...19).each {|col_index|
					label = TkLabel.new(@tk_root) do
						image(photo)
					 	grid('row'=> row_in_grid, 'column'=> col_index, 'padx' => 0, 'pady' => 0, 'ipadx' => 0, 'ipady' => 0)
					end
					label['borderwidth'] = 0
					row.push label
				}
				@tk_map.push row
				row_in_grid += 1
			}
		end
		
		def init_buttons
			@tk_undo_button = TkButton.new(@tk_root) do
				text 'Undo'
				grid('row'=>3, 'column'=>0, 'columnspan' => 3)
				command proc { puts "undo" }
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
		
		def make_binding
			@tk_root.bind('Up') { move :up }
			@tk_root.bind('Down') { move :down }
			@tk_root.bind('Left') { move :left }
			@tk_root.bind('Right') { move :right }
		end
		
		def move symb
			@level.move symb
			display
		end
		
		def preload_images
			@wall = TkPhotoImage.new('file' => '../skins/default/wall.bmp', 'height' => 0, 'width' => 0)
			@crate = TkPhotoImage.new('file' => '../skins/default/crate.bmp', 'height' => 0, 'width' => 0)
			@floor = TkPhotoImage.new('file' => '../skins/default/floor.bmp', 'height' => 0, 'width' => 0)
			@store = TkPhotoImage.new('file' => '../skins/default/store.bmp', 'height' => 0, 'width' => 0)
			@man = TkPhotoImage.new('file' => '../skins/default/man_up.bmp', 'height' => 0, 'width' => 0)
			@crate_store = TkPhotoImage.new('file' => '../skins/default/crate_store.bmp', 'height' => 0, 'width' => 0)
			@man_store = TkPhotoImage.new('file' => '../skins/default/man_store_up.bmp', 'height' => 0, 'width' => 0)
		end
		
	end
	
end
