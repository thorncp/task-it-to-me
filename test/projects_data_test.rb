require_relative 'test_helper'

class TestdataData < Minitest::Test
  def data
    @data ||= ProjectsData.new
  end

  def test_adding_a_project
    data.add(Project.new('cooking'))
    assert_equal(1, data.size)
  end

  def test_duplicate_project_name
    data.add(Project.new('cooking'))
    data.add(Project.new('cooking'))
    assert_equal(1, data.size)
  end

  def test_find_project
    data.add(Project.new('cooking'))
    assert_equal(data.find('cooking').class, Project)
    assert_equal(data.find('cooking').name, 'cooking')
  end

  def test_delete_of_project
    data.add(Project.new('camping'))
    data.delete('camping')
    assert_equal(0, data.size)
  end

  def test_successful_delete_of_project_returns_true
    data.add(Project.new('camping'))
    assert_equal(true, data.delete('camping'))
  end

  def test_delete_of_project_that_does_not_exist
    data.add(Project.new('camping'))
    assert_equal(false, data.delete('glamping'))
  end

  def test_rename_project
    data.add(Project.new('camping'))
    assert_equal(true, data.rename('camping', 'glamping'))
    assert_equal(Project, data.find('glamping').class)
  end
end
