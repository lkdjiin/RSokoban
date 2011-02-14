require "fileutils"
require 'yaml'

module RSokoban

	# I keep trace of your records !
	class Record
	
		# Load the yaml file named <tt>filename</tt>, which keep trace of all records from a
		# special set of levels. <tt>filename</tt> must have the same name that the xsb file but
		# with the <tt>.yaml</tt> extension.
		# @raise ArgumentError if <tt>filename</tt> doesn't exist.
		def initialize filename
			raise ArgumentError unless File.exist? filename
			@filename = filename
			@dict = YAML.load_file(filename)
			# because yaml returns nil/false if filename is empty.
			@dict = {} unless @dict
		end
		
		# @see #initialize
		def self.load_file filename
			new filename
		end
		
		# Get the record for the level number <tt>num</tt>.
		def record_of_level num
			@dict[num]
		end
		
		# Create the file <tt>filename</tt> before loading it as in {#initialize}.
		# @raise ArgumentError if <tt>filename</tt> exist.
		def self.create filename
			raise ArgumentError if File.exist? filename
			FileUtils.touch filename
			new filename
		end
		
		# Add or update the record for level number <tt>level_number</tt>
		def add level_number, moves
			@dict.merge!({level_number => moves})
			f = File.new(@filename, "w")
			f.write @dict.to_yaml
			f.close
		end
		
	end

end
