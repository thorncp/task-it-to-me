require_relative 'test_helper'

class TestProject < Minitest::Test
  def test_finishing_task
    project = Project.new('things')
    project.add_task('start at the beginning')
    task = project.find_task('start at the beginning')
    project.finish('start at the beginning')

    refute_includes(project.tasks, task)
    assert_includes(project.finished_tasks, task)
  end

  def test_expired_finished_tasks
    project = Project.new('things')
    project.add_task('start at the beginning')
    task = project.find_task('start at the beginning')
    project.finish('start at the beginning')
    task.finished_at = Time.now - (Task::GRACE_PERIOD * 2)

    refute_includes(project.tasks, task)
    refute_includes(project.finished_tasks, task)
  end

  def test_project_load
    project_data = {
      'name' => 'Build a Bridge',
      'tasks' => [{'name' => 'buy plastic'}],
      'finished_tasks' => [
        {'name' => 'go sailing', 'finished_at' => Time.now - 3600},
        {'name' => 'go fishing', 'finished_at' => Time.now - Task::GRACE_PERIOD * 4}
      ]
    }
    project = Project.load(project_data)

    assert_equal('Build a Bridge', project.name)

    assert_equal(1, project.tasks.size)
    assert_equal('buy plastic', project.find_task('1').name)

    assert_equal(1, project.finished_tasks.size)
    assert_equal('go sailing', project.finished_tasks.find('1').name)
  end
end
