class State
  attr_reader :projects, :current_project, :persistence
  attr_accessor :username

  def initialize
    @projects = Collection.new
    @current_project = NullProject.new
    @persistence = Persistence.new(data_path)
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

  def load(username)
    @username = username
    @projects = Collection.new
    user_data.each do |project_data|
      projects.add(Project.load(project_data))
    end
  rescue Exception => e
    warn "Stored data could not be loaded: #{e.message}"
    #puts e.backtrace
  end

  extend Forwardable
  def_delegator :projects, :find, :find_project
  def_delegators :current_project, :finished_tasks

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

  def finish_task(*args)
    save { current_project.finish_task(*args) }
  end

  def projects_empty?
    projects.size == 0
  end

  def current_tasks_empty?
    current_tasks.size == 0
  end

  def finished_tasks?
    finished_tasks.size > 0
  end

  def current_tasks
    current_project.tasks
  end

  private

  def user_data
    persistence.load[username] || []
  end

  def save(&block)
    object = block.call
    persistence.save({
      username.to_sym => projects.as_json
    }) if object
    object
  end

  def data_path
    File.expand_path(File.dirname(__FILE__) + "/../data/projects.json")
  end
end
