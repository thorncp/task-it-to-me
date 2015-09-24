class Print < Struct.new(:output_stream)
  def welcome_message
    formatter
      .success("Welcome to Taskitome!").end_line
      .add_large_rule
      .add_line
      .send_to_output
  end

  def projects_menu
    formatter
      .add_menu_header("PROJECTS MENU")
      .command_menu("a",  "Add a new project")
      .command_menu("ls", "List all project")
      .command_menu("d",  "Delete a project")
      .command_menu("e",  "Edit a project")
      .command_menu("q",  "Quit the app")
      .add_separator
      .send_to_output
  end

  def tasks_menu(project_name)
    formatter
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
      .send_to_output
  end

  def list(collection)
    formatter
      .list(collection)
      .send_to_output
  end

  # project menu related messages, no arguments required
  def no_projects_message
    formatter
      .alert("No projects created")
      .add_separator
      .send_to_output
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
    formatter
      .success("Listing projects:")
      .send_to_output
  end

  def cant_delete_project
    formatter
      .alert("Can't delete a project")
      .send_to_output
  end

  def cant_edit_project
    formatter
      .alert("Can't edit any projects")
      .send_to_output
  end

  # project menu related messages, with data passed in
  def project_created(name)
    formatter
      .success("Created project:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  def successful_delete(name)
    formatter
      .success("Deleting project:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  def project_does_not_exist(name)
    formatter
      .alert("Project doesn't exist:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  # task menu related messages, no data passed in


  def task_list_header
    formatter
      .success("Listing tasks:")
      .send_to_output
  end

  # task menu related messages, data required
  def created_task(name)
    formatter
      .success("Created task:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  def changed_project_name(old_name, new_name)
    formatter
      .success("Changed project name from")
      .add(" '#{old_name}' ")
      .success("to")
      .add(" '#{new_name}'")
      .add_separator
      .send_to_output
  end

  def changed_task_name(old_name, new_name)
    formatter
      .success("Changed task name from")
      .add(" '#{old_name}' ")
      .success("to")
      .add(" '#{new_name}'")
      .add_separator
      .send_to_output
  end

  def editing_task(name)
    formatter
      .success("Editing task:")
      .add(" '#{name}'")
      .send_to_output
  end

  def task_does_not_exsit(name)
    formatter
      .alert("Task doesn't exist:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  def no_tasks_created_in(project_name)
    formatter
      .alert("No tasks created in ")
      .add("'#{project_name}'")
      .add_separator
      .send_to_output
  end

  def task_deleted(name)
    formatter
      .success("Deleted task:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  def finished_task(name)
    formatter
      .success("Finished task:")
      .add(" '#{name}'")
      .add_separator
      .send_to_output
  end

  private

  Formatter::COLORS.keys.each do |name|
    define_method(name) do |message|
      formatter
        .add(message, name)
        .send_to_output
    end
  end

  def formatter
    Formatter.new(output_stream)
  end
end
