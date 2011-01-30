module RSokoban
	class NoFileError < ArgumentError
	end
	
	class LevelNumberTooHighError < ArgumentError
	end
	
	# Used by {MoveRecorder}. Raise me if one try to undo when there is no move left.
	class EmptyMoveQueueError < StandardError
	end
	
	# Used by {MoveRecorder}. Raise me if one try to redo when there is nothing to redo.
	class EmptyRedoError < StandardError
	end
end
