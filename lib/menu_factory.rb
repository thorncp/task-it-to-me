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
    Menu.new([
      Route.new("a",  "Add a new project"),
      Route.new("ls", "List all project"),
      Route.new("d",  "Delete a project"),
      Route.new("e",  "Edit a project"),
      Route.new("q",  "Quit the app")
    ])
  end

  def null_projects
    Menu.new([
      Route.new("a",  "Add a new project"),
      Route.new("q",  "Quit the app")
    ])
  end

  def tasks
    Menu.new([
      Route.new("c", "Change the project name"),
      Route.new("a", "Add a new task"),
      Route.new("ls", "List all tasks"),
      Route.new("d", "Delete a task"),
      Route.new("e", "Edit a task"),
      Route.new("f", "Finish a task"),
      Route.new("b", "Back to Projects menu"),
      Route.new("q", "Quit the app")
    ])
  end

  def null_tasks
    Menu.new([
      Route.new("c", "Change the project name"),
      Route.new("a", "Add a new task"),
      Route.new("b", "Back to Projects menu"),
      Route.new("q", "Quit the app")
    ])
  end
end
