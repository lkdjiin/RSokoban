
class TC_SetLoader < Test::Unit::TestCase
	include RSokoban
	
	def setup
		$RSOKOBAN_DATA_PATH = File.expand_path(File.dirname(__FILE__))
	end
	
	def test_instance
		ins = SetLoader.new "original.xsb"
		assert_equal true, ins.instance_of?(SetLoader)
	end
	
	def test_NoFileError
		assert_raise(NoFileError) do
			ins = SetLoader.new "inexistant"
		end
	end
	
	def test_title_of_set
		ins = SetLoader.new "test_file1.xsb"
		assert_equal 'test level', ins.title
	end
	
	def test_description_of_set
		ins = SetLoader.new "test_file1.xsb"
		assert_equal "one simple level to test\n", ins.file_description
	end
	
	def test_level_1
		ins = SetLoader.new "test_file2.xsb"
		level = Level.new(RawLevel.new('1', Map.new(['#####', '#.$@#', '#####'])))
		assert_equal level, ins.level(1)
	end
	
	def test_level_2
		ins = SetLoader.new "test_file2.xsb"
		level = Level.new(RawLevel.new('2', ['######', '#. $@#', '######']))
		assert_equal level, ins.level(2)
	end

	def test_level_3
		ins = SetLoader.new "test_file2.xsb"
		level = Level.new(RawLevel.new('3', ['#####', '#   #', '#$  #', '#. @#', '#####' ]))
		assert_equal level, ins.level(3)
	end
	
	def test_level_4_title
		ins = SetLoader.new "test_file2.xsb"
		assert_equal '4', ins.level(4).title
	end
	
	def test_level_5_title
		ins = SetLoader.new "test_file2.xsb"
		assert_equal '5', ins.level(5).title
	end
	
	def test_level_6_title
		ins = SetLoader.new "test_file2.xsb"
		assert_equal '6', ins.level(6).title
	end
	
	def test_level_6
		ins = SetLoader.new "test_file2.xsb"
		level = Level.new(RawLevel.new('6', Map.new(['#####', '#.$@#', '#####'])))
		assert_equal level, ins.level(6)
	end
	
	def test_level_number_that_doesnt_exist
		ins = SetLoader.new "test_file2.xsb"
		assert_raise(LevelNumberTooHighError) do
			assert_equal '99', ins.level(99).title
		end
	end
	
	def test_get_size_of_set
		ins = SetLoader.new "original.xsb"
		assert_equal 90, ins.size
	end
	
	def test_get_the_description_of_a_set
		ins = SetLoader.new "original.xsb"
		desc = "Copyright: a\nE-Mail:\nWeb Site:\n\nThe 50 original levels from Sokoban plus the 40 from Extra.\n"
		assert_equal desc, ins.file_description
	end
	
	####### BUGS ############################
	
	# There was a bug where size was majored by one when the xsb file
	# finish by several blank lines.
	def test_get_size_of_set_buggy
		ins = SetLoader.new "test_file2.xsb"
		assert_equal 6, ins.size
	end
	
end
