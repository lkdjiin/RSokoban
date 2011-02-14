module RSokoban

	# I extends/implements the API of module Game, to run the game
	# in a console window. I don't define the user interface, you can use me
	# to run game with curses, n-curses, straight text-mode, etc.
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
				
				hash = {:map=>@level.map_as_array, :move=>result[:move_number]}
				case result[:status]
					when :win then player_action = @ui.get_action(hash.merge({:type=>:win}))
					when :ok then player_action = @ui.get_action(hash.merge({:type=>:display}))
					else
						player_action = @ui.get_action(:type=>:display, :map=>@level.map_as_array, :error=>result[:message])
				end
				
			end
			true
		end
		
		# @return [PlayerAction]
		def start_level
			begin
				@level = @level_loader.level(@level_number)
				@ui.get_action(:type=>:start, :map=>@level.map_as_array, :title=>@level.title, :set=>@level_loader.title,
										:number=>@level_number, :total=>@level_loader.size, :record => @level.record)
			rescue LevelNumberTooHighError
				@ui.get_action(:type=>:end_of_set, :map=>Map.new)
			end
		end
		
		def load_a_new_set setname 
			begin
				super(setname)
				@ui.get_action(get_hash_after_loading_set)
			rescue NoFileError
				error = "Error, no such file : #{setname}"
				@ui.get_action(get_hash_after_loading_set.merge({:error=>error}))
			end
		end
		
		private
		
		def get_hash_after_loading_set
			{:type=>:start, :map=>@level.map_as_array, :title=>@level.title, :set=>@level_loader.title,
						:number=>@level_number, :total=>@level_loader.size, :record => @level.record}
		end
		
	end

end
