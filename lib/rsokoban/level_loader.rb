module RSokoban

	# Je charge le fichier contenant les niveaux du jeu. À ma création, vous m'indiquez un fichier 
	# au format xsb contenant un ou plusieurs niveaux. 
	# Vous pouvez ensuite me demander un niveau particulier (un objet Level).
	# @todo translate, document and refactor
	class LevelLoader
		attr_reader :level, :set
	
		# @param [String] filename le nom du fichier où trouver les niveaux.
		#   Ce fichier est cherché dans le dossier data/.
		# @raise [RSokoban::NoFileError] si le fichier n'existe pas
		# @see LevelSet overview of .xsb file format
		def initialize filename
			filename = "#{$RSOKOBAN_DATA_PATH}/" + filename
			raise NoFileError unless File.exist?(filename)
			@set = LevelSet.new
			file = open(filename)
			@set.title = file.readline.chomp.sub(/;/, '').strip
			file.readline # must be blank line
			line = file.readline
			desc = ''
			while line[0] == ?; do
				desc += line.sub(/;/, '').sub(/\s*/, '')
				line = file.readline
			end
			@set.description = desc
			
			loop do
				begin
					line = file.readline.chomp
					raw = []
					while line =~ /^ *#/
						raw.push line
						line = file.readline.chomp
					end
					line = line.chomp.sub(/;/, '').sub(/\s*/, '')
					@set.rawLevels.push RawLevel.new(line, raw) unless raw.empty?
					
					line = file.readline
					while line[0, 1] == ';'
						line = file.readline
					end
					# must be a blank line here
				rescue EOFError
					break
				end
			end
		end
		
		def level num
			raise LevelNumberTooHighError if num > @set.rawLevels.size
			Level.new @set.rawLevels[num-1]
		end
		
	end

end
