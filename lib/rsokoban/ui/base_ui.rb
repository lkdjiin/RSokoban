module RSokoban::UI
		
	# Every concrete UI should inherits from me.
	# @abstract Subclass and override {#get_action} to implement a working UI.
	class BaseUI
	
		def initialize
			@level_title = ''
		end
		
		# Based on things found in the arguments, I display the game
		# to the user. Then he can tell what it want to do. Whatever
		# my childs permit the user to do, they can only return one 
		# of the following actions.
		#
		# List of action I must be able to parse and return :
		# :quit                      to quit game
		# :next                      to load and play next level
		# :retry                     to restart the current level
		# :up, :down, :left, :right  to move the man
		# :undo                      to undo a move
		# a number                   to load this level number
		# an .xsb filename           to load the set with this name
		# 
		# @param ['START'|'DISPLAY'|'WIN'] type the type of message
		# @param [Array<String>] level the picture of the level
		# @param [String] message a message to be displayed. See Level#move
		#   to learn more about the message format and content.
		# @return [Object] the user's action
		# @since 0.71
		# @todo write some examples
		# @todo action diserves its own class
		# @todo picture diserves its own class
		# @todo document better +type+
		def get_action(type, level, message)
			raise "Please implement me !"
		end
		
	end
	
end
