# -*- encoding: utf-8 -*-

require 'rake'

Gem::Specification.new do |s|
  s.name = 'RSokoban'
  s.version = File.read('VERSION').strip
  s.authors = ['Xavier Nayrac']
  s.email = 'xavier.nayrac@gmail.com'
  s.summary = 'Clone of the Sokoban game.'
  s.homepage = 'https://github.com/lkdjiin/RSokoban/wiki'
  s.description = %q{RSokoban is a clone of the famous Sokoban game.
I wrote this program just to improve my skills in Ruby.
Note: Never tested on windows...
Enjoy the game !}
	
	readmes = FileList.new('*') do |list|
		list.exclude(/(^|[^.a-z])[a-z]+/)
		list.exclude('TODO')
	end.to_a
  s.files = FileList['lib/**/*.rb', 'bin/*', 'data/*', 'skins/**/*', '[A-Z]*', 'test/**/*'].to_a + readmes
	s.executables = ['rsokoban']
	s.test_file  = 'test/test.rb'
	#s.license = 'GPL-3'
	s.required_ruby_version = '>= 1.8.7'
end
