module RSokoban

	class Config
		
		def initialize
			@conf = YAML.load_file File.join(CONFIG_FOLDER, CONFIG_FILE)
		end
		
		def [](key)
			@conf[key]
		end
		
		def []= (key, value)
			@conf[key] = value
			write_config
		end
		
		def save_set_and_level setname, level_number
			@conf['set'] = setname
			@conf['level'] = level_number
			write_config
		end
		
		private
		
		def write_config
			f = File.new(File.join(CONFIG_FOLDER, CONFIG_FILE), "w")
			f.write @conf.to_yaml
			f.close
		end
		
	end

end
