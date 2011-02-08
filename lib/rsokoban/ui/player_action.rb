module RSokoban::UI

	# I am an action from the player.
	#
	# List of possible actions :
	# [:quit]                      to quit game
	# [:next]                      to load and play next level
	# [:retry]                     to restart the current level
	# [:up, :down, :left, :right]  to move the man
	# [:undo]                      to undo a move
	# [a number]                   to load this level number
	# [an .xsb filename]           to load the set with this name
	#
	# @since 0.73
	class PlayerAction
		# @param [Object] the action
		attr_reader :action
		
		ALLOWED_SYMBOLS = [ :up, :down, :left, :right, :quit, :next, :retry, :undo ]
		
		# You can look to {PlayerAction} for an allowed list of value.
		# @param [Object] value optional initial action
		# @raise ArgumentError if value is not allowed
		def initialize value = nil
			self.action = value unless value.nil?
		end
		
		def ==(obj)
			@action == obj.action
		end
		
		# Set the player action.
		# @param [Object] value the player action
		# @raise ArgumentError if value is not allowed
		def action=(value)
			check_allowed_symbol(value) if value.instance_of?(Symbol)
			check_allowed_string(value) if value.instance_of?(String)
			@action = value
		end
		
		# @raise ArgumentError if value is not an allowed symbol
		def check_allowed_symbol symb
			raise ArgumentError unless ALLOWED_SYMBOLS.include?(symb)
		end
		
		# @raise ArgumentError if string is not an xsb filename
		def check_allowed_string string
			raise ArgumentError unless string =~ /\.xsb$/
		end
		
		def level_number?
			@action.instance_of?(Fixnum)
		end
		
		def set_name?
			@action.instance_of?(String)
		end
		
		def quit?
			(not @action.nil?) and @action == :quit
		end
		
		def next?
			(not @action.nil?) and @action == :next
		end
		
		def retry?
			(not @action.nil?) and @action == :retry
		end
		
		def move?
			(not @action.nil?) and [:down, :up, :left, :right].include?(@action)
		end
		
		def undo?
			(not @action.nil?) and @action == :undo
		end
	end

end
