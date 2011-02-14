require "fileutils"

module RSokoban

	class Record
	
		def initialize filename
			raise ArgumentError unless File.exist? filename
			@dict = YAML.load_file(filename)
		end
		
		def self.load_file filename
			new filename
		end
		
		def record_of_level num
			@dict[num]
		end
		
		def self.create filename
			raise ArgumentError if File.exist? filename
			FileUtils.touch filename
			new filename
		end
		
	end

end
