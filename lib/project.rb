class Project
  attr_reader   :tasks, :all_finished_tasks
  attr_accessor :name, :position

  def initialize(name)
    @name = name
    @tasks = Collection.new
    @all_finished_tasks = Collection.new
  end

  def add_task(name)
    tasks.add(Task.new(name))
  end

  def finish_task(name)
    return unless task = find_task(name)
    delete_task(name)
    task.finish
    all_finished_tasks.add(task)
    task
  end

  def finished_tasks
    all_finished_tasks.reduce(&:visible?)
  end

  def to_hash
    {
      name: name,
      tasks: tasks.as_json,
      finished_tasks: finished_tasks.as_json
    }
  end

  def self.load(data)
    project = new(data['name'])

    data['tasks'] && data['tasks'].each do |task_data|
      project.tasks.add(Task.load(task_data))
    end

    data['finished_tasks'] && data['finished_tasks'].each do |task_data|
      task = Task.load(task_data)
      project.all_finished_tasks.add(task) if task.visible?
    end

    project
  end

  extend Forwardable

  def_delegator :tasks, :delete, :delete_task
  def_delegator :tasks, :rename, :rename_task
  def_delegator :tasks, :find,   :find_task

  def_delegators :tasks, :size
end
