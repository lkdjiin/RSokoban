class TC_Install< Test::Unit::TestCase
	include RSokoban
	
	def test_create_folder
		Install.create_folder 'temp/record'
		assert File.exist? 'temp/record'
		assert File.directory? 'temp/record'
	ensure
		FileUtils.remove_dir('temp') if File.exist?('temp')
	end
	
end
