class State
  attr_reader :projects, :current_project

  def initialize
    @projects = Collection.new
    @current_project = NullProject.new
  end

  def add_project(name)
    projects.add(Project.new(name))
  end

  extend Forwardable

  def_delegator :projects, :delete, :delete_project
  def_delegator :projects, :rename, :rename_project
  def_delegator :projects, :find,   :find_project

  def set_current_project(name)
    @current_project = find_project(name) || NullProject.new
    current_project?
  end

  def current_project?
    !current_project.is_a?(NullProject)
  end

  def add_task(name)
    current_project.add_task(name)
  end

  def delete_task(name)
    current_project.delete_task(name)
  end

  def rename_task(old_name, new_name)
    current_project.rename_task(old_name, new_name)
  end

  def task_exists?(name)
    !!current_project.find_task(name)
  end

  def projects_empty?
    projects.size == 0
  end

  def current_tasks_empty?
    current_tasks.size == 0
  end

  def current_tasks
    current_project.tasks
  end
end
