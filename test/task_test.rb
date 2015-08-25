require_relative 'test_helper'

class TestTask < Minitest::Test
  def test_task_load
    task_data = {'name' => 'buy plastic'}
    task = Task.load(task_data)
    assert_equal('buy plastic', task.name)
  end
end
