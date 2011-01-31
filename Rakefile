desc 'Unit tests'
task :default => :unit

# Running RSokoban with the different (G)UIs

desc 'Run RSokoban with Tk GUI'
task :tk do
  exec "./bin/rsokoban --tk"
end

desc 'Run RSokoban with curses UI'
task :curses do
  exec "./bin/rsokoban --curses"
end
# Aliases to rake curses
task :curse => :curses
task :curs => :curses
task :cur => :curses

desc 'Run RSokoban in straight text mode'
task :portable do
  exec "./bin/rsokoban --portable"
end

# Testing RSokoban

desc 'Unit tests'
task :unit do 
	Dir.chdir 'test'
	exec "./test.rb"
end

# Documentation
desc 'Generate yard documentation'
task :doc do 
	exec 'yardoc --title "RSokoban Documentation" - NEWS COPYING VERSION'
end
