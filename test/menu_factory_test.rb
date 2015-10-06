require_relative 'test_helper'

class TestMenuFactory < Minitest::Test
  def factory
    @factory ||= MenuFactory.new(state)
  end

  def menu
    factory.generate
  end

  def state
    @state ||= State.new
  end

  def setup
    persistence = mock('persistence')
    persistence.stubs(:save)
    Persistence.stubs(:new).returns(persistence)
  end

  def test_return_type
    assert_equal Menu, menu.class
  end

  def test_when_no_projects
    assert_equal ['a', 'q'], menu.ids
    assert_equal "Add a new project", menu.get('a').description
  end

  def test_when_projects
    state.add_project('foo')
    assert_equal ['a', 'ls', 'd', 'e', 'q'], menu.ids
  end

  def test_when_current_project
    state.add_project('foo')
    state.set_current_project('foo')
    assert_equal ['c', 'a', 'b', 'q'], menu.ids
    assert_equal "Add a new task", menu.get('a').description
  end

  def test_when_current_project_with_tasks
    state.add_project('foo')
    state.set_current_project('foo')
    state.add_task('bar')
    assert_equal ['c', 'a', 'ls', 'd', 'e', 'f', 'b', 'q'], menu.ids
    assert_equal "Add a new task", menu.get('a').description
  end

  def test_when_current_project_with_only_finished_visible_tasks
    state.add_project('foo')
    state.set_current_project('foo')
    state.add_task('bar')
    state.finish_task('bar')
    assert_equal ['c', 'a', 'ls', 'b', 'q'], menu.ids
    assert_equal "Add a new task", menu.get('a').description
  end
end

