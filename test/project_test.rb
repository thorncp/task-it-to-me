require_relative 'test_helper'

class TestProject < Minitest::Test
  def test_project_load
    project_data = {'name' => 'Build a Bridge', 'tasks' => [{'name' => 'buy plastic'}]}
    project = Project.load(project_data)
    assert_equal('Build a Bridge', project.name)
    assert_equal(1, project.tasks.size)
    assert_equal('buy plastic', project.find_task('1').name)
  end
end
