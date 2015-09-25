class Print < Struct.new(:output_stream)
  def welcome_message
    view = formatter
      .success("Welcome to Taskitome!").end_line
      .add_large_rule
      .add_line
      .flush
    send_to_output(view)
  end

  def projects_menu
    view = formatter
      .add_menu_header("PROJECTS MENU")
      .command_menu("a",  "Add a new project")
      .command_menu("ls", "List all project")
      .command_menu("d",  "Delete a project")
      .command_menu("e",  "Edit a project")
      .command_menu("q",  "Quit the app")
      .add_separator
      .flush
    send_to_output(view)
  end

  def tasks_menu(project_name)
    view = formatter
      .success("Editing project: '#{project_name}'").end_line
      .add_menu_header("EDIT PROJECT MENU")
      .command_menu("c", "Change the project name")
      .command_menu("a", "Add a new task")
      .command_menu("ls", "List all tasks")
      .command_menu("d", "Delete a task")
      .command_menu("e", "Edit a task")
      .command_menu("f", "Finish a task")
      .command_menu("b", "Back to Projects menu")
      .command_menu("q", "Quit the app")
      .add_separator
      .flush
    send_to_output(view)
  end

  def list(collection)
    view = formatter.list(collection).flush
    send_to_output(view)
  end

  def project_name_prompt
    prompt("Enter a project name:")
  end

  def new_project_name_prompt
    prompt("Enter new project name:")
  end

  def task_prompt
    prompt("Enter a task name:")
  end

  def listing_project_header
    success("Listing projects:")
  end

  def task_list_header
    success("Listing tasks:")
  end

  def cant_delete_project
    alert("Can't delete a project")
  end

  def cant_edit_project
    alert("Can't edit any projects")
  end

  def no_projects_message
    alert("No projects created")
  end

  def project_created(name)
    success_with_name("Created project:", name)
  end

  def successful_delete(name)
    success_with_name("Deleting project:", name)
  end

  def created_task(name)
    success_with_name("Created task:", name)
  end

  def editing_task(name)
    success_with_name("Editing task:", name)
  end

  def task_deleted(name)
    success_with_name("Deleted task:", name)
  end

  def finished_task(name)
    success_with_name("Finished task:", name)
  end

  def project_does_not_exist(name)
    alert_with_name("Project doesn't exist:", name)
  end

  def task_does_not_exsit(name)
    alert_with_name("Task doesn't exist:", name)
  end

  def no_tasks_created_in(name)
    alert_with_name("No tasks created in", name)
  end

  def changed_project_name(old_name, new_name)
    change_name("Changed project name from", old_name, new_name)
  end

  def changed_task_name(old_name, new_name)
    change_name("Changed task name from", old_name, new_name)
  end

  private

  def change_name(message, old_name, new_name)
    view = formatter
      .change_name(message, old_name, new_name)
      .flush
    send_to_output(view)
  end

  (Formatter::COLORS).keys.each do |method_name|
    define_method(method_name) do |message|
      view = formatter
        .add(message, method_name)
        .flush
      send_to_output(view)
    end
  end

  [:success_with_name, :alert_with_name].each do |method_name|
    define_method(method_name) do |message, name|
      view = formatter
        .send(method_name, message, name)
        .flush
      send_to_output(view)
    end
  end

  def formatter
    Formatter.new
  end

  def send_to_output(view)
    output_stream.puts(view)
  end
end
