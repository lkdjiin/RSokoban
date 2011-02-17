require "fileutils"
require "yaml"

module RSokoban

	class Install
	
		def self.create_folder path
			FileUtils.makedirs path
		end
		
		def self.create_config path
			self.create_folder path
			config = {'skin' => 'BlueGranite'}
			f = File.new(File.join(path, 'config'), "w")
			f.write config.to_yaml
			f.close
		end
		
	end
	
end
