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

  def test_matr_with_all_e
    object = GEMEMDB::Tafya.new()
    assert_equal('1*(00*(1(1(1+0)*+e)+e)+e)', object.matrixToEquation(['0', '1'], ['Se', 'De', 'Pe', 'Qe'], Matrix[['D', 'S'], ['D', 'P'], ['0', 'Q'], ['Q', 'Q']]))
  end

  def test_matr_with_zero_dash
    object = GEMEMDB::Tafya.new()
    assert_equal('2*(10*20*+10*+e)', object.matrixToEquation(['0', '1', '2'], ['Ae', 'B', 'Ce'], Matrix[['0', 'BC', 'A'], ['B', '-', 'C'], ['C', '0', '-']]))
  end

  def test_matr_with_one_transition
    object = GEMEMDB::Tafya.new()
    assert_equal('2*', object.matrixToEquation(['0', '1', '2'], ['Ae'], Matrix[['0', '0', 'A']]))
  end

  def test_matr_with_branching
    object = GEMEMDB::Tafya.new()
    assert_equal('(1+0)*(01(1+0)*)', object.matrixToEquation(['0', '1'], ['A', 'B', 'Ce'], Matrix[['AB', 'A'], ['0', 'C'], ['C', 'C']]))
  end

  def test_sort_equation
    object = GEMEMDB::Tafya.new()
    assert_equal(['01*01*2C+2C+01*'], object.sortEquation(['C'], ["2C+01*+01*01*2C"]))
  end

  def test_equation_to_solution
    object = GEMEMDB::Tafya.new()
    assert_equal('(01*01*2+2)*01*', object.equationToSolution(['C'], ["2C+01*+01*01*2C"]))
  end

  def test_equation_to_one_pred_solution
    object = GEMEMDB::Tafya.new()
    assert_equal({"C"=>"0*"}, object.equationToPredSolution(['C'], ["0C+e"]))
  end

  def test_equation_to_pred_solution
    object = GEMEMDB::Tafya.new()
    assert_equal({"C"=>"(2+01*01*2)*01*"}, object.equationToPredSolution(['C'], ["2C+01*+01*01*2C"]))
  end

  def test_equation_to_two_pred_solution
    object = GEMEMDB::Tafya.new()
    assert_equal({"B"=>"0*0C", "C"=>"(0+1)*2B"}, object.equationToPredSolution(['B', 'C'], ["0B+0C", "0C+1C+2B"]))
  end

  def test_string_to_pred_solution
    object = GEMEMDB::Tafya.new()
    assert_equal('(1+0)*', object.stringToPredSolution('Q', "1Q+0Q+e"))
  end

  def test_string_to_pred_solution_nil
    object = GEMEMDB::Tafya.new()
    assert_equal(nil, object.stringToPredSolution('P', "1Q+0Q+e"))
  end

  def test_invalid_matrix1
    object = GEMEMDB::Tafya.new()
    assert_throw(InvalidMatrix) do object.matrixToEquation(['0', '1'], ['Ae', 'B', 'C'], Matrix[['B', 'A'], ['C', 'B'], ['A', 'C']])
    end
  end

  def test_invalid_matrix2
    object = GEMEMDB::Tafya.new()
    assert_throw(InvalidMatrix) do object.matrixToEquation(['0', '1', '2'], ['A', 'Be', 'Ce'], Matrix[['A', 'A', 'B'], ['0', 'C', 'B'], ['0', '0', 'B']])
    end
  end

end
