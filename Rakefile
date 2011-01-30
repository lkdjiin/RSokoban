desc 'All tests'
task :default => :test

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

desc 'All tests'
task :test do 
	Dir.chdir 'test'
	exec "./test.rb"
end
