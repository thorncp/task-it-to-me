class Print < Struct.new(:output_stream)
  def welcome_message
    print_line( format("Welcome to Taskitome!", :success) )
    print_line( format("=============================", :dividing_line) )
    self.break
  end

  def projects_menu
    print_line("PROJECTS MENU")
    print_line( format("-----------------------------", :dividing_line) )
    print_line( format("ENTER A COMMAND:", :alert) )
    print_line( command("a",  "Add a new project") )
    print_line( command("ls", "List all project") )
    print_line( command("d",  "Delete a project") )
    print_line( command("e",  "Edit a project") )
    print_line( command("q",  "Quit the app") )
    self.break
  end

  def tasks_menu(project_name)
    print_line( format("Editing project: '#{project_name}'", :success) )
    self.break

    print_line( format("EDIT PROJECT MENU", :command) )
    print_line("-----------------------------")
    print_line( format("ENTER A COMMAND:", :alert) )
    print_line( command("c", "Change the project name") )
    print_line( command("a", "Add a new task") )
    print_line( command("ls", "List all tasks") )
    print_line( command("d", "Delete a task") )
    print_line( command("e", "Edit a task") )
    print_line( command("f", "Finish a task") )
    print_line( command("b", "Back to Projects menu") )
    print_line( command("q", "Quit the app") )
    self.break
  end

  # Assorted printing/view methods
  def break
    print_line("\n\n")
  end

  # project menu related messages, no arguments required
  def no_projects_message
    print_line(
      format("No projects created", :alert)
    )
    self.break
  end

  def project_name_prompt
    print_line(
      format("Enter a project name:", :prompt)
    )
  end

  def new_project_name_prompt
    print_line(
      format("Enter new project name:", :prompt)
    )
  end

  def listing_project_header
    print_line(
      format("Listing projects:", :success)
    )
  end

  def cant_delete_project
    print_line(
      format("Can't delete a project", :alert)
    )
  end

  def cant_edit_project
    print_line(
      format("Can't edit any projects", :alert)
    )
  end

  # project menu related messages, with data passed in
  def project_created(name)
    print_line(
      format("Created project:", :success) +  " '#{name}'"
    )
    self.break
  end

  def project_list_item(project)
    print_line(
      "  #{project.position}.  " + format(project.name, :description)
    )
  end

  def successful_delete(name)
    print_line(
      format("Deleting project:", :success) + " '#{name}'"
    )
    self.break
  end

  def project_does_not_exist(name)
    print_line(
      format("Project doesn't exist:", :alert) + " '#{name}'"
    )
    self.break
  end

  # task menu related messages, no data passed in
  def task_name_prompt
    print_line(
      format("Enter a task name:", :prompt)
    )
  end

  def task_list_header
    print_line(
      format("Listing tasks:", :success)
    )
  end

  # task menu related messages, data required
  def created_task(name)
    print_line(
      format("Created task:", :success) + " '#{name}'"
    )
    self.break
  end

  def changed_project_name(old_name, new_name)
    print_line(
      format("Changed project name from", :success) +
        " '#{old_name}' " +
        format("to", :success) +
        " '#{new_name}'"
    )
    self.break
  end

  def changed_task_name(old_name, new_name)
    print_line(
      format("Changed task name from", :success) +
        " '#{old_name}' " +
        format("to", :success) +
        " '#{new_name}'"
    )
    self.break
  end

  def editing_task(name)
    print_line(
      format("Editing task:", :success) + " '#{name}'"
    )
  end

  def task_prompt
    print_line(
      format("Enter a task name:", :prompt)
    )
  end

  def task_does_not_exsit(name)
    print_line(
      format("Task doesn't exist:", :alert) + " '#{name}'"
    )
    self.break
  end

  def no_tasks_created_in(project_name)
    print_line(
      format("No tasks created in ", :alert) +
        "'#{project_name}'"
    )
    self.break
  end

  def task_deleted(name)
    print_line(
      format("Deleted task:", :success) +
      " '#{name}'"
    )
    self.break
  end

  def finished_task(name)
    print_line(
      format("Finished task:", :success) +
      " '#{name}'"
    )
    self.break
  end

  def task_item(task)
    print_line(
      "  #{task.position}.  " +
      format("#{task.name}", :success)
    )
    self.break
  end

  private

  def print_line(message='')
    output_stream.puts(message)
  end

  def formatter
    Formatter.new
  end

  extend Forwardable
  def_delegators :formatter, :format, :command
end
