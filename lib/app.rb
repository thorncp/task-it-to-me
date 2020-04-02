class App
  attr_reader :command,
    :current_project,
    :deleted_project,
    :input_stream,
    :output_stream,
    :project_name,
    :projects,
    :task_name

  def initialize(output_stream, input_stream)
    @output_stream = output_stream
    @input_stream = input_stream
    @projects = []
  end

  def run
    print("\e[38;5;40mWelcome to Taskitome!")
    print("\e[0;37m=============================\n")
    print("\e[0mPROJECTS MENU")
    print("\e[0;37m-----------------------------")
    print("\e[40;38;5;214mENTER A COMMAND:\e[0m")
    print("\e[1;37ma   \e[0;35mAdd a new project")
    print("\e[1;37mls  \e[0;35mList all project")
    print("\e[1;37md   \e[0;35mDelete a project")
    print("\e[1;37me   \e[0;35mEdit a project")
    print("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")

    capture_command

    while command != "q"
      if no_current_project?
        case command
        when "a"
          capture_project_name
          add_project
          print("\e[38;5;40mCreated project:\e[0m '#{project_name}'\n\n")
        when "ls"
          print("\e[38;5;40mListing projects:\e[0m\n")
          if projects?
            projects.each do |project|
              print("  #{project.keys.first}\n")
            end
            print("\n")
          else
            print("\e[40;38;5;214mNo projects created\e[0m\n\n")
          end
        when "d"
          if projects?
            capture_project_name
            delete_project
            if project_deleted?
              print "\e[38;5;40mDeleting project:\e[0m '#{project_name.strip}'\n\n"
            else
              print "\e[40;38;5;214mProject doesn't exist:\e[0m '#{project_name.strip}'\n\n"
            end
          else
            print("\e[40;38;5;214mCan't delete a project\e[0m")
            print("\e[40;38;5;214mNo projects created\e[0m\n\n")
          end
        when "e"
          if no_projects?
            print("\e[40;38;5;214mCan't edit any projects\e[0m")
            print("\e[40;38;5;214mNo projects created\e[0m\n\n")
          elsif capture_project_name && project_name_valid?
            switch_project
            print("\e[38;5;40mEditing project: '#{project_name}'\n\n")
            print("\e[0;37mEDIT PROJECT MENU\e[0m")
            print("-----------------------------")
            print("\e[40;38;5;214mENTER A COMMAND:\e[0m")
            print("\e[1;37mc   \e[0;35mChange the project name")
            print("\e[1;37ma   \e[0;35mAdd a new task")
            print("\e[1;37mls  \e[0;35mList all tasks")
            print("\e[1;37md   \e[0;35mDelete a task")
            print("\e[1;37me   \e[0;35mEdit a task")
            print("\e[1;37mf   \e[0;35mFinish a task")
            print("\e[1;37mb   \e[0;35mBack to Projects menu")
            print("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")
            capture_command
            next
          else
            print("\e[40;38;5;214mCan't edit project\e[0m")
            print("\e[40;38;5;214mProject doesn't exist:\e[0m '#{project_name}'\n\n")
          end
        end
      else
        case command
        when "a"
          capture_task_name
          add_task
          print("\e[38;5;40mCreated task:\e[0m '#{task_name}'\n\n")
        when "b"
          unset_project
          print("\n\n")
        when "c"
          print("\e[0;35mEnter new project name:\e[0m")
          set_project_name
          old_name = current_project.keys.first
          rename_project
          print("\e[38;5;40mChanged project name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{project_name}'\n\n")
        when "e"
          capture_task_name
          if (index = current_project.values.first.find_index(task_name))
            old_name = task_name
            print("\e[38;5;40mEditing task:\e[0m '#{old_name}'")
            capture_task_name
            current_project[current_project.keys.first][index] = task_name
            print("\e[38;5;40mChanged task name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{task_name}'\n\n")
          else
            print("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name}'\n\n")
          end
        when "d"
          project_name = current_project.keys.first
          if current_project.values.first.empty?
            print("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
          else
            capture_task_name
            if current_project[current_project.keys.first].delete(task_name.strip)
              print("\e[38;5;40mDeleted task:\e[0m '#{task_name.strip}'\n\n")
            else
              print("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name.strip}'\n\n")
            end
          end
        when "f"
          project_name = current_project.keys.first
          if current_project.values.first.empty?
            print("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
          else
            capture_task_name
            if current_project[current_project.keys.first].delete(task_name.strip)
              print("\e[38;5;40mFinished task:\e[0m '#{task_name.strip}'\n\n")
            else
              print("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name.strip}'\n\n")
            end
          end
        when "ls"
          if current_project.values.first.empty?
            print("\e[40;38;5;214mNo tasks created in \e[0m'#{current_project.keys.first}'\n\n")
          else
            print("\e[38;5;40mListing tasks:\e[0m")
            current_project.values.first.each do |task|
              print("  #{task}")
            end
            print("\n\n")
          end
        end
      end

      capture_command
    end
  end

  private

  def capture_project_name
    prompt_for_project
    set_project_name
  end

  def prompt_for_project
    print("\e[0;35mEnter a project name:\e[0m")
  end

  def project_name_valid?
    !!referenced_project
  end

  def add_project
    projects << {project_name => []}
  end

  def delete_project
    @deleted_project = projects.delete(referenced_project)
  end

  def rename_project
    old_name = current_project.keys.first
    current_project[project_name] = current_project.values.first
    current_project.delete(old_name)
  end

  def project_deleted?
    !!deleted_project
  end

  def capture_task_name
    prompt_for_task
    set_task_name
  end

  def prompt_for_task
    print("\e[0;35mEnter a task name:\e[0m")
  end

  def set_task_name
    @task_name = get_user_input
  end

  def add_task
    current_project.values.first << task_name
  end

  def switch_project
    @current_project = referenced_project
  end

  def unset_project
    @current_project = nil
  end

  def no_current_project?
    !current_project
  end

  def referenced_project
    projects.detect { |p| p.keys.first == project_name }
  end

  def capture_command
    @command = get_user_input
  end

  def set_project_name
    @project_name = get_user_input
  end

  def get_user_input
    input_stream.gets.strip
  end

  def projects?
    projects.any?
  end

  def no_projects?
    !projects?
  end

  def print(string)
    output_stream.puts(string)
  end
end
