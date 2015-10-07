require_relative 'test_helper'

class TestTask < Minitest::Test
  def test_visible_when_not_finished
    task = Task.new('do it big!')
    assert(task.visible?)
  end

  def test_visible_when_finished_within_grace_period
    task = Task.new('do it big!')
    task.finish
    assert(task.visible?)
  end

  def test_not_visible_when_finished_outside_grace_period
    task = Task.new('do it big!')
    task.finished_at = Time.now - (2*Task::GRACE_PERIOD)
    refute(task.visible?)
  end

  def test_task_load
    task_data = {'name' => 'buy plastic', 'finished_at' => (Time.now - 3600).to_s}
    task = Task.load(task_data)
    assert_equal('buy plastic', task.name)
    assert(task.finished_at.class == Time)
    assert_equal((Time.now - 3600).inspect, task.finished_at.inspect)
  end
end
