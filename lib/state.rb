class State
  attr_reader :projects, :current_project

  def initialize
    @projects = Collection.new
    @current_project = NullProject.new
  end

  def add(name)
    projects.add(Project.new(name))
  end

  extend Forwardable
  def_delegators :projects, :find, :rename, :names, :size, :delete

  def set_current_project(name)
    @current_project = find(name) || NullProject.new
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
    size == 0
  end

  def current_tasks_empty?
    current_project_tasks.size == 0
  end

  def current_project_tasks
    current_project.tasks
  end

  def current_project_name
    current_project.name
  end
end
