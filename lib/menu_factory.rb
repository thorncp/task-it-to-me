class MenuFactory < Struct.new(:state)
  def generate
    if state.current_project? && !state.current_tasks_empty?
      tasks
    elsif state.current_project?
      null_tasks
    elsif state.projects_empty?
      null_projects
    else
      projects
    end
  end

  def projects
    Menu.new(all_project_routes)
  end

  def null_projects
    null_routes = all_project_routes.find_all {|route| ['a', 'q'].include?(route.id) }
    Menu.new(null_routes)
  end

  def tasks
    Menu.new(all_task_routes)
  end

  def null_tasks
    null_routes = all_task_routes.find_all {|route| ['c', 'a', 'b', 'q'].include?(route.id) }
    Menu.new(null_routes)
  end

  private

  def all_task_routes
    [
      Route.new("c", "Change the project name", Controller::RenameProject),
      Route.new("a", "Add a new task",          Controller::CreateTask),
      Route.new("ls", "List all tasks",         Controller::ListTasks),
      Route.new("d", "Delete a task",           Controller::DeleteTask),
      Route.new("e", "Edit a task",             Controller::RenameTask),
      Route.new("f", "Finish a task",           Controller::FinishTask),
      Route.new("b", "Back to Projects menu",   Controller::Back),
      Route.new("q", "Quit the app")
    ]
  end

  def all_project_routes
    [
      Route.new("a",  "Add a new project", Controller::CreateProject),
      Route.new("ls", "List all project",  Controller::ListProjects),
      Route.new("d",  "Delete a project",  Controller::DeleteProject),
      Route.new("e",  "Edit a project",    Controller::EditProject),
      Route.new("q",  "Quit the app")
    ]
  end
end
