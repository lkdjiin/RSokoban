class TC_Record < Test::Unit::TestCase
	include RSokoban

	RECORD_ORIGINAL = 'record/original.yaml'
	RECORD_TEST = 'record/test.yaml'
	
	def get_original
		Record.new RECORD_ORIGINAL
	end

	def test_no_file
		assert_raise(ArgumentError) do
			Record.new 'record/truc.yaml'
		end
	end
	
	def test_load_file_is_a_synonym_of_new
		record = Record.load_file RECORD_ORIGINAL
		assert record.respond_to? :record_of_level
	end
	
	def test_get_record_of_level_1
		record = get_original
		num = record.record_of_level(1)
		assert_equal 200, num
	end
	
	def test_get_record_of_level_22
		record = get_original
		num = record.record_of_level(22)
		assert_equal 321, num
	end
	
	def test_get_record_that_doesnt_exist
		record = get_original
		num = record.record_of_level(100)
		assert_equal nil, num
	end
	
	def test_create_a_new_record_file
		begin
			record = Record.load_file RECORD_TEST
		rescue ArgumentError => e
			record = Record.create RECORD_TEST
		ensure 
			assert File.exist? RECORD_TEST
			assert record.respond_to? :record_of_level
		end
	ensure
		FileUtils.remove_file(RECORD_TEST) if File.exist?(RECORD_TEST)
	end
	
	def test_cannot_create_existing_file
		assert_raise(ArgumentError) do
			Record.create 'record/original.yaml'
		end
	end
	
	def test_save_a_new_record
		record = Record.create RECORD_TEST
		# level number, number of moves
		record.add 1, 123
		num = record.record_of_level(1)
		assert_equal 123, num
	ensure
		FileUtils.remove_file(RECORD_TEST) if File.exist?(RECORD_TEST)
	end
	
	def test_save_a_new_record_to_file
		record = Record.create RECORD_TEST
		record.add 1, 123
		record = Record.load_file RECORD_TEST
		num = record.record_of_level(1)
		assert_equal 123, num
	ensure
		FileUtils.remove_file(RECORD_TEST) if File.exist?(RECORD_TEST)
	end
	
	def test_update_a_record
		record = Record.create RECORD_TEST
		record.add 1, 123
		record.add 1, 456
		num = record.record_of_level(1)
		assert_equal 456, num
	ensure
		FileUtils.remove_file(RECORD_TEST) if File.exist?(RECORD_TEST)
	end
	
	def test_updtae_a_record_to_file
		record = Record.create RECORD_TEST
		record.add 1, 123
		record.add 1, 456
		record = Record.load_file RECORD_TEST
		num = record.record_of_level(1)
		assert_equal 456, num
	ensure
		FileUtils.remove_file(RECORD_TEST) if File.exist?(RECORD_TEST)
	end
	
end
