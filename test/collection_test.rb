require_relative 'test_helper'

class TestCollection < Minitest::Test
  def data
    @data ||= Collection.new
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

  def test_find_project_by_name
    data.add(Project.new('cooking'))
    assert_equal(data.find('cooking').class, Project)
    assert_equal(data.find('cooking').name, 'cooking')
  end

  def test_find_project_by_position
    data.add(Project.new('cooking'))
    assert_equal(data.find('1').name, 'cooking')
  end

  def test_delete_of_project
    data.add(Project.new('camping'))
    data.delete('camping')
    assert_equal(0, data.size)
  end

  def test_successful_delete_of_project_returns_true
    data.add(Project.new('camping'))
    deleted =  data.delete('camping')
    assert_equal('camping', deleted.name)
  end

  def test_delete_of_project_that_does_not_exist
    data.add(Project.new('camping'))
    refute(data.delete('glamping'))
  end

  def test_rename_project
    data.add(Project.new('camping'))
    renamed = data.rename('camping', 'glamping')
    assert_equal(renamed.name, 'glamping')
  end

  def test_setting_position_of_element
    data.add(Project.new('camping'))
    assert_equal(1, data.find('camping').position)
    data.add(Project.new('glamping'))
    assert_equal(2, data.find('glamping').position)
  end

  def test_position_stays_the_same_on_rename
    data.add(Project.new('camping'))
    data.rename('camping', 'glamping')
    assert_equal(1, data.find('glamping').position)
  end

  def test_positions_recalculated_when_deletion_happens
    data.add(Project.new('camping'))
    data.add(Project.new('glamping'))
    data.delete('camping')
    assert_equal(1, data.find('glamping').position)
  end

  def test_reduce
    expired_task = Task.new('expire me')
    expired_task.finished_at = Time.now - Task::GRACE_PERIOD * 3
    data.add(expired_task)

    current_task = Task.new('current affairs')
    data.add(current_task)

    reduced = data.reduce(&:visible?)

    refute(data === reduced)
    assert_includes(reduced, current_task)
    refute_includes(reduced, expired_task)
  end
end
