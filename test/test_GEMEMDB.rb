# frozen_string_literal: true

require "test_helper"

class TestGEMEMDB < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GEMEMDB::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
  
  def test1
		assert_equal true, [[{"x"=>1}, {"y"=>2}, {"z"=>3}], [{"Eps"=>4}], [{"Eps"=>4}], [{"Eps"=>4}]] ==
		GEMEMDB::reg_fm('x + y + z'), 'test1'
	end

	def test2
		assert_equal true, [[{"Eps"=>1}], [{"x"=>2}, {"y"=>3}, {"d"=>4}], [{"Eps"=>1}], [{"Eps"=>1}], [{"Eps"=>5}], [{"z"=>6}, {"y"=>7}], [{"Eps"=>8}], [{"Eps"=>8}]] ==
		GEMEMDB::reg_fm('(x + y) * d (z + y)'), 'test2'
	end
  
end
