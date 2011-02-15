module RSokoban::UI

	# @since 0.76
	class Skin
	
		def initialize
			@path = File.join($RSOKOBAN_PATH, 'skins/')
		end
	
		def list_skins
			dir = Dir.new @path
			ret = []
			dir.each do |item|
				next if ['.', '..'].include? item
				ret.push item
			end
			ret
		end
		
		def path_of_skin dirname
			ret = File.join(@path, dirname)
			raise ArgumentError unless File.directory? ret
			ret
		end
		
	end
	
end
