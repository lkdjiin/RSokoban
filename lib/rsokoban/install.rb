require "fileutils"

module RSokoban

	class Install
	
		def self.create_folder path
			FileUtils.makedirs path
		end
		
	end
	
end
