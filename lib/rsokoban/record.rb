module RSokoban

	class Record
	
		def initialize filename
			raise ArgumentError unless File.exist? filename
		end
		
	end

end
