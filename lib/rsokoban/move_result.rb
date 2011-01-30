module RSokoban

	# I am the result content of a move.
	
	# @since 0.74
	class MoveResult
	
		# @param [Hash] hash the result
		# @option hash [Symbol] :status Could be :ok, :win or :error
		# @option hash [Fixnum] :move_number for a status of :ok or :win
		# @option hash [String] :message for a status of :error
		def initialize hash
			@hash = hash
		end
		
		def [](k)
			@hash[k]
		end
		
		# @return true if move is ok
		def ok?
			@hash[:status] == :ok
		end
		
		# @return true if move result to winning the game
		def win?
			@hash[:status] == :win
		end
		
		# @return true if move is an error
		def error?
			@hash[:status] == :error
		end
		
	end

end
