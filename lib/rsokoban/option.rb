require 'optparse'

# I parse the command line.
class Option

	# Here is a list of command line options :
	# * --curses
	# * --version
	# * --license
	# * --help
	# * --help-output
	# * --portable
	# @todo refactoring
	def initialize
		@options = {:ui => :curses}
		
		optparse = OptionParser.new do|opts|
		 	opts.banner = "Usage: #{$0} [options]"
   		
   		opts.on( '-c', '--curses', 'Use curses console for user interface (default)' ) do
     		@options[:ui] = :curses
   		end
   		
   		@options[:help_output] = false
   		opts.on( '-o', '--help-output', 'Print help on output options and exit' ) do
     		@options[:help_output] = true
   		end
   		
   		@options[:license] = false
   		opts.on( '-l', '--license', 'Print program\'s license and exit' ) do
     		@options[:license] = true
   		end
   		
   		opts.on( '-p', '--portable', 'Use standard console for user interface' ) do
     		@options[:ui] = :portable
   		end
   		
   		@options[:version] = false
   		opts.on( '-v', '--version', 'Print version number and exit' ) do
     		@options[:version] = true
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
		
		print_version if @options[:version]
		print_license if @options[:license]
		print_help_output if @options[:help_output]
	end
	
	def [](k)
		@options[k]
	end
	
private

	def print_version
		puts RSokoban::VERSION
		exit
	end
	
	def print_license
		puts "RSokoban is licensed under the GPL 3. See the COPYING's file."
		exit
	end
	
	def print_help_output
		help=<<EOS

RSokoban can use 2 user interfaces :

  --curses
    This is the default UI. It uses the curses library in a console window.
    It works on Linux. I don't know if it works on Windows or OSX.
    
  --portable
    It uses a plain console window. This UI is boring but should work
    everywhere.
EOS
		puts help
		exit
	end
end
