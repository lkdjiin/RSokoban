require 'optparse'

# I parse the command line.
class Option

	# Here is a list of command line options :
	# * --curses
	# * --help
	# * --help-output
	# * --license
	# * --portable
	# * --tk
	# * --version
	# @todo refactoring
	def initialize
		# Default option(s)
		@options = {:ui => :tk}
		
		optparse = OptionParser.new do|opts|
		 	opts.banner = "Usage: #{$0} [options]"
   		
   		# Options that define the UI
   		opts.on( '-c', '--curses', 'Use curses console for user interface (default)' ) do
     		@options[:ui] = :curses
   		end
   		
   		opts.on( '-p', '--portable', 'Use standard console for user interface' ) do
     		@options[:ui] = :portable
   		end
   		
   		opts.on( '-t', '--tk', 'Make use of Tk library for a graphical user interface' ) do
     		@options[:ui] = :tk
   		end
   		
   		# Options that display a few information
   		@options[:license] = false
   		opts.on( '-l', '--license', 'Print program\'s license and exit' ) do
     		@options[:license] = true
   		end
   		
   		@options[:version] = false
   		opts.on( '-v', '--version', 'Print version number and exit' ) do
     		@options[:version] = true
   		end
   		
   		# Options that display some help
   		@options[:help_output] = false
   		opts.on( '-o', '--help-output', 'Print help on output options and exit' ) do
     		@options[:help_output] = true
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
	
	def interface=(k)
		@options[:ui] = k
	end
	
private

	def print_version
		puts File.read($RSOKOBAN_PATH + '/VERSION').strip
		exit
	end
	
	def print_license
		puts "RSokoban is licensed under the GPL 3. See the COPYING's file."
		exit
	end
	
	def print_help_output
		help=<<EOS

RSokoban can use 3 user interfaces :

  --curses
    This is the default UI. It uses the curses library in a console window.
    It works on Linux. I don't know if it works on Windows or OSX.
    
  --portable
    It uses a plain console window. This UI is boring but should work
    everywhere.
    
  --tk
    The only graphical UI for now. Make sure tk is installed on your computer
    along with the libtk-img extension library.
EOS
		puts help
		exit
	end
end
