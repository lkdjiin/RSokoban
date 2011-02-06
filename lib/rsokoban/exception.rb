module RSokoban
	# @todo look if ruby doesn't already have got this kind of class.
	class NoFileError < ArgumentError
	end
	
	# Used when we try to load a level (from a set of levels) that is out of limit.
	class LevelNumberTooHighError < ArgumentError
	end
	
	# Used by {MoveRecorder}. Raise me if one try to undo when there is no move left.
	class EmptyMoveQueueError < StandardError
	end
	
	# Used by {MoveRecorder}. Raise me if one try to redo when there is nothing to redo.
	class EmptyRedoError < StandardError
	end
end
