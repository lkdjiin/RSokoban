require "yaml"

module RSokoban::UI

	# @since 0.76
	class Skin
	
		def initialize
			@path = File.join($RSOKOBAN_PATH, 'skins/')
			@path_home = File.expand_path("~/.rsokoban/skins/")
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
			
			ret
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
		
	end
	
end
