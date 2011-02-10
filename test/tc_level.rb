
class TC_Level < Test::Unit::TestCase
	include RSokoban

	Text1 = [ '#####',
            '#.$@#',
            '#####']
  
  Text2 = [ '######',
						'#.$  #',
						'#.$  #',
						'#.$ @#',
						'######']
						
	Text3 = [ '####',
	          '#..#',
	          '#$$#',
	          '#@ #',
	          '####']
	
	def setup
		@text_1 = Level.new(RawLevel.new('1', Text1))
		@text_2 = Level.new(RawLevel.new('1', Text2))
		@text_3 = Level.new(RawLevel.new('1', Text3))
		@original_1 = Level.new(RawLevel.new('1', Level1))
	end
	
	def test_instance
		assert_equal true, @text_1.instance_of?(Level), "Must be an instance of Level"
	end
	
	def test_move_number
		assert_equal 0, @text_1.move_number
	end
	
	def test_floor_with_Text1
		expected = [ '#####',
            		 '#   #',
                 '#####']
		assert_equal expected, @text_1.floor
	end
	
	def test_floor_with_Text3
		expected = [ '####',
								 '#  #',
								 '#  #',
								 '#  #',
								 '####']
		assert_equal expected, @text_3.floor
	end
	
	def test_man_position
		assert_equal 3, @text_1.man.x
		assert_equal 1, @text_1.man.y
	end
	
	def test_crates_is_an_Array
		assert_equal true, @text_1.crates.instance_of?(Array), "Must be an Array"
	end
	
	def test_crates_with_Text1_must_be_of_size_1
		assert_equal 1, @text_1.crates.size
	end
	
	def test_crates_contains_some_crate
		assert_equal true, @text_1.crates[0].instance_of?(Crate)
	end
	
	def test_crates_with_Text2_must_be_of_size_3
		assert_equal 3, @text_2.crates.size
	end
	
	def test_crates_positions
		assert_equal 2, @text_2.crates[0].x
		assert_equal 1, @text_2.crates[0].y
		
		assert_equal 2, @text_2.crates[1].x
		assert_equal 2, @text_2.crates[1].y
		
		assert_equal 2, @text_2.crates[2].x
		assert_equal 3, @text_2.crates[2].y
	end
	
	def test_several_crates_on_a_line
		assert_equal 1, @text_3.crates[0].x
		assert_equal 2, @text_3.crates[0].y
		
		assert_equal 2, @text_3.crates[1].x
		assert_equal 2, @text_3.crates[1].y
	end
	
	def test_storages
		assert_equal true, @text_1.storages.instance_of?(Array), "Must be an Array"
	end
	
	def test_storages_with_Text1_must_be_of_size_1
		assert_equal 1, @text_1.storages.size
	end
	
	def test_storages_with_Text2_must_be_of_size_3
		assert_equal 3, @text_2.storages.size
	end
	
	def test_storages_contains_some_storage
		assert_equal true, @text_1.storages[0].instance_of?(Storage)
	end
	
	def test_storages_positions
		assert_equal 1, @text_2.storages[0].x
		assert_equal 1, @text_2.storages[0].y
		
		assert_equal 1, @text_2.storages[1].x
		assert_equal 2, @text_2.storages[1].y
		
		assert_equal 1, @text_2.storages[2].x
		assert_equal 3, @text_2.storages[2].y
	end
	
	def test_several_storages_on_a_line
		assert_equal 1, @text_3.storages[0].x
		assert_equal 1, @text_3.storages[0].y
		
		assert_equal 2, @text_3.storages[1].x
		assert_equal 1, @text_3.storages[1].y
	end
	
	def test_equality
		ins = Level.new(RawLevel.new('1', Text3))
		assert ins == @text_3
	end
	
	Level1 = ['    #####',
'    #   #',
'    #$  #',
'  ###  $##',
'  #  $ $ #',
'### # ## #   ######',
'#   # ## #####  ..#',
'# $  $          ..#',
'##### ### #@##  ..#',
'    #     #########',
'    #######']

	def test_rawLevel
		assert_equal Level1, @original_1.map_as_array
	end
	
	def test_width
		assert_equal 19, @original_1.width
	end
	
	def test_height
		assert_equal 11, @original_1.height
	end
	
	Level1_u = [
'oooo#####oooooooooo',
'oooo#   #oooooooooo',
'oooo#$  #oooooooooo',
'oo###  $##ooooooooo',
'oo#  $ $ #ooooooooo',
'### # ## #ooo######',
'#   # ## #####  ..#',
'# $  $     @    ..#',
'##### ### # ##  ..#',
'oooo#     #########',
'oooo#######oooooooo']

	def test_rawLevel_after_move_up
		ins = @original_1
		ins.move(:up)
		assert_equal Level1_u, ins.map_as_array
	end
	
	Text4 = [ '####',
	          '#.*#',
	          '#$ #',
	          '#@ #',
	          '####']
	
	def test_crate_on_storage_at_startup
		ins = Level.new(RawLevel.new('1', Text4))
		result = ins.move(:up)
		assert_equal :win, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	### Move up ##############################################
	
	CanMoveUp1 = ['###',
	              '# #',
	              '#@#',
	              '###']
	              
	AfterMoveUp1 = ['###',
									'#@#',
									'# #',
									'###']
	               
	def test_CanMoveUp1
		ins = Level.new(RawLevel.new('1', CanMoveUp1))
		result = ins.move(:up)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
		assert_equal 1, ins.man.x
		assert_equal 1, ins.man.y
	end
	
	def test_AfterMoveUp1
		ins = Level.new(RawLevel.new('1', CanMoveUp1))
		ins.move(:up)
		assert_equal AfterMoveUp1, ins.map_as_array
	end
	
	CanMoveUp2 = ['###',
	              '#.#',
	              '#@#',
	              '###']
	              
	AfterMoveUp2 = ['###',
									'#+#',
									'# #',
									'###']
	              
	def test_CanMoveUp2
		ins = Level.new(RawLevel.new('1', CanMoveUp2))
		result = ins.move(:up)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
		assert_equal 1, ins.man.x
		assert_equal 1, ins.man.y
	end
	
	def test_AfterMoveUp2
		ins = Level.new(RawLevel.new('1', CanMoveUp2))
		ins.move(:up)
		assert_equal AfterMoveUp2, ins.map_as_array
	end
	
	CanMoveUp3 = ['###',
	              '# #',
	              '#$#',
	              '#@#',
	              '###'] 
	
	AfterMoveUp3 = ['###',
									'#$#',
									'#@#',
									'# #',
									'###'] 
	
	def test_CanMoveUp3
		ins = Level.new(RawLevel.new('1', CanMoveUp3))
		result = ins.move(:up)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
		assert_equal 1, ins.man.x
		assert_equal 2, ins.man.y
	end
	
	def test_AfterMoveUp3
		ins = Level.new(RawLevel.new('1', CanMoveUp3))
		ins.move(:up)
		assert_equal AfterMoveUp3, ins.map_as_array
	end
	
	CanMoveUp4 = ['###',
	              '#.#',
	              '#$#',
	              '#@#',
	              '###']
	
	AfterMoveUp4 = ['###',
									'#*#',
									'#@#',
									'# #',
									'###']
	              
	def test_CanMoveUp4
		ins = Level.new(RawLevel.new('1', CanMoveUp4))
		result = ins.move(:up)
		assert_equal :win, result[:status]
		assert_equal 1, result[:move_number]
		assert_equal 1, ins.man.x
		assert_equal 2, ins.man.y
	end
	
	def test_AfterMoveUp4
		ins = Level.new(RawLevel.new('1', CanMoveUp4))
		ins.move(:up)
		assert_equal AfterMoveUp4, ins.map_as_array
	end
	
	CannotMoveUp1 = ['###',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp1
		ins = Level.new(RawLevel.new('1', CannotMoveUp1))
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'wall', result[:message]
		assert_equal CannotMoveUp1, ins.map_as_array
	end
	
	CannotMoveUp2 = ['###',
									 '#$#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp2
		ins = Level.new(RawLevel.new('1', CannotMoveUp2))
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'wall behind crate', result[:message]
		assert_equal CannotMoveUp2, ins.map_as_array
	end
	
	CannotMoveUp3 = ['###',
									 '# #',
									 '#$#',
									 '#$#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp3
		ins = Level.new(RawLevel.new('1', CannotMoveUp3))
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveUp3, ins.map_as_array
	end
	
	CannotMoveUp4 = ['###',
									 '# #',
									 '#*#',
									 '#$#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp4
		ins = Level.new(RawLevel.new('1', CannotMoveUp4))
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveUp4, ins.map_as_array
	end
	
	CannotMoveUp5 = ['###',
									 '# #',
									 '#$#',
									 '#*#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp5
		ins = Level.new(RawLevel.new('1', CannotMoveUp5))
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveUp5, ins.map_as_array
	end
	
	CannotMoveUp6 = ['###',
									 '# #',
									 '#*#',
									 '#*#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp6
		ins = Level.new(RawLevel.new('1', CannotMoveUp6))
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveUp6, ins.map_as_array
	end
	
	### Move down ##############################################
	
	CanMoveDown1 = ['###',
									'#@#',
									'# #',
									'###']
	              
	AfterMoveDown1 = ['###',
										'# #',
										'#@#',
										'###']
	               
	def test_CanMoveDown1
		ins = Level.new(RawLevel.new('1', CanMoveDown1))
		result = ins.move(:down)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveDown1
		ins = Level.new(RawLevel.new('1', CanMoveDown1))
		ins.move(:down)
		assert_equal AfterMoveDown1, ins.map_as_array
	end
	
	CanMoveDown2 = ['###',
									'#@#',
									'#.#',
									'###']
	              
	AfterMoveDown2 = ['###',
										'# #',
										'#+#',
										'###']
	              
	def test_CanMoveDown2
		ins = Level.new(RawLevel.new('1', CanMoveDown2))
		result = ins.move(:down)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveDown2
		ins = Level.new(RawLevel.new('1', CanMoveDown2))
		ins.move(:down)
		assert_equal AfterMoveDown2, ins.map_as_array
	end
	
	CanMoveDown3 = ['###',
									'#@#',
									'#$#',
									'# #',
									'###'] 
	
	AfterMoveDown3 = ['###',
										'# #',
										'#@#',
										'#$#',
										'###'] 
	
	def test_CanMoveDown3
		ins = Level.new(RawLevel.new('1', CanMoveDown3))
		result = ins.move(:down)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveDown3
		ins = Level.new(RawLevel.new('1', CanMoveDown3))
		ins.move(:down)
		assert_equal AfterMoveDown3, ins.map_as_array
	end
	
	CanMoveDown4 = ['###',
									'#@#',
									'#$#',
									'#.#',
									'###']
	
	AfterMoveDown4 = ['###',
										'# #',
										'#@#',
										'#*#',
										'###']
	              
	def test_CanMoveDown4
		ins = Level.new(RawLevel.new('1', CanMoveDown4))
		result = ins.move(:down)
		assert_equal :win, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveDown4
		ins = Level.new(RawLevel.new('1', CanMoveDown4))
		ins.move(:down)
		assert_equal AfterMoveDown4, ins.map_as_array
	end
	
	CannotMoveDown1 = ['###',
										 '#@#',
										 '###']
	
	def test_CannotMoveDown1
		ins = Level.new(RawLevel.new('1', CannotMoveDown1))
		result = ins.move(:down)
		assert_equal :error, result[:status]
		assert_equal 'wall', result[:message]
		assert_equal CannotMoveDown1, ins.map_as_array
	end
	
	CannotMoveDown2 = ['###',
										 '#@#',
										 '#$#',
										 '###']
	
	def test_CannotMoveDown2
		ins = Level.new(RawLevel.new('1', CannotMoveDown2))
		result = ins.move(:down)
		assert_equal :error, result[:status]
		assert_equal 'wall behind crate', result[:message]
		assert_equal CannotMoveDown2, ins.map_as_array
	end
	
	CannotMoveDown3 = ['###',
										 '#@#',
										 '#$#',
										 '#$#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown3
		ins = Level.new(RawLevel.new('1', CannotMoveDown3))
		result = ins.move(:down)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveDown3, ins.map_as_array
	end
	
	CannotMoveDown4 = ['###',
										 '#@#',
										 '#$#',
										 '#*#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown4
		ins = Level.new(RawLevel.new('1', CannotMoveDown4))
		result = ins.move(:down)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveDown4, ins.map_as_array
	end
	
	CannotMoveDown5 = ['###',
										 '#@#',
										 '#*#',
										 '#$#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown5
		ins = Level.new(RawLevel.new('1', CannotMoveDown5))
		result = ins.move(:down)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveDown5, ins.map_as_array
	end
	
	CannotMoveDown6 = ['###',
										 '#@#',
										 '#*#',
										 '#*#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown6
		ins = Level.new(RawLevel.new('1', CannotMoveDown6))
		result = ins.move(:down)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveDown6, ins.map_as_array
	end
	
	### Move left ##############################################
	
	CanMoveLeft1 = ['####',
									'# @#',
									'####']
	              
	AfterMoveLeft1 = ['####',
										'#@ #',
										'####']
	               
	def test_CanMoveLeft1
		ins = Level.new(RawLevel.new('1', CanMoveLeft1))
		result = ins.move(:left)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveLeft1
		ins = Level.new(RawLevel.new('1', CanMoveLeft1))
		ins.move(:left)
		assert_equal AfterMoveLeft1, ins.map_as_array
	end
	
	CanMoveLeft2 = ['####',
									'#.@#',
									'####']
	              
	AfterMoveLeft2 = ['####',
									  '#+ #',
									  '####']
	              
	def test_CanMoveLeft2
		ins = Level.new(RawLevel.new('1', CanMoveLeft2))
		result = ins.move(:left)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveLeft2
		ins = Level.new(RawLevel.new('1', CanMoveLeft2))
		ins.move(:left)
		assert_equal AfterMoveLeft2, ins.map_as_array
	end
	
	CanMoveLeft3 = ['#####',
									'# $@#',
									'#####']
	
	AfterMoveLeft3 = ['#####',
									  '#$@ #',
									  '#####']
	
	def test_CanMoveLeft3
		ins = Level.new(RawLevel.new('1', CanMoveLeft3))
		result = ins.move(:left)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveLeft3
		ins = Level.new(RawLevel.new('1', CanMoveLeft3))
		ins.move(:left)
		assert_equal AfterMoveLeft3, ins.map_as_array
	end
	
	CanMoveLeft4 = ['#####',
									'#.$@#',
									'#####']
	
	AfterMoveLeft4 = ['#####',
										'#*@ #',
										'#####']
	              
	def test_CanMoveLeft4
		ins = Level.new(RawLevel.new('1', CanMoveLeft4))
		result = ins.move(:left)
		assert_equal :win, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveLeft4
		ins = Level.new(RawLevel.new('1', CanMoveLeft4))
		ins.move(:left)
		assert_equal AfterMoveLeft4, ins.map_as_array
	end
	
	CannotMoveLeft1 = ['###',
										 '#@#',
										 '###']
	
	def test_CannotMoveLeft1
		ins = Level.new(RawLevel.new('1', CannotMoveLeft1))
		result = ins.move(:left)
		assert_equal :error, result[:status]
		assert_equal 'wall', result[:message]
		assert_equal CannotMoveLeft1, ins.map_as_array
	end
	
	CannotMoveLeft2 = ['####',
										 '#$@#',
										 '####']
	
	def test_CannotMoveLeft2
		ins = Level.new(RawLevel.new('1', CannotMoveLeft2))
		result = ins.move(:left)
		assert_equal :error, result[:status]
		assert_equal 'wall behind crate', result[:message]
		assert_equal CannotMoveLeft2, ins.map_as_array
	end
	
	CannotMoveLeft3 = ['######',
										 '# $$@#',
										 '######']
	
	def test_CannotMoveLeft3
		ins = Level.new(RawLevel.new('1', CannotMoveLeft3))
		result = ins.move(:left)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveLeft3, ins.map_as_array
	end
	
	### Move right ##############################################
	
	CanMoveRight1 = ['####',
							 		 '#@ #',
									 '####']
	              
	AfterMoveRight1 = ['####',
										 '# @#',
										 '####']
	               
	def test_CanMoveRight1
		ins = Level.new(RawLevel.new('1', CanMoveRight1))
		result = ins.move(:right)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveRight1
		ins = Level.new(RawLevel.new('1', CanMoveRight1))
		ins.move(:right)
		assert_equal AfterMoveRight1, ins.map_as_array
	end
	
	CanMoveRight2 = ['####',
									 '#@.#',
									 '####']
	              
	AfterMoveRight2 = ['####',
									   '# +#',
									   '####']
	              
	def test_CanMoveRight2
		ins = Level.new(RawLevel.new('1', CanMoveRight2))
		result = ins.move(:right)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveRight2
		ins = Level.new(RawLevel.new('1', CanMoveRight2))
		ins.move(:right)
		assert_equal AfterMoveRight2, ins.map_as_array
	end
	
	CanMoveRight3 = ['#####',
									 '#@$ #',
									 '#####']
	
	AfterMoveRight3 = ['#####',
									   '# @$#',
									   '#####']
	
	def test_CanMoveRight3
		ins = Level.new(RawLevel.new('1', CanMoveRight3))
		result = ins.move(:right)
		assert_equal :ok, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveRight3
		ins = Level.new(RawLevel.new('1', CanMoveRight3))
		ins.move(:right)
		assert_equal AfterMoveRight3, ins.map_as_array
	end
	
	CanMoveRight4 = ['#####',
									 '#@$.#',
									 '#####']
	
	AfterMoveRight4 = ['#####',
										 '# @*#',
										 '#####']
	              
	def test_CanMoveRight4
		ins = Level.new(RawLevel.new('1', CanMoveRight4))
		result = ins.move(:right)
		assert_equal :win, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	def test_AfterMoveRight4
		ins = Level.new(RawLevel.new('1', CanMoveRight4))
		ins.move(:right)
		assert_equal AfterMoveRight4, ins.map_as_array
	end
	
	CannotMoveRight1 = ['###',
										 '#@#',
										 '###']
	
	def test_CannotMoveRight1
		ins = Level.new(RawLevel.new('1', CannotMoveRight1))
		result = ins.move(:right)
		assert_equal :error, result[:status]
		assert_equal 'wall', result[:message]
		assert_equal CannotMoveRight1, ins.map_as_array
	end
	
	CannotMoveRight2 = ['####',
										  '#@$#',
										  '####']
	
	def test_CannotMoveRight2
		ins = Level.new(RawLevel.new('1', CannotMoveRight2))
		result = ins.move(:right)
		assert_equal :error, result[:status]
		assert_equal 'wall behind crate', result[:message]
		assert_equal CannotMoveRight2, ins.map_as_array
	end
	
	CannotMoveRight3 = ['######',
										  '#@$$ #',
										  '######']
	
	def test_CannotMoveRight3
		ins = Level.new(RawLevel.new('1', CannotMoveRight3))
		result = ins.move(:right)
		assert_equal :error, result[:status]
		assert_equal 'double crate', result[:message]
		assert_equal CannotMoveRight3, ins.map_as_array
	end
	
	### WIN ########################################################
	
	Win1 = ['#####',
	        '#@$.#',
	        '#####']
	
	def test_solution_avec_une_seule_caisse
		ins = Level.new(RawLevel.new('1', Win1))
		result = ins.move(:right)
		assert_equal :win, result[:status]
		assert_equal 1, result[:move_number]
	end
	
	### BUGS #######################################
	
	# I need a 'crate on storage' in 1, 1. But Level#new don't know how to parse this.
	# This is the picture I really want to test :
	# ###
	# #*#
	# #@#
	# ###
	CannotMoveUpBug1 = ['###',
										  '#$#',
										  '#@#',
										  '# #',
										  '#$#',
										  '#.#',
										  '###']
	
	def test_bug_first
		ins = Level.new(RawLevel.new('1', CannotMoveUpBug1))
		# Changing 'o' to '*'
		def ins.addStorage
			@layered_map.storages.push Storage.new(1, 1)
		end
		ins.addStorage
		
		# I need to be sure that coord 1, 1 is '*'
		assert_equal '#*#', ins.map_as_array[1]
		
		result = ins.move(:up)
		assert_equal :error, result[:status]
		assert_equal 'wall behind crate', result[:message]
	end
end
