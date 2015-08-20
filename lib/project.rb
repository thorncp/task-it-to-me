class Project
  attr_reader   :tasks
  attr_accessor :name

  def initialize(name)
    @name = name
    @tasks = Collection.new
  end

  def add_task(name)
    tasks.add(Task.new(name))
  end

  extend Forwardable

  def_delegator :tasks, :delete, :delete_task
  def_delegator :tasks, :rename, :rename_task
  def_delegator :tasks, :find,   :find_task

  def_delegators :tasks, :size
end
