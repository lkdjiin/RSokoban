module RSokoban

	# I load a file containing a bunch of levels for the game. On instanciation,
	# you give me a filename (in xsb file format) containing one or more levels.
	#
	# You can then ask for a particular level (a Level object). You can use me too
	# to find the description of a level.
	# @todo give some examples
	class SetLoader
	
		# @param [String] filename an xsb filename.
		#   This file is searched in the data/ folder.
		# @raise [RSokoban::NoFileError] if filename doesn't exist
		# @see LevelSet overview of .xsb file format
		def initialize filename
			@filename = filename
			@set = LevelSet.new
			@file = open_file
			get_title_of_the_set
			get_description_of_the_set
			get_levels_of_the_set
		end
		
		# @param [Fixnum] num a level number in base 1
		# @return [Level]
		def level num
			raise LevelNumberTooHighError if num > @set.raw_levels.size
			level = Level.new @set.raw_levels[num-1]
			level.set_filename = File.basename @filename, '.xsb'
			level.number = num
			level
		end
		
		# Get the description field from the loaded set of levels.
		# @return [String] possibly multi-line
		def file_description
			@set.description
		end
		
		# Get number of levels in this set.
		# @return [Fixnum]
		def size
			@set.size
		end
		
		# Get title of this set.
		# @return [String]
		def title
			@set.title
		end
		
		private
		
		# @param [String] filename an xsb file to be found in data/ folder
		# @return [File]
		# @raise NoFileError
		def open_file
			filename = "#{$RSOKOBAN_DATA_PATH}/" + @filename
			raise NoFileError unless File.exist?(filename)
			open(filename)
		end
		
		def get_title_of_the_set
			@set.title = @file.readline.get_xsb_info_line_chomp
			# After the title, there must be a blank line
			line = @file.readline 
			raise "Must be a blank line" unless line.strip.empty?
		end
		
		def get_description_of_the_set
			line = @file.readline
			desc = ''
			while line[0] == ?; do
				desc += line.get_xsb_info_line
				line = @file.readline
			end
			@set.description = desc
			# After the description, there must be a blank line
			raise "Must be a blank line" unless line.strip.empty?
		end
		
		def get_levels_of_the_set
			loop do
				begin
					line = @file.readline.chomp
					raw = []
					while line =~ /^ *#/
						raw.push line
						line = @file.readline.chomp
					end
					line = line.get_xsb_info_line_chomp
					@set.raw_levels.push RawLevel.new(line, Map.new(raw)) unless raw.empty?
					
					line = @file.readline
					while line[0, 1] == ';'
						line = @file.readline
					end
					# must be a blank line here
					raise "Must be a blank line" unless line.strip.empty?
				rescue EOFError
					break
				end
			end
		end
		
	end

end
