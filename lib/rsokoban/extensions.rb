
class String
	# In xsb files, an information line start with a semi-colon.
	# I remove it, remove leading and trailing spaces and inject a newline to the end.
	# @example
	#   > a = "; hello world !   \n"
	#   > a.get_xsb_info_line
	#   => "hello world !\n"
	# @since 0.74
	# @see #get_xsb_info_line_chomp
	def get_xsb_info_line
		self.get_xsb_info_line_chomp + "\n"
	end
	
	# In xsb files, an information line start with a semi-colon.
	# I remove it and also remove leading and trailing spaces.
	# @example
	#   > a = "; hello world !   \n"
	#   > a.get_xsb_info_line_chomp
	#   => "hello world !"
	# @since 0.74
	# @see #get_xsb_info_line
	def get_xsb_info_line_chomp
		self.sub(/;/, '').strip
	end
end
