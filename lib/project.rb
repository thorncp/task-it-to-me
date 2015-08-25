class Project
  attr_reader   :tasks
  attr_accessor :name, :position

  def initialize(name)
    @name = name
    @tasks = Collection.new
  end

  def add_task(name)
    tasks.add(Task.new(name))
  end

  def to_hash
    {
      name: name,
      tasks: tasks.as_json
    }
  end

  def self.load(data)
    project = new(data['name'])
    data['tasks'].each do |task_data|
      project.tasks.add(Task.load(task_data))
    end
    project
  end

  extend Forwardable

  def_delegator :tasks, :delete, :delete_task
  def_delegator :tasks, :rename, :rename_task
  def_delegator :tasks, :find,   :find_task

  def_delegators :tasks, :size
end
