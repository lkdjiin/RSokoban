module RSokoban

	# I load a file containing the levels of the game. On instanciation,
	# you tell me a file (in xsb file format) containing one or more levels.
	#
	# You can then ask for a particular level (a Level object). You can use me too
	# to find the description of a level.
	# @todo give some examples
	# @todo document and refactor
	class LevelLoader
		attr_reader :level, :set
	
		# @param [String] filename an xsb filename.
		#   This file is searched in thedata/ folder.
		# @raise [RSokoban::NoFileError] if filename doesn't exist
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
