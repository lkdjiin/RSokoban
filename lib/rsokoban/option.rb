require 'optparse'

# I parse the command line.
class Option

	# Here is a list of command line options :
	# * --version
	# * --license
	# * --help
	# @todo refactoring
	def initialize
		@options = {}
		optparse = OptionParser.new do|opts|
		 	opts.banner = "Usage: #{$0} [options]"
		 	# Define the options, and what they do
   		@options[:version] = false
   		opts.on( '-v', '--version', 'Print version number and exit' ) do
     		@options[:version] = true
   		end
   		
   		@options[:license] = false
   		opts.on( '-l', '--license', 'Print program\'s license and exit' ) do
     		@options[:license] = true
   		end
   		
   		opts.on( '-h', '--help', 'Display this screen' ) do
     		puts opts
     		exit
   		end
		end
		begin
			optparse.parse!
		rescue OptionParser::InvalidOption => e
			puts e.to_s
			exit 1
		end
		printVersion if @options[:version]
		printLicense if @options[:license]
	end
	
	def [](k)
		@options[k]
	end
	
private

	def printVersion
		puts RSokoban::VERSION
		exit
	end
	
	def printLicense
		puts "RSokoban is licensed under the GPL 3. See the COPYING's file."
		exit
	end
end
