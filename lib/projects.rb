class Projects
  attr_reader :projects, :current_project

  def initialize
    @projects = []
  end

  def add(name)
    return if names.include?(name)
    projects << {name => []}
  end

  def delete(name)
    projects.delete_if {|project| name_for_project(project) == name }.empty?
  end

  def rename(old_name, new_name)
    current_project[new_name] = current_project_tasks
    current_project.delete(old_name)
  end

  def size
    projects.size
  end

  def names
    projects.map{ |project| project.keys.first }
  end

  def set_current_project(name)
    @current_project = find_project_by_name(name)
  end

  def add_task(name)
    current_project_tasks << name
  end

  def delete_task(name)
    current_project_tasks.delete(name)
  end

  def rename_task(old_name, new_name)
    index = current_project_tasks.find_index(old_name)
    current_project_tasks[index] = new_name
  end

  def projects_empty?
    projects.empty?
  end

  def name_for_project(project_data)
    project_data.keys.first
  end

  def tasks_for_project(project_data)
    project_data.values.first
  end

  def find_project_by_name(name)
    projects.detect{|project| name_for_project(project) == name}
  end

  def current_project_tasks
    tasks_for_project(current_project)
  end

  def current_project_name
    name_for_project(current_project)
  end

  def current_tasks_empty?
    current_project_tasks.empty?
  end

  def task_exists?(name)
    current_project_tasks.any?{|n| n == name}
  end
end
