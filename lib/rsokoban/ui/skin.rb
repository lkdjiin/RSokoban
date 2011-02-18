require "yaml"

module RSokoban::UI

	# @since 0.76
	class Skin
	
		def initialize
			@path = File.join($RSOKOBAN_PATH, 'skins/')
			@path_home = File.expand_path("~/.rsokoban/skins/")
			@filenames = {}
		end
	
		def list_skins
			dir = Dir.new @path
			ret = []
			dir.each do |item|
				next if ['.', '..'].include? item
				ret.push item
			end
			
			if File.exist? @path_home
				dir = Dir.new @path_home
				dir.each do |item|
					next if ['.', '..'].include? item
					ret.push item
				end
			end
			
			ret.sort
		end
		
		def path_of_skin dirname
			ret = File.join(@path, dirname)
			return ret if File.directory? ret
			ret = File.join(@path_home, dirname)
			raise ArgumentError unless File.directory? ret
			ret
		end
		
		def size_of full_path_dir
			conf = YAML.load_file File.join(full_path_dir, 'skin.conf')
			conf['size']
		end
		
		def filenames full_path_dir
			@filenames = {}
			get_other_filenames full_path_dir
			get_man_filenames full_path_dir
			get_man_on_storage_filenames full_path_dir
			get_wall_filenames full_path_dir
			@filenames
		end
		
		private
		
		def get_other_filenames full_path_dir
			images = [:crate, :floor, :store, :crate_store, :outside]
			images.each do |image|
				@filenames[image] = File.join(full_path_dir, image.to_s + '.bmp')
			end
		end
		
		def get_man_filenames full_path_dir
			man_file = File.join(full_path_dir, 'man.bmp')
			if File.exist?(man_file)				
				@filenames[:man_up] = @filenames[:man_down] = @filenames[:man_left] = @filenames[:man_right] = man_file
			else
				images = [:man_up, :man_down, :man_left, :man_right]
				images.each do |image|
					@filenames[image] = File.join(full_path_dir, image.to_s + '.bmp')
				end
			end
		end
		
		def get_man_on_storage_filenames full_path_dir
			man_file = File.join(full_path_dir, 'man_store.bmp')
			if File.exist?(man_file)
				@filenames[:man_store_up] = @filenames[:man_store_down] = @filenames[:man_store_left] = @filenames[:man_store_right] = man_file
			else
				images = [:man_store_up, :man_store_down, :man_store_left, :man_store_right]
				images.each do |image| 
					@filenames[image] = File.join(full_path_dir, image.to_s + '.bmp')
				end
			end
		end
		
		def get_wall_filenames full_path_dir
			wall_test_file = File.join(full_path_dir, 'wall_d.bmp')
			images = [:wall, :wall_d, :wall_dl, :wall_dlr, :wall_dr, :wall_l, :wall_lr, :wall_r,
				        :wall_u, :wall_ud, :wall_udl, :wall_udlr, :wall_udr, :wall_ul, :wall_ulr, :wall_ur]
			if File.exist?(wall_test_file)
				images.each do |image|
					@filenames[image] = File.join(full_path_dir, image.to_s + '.bmp')
				end
			else
				images.each do |image|
					@filenames[image] = File.join(full_path_dir, 'wall.bmp')
				end
			end
		end
		
	end
	
end
