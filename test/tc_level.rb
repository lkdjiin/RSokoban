
class TC_Level < Test::Unit::TestCase

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
	          
	def test_instance
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal true, ins.instance_of?(RSokoban::Level), "Must be an instance of RSokoban::Level"
	end
	
	def test_floor_with_Text1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		expected = [ '#####',
            		 '#   #',
                 '#####']
		assert_equal expected, ins.floor
	end
	
	def test_floor_with_Text3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text3))
		expected = [ '####',
								 '#  #',
								 '#  #',
								 '#  #',
								 '####']
		assert_equal expected, ins.floor
	end
	
	def test_man_position
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal 3, ins.man.x
		assert_equal 1, ins.man.y
	end
	
	def test_crates_is_an_Array
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal true, ins.crates.instance_of?(Array), "Must be an Array"
	end
	
	def test_crates_with_Text1_must_be_of_size_1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal 1, ins.crates.size
	end
	
	def test_crates_contains_some_crate
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal true, ins.crates[0].instance_of?(RSokoban::Crate)
	end
	
	def test_crates_with_Text2_must_be_of_size_3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text2))
		assert_equal 3, ins.crates.size
	end
	
	def test_crates_positions
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text2))
		assert_equal 2, ins.crates[0].x
		assert_equal 1, ins.crates[0].y
		
		assert_equal 2, ins.crates[1].x
		assert_equal 2, ins.crates[1].y
		
		assert_equal 2, ins.crates[2].x
		assert_equal 3, ins.crates[2].y
	end
	
	def test_several_crates_on_a_line
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text3))
		assert_equal 1, ins.crates[0].x
		assert_equal 2, ins.crates[0].y
		
		assert_equal 2, ins.crates[1].x
		assert_equal 2, ins.crates[1].y
	end
	
	def test_storages
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal true, ins.storages.instance_of?(Array), "Must be an Array"
	end
	
	def test_storages_with_Text1_must_be_of_size_1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal 1, ins.storages.size
	end
	
	def test_storages_with_Text2_must_be_of_size_3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text2))
		assert_equal 3, ins.storages.size
	end
	
	def test_storages_contains_some_storage
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text1))
		assert_equal true, ins.storages[0].instance_of?(RSokoban::Storage)
	end
	
	def test_storages_positions
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text2))
		assert_equal 1, ins.storages[0].x
		assert_equal 1, ins.storages[0].y
		
		assert_equal 1, ins.storages[1].x
		assert_equal 2, ins.storages[1].y
		
		assert_equal 1, ins.storages[2].x
		assert_equal 3, ins.storages[2].y
	end
	
	def test_several_storages_on_a_line
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text3))
		assert_equal 1, ins.storages[0].x
		assert_equal 1, ins.storages[0].y
		
		assert_equal 2, ins.storages[1].x
		assert_equal 1, ins.storages[1].y
	end
	
	def test_equality
		ins1 = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text3))
		ins2 = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text3))
		assert ins1 == ins2
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Level1))
		assert_equal Level1, ins.picture
	end
	
	Level1_u = ['    #####',
'    #   #',
'    #$  #',
'  ###  $##',
'  #  $ $ #',
'### # ## #   ######',
'#   # ## #####  ..#',
'# $  $     @    ..#',
'##### ### # ##  ..#',
'    #     #########',
'    #######']

	def test_rawLevel_after_move_up
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Level1))
		ins.move :up
		assert_equal Level1_u, ins.picture
	end
	
	Text4 = [ '####',
	          '#.*#',
	          '#$ #',
	          '#@ #',
	          '####']
	
	def test_crate_on_storage_at_startup
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Text4))
		assert_equal 'WIN move 1', ins.move(:up)
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp1))
		assert_equal 'OK move 1', ins.moveUp
		assert_equal 1, ins.man.x
		assert_equal 1, ins.man.y
	end
	
	def test_AfterMoveUp1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp1))
		ins.moveUp
		assert_equal AfterMoveUp1, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp2))
		assert_equal 'OK move 1', ins.moveUp
		assert_equal 1, ins.man.x
		assert_equal 1, ins.man.y
	end
	
	def test_AfterMoveUp2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp2))
		ins.moveUp
		assert_equal AfterMoveUp2, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp3))
		assert_equal 'OK move 1', ins.moveUp
		assert_equal 1, ins.man.x
		assert_equal 2, ins.man.y
	end
	
	def test_AfterMoveUp3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp3))
		ins.moveUp
		assert_equal AfterMoveUp3, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp4))
		assert_equal 'WIN move 1', ins.moveUp
		assert_equal 1, ins.man.x
		assert_equal 2, ins.man.y
	end
	
	def test_AfterMoveUp4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveUp4))
		ins.moveUp
		assert_equal AfterMoveUp4, ins.picture
	end
	
	CannotMoveUp1 = ['###',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUp1))
		assert_equal 'ERROR wall', ins.moveUp
		assert_equal CannotMoveUp1, ins.picture
	end
	
	CannotMoveUp2 = ['###',
									 '#$#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUp2))
		assert_equal 'ERROR wall behind crate', ins.moveUp
		assert_equal CannotMoveUp2, ins.picture
	end
	
	CannotMoveUp3 = ['###',
									 '# #',
									 '#$#',
									 '#$#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUp3))
		assert_equal 'ERROR double crate', ins.moveUp
		assert_equal CannotMoveUp3, ins.picture
	end
	
	CannotMoveUp4 = ['###',
									 '# #',
									 '#*#',
									 '#$#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUp4))
		assert_equal 'ERROR double crate', ins.moveUp
		assert_equal CannotMoveUp4, ins.picture
	end
	
	CannotMoveUp5 = ['###',
									 '# #',
									 '#$#',
									 '#*#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp5
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUp5))
		assert_equal 'ERROR double crate', ins.moveUp
		assert_equal CannotMoveUp5, ins.picture
	end
	
	CannotMoveUp6 = ['###',
									 '# #',
									 '#*#',
									 '#*#',
									 '#@#',
									 '###']
	
	def test_CannotMoveUp6
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUp6))
		assert_equal 'ERROR double crate', ins.moveUp
		assert_equal CannotMoveUp6, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown1))
		assert_equal 'OK move 1', ins.moveDown
	end
	
	def test_AfterMoveDown1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown1))
		ins.moveDown
		assert_equal AfterMoveDown1, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown2))
		assert_equal 'OK move 1', ins.moveDown
	end
	
	def test_AfterMoveDown2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown2))
		ins.moveDown
		assert_equal AfterMoveDown2, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown3))
		assert_equal 'OK move 1', ins.moveDown
	end
	
	def test_AfterMoveDown3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown3))
		ins.moveDown
		assert_equal AfterMoveDown3, ins.picture
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
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown4))
		assert_equal 'WIN move 1', ins.moveDown
	end
	
	def test_AfterMoveDown4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveDown4))
		ins.moveDown
		assert_equal AfterMoveDown4, ins.picture
	end
	
	CannotMoveDown1 = ['###',
										 '#@#',
										 '###']
	
	def test_CannotMoveDown1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveDown1))
		assert_equal 'ERROR wall', ins.moveDown
		assert_equal CannotMoveDown1, ins.picture
	end
	
	CannotMoveDown2 = ['###',
										 '#@#',
										 '#$#',
										 '###']
	
	def test_CannotMoveDown2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveDown2))
		assert_equal 'ERROR wall behind crate', ins.moveDown
		assert_equal CannotMoveDown2, ins.picture
	end
	
	CannotMoveDown3 = ['###',
										 '#@#',
										 '#$#',
										 '#$#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveDown3))
		assert_equal 'ERROR double crate', ins.moveDown
		assert_equal CannotMoveDown3, ins.picture
	end
	
	CannotMoveDown4 = ['###',
										 '#@#',
										 '#$#',
										 '#*#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveDown4))
		assert_equal 'ERROR double crate', ins.moveDown
		assert_equal CannotMoveDown4, ins.picture
	end
	
	CannotMoveDown5 = ['###',
										 '#@#',
										 '#*#',
										 '#$#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown5
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveDown5))
		assert_equal 'ERROR double crate', ins.moveDown
		assert_equal CannotMoveDown5, ins.picture
	end
	
	CannotMoveDown6 = ['###',
										 '#@#',
										 '#*#',
										 '#*#',
										 '# #',
										 '###']
	
	def test_CannotMoveDown6
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveDown6))
		assert_equal 'ERROR double crate', ins.moveDown
		assert_equal CannotMoveDown6, ins.picture
	end
	
	### Move left ##############################################
	
	CanMoveLeft1 = ['####',
									'# @#',
									'####']
	              
	AfterMoveLeft1 = ['####',
										'#@ #',
										'####']
	               
	def test_CanMoveLeft1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft1))
		assert_equal 'OK move 1', ins.moveLeft
	end
	
	def test_AfterMoveLeft1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft1))
		ins.moveLeft
		assert_equal AfterMoveLeft1, ins.picture
	end
	
	CanMoveLeft2 = ['####',
									'#.@#',
									'####']
	              
	AfterMoveLeft2 = ['####',
									  '#+ #',
									  '####']
	              
	def test_CanMoveLeft2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft2))
		assert_equal 'OK move 1', ins.moveLeft
	end
	
	def test_AfterMoveLeft2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft2))
		ins.moveLeft
		assert_equal AfterMoveLeft2, ins.picture
	end
	
	CanMoveLeft3 = ['#####',
									'# $@#',
									'#####']
	
	AfterMoveLeft3 = ['#####',
									  '#$@ #',
									  '#####']
	
	def test_CanMoveLeft3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft3))
		assert_equal 'OK move 1', ins.moveLeft
	end
	
	def test_AfterMoveLeft3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft3))
		ins.moveLeft
		assert_equal AfterMoveLeft3, ins.picture
	end
	
	CanMoveLeft4 = ['#####',
									'#.$@#',
									'#####']
	
	AfterMoveLeft4 = ['#####',
										'#*@ #',
										'#####']
	              
	def test_CanMoveLeft4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft4))
		assert_equal 'WIN move 1', ins.moveLeft
	end
	
	def test_AfterMoveLeft4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveLeft4))
		ins.moveLeft
		assert_equal AfterMoveLeft4, ins.picture
	end
	
	CannotMoveLeft1 = ['###',
										 '#@#',
										 '###']
	
	def test_CannotMoveLeft1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveLeft1))
		assert_equal 'ERROR wall', ins.moveLeft
		assert_equal CannotMoveLeft1, ins.picture
	end
	
	CannotMoveLeft2 = ['####',
										 '#$@#',
										 '####']
	
	def test_CannotMoveLeft2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveLeft2))
		assert_equal 'ERROR wall behind crate', ins.moveLeft
		assert_equal CannotMoveLeft2, ins.picture
	end
	
	CannotMoveLeft3 = ['######',
										 '# $$@#',
										 '######']
	
	def test_CannotMoveLeft3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveLeft3))
		assert_equal 'ERROR double crate', ins.moveLeft
		assert_equal CannotMoveLeft3, ins.picture
	end
	
	### Move right ##############################################
	
	CanMoveRight1 = ['####',
							 		 '#@ #',
									 '####']
	              
	AfterMoveRight1 = ['####',
										 '# @#',
										 '####']
	               
	def test_CanMoveRight1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight1))
		assert_equal 'OK move 1', ins.moveRight
	end
	
	def test_AfterMoveRight1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight1))
		ins.moveRight
		assert_equal AfterMoveRight1, ins.picture
	end
	
	CanMoveRight2 = ['####',
									 '#@.#',
									 '####']
	              
	AfterMoveRight2 = ['####',
									   '# +#',
									   '####']
	              
	def test_CanMoveRight2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight2))
		assert_equal 'OK move 1', ins.moveRight
	end
	
	def test_AfterMoveRight2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight2))
		ins.moveRight
		assert_equal AfterMoveRight2, ins.picture
	end
	
	CanMoveRight3 = ['#####',
									 '#@$ #',
									 '#####']
	
	AfterMoveRight3 = ['#####',
									   '# @$#',
									   '#####']
	
	def test_CanMoveRight3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight3))
		assert_equal 'OK move 1', ins.moveRight
	end
	
	def test_AfterMoveRight3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight3))
		ins.moveRight
		assert_equal AfterMoveRight3, ins.picture
	end
	
	CanMoveRight4 = ['#####',
									 '#@$.#',
									 '#####']
	
	AfterMoveRight4 = ['#####',
										 '# @*#',
										 '#####']
	              
	def test_CanMoveRight4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight4))
		assert_equal 'WIN move 1', ins.moveRight
	end
	
	def test_AfterMoveRight4
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CanMoveRight4))
		ins.moveRight
		assert_equal AfterMoveRight4, ins.picture
	end
	
	CannotMoveRight1 = ['###',
										 '#@#',
										 '###']
	
	def test_CannotMoveRight1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveRight1))
		assert_equal 'ERROR wall', ins.moveRight
		assert_equal CannotMoveRight1, ins.picture
	end
	
	CannotMoveRight2 = ['####',
										  '#@$#',
										  '####']
	
	def test_CannotMoveRight2
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveRight2))
		assert_equal 'ERROR wall behind crate', ins.moveRight
		assert_equal CannotMoveRight2, ins.picture
	end
	
	CannotMoveRight3 = ['######',
										  '#@$$ #',
										  '######']
	
	def test_CannotMoveRight3
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveRight3))
		assert_equal 'ERROR double crate', ins.moveRight
		assert_equal CannotMoveRight3, ins.picture
	end
	
	### WIN ########################################################
	
	Win1 = ['#####',
	        '#@$.#',
	        '#####']
	
	def test_solution_avec_une_seule_caisse
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', Win1))
		assert_equal 'WIN move 1', ins.moveRight
	end
	
	### BUG 1 #######################################
	
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
	
	def test_bug_1
		ins = RSokoban::Level.new(RSokoban::RawLevel.new('1', CannotMoveUpBug1))
		# Changing 'o' to '*'
		def ins.addStorage
			@storages.push RSokoban::Storage.new(1, 1)
		end
		ins.addStorage
		
		# I need to be sure that coord 1, 1 is '*'
		assert_equal '#*#', ins.picture[1]
		
		assert_equal 'ERROR wall behind crate', ins.moveUp
	end
end
