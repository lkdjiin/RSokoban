module RSokoban::UI
		
	# Every concrete UI should inherits from me.
	# @abstract Subclass and override {#get_action} to implement a working UI.
	class BaseUI
	
		def initialize
			@level_title = ''
		end
		
		# Based on things found in the +hash+ argument, I display the game
		# to the user. Then he can tell what he wants to do. Whatever
		# my childs permit the user to do, they can only return an 
		# ActionPlayer object.
		# 
		# @param [Hash] hash
		#   :type => type of message, :win or :start or :display or :end_of_set
		#   :map => current game map
		# @param [Hash] hash the options passed to the UI.
		# @option hash [:win|:start|:display|:end_of_set] :type The type of the message (always +requiered+)
		# @option hash [Map] :map The current map of the game (always +requiered+)
		# @option hash [String] :title The level's title (requiered if type==:start)
		# @option hash [String] :set The set's title (requiered if type==:start)
		# @option hash [Fixnum] :number The level's number (requiered if type==:start)
		# @option hash [Fixnum] :total Number of level in this set (requiered if type==:start)
		# @option hash [Fixnum] :move The move's number (requiered when type is :display or :win)
		# @option hash [String] :error An error message. Could happen when type is :display or :start
		# @return [PlayerAction] the user's action
		# @since 0.73
		# @todo write some examples
		def get_action(hash)
			raise "Please implement me !"
		end
		
	end
	
end
