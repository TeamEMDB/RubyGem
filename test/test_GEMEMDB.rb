# frozen_string_literal: true

require_relative 'test_helper'

class TestGEMEMDB < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GEMEMDB::VERSION
  end

  def test_that_check_first_complex_reg_to_fm
    object = GEMEMDB::Tafya.new()
    assert_equal true, [] ==
      object.reg_fm(""), 'first_complex'
  end

  def test_that_check_second_complex_reg_to_fm
    object = GEMEMDB::Tafya.new()
    assert_equal true, [[{"x"=>1}, {"y"=>2}, {"z"=>3}], [{"Eps"=>4}], [{"Eps"=>4}], [{"Eps"=>4}]] ==
      object.reg_fm("x + y + z"), 'first_complex'
  end

  def test_that_check_third_complex_reg_to_fm
    object = GEMEMDB::Tafya.new()
    assert_equal true, [[{"Eps"=>1}], [{"x"=>2}, {"y"=>3}, {"z"=>4}], [{"Eps"=>1}], [{"Eps"=>1}], [{"Eps"=>1}]] ==
      object.reg_fm('(x + y + z)*'), 'third_complex'
  end

  def test_that_check_fourth_complex_reg_to_fm
    object = GEMEMDB::Tafya.new()
    assert_equal true, [[{"Eps"=>1}], [{"x"=>1}, {"y"=>2}, {"Eps"=>3}], [{"Eps"=>3}], [{"Eps"=>4}], [{"z"=>5}, {"z"=>6}], [{"Eps"=>8}], [{"z"=>7}], [{"Eps"=>8}]] ==
      object.reg_fm('(x* + y)(z + zz)'), 'fourth_complex'
  end

  def test_that_check_fifth_complex_reg_to_fm
    object = GEMEMDB::Tafya.new()
    assert_equal true, [[{"Eps"=>1}], [{"x"=>2}, {"y"=>3}, {"d"=>4}], [{"Eps"=>1}], [{"Eps"=>1}], [{"Eps"=>5}], [{"z"=>6}, {"y"=>7}], [{"Eps"=>8}], [{"Eps"=>8}]] ==
      object.reg_fm('(x + y) * d (z + y)'), 'fifth_complex'
  end

end
