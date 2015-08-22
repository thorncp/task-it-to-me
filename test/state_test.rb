require_relative 'test_helper'

class TestState < Minitest::Test
  def state
    @state ||= State.new
  end

  def test_adding_a_project
    state.add_project('cooking')
    assert_equal(1, state.projects.size)
  end

  def test_delete_of_project
    state.add_project('camping')
    state.delete_project('camping')
    assert_equal(0, state.projects.size)
  end

  def test_rename_project
    state.add_project('camping')
    assert_equal(true, state.rename_project('camping', 'glamping'))
    assert_equal(Project, state.find_project('glamping').class)
  end

  def test_set_current_project_by_name
    state.add_project('camping')
    state.set_current_project('camping')
    assert_equal(state.current_project, state.find_project('camping'))
  end

  def test_add_task_when_no_current_project
    assert_equal(false, state.add_task('but add it where'))
  end

  def test_add_task_to_current_project
    state.add_project('glamping')
    state.set_current_project('glamping')
    state.add_task('do nails')
    assert_equal(1, state.current_project.tasks.size) # holy demeter violation!
  end

  def test_delete_task_when_no_current_project
    assert_equal(false, state.delete_task('not here, yo!'))
  end

  def test_deleting_task_that_exists
    state.add_project('glamping')
    state.set_current_project('glamping')
    state.add_task('do nails')
    state.delete_task('do nails')
    assert_equal(0, state.current_project.tasks.size) # holy demeter violation!
  end

  def test_rename_task_when_no_current_project
    assert_equal(false, state.rename_task('not here, yo!', 'doesnt matter'))
  end

  def test_rename_task_when_exists
    state.add_project('glamping')
    state.set_current_project('glamping')
    state.add_task('do nails')
    state.rename_task('do nails', 'wash hair')
    assert(state.task_exists?('wash hair'))
  end

  def test_projects_empty?
    assert(state.projects_empty?)
    state.add_project('fullfillment')
    refute(state.projects_empty?)
  end

  def test_current_tasks_empty?
    assert(state.current_tasks_empty?)
    state.add_project('glamping')
    state.set_current_project('glamping')
    state.add_task('do nails')
    refute(state.current_tasks_empty?)
  end
end
