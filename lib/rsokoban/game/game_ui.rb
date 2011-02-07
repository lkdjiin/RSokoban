module RSokoban

	# @since 0.74.1
	module GameUI
		include Game
		
		def initialize ui, setname = 'microban.xsb'
			super(ui, setname)
		end
		
		# I am the game loop for UIs.
		def run
			player_action = start_level
			loop do
				if player_action.level_number?
					player_action = load_level player_action.action
					next
				elsif player_action.set_name?
					player_action = load_a_new_set player_action.action
					next
				elsif player_action.quit?
					break
				elsif player_action.next?
					player_action = next_level
					next
				elsif player_action.retry?
					player_action = start_level
					next
				elsif player_action.move?
					result = @level.move(player_action.action)
				elsif player_action.undo?
					result = @level.undo
				end
				
				if result[:status] == :win
					player_action = @ui.get_action(:type=>:win, :map=>@level.map, :move=>result[:move_number])
				elsif result[:status] == :ok
					player_action = @ui.get_action(:type=>:display, :map=>@level.map, :move=>result[:move_number])
				else
					player_action = @ui.get_action(:type=>:display, :map=>@level.map, :error=>result[:message])
				end
			end
			true
		end
		
		def start_level
			begin
				@level = @level_loader.level(@level_number)
				@ui.get_action(:type=>:start, :map=>@level.map, :title=>@level.title, :set=>@level_loader.title,
										:number=>@level_number, :total=>@level_loader.size)
			rescue LevelNumberTooHighError
				@ui.get_action(:type=>:end_of_set, :map=>Map.new)
			end
		end
		
		def load_a_new_set setname 
			begin
				super(setname)
				@ui.get_action(:type=>:start, :map=>@level.map, :title=>@level.title, :set=>@level_loader.title,
						:number=>@level_number, :total=>@level_loader.size)
			rescue NoFileError
				error = "Error, no such file : #{setname}"
				@ui.get_action(:type=>:start, :map=>@level.map, :title=>@level.title, :error=>error, :set=>@level_loader.title,
						:number=>@level_number, :total=>@level_loader.size)
			end
		end
		
	end

end
