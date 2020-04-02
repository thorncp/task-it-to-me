class App
  attr_reader :command,
    :current_project,
    :input_stream,
    :output_stream,
    :project_name,
    :projects,
    :task_name

  def initialize(output_stream, input_stream)
    @output_stream = output_stream
    @input_stream = input_stream
  end

  def run
    @output_stream.puts("\e[38;5;40mWelcome to Taskitome!")
    @output_stream.puts("\e[0;37m=============================\n")
    @output_stream.puts("\e[0mPROJECTS MENU")
    @output_stream.puts("\e[0;37m-----------------------------")
    @output_stream.puts("\e[40;38;5;214mENTER A COMMAND:\e[0m")
    @output_stream.puts("\e[1;37ma   \e[0;35mAdd a new project")
    @output_stream.puts("\e[1;37mls  \e[0;35mList all project")
    @output_stream.puts("\e[1;37md   \e[0;35mDelete a project")
    @output_stream.puts("\e[1;37me   \e[0;35mEdit a project")
    @output_stream.puts("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")

    capture_command

    while command != "q"
      if !@current_project
        case command
        when "a"
          @projects = [] if @projects.nil?
          @output_stream.puts("\e[0;3mEnter a project name:\e[0m")
          name = @input_stream.gets.chomp
          @projects << {name => []}
          @output_stream.puts("\e[38;5;40mCreated project:\e[0m '#{name}'\n\n")
        when "ls"
          @output_stream.puts("\e[38;5;40mListing projects:\e[0m\n")
          if !@projects.nil? && !@projects.empty?
            @projects.each do |project|
              @output_stream.puts("  #{project.keys.first}\n")
            end
            @output_stream.puts("\n")
          else
            @output_stream.puts("\e[40;38;5;214mNo projects created\e[0m\n\n")
          end
        when "d"
          if @projects && (@projects.size > 0)
            @output_stream.puts("\e[0;35mEnter a project name:\e[0m")
            capture_project_name
            @deleted = @projects.delete_if { |project| project.keys.first == project_name.strip }.empty?
            if @deleted
              @output_stream.puts "\e[38;5;40mDeleting project:\e[0m '#{project_name.strip}'\n\n"
            else
              @output_stream.puts "\e[40;38;5;214mProject doesn't exist:\e[0m '#{project_name.strip}'\n\n"
            end
          end

          if !@deleted && (!@projects || @projects.empty?)
            @output_stream.puts("\e[40;38;5;214mCan't delete a project\e[0m")
            @output_stream.puts("\e[40;38;5;214mNo projects created\e[0m\n\n")
          end
          @deleted = nil
        when "e"
          if no_projects?
            @output_stream.puts("\e[40;38;5;214mCan't edit any projects\e[0m")
            @output_stream.puts("\e[40;38;5;214mNo projects created\e[0m\n\n")
          elsif capture_project_name && project_name_valid?
            switch_project
            @output_stream.puts("\e[38;5;40mEditing project: '#{project_name}'\n\n")
            @output_stream.puts("\e[0;37mEDIT PROJECT MENU\e[0m")
            @output_stream.puts("-----------------------------")
            @output_stream.puts("\e[40;38;5;214mENTER A COMMAND:\e[0m")
            @output_stream.puts("\e[1;37mc   \e[0;35mChange the project name")
            @output_stream.puts("\e[1;37ma   \e[0;35mAdd a new task")
            @output_stream.puts("\e[1;37mls  \e[0;35mList all tasks")
            @output_stream.puts("\e[1;37md   \e[0;35mDelete a task")
            @output_stream.puts("\e[1;37me   \e[0;35mEdit a task")
            @output_stream.puts("\e[1;37mf   \e[0;35mFinish a task")
            @output_stream.puts("\e[1;37mb   \e[0;35mBack to Projects menu")
            @output_stream.puts("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")
            capture_command
            next
          else
            @output_stream.puts("\e[40;38;5;214mCan't edit project\e[0m")
            @output_stream.puts("\e[40;38;5;214mProject doesn't exist:\e[0m '#{project_name}'\n\n")
          end
        end
      else
        case command
        when "a"
          capture_task_name
          @current_project.values.first << task_name
          @output_stream.puts("\e[38;5;40mCreated task:\e[0m '#{task_name}'\n\n")
        when "b"
          @current_project = false
          @output_stream.puts("\n\n")
        when "c"
          @output_stream.puts("\e[0;35mEnter new project name:\e[0m")
          old_name = @current_project.keys.first
          capture_project_name
          @current_project[project_name] = @current_project.values.first
          @current_project.delete(old_name)
          @output_stream.puts("\e[38;5;40mChanged project name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{project_name}'\n\n")
        when "e"
          capture_task_name
          if (index = @current_project.values.first.find_index(task_name))
            old_name = task_name
            @output_stream.puts("\e[38;5;40mEditing task:\e[0m '#{old_name}'")
            capture_task_name
            @current_project[@current_project.keys.first][index] = task_name
            @output_stream.puts("\e[38;5;40mChanged task name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{task_name}'\n\n")
          else
            @output_stream.puts("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name}'\n\n")
          end
        when "d"
          project_name = @current_project.keys.first
          if @current_project.values.first.empty?
            @output_stream.puts("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
          else
            @output_stream.puts("\e[0;35mEnter task name:\e[0m")
            task_name = @input_stream.gets
            if @current_project[@current_project.keys.first].delete(task_name.strip)
              @output_stream.puts("\e[38;5;40mDeleted task:\e[0m '#{task_name.strip}'\n\n")
            else
              @output_stream.puts("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name.strip}'\n\n")
            end
          end
        when "f"
          project_name = @current_project.keys.first
          if @current_project.values.first.empty?
            @output_stream.puts("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
          else
            @output_stream.puts("\e[0;35mEnter task name:\e[0m")
            task_name = @input_stream.gets
            if @current_project[@current_project.keys.first].delete(task_name.strip)
              @output_stream.puts("\e[38;5;40mFinished task:\e[0m '#{task_name.strip}'\n\n")
            else
              @output_stream.puts("\e[40;38;5;214mTask doesn't exist:\e[0m '#{task_name.strip}'\n\n")
            end
          end
        when "ls"
          if @current_project.values.first.empty?
            @output_stream.puts("\e[40;38;5;214mNo tasks created in \e[0m'#{@current_project.keys.first}'\n\n")
          else
            @output_stream.puts("\e[38;5;40mListing tasks:\e[0m")
            @current_project.values.first.each do |task|
              @output_stream.puts("  #{task}")
            end
            @output_stream.puts("\n\n")
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
    output_stream.puts("\e[0;35mEnter a project name:\e[0m")
  end

  def project_name_valid?
    !!referenced_project
  end

  def capture_task_name
    prompt_for_task
    set_task_name
  end

  def prompt_for_task
    output_stream.puts("\e[0;35mEnter a task name:\e[0m")
  end

  def set_task_name
    @task_name = get_user_input
  end

  def switch_project
    @current_project = referenced_project
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

  def no_projects?
    !@projects || @projects.size == 0
  end
end
