class App
  attr_reader :input_stream, :output_stream

  def initialize(output_stream, input_stream)
    @output_stream = output_stream
    @input_stream = input_stream
    @projects = []
  end

  def run
    print_line("\e[38;5;40mWelcome to Taskitome!")
    print_line("\e[0;37m=============================\n")
    print_line("\e[0mPROJECTS MENU")
    print_line("\e[0;37m-----------------------------")
    print_line("\e[40;38;5;214mENTER A COMMAND:\e[0m")
    print_line("\e[1;37ma   \e[0;35mAdd a new project")
    print_line("\e[1;37mls  \e[0;35mList all project")
    print_line("\e[1;37md   \e[0;35mDelete a project")
    print_line("\e[1;37me   \e[0;35mEdit a project")
    print_line("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")

    command = get_input

    while command != 'q'
      if !@current_project
        case command
        when 'a'
          print_line("\e[0;3mEnter a project name:\e[0m")
          name = get_input
          @projects << {name => []}
          print_line("\e[38;5;40mCreated project:\e[0m '#{name}'\n\n")
        when 'ls'
          print_line("\e[38;5;40mListing projects:\e[0m\n")
          if !@projects.empty?
            @projects.each do |project|
              print_line("  #{name_for_project(project)}\n")
            end
            print_line("\n")
          else
            print_no_projects_message
          end
        when 'd'
          if @projects.size > 0
            print_line("\e[0;35mEnter a project name:\e[0m")
            project_name = get_input
            @deleted = @projects.delete_if {|project| name_for_project(project) == project_name }.empty?
            if @deleted
              print_line "\e[38;5;40mDeleting project:\e[0m '#{project_name}'\n\n"
            else
              print_line "\e[40;38;5;214mProject doesn't exist:\e[0m '#{project_name}'\n\n"
            end
          end

          if !@deleted && @projects.empty?
            print_line("\e[40;38;5;214mCan't delete a project\e[0m")
            print_no_projects_message
          end
          @deleted = nil
        when 'e'
          if @projects.size == 0
            print_line("\e[40;38;5;214mCan't edit any projects\e[0m")
            print_no_projects_message
          else
            print_line("\e[0;35mEnter a project name:\e[0m")
            name = get_input
            if @current_project = @projects.detect{|project| name_for_project(project) == name}
              print_line("\e[38;5;40mEditing project: '#{name}'\n\n")
              print_line("\e[0;37mEDIT PROJECT MENU\e[0m")
              print_line("-----------------------------")
              print_line("\e[40;38;5;214mENTER A COMMAND:\e[0m")
              print_line("\e[1;37mc   \e[0;35mChange the project name")
              print_line("\e[1;37ma   \e[0;35mAdd a new task")
              print_line("\e[1;37mls  \e[0;35mList all tasks")
              print_line("\e[1;37md   \e[0;35mDelete a task")
              print_line("\e[1;37me   \e[0;35mEdit a task")
              print_line("\e[1;37mf   \e[0;35mFinish a task")
              print_line("\e[1;37mb   \e[0;35mBack to Projects menu")
              print_line("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")
              command = get_input
              next
            else
              print_line("\e[40;38;5;214mCan't edit project\e[0m")
              print_line("\e[40;38;5;214mProject doesn't exist:\e[0m '#{name}'\n\n")
            end
          end
        end
      else
        case command
        when 'a'
          print_line("\e[0;35mEnter a task name:\e[0m")
          task_name = get_input
          current_project_tasks << task_name
          print_line("\e[38;5;40mCreated task:\e[0m '#{task_name}'\n\n")
        when 'b'
          @current_project = false
          print_line("\n\n")
        when 'c'
          print_line("\e[0;35mEnter new project name:\e[0m")
          old_name = current_project_name
          new_name = get_input
          @current_project[new_name] = current_project_tasks
          @current_project.delete(old_name)
          print_line("\e[38;5;40mChanged project name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{new_name}'\n\n")
        when 'e'
          name = get_input
          if index = current_project_tasks.find_index(name)
            print_line("\e[38;5;40mEditing task:\e[0m '#{name}'")
            print_line("\e[0;35mEnter a task name:\e[0m")
            new_name = get_input
            current_project_tasks[index] = new_name
            print_line("\e[38;5;40mChanged task name from\e[0m '#{name}' \e[38;5;40mto\e[0m '#{new_name}'\n\n")
          else
            print_line("\e[40;38;5;214mTask doesn't exist:\e[0m '#{name}'\n\n")
          end
        when 'd'
          project_name = current_project_name
          if current_project_tasks.empty?
            print_line("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
          else
            print_line("\e[0;35mEnter task name:\e[0m")
            task_name = get_input
            if current_project_tasks.delete(task_name)
              print_line("\e[38;5;40mDeleted task:\e[0m '#{task_name}'\n\n")
            else
              print_line("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name}'\n\n")
            end
          end
        when 'f'
          project_name = current_project_name
          if current_project_tasks.empty?
            print_line("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
          else
            print_line("\e[0;35mEnter task name:\e[0m")
            task_name = get_input
            if current_project_tasks.delete(task_name)
              print_line("\e[38;5;40mFinished task:\e[0m '#{task_name}'\n\n")
            else
              print_line("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name}'\n\n")
            end
          end
        when 'ls'
          if current_project_tasks.empty?
            print_line("\e[40;38;5;214mNo tasks created in \e[0m'#{current_project_name}'\n\n")
          else
            print_line("\e[38;5;40mListing tasks:\e[0m")
            current_project_tasks.each do |task|
              print_line("  #{task}")
            end
            print_line("\n\n")
          end
        end
      end

      command = get_input
    end
  end

  def get_input
    input_stream.gets.strip
  end

  def print_line(message='')
    output_stream.puts(message)
  end

  def print_no_projects_message
    print_line("\e[40;38;5;214mNo projects created\e[0m\n\n")
  end

  def name_for_project(data)
    data.keys.first
  end

  def tasks_for_project(data)
    data.values.first
  end

  def current_project_tasks
    tasks_for_project(@current_project)
  end

  def current_project_name
    name_for_project(@current_project)
  end
end
