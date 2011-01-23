module RSokoban::UI
		
	# Every concrete UI should inherits from me.
	# @abstract Subclass and override {#get_action} to implement a working UI.
	class BaseUI
	
		def initialize
			@level_title = ''
		end
		
		# Based on things found in the arguments, I display the game
		# to the user. Then he can tell what it want to do. Whatever
		# my childs permit the user to do, they can only return an 
		# ActionPlayer object.
		# 
		# @param ['START'|'DISPLAY'|'WIN'] type the type of message
		# @param [Map] map the map of the level
		# @param [String] message a message to be displayed. See Level#move
		#   to learn more about the message format and content.
		# @return [PlayerAction] the user's action
		# @since 0.71
		# @todo write some examples
		# @todo document better +type+
		def get_action(type, map, message)
			raise "Please implement me !"
		end
		
	end
	
end
