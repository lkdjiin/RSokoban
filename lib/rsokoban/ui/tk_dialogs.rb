module RSokoban::UI

	# As dialog box, I allow the user to choose a specific level number.
	class TkLevelDialog < TkToplevel
	
		# Create and show the dialog
		# @param [TkRoot|TkToplevel] root the Tk widget I belong to
		# @param [String] title my window title
		def initialize(root, title)
			super(root)
			title(title)
			minsize(200, 100)
			@state = :cancel
			grab
			
			@frame_north = TkFrame.new(self) do
				grid(:row => 0, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			$spinval = TkVariable.new
			@spin = TkSpinbox.new(@frame_north) do
				textvariable($spinval)
				width 3
				grid(:row => 0, :column => 0)
			end
			@spin.to(999)
			@spin.from(1)
			@spin.focus
			@spin.bind 'Key-Return', proc{ ok_on_clic }
			
			@ok = TkButton.new(self) do
				text 'OK'
				grid(:row => 1, :column => 0)
				default :active
			end
			@ok.command { ok_on_clic }
			
			@cancel = TkButton.new(self) do
				text 'Cancel'
				grid(:row => 1, :column => 1)
			end
			@cancel.command { cancel_on_clic }
			
			wait_destroy
		end
		
		# @return true if user clicked the OK button
		def ok?
			@state == :ok
		end
		
		# @return [Fixnum] level number
		def value
			$spinval.to_i
		end
		
		private
		
		def ok_on_clic
			@state = :ok
			destroy
		end
		
		def cancel_on_clic
			@state = :cancel
			destroy
		end
	end
	
	# As dialog box, I allow the user to select a skin.
	# @since 0.76
	class SkinDialog < TkToplevel
		include RSokoban
		
		def initialize(root, title)
			super(root)
			title(title)
			width(300)
			height(400)
			@state = 'CANCEL'
			grab
			self['resizable'] = false, false
			
			@skins = Skin.new.list_skins
			$listval = TkVariable.new(@skins)
			@value = @skins[0]
			
			# A frame for the listbox
			@frame_north = TkFrame.new(self) do
				grid(:row => 0, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			@list = TkListbox.new(@frame_north) do
				width 40
			 	height 8
			 	listvariable $listval
			 	grid(:row => 0, :column => 0, :sticky => :we)
			end
			
			#@list.bind '<ListboxSelect>', proc{ show_description }
			@list.bind 'Double-1', proc{ ok_on_clic }
			@list.bind 'Return', proc{ ok_on_clic }

			
			scroll = TkScrollbar.new(@frame_north) do
				orient 'vertical'
				grid(:row => 0, :column => 1, :sticky => :ns)
			end

			@list.yscrollcommand(proc { |*args| scroll.set(*args) })
			scroll.command(proc { |*args| @list.yview(*args) })
			
			# The buttons
			@ok = TkButton.new(self) do
				text 'OK'
				grid(:row => 2, :column => 0)
				default :active
			end
			@ok.command { ok_on_clic }
			
			@cancel = TkButton.new(self) do
				text 'Cancel'
				grid(:row => 2, :column => 1)
			end
			@cancel.command { cancel_on_clic }
			
			@list.focus
			wait_destroy
		end
		
		# @return true if user clicked the OK button
		def ok?
			@state == 'OK'
		end
		
		# @return [String] the name of the set
		def value
			@value
		end
		
		private
		
		def ok_on_clic
			@state = 'OK'
			idx = @list.curselection
			unless idx.empty?
				@value = @skins[idx[0]]
			end
			destroy
		end
		
		def cancel_on_clic
			@state = 'CANCEL'
			destroy
		end
		
	end
	
	# As dialog box, I allow the user to choose a set name.
	class SetDialog < TkToplevel
		include RSokoban
		# Create and show the dialog
		# @param [TkRoot|TkToplevel] root the Tk widget I belong to
		# @param [String] title my window title
		def initialize(root, title)
			super(root)
			title(title)
			width(300)
			height(400)
			@state = 'CANCEL'
			grab
			self['resizable'] = false, false
			
			@xsb = get_xsb
			$listval = TkVariable.new(@xsb)
			@value = @xsb[0]
			
			# A frame for the listbox
			@frame_north = TkFrame.new(self) do
				grid(:row => 0, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			@list = TkListbox.new(@frame_north) do
				width 40
			 	height 8
			 	listvariable $listval
			 	grid(:row => 0, :column => 0, :sticky => :we)
			end
			
			@list.bind '<ListboxSelect>', proc{ show_description }
			@list.bind 'Double-1', proc{ ok_on_clic }
			@list.bind 'Return', proc{ ok_on_clic }

			
			scroll = TkScrollbar.new(@frame_north) do
				orient 'vertical'
				grid(:row => 0, :column => 1, :sticky => :ns)
			end

			@list.yscrollcommand(proc { |*args| scroll.set(*args) })
			scroll.command(proc { |*args| @list.yview(*args) })
			
			# A frame for the set description
			@frame_desc = TkFrame.new(self) do
				grid(:row => 1, :column => 0, :columnspan => 2, :sticky => :we)
				padx 10
				pady 10
			end
			
			@desc = TkText.new(@frame_desc) do
				borderwidth 1
				font TkFont.new('times 12')
				width 40
				height 10
				wrap :word
			 	grid(:row => 0, :column => 0)
			end
			
			scroll2 = TkScrollbar.new(@frame_desc) do
				orient 'vertical'
				grid(:row => 0, :column => 1, :sticky => :ns)
			end

			@desc.yscrollcommand(proc { |*args| scroll2.set(*args) })
			scroll2.command(proc { |*args| @desc.yview(*args) }) 
			
			# The buttons
			@ok = TkButton.new(self) do
				text 'OK'
				grid(:row => 2, :column => 0)
				default :active
			end
			@ok.command { ok_on_clic }
			
			@cancel = TkButton.new(self) do
				text 'Cancel'
				grid(:row => 2, :column => 1)
			end
			@cancel.command { cancel_on_clic }
			
			@list.focus
			wait_destroy
		end
		
		# @return true if user clicked the OK button
		def ok?
			@state == 'OK'
		end
		
		# @return [String] the name of the set
		def value
			@value
		end
		
		private
		
		def ok_on_clic
			@state = 'OK'
			idx = @list.curselection
			unless idx.empty?
				@value = @xsb[idx[0]]
			end
			destroy
		end
		
		def cancel_on_clic
			@state = 'CANCEL'
			destroy
		end
		
		def get_xsb
			current = Dir.pwd
			Dir.chdir $RSOKOBAN_DATA_PATH
			ret = Dir.glob '*.xsb'
			Dir.chdir current
			ret
		end
		
		def show_description
			idx = @list.curselection
			ll = SetLoader.new @xsb[idx[0]]
			@desc.delete '1.0', :end
			@desc.insert :end, ll.file_description
		end
	end
	
	# As dialog box, I display some help.
	class HelpDialog < TkToplevel
		# Create and show the dialog
		# @param [TkRoot|TkToplevel] root the Tk widget I belong to
		# @param [String] title my window title
		def initialize(root, title)
			super(root)
			title(title)
			minsize(200, 100)

			text = TkText.new(self) do
				borderwidth 1
				font TkFont.new('times 12 bold')
				grid('row' => 0, 'column' => 0)
			end
			
			help=<<EOS
Welcome to RSokoban !

Goal of Sokoban game is to place each crate on a storage location.
Move the man using the arrow keys.
For a more comprehensive help, please visit the wiki at https://github.com/lkdjiin/RSokoban/wiki.
EOS
			
			text.insert 'end', help

			@ok = TkButton.new(self) do
				text 'OK'
				grid('row'=>1, 'column'=>0)
			end
			@ok.command { ok_on_clic }
		end
		
		def ok_on_clic
			destroy
		end
	end
	
end
