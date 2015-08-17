require_relative 'test_helper'

class TestAppRun < Minitest::Test
  def projects
    @projects ||= Projects.new
  end

  def test_duplicate_project_name
    projects.add('cooking')
    projects.add('cooking')
    assert_equal(1, projects.size)
  end
end
