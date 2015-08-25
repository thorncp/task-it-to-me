class State
  attr_reader :projects, :current_project, :persistence

  def initialize
    @projects = Collection.new
    @current_project = NullProject.new
    @persistence = Persistence.new
  end

  def add_project(name)
    save { projects.add(Project.new(name)) }
  end

  def rename_project(*args)
    save { projects.rename(*args) }
  end

  def delete_project(*args)
    save { projects.delete(*args) }
  end

  def load
    @projects = Collection.new
    persistence.load.each do |project_data|
      projects.add(Project.load(project_data))
    end
  end

  extend Forwardable
  def_delegator :projects, :find,   :find_project

  def set_current_project(name)
    @current_project = find_project(name) || NullProject.new
    current_project? ? current_project : false
  end

  def current_project?
    !current_project.is_a?(NullProject)
  end

  def_delegators :current_project, :find_task

  def add_task(*args)
    save { current_project.add_task(*args) }
  end

  def rename_task(*args)
    save { current_project.rename_task(*args) }
  end

  def delete_task(*args)
    save { current_project.delete_task(*args) }
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

  private

  def save(&block)
    object = block.call
    persistence.save(projects.as_json) if object
    object
  end
end
