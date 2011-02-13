class TC_Record < Test::Unit::TestCase
	include RSokoban

	def setup
		@record = Record.new 'record/original.yaml'
	end

	def test_no_file
		assert_raise(ArgumentError) do
			Record.new 'record/truc.yaml'
		end
	end
	
end
