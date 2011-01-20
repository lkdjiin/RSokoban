module RSokoban

	# Je suis un niveau du jeu.
	# Pour réussir un niveau, placer chaque caisses ('$') sur un emplacement
	# de stockage ('.').
	class Level
		attr_reader :floor, :man, :crates, :storages, :title
		
		# Je construit le niveau à partir d'un format brut.
		# @example un niveau en format brut
		#	  'Level 1', ['#####', '#.o@#', '#####']
		# 
		# * '#' est un mur
		# * '.' est un emplacement de stockage
		# * '$' est une caisse
		# * '@' est le bonhomme
		# * ' ' est un bout de sol vide
		#
		# @param [RawLevel] rawLevel le niveau en format brut
		def initialize rawLevel
			@title = rawLevel.title
			@floor = init_floor rawLevel.picture
			@man = init_man rawLevel.picture
			
			@crates = []
			@storages = []
			init_crates_and_storages rawLevel.picture
			
			@move = 0
			@picture = nil
		end
		
		# Two Level objects are equals if their @floor, @man, @crates and @storages are equals.
		# @param [Object] obj
		# @return [false|true]
		def ==(obj)
			return false unless obj.kind_of?(Level)
			@floor == obj.floor and @man == obj.man and @crates == obj.crates and @storages == obj.storages and @title == obj.title
		end
		
		# Synonym of #==
		# @see #==
		def eql?(obj)
			self == obj
		end
		
		# @return [Array<String>] le niveau, en format brut, après les X tours de jeu
		def picture
			@picture = init_floor @floor
			draw_crates
			draw_storages
			draw_man
			@picture
		end
		
		# Bouge le bonhomme une case vers le haut.
		# @return [String] le résultat du coup
		#   ["ERROR wall"] si le joueur est stoppé par un mur
		#   ['ERROR wall behind crate'] si le joueur est stoppé par une caisse suivie d'un mur
		#   ['ERROR double crate'] si le joueur est stoppé par deux caisses qui se suivent
		#   ['OK move ?'] si le coup est accepté (? est remplacé par le numéro du coup)
		#   ['WIN move ?'] si le jeu est gagné (? est remplacé par le numéro du coup)
		def moveUp
			move :up
		end
		
		# Bouge le bonhomme une case vers le bas.
		# @see #moveUp pour plus d'explications
		def moveDown
			move :down
		end
		
		# Bouge le bonhomme une case vers la gauche.
		# @see #moveUp pour plus d'explications
		def moveLeft
			move :left
		end
		
		# Bouge le bonhomme une case vers la droite.
		# @see #moveUp pour plus d'explications
		def moveRight
			move :right
		end
		
		# Bouge le bonhomme une case vers +direction+.
		# @see #moveUp pour plus d'explications
		def move direction
			return 'ERROR wall' if wall?(direction)
			return 'ERROR wall behind crate' if wall_behind_crate?(direction)
			return 'ERROR double crate' if double_crate?(direction)
			@move += 1
			@man.send(direction)
			if @crates.include?(Crate.new(@man.x, @man.y))
				i = @crates.index(Crate.new(@man.x, @man.y))
				@crates[i].send(direction)
			end
			return "WIN move #{@move}" if win?
			"OK move #{@move}"
		end
		
		private
		
		# @return true if all crates are on a storage
		def win?
			return false if @crates.size == 0 # needed for testing purpose.
			@crates.each {|c|
				return false unless @storages.include?(c)
			}
			true
		end
		
		# Is there a wall near the man, in the direction pointed by +direction+ ?
		# @param [:up|:down|:left|:right]
		# @return [true|false]
		def wall? direction
			case direction
				when :up
					box = what_is_on(@man.x, @man.y-1)
				when :down
					box = what_is_on(@man.x, @man.y+1)
				when :left
					box = what_is_on(@man.x-1, @man.y)
				when :right
					box = what_is_on(@man.x+1, @man.y)
			end
			return(box == WALL)
		end
		
		def wall_behind_crate?(direction)
			case direction
				when :up
					near = crate?(@man.x, @man.y-1)
					boxBehind = what_is_on(@man.x, @man.y-2)
				when :down
					near = crate?(@man.x, @man.y+1)
					boxBehind = what_is_on(@man.x, @man.y+2)
				when :left
					near = crate?(@man.x-1, @man.y)
					boxBehind = what_is_on(@man.x-2, @man.y)
				when :right
					near = crate?(@man.x+1, @man.y)
					boxBehind = what_is_on(@man.x+2, @man.y)
			end
			return(near and boxBehind == WALL)
		end
		
		def double_crate?(direction)
			case direction
				when :up
					true if crate?(@man.x, @man.y-1) and crate?(@man.x, @man.y-2)
				when :down
					true if crate?(@man.x, @man.y+1) and crate?(@man.x, @man.y+2)
				when :left
					true if crate?(@man.x-1, @man.y) and crate?(@man.x-2, @man.y)
				when :right
					true if crate?(@man.x+1, @man.y) and crate?(@man.x+2, @man.y)
			end
		end
		
		# Y-a-t-il une caisse ('o' ou '*') au sol dans la case x, y ?
		# @param [Fixnum] x coordonnée x
		# @param [Fixnum] y coordonnée y
		# @return [true|false]
		def crate?(x, y)
			box = what_is_on(x, y)
			return true if box == CRATE or box == CRATE_ON_STORAGE
			false
		end
		
		# Draw the man for @picture output
		def draw_man
			box = what_is_on @man.x, @man.y
			@picture[@man.y][@man.x] = MAN if box == FLOOR
			@picture[@man.y][@man.x] = MAN_ON_STORAGE if box == STORAGE
		end
		
		# Draw the crates for @picture output
		def draw_crates
			@crates.each {|crate| @picture[crate.y][crate.x] = what_is_on(crate.x, crate.y) }
		end
		
		def draw_storages
			@storages.each {|st| @picture[st.y][st.x] = what_is_on(st.x, st.y) }
		end

		# Qu'y-a-t-il au sol dans la case x, y ?
		# @param [Fixnum] x coordonnée x
		# @param [Fixnum] y coordonnée y
		# @return [' ' | '#' | '.' | 'o' | '*']
		def what_is_on x, y
			box = (@floor[y][x]).chr
			if box == ' '
				s = Storage.new(x, y)
				c = Crate.new(x, y)
				if @storages.include?(s) and @crates.include?(c)
					box = CRATE_ON_STORAGE 
				elsif @storages.include?(s)
					box = STORAGE
				elsif @crates.include?(c)
					box = CRATE
				end
			end
			box
		end
		
		# Retire tous les emplacements de stockages, toutes les caisses et le bonhomme
		# pour ne laisser que les murs et le sol.
		#
		# @param [Array<String>] picture le niveau (map)
		# @return [Array<String>] le niveau en format brut avec seulement le sol vide et les murs
		def init_floor picture
			floor = []
			picture.each {|x| floor.push x.tr("#{STORAGE}#{CRATE}#{MAN}#{CRATE_ON_STORAGE}", FLOOR) }
			floor
		end
		
		# Trouve la position du bonhomme, au début du niveau.
		#
		# @param [Array<String>] rawLevel le niveau en format brut
		# @return [Man] un bonhomme initialisé
		def init_man rawLevel
			x = y = 0
			rawLevel.each {|line| 
				if line.include?(MAN)
					x = line.index(MAN)
					break
				end
				y += 1
			}
			Man.new x, y
		end
		
		# Trouve la position des caisses et des emplacements de stockage, au début du niveau.
		#
		# @param [Array<String>] picture le niveau (map)
		def init_crates_and_storages picture
			y = 0
			picture.each do |line| 
				count = 0
				line.each_char do |c| 
					@crates.push Crate.new(count, y) if c == CRATE
					@storages.push Storage.new(count, y) if c == STORAGE
					if c == CRATE_ON_STORAGE
						@crates.push Crate.new(count, y)
						@storages.push Storage.new(count, y)
					end
					count += 1
				end
				y += 1
			end
		end
		
	end

end
