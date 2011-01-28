class TC_Extensions < Test::Unit::TestCase

	def test_String_get_xsb_info_line
		assert_equal "E-Mail:\n", "; E-Mail: \n".get_xsb_info_line
	end
	
	def test_String_get_xsb_info_line_from_empty_info
		assert_equal "\n", ";\n".get_xsb_info_line
	end
	
	def test_String_get_xsb_info_line_with_semi_colon_in_it
		assert ";foo;bar;\n", ";;foo;bar;\n".get_xsb_info_line
	end
	
	def test_String_get_xsb_info_line_chomp
		assert_equal "E-Mail:", "; E-Mail: \n".get_xsb_info_line_chomp
	end
	
	def test_String_get_xsb_info_line_chomp_from_empty_info
		assert_equal "", ";\n".get_xsb_info_line_chomp
	end
	
	def test_String_get_xsb_info_line_chomp_with_semi_colon_in_it
		assert_equal ";foo;bar;", ";;foo;bar;\n".get_xsb_info_line_chomp
	end
end
