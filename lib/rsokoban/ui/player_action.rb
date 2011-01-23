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
		
		@@Allowed_symbols = [ :up, :down, :left, :right, :quit, :next, :retry, :undo ]
		
		# You can the the {class description}[PlayerAction] for an allowed list of value.
		# @param [Object] value optional initial action
		# @raise ArgumentError if value is not allowed
		def initialize value = nil
			self.action = value unless value.nil?
		end
		
		# Set the player action.
		# You can the the {class description}[PlayerAction] for an allowed list of value.
		# @param [Object] value the player action
		def action=(value)
			if value.instance_of?(Symbol)
				raise ArgumentError unless @@Allowed_symbols.include?(value)
			end
			if value.instance_of?(String)
				raise ArgumentError unless value =~ /\.xsb$/
			end
			@action = value
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
