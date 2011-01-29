
class TC_LevelLoader < Test::Unit::TestCase

	def setup
		$RSOKOBAN_DATA_PATH = File.expand_path(File.dirname(__FILE__))
	end
	
	def test_instance
		ins = RSokoban::LevelLoader.new "original.xsb"
		assert_equal true, ins.instance_of?(RSokoban::LevelLoader)
	end
	
	def test_NoFileError
		assert_raise(RSokoban::NoFileError) do
			ins = RSokoban::LevelLoader.new "inexistant"
		end
	end
	
	def test_title_of_set
		ins = RSokoban::LevelLoader.new "test_file1.xsb"
		assert_equal 'test level', ins.title
	end
	
	def test_description_of_set
		ins = RSokoban::LevelLoader.new "test_file1.xsb"
		assert_equal "one simple level to test\n", ins.file_description
	end
	
	def test_level_1
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		level = RSokoban::Level.new(RSokoban::RawLevel.new('1', ['#####', '#.$@#', '#####']))
		assert_equal level, ins.level(1)
	end
	
	def test_level_2
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		level = RSokoban::Level.new(RSokoban::RawLevel.new('2', ['######', '#. $@#', '######']))
		assert_equal level, ins.level(2)
	end

	def test_level_3
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		level = RSokoban::Level.new(RSokoban::RawLevel.new('3', ['#####', '#   #', '#$  #', '#. @#', '#####' ]))
		assert_equal level, ins.level(3)
	end
	
	def test_level_4_title
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		assert_equal '4', ins.level(4).title
	end
	
	def test_level_5_title
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		assert_equal '5', ins.level(5).title
	end
	
	def test_level_6_title
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		assert_equal '6', ins.level(6).title
	end
	
	def test_level_6
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		level = RSokoban::Level.new(RSokoban::RawLevel.new('6', ['#####', '#.$@#', '#####']))
		assert_equal level, ins.level(6)
	end
	
	def test_level_number_that_doesnt_exist
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		assert_raise(RSokoban::LevelNumberTooHighError) do
			assert_equal '99', ins.level(99).title
		end
	end
	
	def test_get_size_of_set
		ins = RSokoban::LevelLoader.new "original.xsb"
		assert_equal 90, ins.size
	end
	
	def test_get_the_description_of_a_set
		ins = RSokoban::LevelLoader.new "original.xsb"
		desc = "Copyright: a\nE-Mail:\nWeb Site:\n\nThe 50 original levels from Sokoban plus the 40 from Extra.\n"
		assert_equal desc, ins.file_description
	end
	
	####### BUGS ############################
	
	# There was a bug where size was majored by one when the xsb file
	# finish by several blank lines.
	def test_get_size_of_set_buggy
		ins = RSokoban::LevelLoader.new "test_file2.xsb"
		assert_equal 6, ins.size
	end
	
end
